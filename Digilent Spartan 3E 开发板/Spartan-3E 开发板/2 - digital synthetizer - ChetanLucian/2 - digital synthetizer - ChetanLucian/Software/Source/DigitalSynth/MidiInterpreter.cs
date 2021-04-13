using System.IO;
using System;
using System.Collections;

namespace DigitalSynth
{
	/// <summary>
	/// Interprets a file that contains note information.
	/// </summary>
	class MidiInterpreter
	{
		#region Structures, Objects, Variables, Constants, Other declarations

		/// <summary>
		/// A note is identified by the start time, the end time and the value.
		/// </summary>
		public struct RawNote
		{
			public int note;
			public int start;
			public int end;
		}
		/// <summary>
		/// Graphic notes will be generated based on this structure
		/// </summary>
		public struct MusicalElement
		{
			public int elementType; // 0 = note; 1 = rest
			public int noteValue; // note value
			public int start; // start time
			public int end; // end time
			public int length; // note length (full note, half note, quarter, eigtht, sixteenth)
			public bool isTiedToNext; // specifies whether the note is tied to the following note (in the same measure, or in the next measure)
		}

		private FileStream fileStream;
		private StreamReader streamReader;
		private string filePath;
		private string fileLine;
		private string errorString;
		private int deltaTicksPerQuarter;
		private int totalDeltaTicks;
		private int numberOfMeasures;
		private int measureLength;
		private float quartersPerMeasure;
		private bool error;
		private ArrayList fileLines = new ArrayList();
		private ArrayList notes = new ArrayList(); // array of all the notes read from the file
		private ArrayList notesTrack1, notesTrack2, notesTrack3, notesTrack4;
		private ArrayList workTrack, measuresTrack1, measuresTrack2, measuresTrack3, measuresTrack4;
		const int POLYPHONY = 4;
		private int[] slotAssignmentForNote;
		private int[] slotStatus = new int[POLYPHONY + 1];
		private int[] currentSlotAssignment = new int[POLYPHONY + 1];	

		public ArrayList MeasuresTrack1
		{
			get { return measuresTrack1; }
		}
		public ArrayList MeasuresTrack2
		{
			get { return measuresTrack2; }
		}
		public ArrayList MeasuresTrack3
		{
			get { return measuresTrack3; }
		}
		public ArrayList MeasuresTrack4
		{
			get { return measuresTrack4; }
		}
		public ArrayList Notes
		{
			get { return notes; }
		}
		public int[] SlotAssignment
		{
			get { return slotAssignmentForNote; }
		}
		public int NumberOfMeasures
		{
			get { return numberOfMeasures; }
		}
		public string ErrorString
		{
			get { return errorString; }
		}

		#endregion


		/// <summary>
		/// Creates a MidiInterpreter object that reads the file containing note information and generates the four 'note tracks'.
		/// </summary>
		/// <param name="path">Path to the file.</param>
		/// <param name="deltaTicksPerQuarter">The number of clock ticks per quarter note.</param>
		/// <param name="totalDeltaTicks">The total number of clock ticks.</param>
		/// <param name="quartersPerMeasure">The number of quarters per measure.</param>
		public MidiInterpreter(string path, int deltaTicksPerQuarter, int totalDeltaTicks, float quartersPerMeasure)
		{
			try
			{
				// open the file for reading
				filePath = path;
				fileStream = new FileStream(path, FileMode.Open, FileAccess.Read);
				streamReader = new StreamReader(fileStream);
			}
			catch (Exception)
			{
				error = true;
				errorString = "File not found or couldn't be opened.";
			}
			this.deltaTicksPerQuarter = deltaTicksPerQuarter;
			this.totalDeltaTicks = totalDeltaTicks;
			this.quartersPerMeasure = quartersPerMeasure;
		}


		/// <summary>
		/// Reads the file and generates an array with the lines that the file contain.
		/// </summary>
		private void ReadFile()
		{
			try
			{
				while (!streamReader.EndOfStream)
					fileLines.Add(streamReader.ReadLine());
				fileLines.RemoveAt(fileLines.Count - 1); // remove the last read line (it is known that it contains only the "EndOfFile" message)
				if (streamReader != null)
					streamReader.Close();
				if (fileStream != null)
					fileStream.Close();
			}
			catch (Exception)
			{
				error = true;
				errorString = "Could not read file.";
			}
		}

		/// <summary>
		/// Parses the lines that have the following format: "[Time]_On_[Note]" or "[Time]_Off_[Note]".
		/// </summary>
		private void ParseFileLines()
		{
			bool matched;

			// try to match "On" messages to "Off" messages
			while (fileLines.Count > 0)
			{
				// take the first line in the array (it contains an "On" message)
				fileLine = (string)fileLines[0];
				string[] line1 = fileLine.Split('_'); // split it in 3 strings: time, message, note value

				matched = false;
				// search for the matching line
				// example: timeStart_On_60 matches timeEnd_Off_60
				for (int i = 1; i < fileLines.Count; i++)
				{
					string[] line2 = ((string)fileLines[i]).Split('_');
					if (MatchingBetween(line1, line2))
					{
						// create a note structure based on the information contained by the 2 lines
						RawNote note;
						note.note = int.Parse(line1[2]);
						note.start = int.Parse(line1[0]);
						note.end = int.Parse(line2[0]);

						notes.Add(note);
						fileLines.RemoveAt(i); // remove the line with the "Off" message
						fileLines.RemoveAt(0); // remove the note with the "On" message
						matched = true;
						break; // stop searching for a match in the rest of the lines
					}
				}
				
				if (!matched)
					fileLines.RemoveAt(0); // remove the note with the "On" message
			}
		}

		/// <summary>
		/// Determines whether two lines read from the file match.
		/// </summary>
		/// <param name="a">First line.</param>
		/// <param name="b">Second line.</param>
		/// <returns>Returns true if the lines match. Returns false otherwise.</returns>
		private bool MatchingBetween(string[] a, string[] b)
		{
			/*	1.	TimeStart			TimeEnd
			 *	2.	On			<=>		Off
			 *	3.	Note				Note
			 */
			if (a[1] == "On" & b[1] == "Off" & a[2] == b[2])
				return true;
			else
				return false;
		}

		/// <summary>
		/// Generates an array of values that contain the slot value of each note.
		/// </summary>
		/// <returns>Returns 1 if successful. Returns -1 if unsuccessful.</returns>
		private int AssignPolyphonySlots()
		{
			slotAssignmentForNote = new int[notes.Count]; // generate an empty array with the length equal to that of the "notes" array.

			/* For every note in the note array compare its start time with the end time of the notes that currently occupy a slot.
			 * the start time > the end time => the slot must be freed
			 * Every time a note starts it must be assigned to a polyphony slot; otherwise an error will occur.
			 * --
			 * The notes in the "notes" array are sorted by their start time. When a new note starts, previous notes must have ended already.
			 */
			for (int i = 0; i < notes.Count; i++)
			{
				FreeSlots(((RawNote)notes[i]).start); // free the slots that contain notes that have ended
				int freeSlot = FindFirstFreeSlot(); // search for the first empty slot
				if (freeSlot != -1) // if one is found...
				{
					slotAssignmentForNote[i] = freeSlot; // link the note to it
					currentSlotAssignment[freeSlot] = i; // assign to the slot the new note
					slotStatus[freeSlot] = 1; // mark the slot as occupied
				}
				else
				{
					error = true;
					errorString = "Slot polyphony assignment error.";
					return -1;
				}
			}
			return 1; // success
		}

		/// <summary>
		/// Frees the slots that have notes with the end time lower that the start time of the new note.
		/// </summary>
		/// <param name="startTime">The start time of the new note.</param>
		private void FreeSlots(int startTime)
		{
			int endTime;
			for (int i = 1; i <= POLYPHONY; i++)
			{
				endTime = ((RawNote)notes[currentSlotAssignment[i]]).end;
				if (endTime <= startTime)
					slotStatus[i] = 0; // mark the slot as free
			}
		}

		/// <summary>
		/// Search for the first free slot.
		/// </summary>
		/// <returns>Returns the index of the first free slot if one exists. Returns -1 if there are no free slots.</returns>
		private int FindFirstFreeSlot()
		{
			for (int i = 1; i <= POLYPHONY; i++)
				if (slotStatus[i] == 0)
					return i;
			return -1;
		}

		/// <summary>
		/// Generates 4 arrays of notes that share the same slots.
		/// </summary>
		private void SeparateTracks()
		{
			notesTrack1 = new ArrayList();
			notesTrack2 = new ArrayList();
			notesTrack3 = new ArrayList();
			notesTrack4 = new ArrayList();

			for (int i = 0; i < slotAssignmentForNote.Length; i++)
			{
				// based on the notes' slot assignment, generate the 4 tracks
				switch (slotAssignmentForNote[i])
				{
					case 1: notesTrack1.Add(notes[i]); break;
					case 2: notesTrack2.Add(notes[i]); break;
					case 3: notesTrack3.Add(notes[i]); break;
					case 4: notesTrack4.Add(notes[i]); break;
					default: break;
				}
			}
		}

		/// <summary>
		/// Fills the measures with rests.
		/// </summary>
		/// <param name="list">The source track that contains only notes.</param>
		/// <returns>Returns the track containing both notes and rests.</returns>
		private ArrayList FillRests(ArrayList list)
		{
			/* create an array of empty measures in which to copy the notes from the source track
			 * and in which to place the rests.
			 */
			ArrayList result = new ArrayList(numberOfMeasures);
			CreateEmptyMeasures(result);

			for (int i = 0; i < numberOfMeasures; i++)
				FillRestsInsideMeasure(i, (ArrayList)list[i], (ArrayList)result[i]);

			return result;
		}

		/// <summary>
		/// Fills the rests insinde one measure.
		/// </summary>
		/// <param name="measureNumber">The number of the measure to fill.</param>
		/// <param name="source">The source track from which to copy notes.</param>
		/// <param name="destination">The destination track in which to copy notes and place rests.</param>
		private void FillRestsInsideMeasure(int measureNumber, ArrayList source, ArrayList destination)
		{
			/* If the measure contains 0 notes, then it must be completely filled with a rest.
			 * A 3/4 track that has an empty measure will have a rest composed of a half rest and a quarter rest.
			 * A 4/4 track will have a full rest.
			 */
			int measureLength = (int)quartersPerMeasure * deltaTicksPerQuarter;

			if (source.Count == 0)
				GenerateRests(measureLength, destination);
			else
			{
				// if there is a rest at the start of a measure...
				if (((MusicalElement)source[0]).start != measureNumber * measureLength)
					GenerateRests(((MusicalElement)source[0]).start - measureNumber * measureLength, destination);
				
				// search for rests between notes
				for (int i = 1; i < source.Count; i++)
				{
					MusicalElement curr = (MusicalElement)source[i];
					MusicalElement prev = (MusicalElement)source[i - 1];
					destination.Add(prev); // add the notes too
					if (curr.start != prev.end)
						GenerateRests(curr.start - prev.end, destination);
				}
				destination.Add(source[source.Count - 1]);

				// if there is a rest at the end of a measure...
				if (((MusicalElement)source[source.Count - 1]).end != (measureNumber + 1) * measureLength)
					GenerateRests((measureNumber + 1) * measureLength - ((MusicalElement)source[source.Count - 1]).end, destination);
			}
		}

		/// <summary>
		/// Generates rests in order to fill gaps between notes.
		/// </summary>
		/// <param name="duration">The total duration of the rest.</param>
		/// <param name="destination">The track in which to place the generated rests.</param>
		private void GenerateRests(int duration, ArrayList destination)
		{
			int[] composition;
			composition = MapOnPresetDurations(duration); // find which rests could fill the gap

			for (int k = 0; k < composition.Length; k++)
			{
				if (composition[k] != 0)
				{
					MusicalElement element = new MusicalElement();
					element.elementType = 1;
					element.length = (int)Math.Pow(2, k); // 0 - full (1), 1 - half (2), 2 - quarter (4), etc.
					destination.Add(element);
				}
			}
		}

		/// <summary>
		/// Generates the measures (containing notes and rests) for each track.
		/// </summary>
		private void GenerateMeasuresForAllTracks()
		{
			// an M/4 track that has 'X' clock ticks will have N = X / (M * deltaTicksPerMeasure) measures
			// M/4 is the signature of the track
			measureLength = (int)(quartersPerMeasure * deltaTicksPerQuarter);
			if (measureLength != 0)
				numberOfMeasures = totalDeltaTicks / measureLength;

			// Each track is a collection of arrays (the measures).
			// Each measure is a collection of notes and rests.
			
			workTrack = new ArrayList(numberOfMeasures);
			CreateEmptyMeasures(workTrack);
			GenerateMeasures(notesTrack1, workTrack);
			measuresTrack1 = FillRests(workTrack);
			workTrack.Clear();

			CreateEmptyMeasures(workTrack);
			GenerateMeasures(notesTrack2, workTrack);
			measuresTrack2 = FillRests(workTrack);
			workTrack.Clear();

			CreateEmptyMeasures(workTrack);
			GenerateMeasures(notesTrack3, workTrack);
			measuresTrack3 = FillRests(workTrack);
			workTrack.Clear();

			CreateEmptyMeasures(workTrack);
			GenerateMeasures(notesTrack4, workTrack);
			measuresTrack4 = FillRests(workTrack);
		}

		/// <summary>
		/// Creates empty measures (empty arrays).
		/// </summary>
		/// <param name="track">The track for which to create the measures.</param>
		private void CreateEmptyMeasures(ArrayList track)
		{
			for (int i = 0; i < numberOfMeasures; i++)
			{
				ArrayList al = new ArrayList();
				track.Add(al);
			}
		}

		/// <summary>
		/// Generates the measures for each track.
		/// </summary>
		/// <param name="noteTrack">The track from which to read the notes.</param>
		/// <param name="measureTrack">The track for which to create the measures.</param>
		private void GenerateMeasures(ArrayList noteTrack, ArrayList measureTrack)
		{
			/* Each note in the note track has to be assigned to a certain measure.
			 * One way to determine which measure the note belongs to is to calculate
			 * the start measure and the end measure. If they are equal, the note belongs to 
			 * the one of them. If not, the note must be split, so that it is assigned
			 * to both the start measure and the end measure, as well as to any eventual
			 * measures in between.
			 * |				|
			 * |	x-----x		|	(one measure)
			 * |				|
			 * 
			 * |		|		|		|
			 * |	x---|--...--|---x	|	(several measures)
			 * |		|		|		|
			 */
			int startMeasure, endMeasure, currentPositionInMeasure = 0, measuresToFill;

			foreach (RawNote note in noteTrack)
			{
				startMeasure = note.start / measureLength;
				endMeasure = note.end / measureLength;
				measuresToFill = endMeasure - startMeasure; // the number of measures the note spans over

				if (measuresToFill == 0 || note.end == (endMeasure * measureLength)) // the note might end at exactly the start of the next measure
				{
					// the note fits in one measure only
					SplitNoteInsideMeasure(note, (ArrayList)measureTrack[startMeasure], false);
					currentPositionInMeasure += note.end - note.start; // keep track of the position in the measure
				}
				else
				{
					// the note spans over more than one measure
					SplitNoteOverMeasures(note, startMeasure, endMeasure, measuresToFill, measureTrack);
					currentPositionInMeasure = 0;
				}
			}
		}

		/// <summary>
		/// Generates notes according to the structure of the original note that has a length different of those of the basic notes, and that fits in one measure.
		/// </summary>
		/// <param name="originalNote">The original note.</param>
		/// <param name="measureTrack">The track that will contain all the generated notes.</param>
		/// <param name="itSpansOverMeasures">Specifies whether a note spans over several measures.</param>
		private void SplitNoteInsideMeasure(RawNote originalNote, ArrayList measureTrack, bool itSpansOverMeasures)
		{
			int noteStart = originalNote.start;
			int noteEnd = originalNote.end;
			int noteDuration = noteEnd - noteStart;
			int[] composition = MapOnPresetDurations(noteDuration); // determine the composition of the original note
			int[] presetNotesValues = { 4 * deltaTicksPerQuarter, 2 * deltaTicksPerQuarter, deltaTicksPerQuarter, deltaTicksPerQuarter / 2, deltaTicksPerQuarter / 4 };

			/* If the result is similar to the next one:
			 * full half quar eigh sixt
			 * 0    0    3    0    2
			 * then convert to:
			 * 0    1    1    1    0
			 * because 2 sixteenths make 1 eighth, and so on.
			 * The result consists of a lower number of notes to be generated.
			 */
			for (int i = composition.Length - 1; i > 0; i--)
			{
				int x = composition[i];
				composition[i] = x % 2;
				composition[i - 1] += x / 2;
			}

			int notesToGenerate = 0;
			for (int i = 0; i < composition.Length; i++)
				notesToGenerate += composition[i]; // determine the number of notes that must be generated so that they are equal to the original one

			for (int i = 0; i < composition.Length; i++)
			{
				while (composition[i] > 0)
				{
					notesToGenerate--;
					composition[i]--;

					MusicalElement note = new MusicalElement();
					note.elementType = 0;
					note.noteValue = originalNote.note;
					note.start = noteStart;
					note.end = noteStart = noteStart + presetNotesValues[i];
					note.length = AssignNoteType(note.end - note.start);

					if (notesToGenerate == 0) // if only one note was generated
						note.isTiedToNext = false; // the note will not be tied to the next one
					else
						note.isTiedToNext = true; // otherwise it will be tied to the next one

					if (itSpansOverMeasures)
						note.isTiedToNext = true;

					measureTrack.Add(note);
				}
			}
		}

		/// <summary>
		/// Generates notes according to the structure of the original note that has a length different of those of the basic notes, and that spans over multiple measure.
		/// </summary>
		/// <param name="originalNote">The original note.</param>
		/// <param name="startMeasure">The start measure of the note.</param>
		/// <param name="endMeasure">The end measure of the note.</param>
		/// <param name="measuresToGenerate">The total number of measures to fill.</param>
		/// <param name="measureTrack">The track that will contain all the generated notes.</param>
		private void SplitNoteOverMeasures(RawNote originalNote, int startMeasure, int endMeasure, int measuresToGenerate, ArrayList measureTrack)
		{
			/* Suppose we have a note that spans over N measures.
			 * We must take a part of the note to fill the rest of the measure it starts in,
			 * then the note will fill N-2 measures (it will be composed of full notes, all tied)
			 * and the the rest of the note will go in the last measure
			 * (it could fill the entire measure or only a part). 
			 */
			int currentMeasure = startMeasure;
			RawNote firstNote = new RawNote(); // create the note that will fill the first start measure
			firstNote.note = originalNote.note;
			firstNote.start = originalNote.start;
			firstNote.end = (startMeasure + 1) * measureLength;
			SplitNoteInsideMeasure(firstNote, (ArrayList)measureTrack[startMeasure], true); // this note might not map on a basic note, so it needs decomposition

			currentMeasure++; // get to the next measure
			measuresToGenerate--;
			while (measuresToGenerate > 0)
			{
				MusicalElement note = new MusicalElement(); // keep generating measures that will fill entire measures
				note.elementType = 0;
				note.noteValue = originalNote.note;
				note.start = currentMeasure * measureLength;
				note.end = (currentMeasure + 1) * measureLength;
				note.isTiedToNext = false;
				((ArrayList)measureTrack[currentMeasure]).Add(note);
				measuresToGenerate--;
				currentMeasure++;
			}

			RawNote lastNote = new RawNote(); // generate the note that will belong to the last measure
			lastNote.note = originalNote.note;
			lastNote.start = endMeasure * measureLength;
			lastNote.end = originalNote.end;
			SplitNoteInsideMeasure(lastNote, (ArrayList)measureTrack[currentMeasure], false); // this note might not map on a basic note, so it needs decomposition
		}

		/// <summary>
		/// Generates the structure of an element (note or rest) composed of basic element lengths, based on its duration.
		/// </summary>
		/// <param name="duration">The duration of the element (note or rest) to be processed.</param>
		/// <returns>Returns the configuration of the element (note or rest).</returns>
		private int[] MapOnPresetDurations(int duration)
		{
			/* A note that has a duration greater than the duration of basic notes (full, half, quarter, eighth, sixteenth)
			 * are composed of several basic notes tied tigether. The sum of their lengths is equal to the original note.
			 * First we determine the number of full notes in the original note, then the number of half notes and so on.
			 */

			// The basic note lengths are: full = 4 * quarter, half = 2 * quarter, quarter, eighth = quarter / 2, sixteenth = quarter / 4
			int[] presetNotesValues = { 4 * deltaTicksPerQuarter, 2 * deltaTicksPerQuarter, deltaTicksPerQuarter, deltaTicksPerQuarter / 2, deltaTicksPerQuarter / 4 };
			int[] resultingComposition = { 0, 0, 0, 0, 0 };

			for (int i = 0; i < 5; i++)
			{
				// while the note is greater than a basic value...
				while (duration >= presetNotesValues[i])
				{
					duration -= presetNotesValues[i]; // substract that basic length
					resultingComposition[i]++; // increment the number of basic notes in the composition
				}

				int testResult = TestFinalMapping(duration); // test the remaining duration to see if it maps successfully on a basic length
				if (testResult != -1)
				{
					// there is a match
					resultingComposition[testResult]++;
					return resultingComposition; // exit
				}
				// otherwise continue with a lower basic note length
			}
			return resultingComposition;
		}

		/// <summary>
		/// Tests the duration of a note to see if it's equal to the duration of a basic note length.
		/// </summary>
		/// <param name="duration">The note's duration.</param>
		/// <returns>Returns the code of the basic note that the original note correspond to. Returns -1 if no match found.</returns>
		private int TestFinalMapping(int duration)
		{
			// This operation is required because the "Overture" program generates only 90 % of the normal duration a note should have.
			if (duration == (4 * deltaTicksPerQuarter) * 9 / 10)
				return 0;
			if (duration == (2 * deltaTicksPerQuarter) * 9 / 10)
				return 1;
			if (duration == (deltaTicksPerQuarter) * 9 / 10)
				return 2;
			if (duration == (deltaTicksPerQuarter / 2) * 9 / 10)
				return 3;
			if (duration == (deltaTicksPerQuarter / 4) * 9 / 10)
				return 4;
			return -1;
		}

		/// <summary>
		/// Determines the type of the note.
		/// </summary>
		/// <param name="duration">The duration of the note.</param>
		/// <returns>Returns the note type.</returns>
		private int AssignNoteType(int duration)
		{
			switch (duration)
			{
				case 1920: return 1;
				case 1728: return 1;
				case 960: return 2;
				case 864: return 2;
				case 480: return 4;
				case 432: return 4;
				case 240: return 8;
				case 216: return 8;
				case 120: return 16;
				case 108: return 16;
				default: return 16;
			}
		}

		/// <summary>
		/// Generates the notes inside their respective measures.
		/// </summary>
		/// <returns>Returns 1 if no errors occur. Returns -1 otherwise.</returns>
		public int InterpretMidi()
		{
			if (!error)
			{
				try
				{
					ReadFile(); // reads the file and generates an array containing all the file lines
					ParseFileLines(); // parses the lines and determines the notes (start time, end time, note)
					AssignPolyphonySlots(); // generates an array with values that assign a polyphony slot to every note
					SeparateTracks(); // generates 4 arrays with the notes that belong to a polyphony slot
					GenerateMeasuresForAllTracks(); // generates the measures for every track
					return 1;
				}
				catch (Exception)
				{
				    errorString = "Unspecified error.";
				}
			}
			return -1;
		}
	}
}