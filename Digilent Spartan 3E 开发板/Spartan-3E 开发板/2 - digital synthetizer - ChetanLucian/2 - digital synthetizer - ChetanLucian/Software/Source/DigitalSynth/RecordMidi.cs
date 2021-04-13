using System.Collections;
using System.Windows.Forms;
using System.IO;

namespace DigitalSynth
{
	class RecordMidi
	{
		private MidiEncoder midiEncoder;
		private const int MAXEVENTS = 1000;
		private ArrayList rec = new ArrayList();
		private ArrayList times = new ArrayList();
		private ArrayList events = new ArrayList();
		private string fileName;
		private string title;
		private string trackName;
		private int upperTimeSignature;
		private int instrumentVoice;
		private int currentTime;
		private int previousTime;
		private int handle;
		private int errorCode;
		public bool ready;
		private byte[] address = new byte[4] { 0x01, 0x02, 0x03, 0x04 };
		private byte[] currentEvent = new byte[4];
		private byte[] previousEvent = new byte[4] { 0xFF, 0xFF, 0xFF, 0xFF };
		private bool recording;
		private bool midiFileCreated;
		public byte currentVoice;
		public bool Recording
		{
			get { return recording; }
			set { recording = value; }
		}
		public bool MidiFileCreated
		{
			get { return midiFileCreated; }
		}


		public RecordMidi(string fileName, string title, string trackName, int upperTimeSignature, int instrumentVoice, int handle, bool ready)
		{
			this.fileName = fileName;
			this.title = title;
			this.trackName = trackName;
			this.upperTimeSignature = upperTimeSignature;
			this.instrumentVoice = instrumentVoice;
			this.handle = handle;
			this.ready = ready;
		}


		public void StartRecording()
		{
			times.Clear();
			events.Clear();
			currentTime = 0;
			midiFileCreated = false;
			if (ready)
			{
				if (!DPCUTIL.DpcPutReg(handle, 0x00, currentVoice, ref errorCode, 0))
				{
					MessageBox.Show("An error occured while trying to setup the board for recording. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
					return;
				}
				recording = true;
			}
			else
				MessageBox.Show("Start the USB communication first.\n(Choose \"Settings > Options...\" in the menu.)", "Notification", MessageBoxButtons.OK, MessageBoxIcon.Warning);
		}

		public void StopRecording()
		{
			recording = false;
			if (times.Count > 0 && events.Count > 0)
			{
				times[0] = 0;
				midiEncoder = new MidiEncoder(fileName, times, events, title, trackName, upperTimeSignature, instrumentVoice);
				midiFileCreated = midiEncoder.RenderMidiFile();
			}
		}

		public void Record()
		{
			if (times.Count < MAXEVENTS)
			{
				if (GetData(address, currentEvent))
				{
					for (int i = 0; i < 4; i++)
					{
						if (currentEvent[i] < 31)
							currentEvent[i] = previousEvent[i];

						if (currentEvent[i] != previousEvent[i])
						{
							times.Add(currentTime - previousTime);
							previousTime = currentTime;
							if (currentEvent[i] != 31)
								events.Add(currentEvent[i] - 128);
							else
								events.Add(-previousEvent[i] + 128);
						}

						previousEvent[i] = currentEvent[i];
					}

					currentTime += 30;
				}
				else
				{
					StopRecording();
					MessageBox.Show("An error occured while trying to read data from the FPGA board.\nRecording will be stopped.\n\nNo MIDI file has been created.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
			}
			else
			{
				StopRecording();
				MessageBox.Show("The memory allocated for recording is now full.\nRecording will be stopped.", "Notification", MessageBoxButtons.OK, MessageBoxIcon.Information);
			}
		}

		private bool GetData(byte[] address, byte[] data)
		{
			if (ready)
				return DPCUTIL.DpcGetRegSet(handle, address, data, 4, ref errorCode, 0);
			else
				return false;
		}
	}
}