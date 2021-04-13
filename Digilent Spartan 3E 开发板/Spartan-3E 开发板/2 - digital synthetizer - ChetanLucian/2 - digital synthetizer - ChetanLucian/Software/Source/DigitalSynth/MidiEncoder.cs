using System.Collections;
using System.IO;
using System;

namespace DigitalSynth
{
	class MidiEncoder
	{
		private ArrayList times;
		private ArrayList events;

		private FileStream fileStream;
		private BinaryWriter binaryWriter;

		private int totalTime;
		private int normalizedTime;
		private int timeDifference;
		private int upperTimeSignature;
		private int chunkSize;
		private int instrumentVoice;
		private string fileName;
		private string title;
		private string trackName;
		private string instrument = "Microsoft GS Wavetable SW Synth";

		/* MIDI files have the following basic structure:
		 * [header chunk] + [track chunk start] + [size of the track chunk] +
		 * ["title" meta event] + ["time signature" meta event] + ["tempo" meta event] +
		 * [delta time of the "end of track" meta event] + ["end of track" meta event] + 
		 * [track chunk start] + [size of the track chunk] + ["track name" meta event] +
		 * ["instrument" meta event] + ["patch" midi event] + ["controller" midi event] +
		 * {[delta time of midi event] + [midi event]} + [delta time of the "end of track" meta event] +
		 * ["end of track" meta event]
		 */
		private byte[] headerChunk = new byte[14] { 0x4D, 0x54, 0x68, 0x64, 0x00, 0x00, 0x00, 0x06, 0x00, 0x01, 0x00, 0x02, 0x01, 0xE0 };
		private byte[] trackChunkStart = new byte[4] { 0x4D, 0x54, 0x72, 0x6B };
		private byte[] title_metaEvent = new byte[3] { 0x00, 0xFF, 0x03 };
		private byte[] tempo_metaEvent = new byte[7] { 0x00, 0xFF, 0x51, 0x03, 0x09, 0x89, 0x68 };
		private byte[] timeSignature_metaEvent = new byte[8] { 0x00, 0xFF, 0x58, 0x04, 0x00, 0x02, 0x18, 0x08 };
		private byte[] trackName_metaEvent = new byte[3] { 0x00, 0xFF, 0x03 };
		private byte[] instrument_metaEvent = new byte[] { 0x00, 0xFF, 0x04, 0x1F };
		private byte[] end_metaEvent = new byte[3] { 0xFF, 0x2F, 0x00 };
		private byte[] patch_midiEvent = new byte[3] { 0x00, 0xC0, 0x00 };
		private byte[] controller_midiEvent = new byte[4] { 0x00, 0xB0, 0x0A, 0x40 };


		public MidiEncoder(string fileName, ArrayList times, ArrayList events, string title, string trackName, int upperTimeSignature, int instrumentVoice)
		{
			// the MIDI file will contain the title and track information
			// if not provided by the user in the "New File" form, default values are used

			if (String.IsNullOrEmpty(fileName))
				this.fileName = "Untitled";
			else
				this.fileName = fileName;

			this.times = times;
			this.events = events;

			if (String.IsNullOrEmpty(title))
				this.title = "Title";
			else
				this.title = title;

			if (String.IsNullOrEmpty(trackName))
				this.trackName = "Track 1";
			else
				this.trackName = trackName;

			this.upperTimeSignature = upperTimeSignature;
			this.instrumentVoice = instrumentVoice;

			timeSignature_metaEvent[4] = (byte)upperTimeSignature;
			patch_midiEvent[2] = (byte)instrumentVoice;
		}


		public bool RenderMidiFile()
		{
			// The board send "note off" events until the user pressed any key.
			// These events are deleted from the "times" and "events" arrays until the first "note on" event is encountered.
			if (CorrectFile(times, events))
			{
				totalTime = 0;
				foreach (int i in times)
					totalTime += i; // determine the total time of the song
				normalizedTime = (int)Math.Ceiling((double)totalTime / (upperTimeSignature * 480)) * (upperTimeSignature * 480); // determine the number of measures the song spans over
				timeDifference = normalizedTime - totalTime; // if a song lasts for 3 measures and a half, the end of the MIDI file will be after 4 measures

				RenderMidiFile(times, events, normalizedTime, title, trackName, upperTimeSignature);
				return true;
			}
			else
				return false;
		}

		private void RenderMidiFile(ArrayList times, ArrayList events, int totalTime, string title, string trackName, int upperTimeSignature)
		{
			// the bytes of the file are stored into an array list
			// the contents of the list is stored in a byte array which will be written to the file
			ArrayList byteArray = new ArrayList();
			fileStream = new FileStream("Recordings\\" + fileName + ".mid", FileMode.Create, FileAccess.Write);
			binaryWriter = new BinaryWriter(fileStream);

			byteArray.Add(headerChunk);
			byteArray.Add(trackChunkStart);

			byte[] total = EncodeDeltaTime(totalTime);
			chunkSize = 22 + title.Length + total.Length;
			byte[] size = EncodeSize(chunkSize);

			byteArray.Add(size);
			byteArray.Add(title_metaEvent);
			byteArray.Add(new byte[1] { (byte)title.Length });
			byteArray.Add(ToByteArray(title));
			byteArray.Add(timeSignature_metaEvent);
			byteArray.Add(tempo_metaEvent);
			byteArray.Add(total);
			byteArray.Add(end_metaEvent);

			byteArray.Add(trackChunkStart);

			int midiEventsSize = EncodeMidiEvents(events);
			int deltaTimesSize = EncodeDeltaTimes(times);
			byte[] difference = EncodeDeltaTime(timeDifference);
			int k = deltaTimesSize + midiEventsSize + 49 + difference.Length + trackName.Length;
			byteArray.Add(EncodeSize(k));
			byteArray.Add(trackName_metaEvent);
			byteArray.Add(new byte[1] { (byte)trackName.Length });
			byteArray.Add(ToByteArray(trackName));
			byteArray.Add(instrument_metaEvent); 
			byteArray.Add(ToByteArray(instrument));
			byteArray.Add(patch_midiEvent);
			byteArray.Add(controller_midiEvent);
			for (int i = 0; i < times.Count; i++)
			{
				byte[] b;
				b = (byte[])times[i];
				byteArray.Add(b);
				b = (byte[])events[i];
				byteArray.Add(b);
			}

			byteArray.Add(difference);
			byteArray.Add(end_metaEvent);

			int midiFileSize = 0;
			foreach (byte[] b in byteArray)
				midiFileSize += b.Length; // determine the size of the file

			byte[] midiFile = new byte[midiFileSize]; // create the byte array

			int pos = 0;
			foreach (byte[] b in byteArray)
			{
				for (int i = 0; i < b.Length; i++)
				{
					midiFile[pos] = b[i]; // write to the byte array
					pos++;
				}
			}
			binaryWriter.Write(midiFile); // write the byte array to the file
			binaryWriter.Close();
			fileStream.Close();
		}

		private bool CorrectFile(ArrayList times, ArrayList events)
		{
			// MIDI file recording starts with a number of "note off" events that must be removed
			while (events.Count > 0 && (int)events[0] < 0)
			{
				events.RemoveAt(0);
				times.RemoveAt(0);
			}
			if (times.Count > 0)
			{
				times[0] = 0; // set the time of the first event to 0
				return true;
			}
			else
				return false;
		}

		private byte[] EncodeDeltaTime(int value)
		{
			// The value that needs encoding will be represented on a number N of bytes.
			// Each byte has the following structure:
			//		- the first bit signals if another byte follows
			//			- 0: this is the last byte
			//			- 1: another byte follows
			//		- the last 7 bits contain the data
			// The first N-1 bytes have the first bit equal to '1', and the last byte has the first bit equal to '0'.
			// encodes delta times as in the following example:
			// 1256 = 9 * 128 + 104 * 1
			// 1256 = 10001001 01101000 = 8968
			//        ^		   ^
			int x = value;
			int y = 0;
			ArrayList a = new ArrayList();

			while (x > 127)
			{
				y = x % 128;
				x = x / 128;
				a.Add(y);
			}
			a.Add(x);

			byte[] b = new byte[a.Count];

			for (int i = 0; i < b.Length - 1; i++)
				b[i] = (byte)(128 + (int)a[a.Count - i - 1]);
			
			b[b.Length - 1] = (byte)(int)a[0];

			return b;
		}

		private int EncodeDeltaTimes(ArrayList times)
		{
			// replaces the values of the "times" array with delta time
			int size = 0;

			for (int i = 0; i < times.Count; i++)
			{
				int k = (int)times[i];
				times[i] = EncodeDeltaTime(k);
				size += ((byte[])times[i]).Length;
			}

			return size;
		}

		private int EncodeMidiEvents(ArrayList events)
		{
			for (int i = 0; i < events.Count; i++)
			{
				int k = (int)events[i];
				// note 0 on the board is MIDI note 53
				// "note on"  events have the following byte structure: [90h] [note] [note_volume]
				// "note off" events have the following byte structure: [80h] [note] [note_volume]
				if (k > 0)
					events[i] = new byte[3] { 0x90, (byte)(k + 53), 0x50 };
				else
					events[i] = new byte[3] { 0x80, (byte)(-k + 53), 0x40 };
			}

			return events.Count * 3;
		}

		private byte[] EncodeSize(int value)
		{
			// represent an integer as a byte array
			byte[] b = new byte[4];

			for (int i = 0; i < 3; i++)
				b[i] = (byte)(value / (Math.Pow(256, 3 - i)));
			b[3] = (byte)(value % 256);

			return b;
		}

		private byte[] ToByteArray(string s)
		{
			// transforms a string into a byte array
			char[] c = s.ToCharArray();
			byte[] b = new byte[c.Length];

			for (int i = 0; i < b.Length; i++)
				b[i] = (byte)c[i];

			return b;
		}
	}
}