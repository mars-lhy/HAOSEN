using System;
using System.IO;
using System.Collections;

namespace DigitalSynth
{
	/// <summary>
	/// Reads Meta and Midi Events and writes to file important note information (doesn't read SysEx Events)
	/// </summary>
	class MidiDecoder
	{
		/// <summary>
		/// A MIDI file has a "header chunk" and one or more "track chunk"s.
		/// The header chunk has the following fields:
		///		- chunk ID = MThd (4 bytes),
		///		- chunk size (4 bytes) [length value is always 6 bytes],
		///		- file format (2 bytes):
		///			+ 0 = single track
		///			+ 1 = multiple tracks (all start at the same time)
		///			+ 2 = multiple tracks (they start asynchronously)
		///		- the number of tracks (the number of track chunks),
		///		- the number of clock ticks per quarter note.
		/// The track chunk has the following fields:
		///		- chunk ID = MTrk (4 bytes),
		///		- chunk size (4 bytes) [a value equal to 'n'],
		///		- track data ('n' bytes).
		/// </summary>
		#region Structures, Objects, Variables, Constants, Other declarations

		private struct MThd_chunk
		{
			public char[] ID; // 4 chars
			public byte[] Length; // 4 bytes
			public byte[] Format; // 2 bytes
			public byte[] NumTracks; // 2 bytes
			public byte[] Division; // 2 bytes
		}
		private struct MTrk_chunk
		{
			public char[] ID; // 4 chars
			public byte[] Length; // 4 bytes
			//public byte[] Data; // n bytes
		}
		private FileStream midiFile;
		private FileStream writeFile;
		private BinaryReader binaryReader;
		private StreamWriter streamWriter;
		private MThd_chunk MThd;
		private MTrk_chunk MTrk;
		private string trackName;
		private int delta;
		private bool allowWritingToFile;
		private bool error;

		private string fileTitle;
		private string timeSignature;
		private float quartersPerMeasure;
		private int deltaTicks;
		private int totalDeltaTicks;
		private int tempo;
		private string errorString = null;

		public string FileTitle
		{
		    get { return fileTitle; }
		}
		public string TimeSignature
		{
			get { return timeSignature; }
		}
		public float QuartersPerMeasure
		{
			get { return quartersPerMeasure; }
		}
		public int DeltaTicks
		{
			get { return deltaTicks; }
		}
		public int TotalDeltaTicks
		{
			get { return totalDeltaTicks; }
		}
		public int Tempo
		{
			get { return tempo; }
		}
		public string ErrorString
		{
			get { return errorString; }
		}

		#endregion


		/// <summary>
		/// Creates a MIDI object that reads MIDI and Meta events of a MIDI file specified by the path,
		/// and that writes important note information to the output file.
		/// </summary>
		/// <param name="openFilePath">The path to the MIDI file to be opened.</param>
		/// <param name="writeFilePath">The path to the text file that will contain usefull information.</param>
		public MidiDecoder(string openFilePath, string writeFilePath)
		{
			// we try to open both files
			try
			{
				midiFile = new FileStream(openFilePath, FileMode.Open, FileAccess.Read);
				binaryReader = new BinaryReader(midiFile);
			}
			catch (Exception)
			{
				error = true;
				errorString = "MIDI file not found.";
			}

			try
			{
				writeFile = new FileStream(writeFilePath, FileMode.Create, FileAccess.Write);
				streamWriter = new StreamWriter(writeFile);
			}
			catch (Exception)
			{
				error = true;
				errorString = "Could not create the necessary files.";
			}
		}


		/// <summary>
		/// Reads the header chunk of the MIDI file.
		/// </summary>
		private void ReadHeader()
		{
			MThd.ID = binaryReader.ReadChars(4);
			MThd.Length = binaryReader.ReadBytes(4);
			MThd.Format = binaryReader.ReadBytes(2);
			MThd.NumTracks = binaryReader.ReadBytes(2);
			MThd.Division = binaryReader.ReadBytes(2);
			deltaTicks = CONVERTER.ConvertByteArrayToInt(MThd.Division);
		}

		/// <summary>
		/// Reads the track chunk specified by the track number.
		/// </summary>
		/// <param name="trackNumber">The number of the track to be read.</param>
		private void ReadTrack(int trackNumber)
		{
			MTrk.ID = binaryReader.ReadChars(4);
			MTrk.Length = binaryReader.ReadBytes(4);

			// we read the data bytes of the track and we decode the information they contain
			DecodeTrackData(CONVERTER.ConvertByteArrayToInt(MTrk.Length));
			if (trackNumber == 0)
				fileTitle = trackName; // the first track of the file usually contains the title of the entire file
		}

		/// <summary>
		/// Reads the delta time corresponding to an event.
		/// </summary>
		/// <returns>Returns the number of bytes of the delta time.</returns>
		private int ReadDeltaTime()
		{
			/* The delta time is a variable-length encoded value,
			 * that is it can represent large numbers using as many bytes as they need,
			 * without requiring smaller numbers to waste unused bytes.
			 * The delta time value is represented on a number of bytes, n.
			 * 1xxxxxxx  1xxxxxxx  ...  1xxxxxxx  0xxxxxxx
			 * byte 1    byte 2         byte n-1  byte n
			 * Every byte, except for the last, has the MSB equal to 1. The last byte has the MSB equal to 0.
			 * 
			 * We keep on reading bytes until we find a byte that has the MSB equal to 0.
			 */
			int readBytes = 1; // the delta time has at least one byte 
			Byte b = binaryReader.ReadByte();
			ArrayList byteArray = new ArrayList();
			byteArray.Add(b);

			// we keep on reading while MSB = 1 <=> byte_value >= 128
			while (b >= 0x80)
			{
				b = binaryReader.ReadByte();
				byteArray.Add(b);
				readBytes++;
			}

			// we set to 0 the MSB of all the bytes
			for (int i = 0; i < byteArray.Count; i++)
				byteArray[i] = ((byte)byteArray[i] & 0x7F); // 1abcdefg AND 01111111 = 0abcdefg

			// we have an array of bytes that we transform into an integer
			int deltaTimeValue = 0;
			for (int i = 0; i < readBytes; i++)
				deltaTimeValue += (int)((int)byteArray[i] * Math.Pow(256, readBytes - 1 - i)) >> (readBytes - 1 - i);

			delta += deltaTimeValue; // we add the delta to the offset
			totalDeltaTicks = delta;

			return readBytes;
		}

		/// <summary>
		/// Decodes the Meta Event identified by its corresponding ID.
		/// </summary>
		/// <param name="metaEvent">The ID of the Meta Event.</param>
		/// <returns>Returns the number of bytes of the Meta Event.</returns>
		private int ReadMetaEvent(byte metaEvent)
		{
			/* A Meta Event has the following format: 0xFF(1 byte) ID(1 byte) Length(1 byte) Info(n=length bytes)
			 * Each event has its own fixed form.
			 * Example:
			 *		FF 00 nn ss ss => Set the track's sequence number, nn = 0x02, ss ss = sequence number
			 *		FF 01 nn tt ... => Text event, nn = number of characters, tt = text character
			 *		etc...
			 */

			int readBytes;
			char[] info;
			
			switch (metaEvent)
			{
				case 0x00:
					// Sequence number
					binaryReader.ReadBytes(3);
					return 5; // "FF" byte + "00" byte + other 3 bytes = 5 bytes
				
				case 0x01:
					// Text
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadBytes(readBytes);
					return readBytes + 3;

				case 0x02:
					// Copyright information
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadBytes(readBytes);
					return readBytes + 3;
				
				case 0x03:
					// Track name
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					info = new char[readBytes];
					for (int i = 0; i < readBytes; i++)
						info[i] = (char)(binaryReader.ReadByte());
					trackName = new string(info);
					return readBytes + 3;
				
				case 0x04:
					// Instrument name
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadBytes(readBytes);
					return readBytes + 3;
				
				case 0x05:
					// Lyric
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadBytes(readBytes);
					return readBytes + 3;

				case 0x06:
					// Marker
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadBytes(readBytes);
					return readBytes + 3;

				case 0x07:
					// Cue point
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadBytes(readBytes);
					return readBytes + 3;

				case 0x2F:
					// End of track
					binaryReader.ReadByte();
					if (allowWritingToFile)
					{
						streamWriter.Write(delta + "_");
						streamWriter.WriteLine("EndOfFile");
					}
					return 3;

				case 0x51:
					// Tempo
					binaryReader.ReadByte();
					int msec = CONVERTER.ConvertByteArrayToInt(binaryReader.ReadBytes(3));
					tempo = 60000000 / msec;
					return 6;

				case 0x58:
					// Time signature
					binaryReader.ReadByte();
					timeSignature = IdentifyTimeSignature(binaryReader.ReadBytes(4));
					return 7;

				case 0x59:
					// Key signature
					binaryReader.ReadByte();
					IdentifyKeySignature((int)binaryReader.ReadByte(), (int)binaryReader.ReadByte());
					return 5;

				case 0x7F:
					// Sequencer specific information
					readBytes = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadBytes(readBytes);
					return readBytes + 3;

				default:
					return 2; // two bytes of the meta event are read already ("FF" + ID)
			}
		}

		/// <summary>
		/// Decodes the MIDI Event identified by its corresponding ID.
		/// </summary>
		/// <param name="midiEvent">The ID of the MIDI Event.</param>
		/// <returns>Returns the number of bytes of the MIDI Event.</returns>
		private int ReadMidiEvent(byte midiEvent)
		{
			/* A MIDI Event has the following form: ID(1 byte) Params(n bytes)
			 * Each event has its own fixed form.
			 * Example:
			 *		8x nn vv => Note Off event, x = channel number (0 to 15), nn = note number, vv = velocity
			 *		9x nn vv => Note On event
			 *		Cx pp => Program change event, pp = new value
			 *		etc...
			 */

			int result;
			midiEvent = (byte)(midiEvent >> 4);

			switch (midiEvent)
			{
				case 0x8:
					// Note off (requires reading 2 additional bytes, of which we use the first)
					result = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadByte();
					streamWriter.Write(delta + "_");
					streamWriter.WriteLine("Off_" + result);
					return 3;

				case 0x9:
					// Note on
					result = CONVERTER.ConvertByteToInt(binaryReader.ReadByte());
					binaryReader.ReadByte();
					streamWriter.Write(delta + "_");
					streamWriter.WriteLine("On_" + result);
					return 3;

				case 0xA:
					// Key after-touch
					binaryReader.ReadBytes(2);
					return 3;

				case 0xB:
					// Control change
					binaryReader.ReadBytes(2);
					return 3;

				case 0xC:
					// Program change
					binaryReader.ReadByte();
					return 2;

				case 0xD:
					// Channel after-touch
					binaryReader.ReadByte();
					return 2;

				case 0xE:
					// Pitch wheel change
					binaryReader.ReadBytes(2);
					return 3;

				default:
					return 1; // One byte is read already (ID)
			}
		}

		/// <summary>
		/// Decodes events (meta or MIDI).
		/// </summary>
		/// <returns>Returns the number of bytes (delta time and event).</returns>
		private int ReadEvents()
		{
			int deltaTimeBytes = ReadDeltaTime(); // first, we read the delta time
			int eventBytes = 0;

			Byte b = binaryReader.ReadByte(); // after the delta time, we read one byte to see the type of the following event
			if (b == 0xFF)
				eventBytes = ReadMetaEvent(binaryReader.ReadByte()); // we read a meta event, identified by the next byte
			else
				eventBytes = ReadMidiEvent(b); // we read a MIDI event

			return deltaTimeBytes + eventBytes;
		}

		/// <summary>
		/// Decodes the track chunk data.
		/// </summary>
		/// <param name="dataLength">The length of the data in the track chunk.</param>
		private void DecodeTrackData(int dataLength)
		{
			// while there is data still to be read...
			while (dataLength > 0)
				// we read events and we decrease the number of bytes that we haven't read yet
				dataLength -= ReadEvents();
		}

		/// <summary>
		/// Identifies the note's name based on its value.
		/// </summary>
		/// <param name="noteNumber">The number of the note.</param>
		/// <returns>Returns a string containing the note's name.</returns>
		//private string IdentifyNote(byte noteNumber)
		//{
		//    // noteNumber = pitch + octave * 12
		//    int octave = noteNumber / 12;
		//    int pitch = noteNumber % 12;

		//    switch (pitch)
		//    {
		//        case 0: return "C" + octave.ToString();
		//        case 1: return "C#" + octave.ToString();
		//        case 2: return "D" + octave.ToString();
		//        case 3: return "D#" + octave.ToString();
		//        case 4: return "E" + octave.ToString();
		//        case 5: return "F" + octave.ToString();
		//        case 6: return "F#" + octave.ToString();
		//        case 7: return "G" + octave.ToString();
		//        case 8: return "G#" + octave.ToString();
		//        case 9: return "A" + octave.ToString();
		//        case 10: return "A#" + octave.ToString();
		//        case 11: return "B" + octave.ToString();
		//        default: return "";
		//    }
		//}

		/// <summary>
		/// Identifies the time signature of the MIDI file.
		/// </summary>
		/// <param name="b">The array of bytes that contain the information.</param>
		/// <returns>Returns a string that contains the time signature.</returns>
		private string IdentifyTimeSignature(byte[] b)
		{
			int first = b[0];
			int second = 2 << (b[1] - 1);
			quartersPerMeasure = (4 * first) / second;
			return b[0] + "/" + (2 << (b[1] - 1));
		}

		/// <summary>
		/// Identifies the key signature of the MIDI file.
		/// </summary>
		/// <param name="key">The signed number of flats or sharps.</param>
		/// <param name="scaleType">The scale type: major = 0, minor = 1.</param>
		/// <returns></returns>
		private string IdentifyKeySignature(int key, int scaleType)
		{
			if (key > 127)
				key = 256 - key;

			switch (key)
			{
				case -7:
					if (scaleType == 0)
						return "Cb Major";
					else
						return "Ab Minor";
				case -6:
					if (scaleType == 0)
						return "Gb Major";
					else
						return "Eb Minor";
				case -5:
					if (scaleType == 0)
						return "Db Major";
					else
						return "Bb Minor";
				case -4:
					if (scaleType == 0)
						return "Ab Major";
					else
						return "F Minor";
				case -3:
					if (scaleType == 0)
						return "Eb Major";
					else
						return "C Minor";
				case -2:
					if (scaleType == 0)
						return "Bb Major";
					else
						return "G Minor";
				case -1:
					if (scaleType == 0)
						return "F Major";
					else
						return "D Minor";
				case 0:
					if (scaleType == 0)
						return "C Major";
					else
						return "A Minor";
				case 1:
					if (scaleType == 0)
						return "G Major";
					else
						return "E Minor";
				case 2:
					if (scaleType == 0)
						return "D Major";
					else
						return "B Minor";
				case 3:
					if (scaleType == 0)
						return "A Major";
					else
						return "F# Minor";
				case 4:
					if (scaleType == 0)
						return "E Major";
					else
						return "C# Minor";
				case 5:
					if (scaleType == 0)
						return "B Major";
					else
						return "G# Minor";
				case 6:
					if (scaleType == 0)
						return "F# Major";
					else
						return "D# Minor";
				case 7:
					if (scaleType == 0)
						return "C# Major";
					else
						return "A# Minor";
				default:
					return "";
			}
		}

		/// <summary>
		/// Decodes the MIDI file and writes to file usefull note information.
		/// </summary>
		/// <returns>Returns 1 if successfully. Returns -1 otherwise.</returns>
		public int DecodeMidiFile()
		{
			if (!error)
			{
				// there was no error while opening the files

				ReadHeader();
				// we allow decoding type-1 files, with only 2 tracks:
				// - the first track contains general information
				// - the second track contains note information
				if (CONVERTER.ConvertByteArrayToInt(MThd.Format) == 1)
				{
					// type-1 file
					if (CONVERTER.ConvertByteArrayToInt(MThd.NumTracks) == 2)
					{
						// there are 2 tracks
						for (int i = 0; i < 2; i++)
						{
							delta = 0; // reset "delta" for a new track
							if (i == 1)
								// we allow writing to file only the note information which is found in the second track
								allowWritingToFile = true;
							ReadTrack(i);
						}

						binaryReader.Close();
						midiFile.Close();
						streamWriter.Close();
						writeFile.Close();
						return 1; // exit successfully
					}
					else
						// there there are not 2 tracks
						errorString = "MIDI file has a wrong number of tracks.";
				}
				else
					// not type-1 file
					errorString = "MIDI file has a wrong format.";
			}

			if (binaryReader != null)
				binaryReader.Close();
			if (midiFile != null)
				midiFile.Close();
			if (streamWriter != null)
				streamWriter.Close();
			if (writeFile != null)
				writeFile.Close();
			return -1;
		}
	}
}