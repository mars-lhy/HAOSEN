using System.Windows.Forms;
using System.Collections;
using System.IO;
using System;

namespace DigitalSynth
{
	class PlayMidi
	{
		private ArrayList notes;
		private ArrayList endingNotes;
		private ArrayList endingNotesSlots;
		private int[] slotAssignment;
		private int notesCount;
		private int index;
		private int time;
		private int duration;
		private int handle;
		private int quartersPerMeasure;
		private int errorCode;
		private int currentMeasurePlaying;
		public bool ready;

		private bool playing;
		public bool Playing
		{
			get { return playing; }
			set { playing = value; }
		}
		public int CurrentMeasurePlaying
		{
			get { return currentMeasurePlaying; }
		}
		public int currentEffect;
		public byte currentVoice;


		public PlayMidi(int duration, ArrayList notes, int[] slotAssignment, int quartersPerMeasure, int handle, bool ready)
		{
			this.duration = duration;
			this.notes = notes;
			this.slotAssignment = slotAssignment;
			this.quartersPerMeasure = quartersPerMeasure;
			this.handle = handle;
			this.ready = ready;

			this.notesCount = slotAssignment.Length;
			this.endingNotes = new ArrayList(4);
			this.endingNotesSlots = new ArrayList(4);
		}


		public void StartPlaying()
		{
			time = 0;
			index = 0;
			currentMeasurePlaying = 0;
			if (ready)
			{
				byte effectSetup = (byte)((byte)(currentEffect << 1) + 1);
				if (!DPCUTIL.DpcPutReg(handle, 0x00, (byte)(effectSetup + currentVoice), ref errorCode, 0))
				{
					MessageBox.Show("An error occured while trying to setup the board for playing. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
					return;
				}
				playing = true;
			}
			else
				MessageBox.Show("Start the USB communication first.\n(Choose \"Settings > Options...\" in the menu.)", "Notification", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
		}

		public void StopPlaying()
		{
			playing = false;
			currentMeasurePlaying = 0;
			if (ready)
			{
				DPCUTIL.DpcPutReg(handle, 0x01, 0x00, ref errorCode, 0);
				DPCUTIL.DpcPutReg(handle, 0x02, 0x00, ref errorCode, 0);
				DPCUTIL.DpcPutReg(handle, 0x03, 0x00, ref errorCode, 0);
				DPCUTIL.DpcPutReg(handle, 0x04, 0x00, ref errorCode, 0);
				byte effectSetup = (byte)(currentEffect << 1);
				if (!DPCUTIL.DpcPutReg(handle, 0x00, (byte)(effectSetup + currentVoice), ref errorCode, 0))
				{
					MessageBox.Show("An error occured while trying to setup the board for keyboard playing. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
					return;
				}
			}
		}

		public void Play()
		{
			if (time < duration)
			{
				while (index < notesCount && ((MidiInterpreter.RawNote)notes[index]).start == time)
				{
					MidiInterpreter.RawNote note = (MidiInterpreter.RawNote)notes[index];
					endingNotes.Add(note); // ending notes are those that are played completely and that need to be stopped
					endingNotesSlots.Add(slotAssignment[index]);

					if (!SendData((byte)(slotAssignment[index]), EncodeData(1, note.note)))
					{
						StopPlaying();
						MessageBox.Show("An error occured while trying to send data to the FPGA board.\nPlaying will be stopped.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
						return;
					}
					index++;
				}

				// stopping the notes that have been played completely
				for (int i = endingNotes.Count - 1; i >= 0; i--)
				{
					MidiInterpreter.RawNote note = (MidiInterpreter.RawNote)endingNotes[i];
					if (Math.Abs(note.end - time) < 30)
					{
						if (!SendData((byte)(int)endingNotesSlots[i], EncodeData(0, note.note)))
						{
							StopPlaying();
							MessageBox.Show("An error occured while trying to send data to the FPGA board.\nPlaying will be stopped.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
							return;
						}
						endingNotes.RemoveAt(i);
						endingNotesSlots.RemoveAt(i);
						i--;
					}
				}
				currentMeasurePlaying = time / (quartersPerMeasure * 480);
				time += 30;
			}
			else
				StopPlaying();
		}

		private bool SendData(byte address, byte data)
		{
			if (ready)
				return DPCUTIL.DpcPutReg(handle, address, data, ref errorCode, 0);
			else
				return false;
		}

		private byte EncodeData(int messageType, int note)
		{
			// messageType = 0 => Off
			// messageType = 1 => On

			byte data = 0x00;

			if (messageType == 1)
				data += 0x80;
			data += (byte)(note - 53);

			return data;
		}
	}
}