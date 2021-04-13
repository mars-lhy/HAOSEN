using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections;
using System.IO;

namespace DigitalSynth
{
	public partial class ApplicationForm : Form
	{
		private Graphics graphics;
		private DisplayElements displayElements;
		private MidiDecoder midiDecoder;
		private MidiInterpreter midiInterpreter;
		private PlayMidi playMidi;
		private RecordMidi recordMidi;
		private UsbCommunicationForm usbCommunicationForm = new UsbCommunicationForm();
		private HelpForm helpForm = new HelpForm();
		private AudioConsoleForm audioConsole;
		private NewFileForm newFileForm;

		private int currentMeasure;
		private int measureCount;
		private int pageNumber = 1;
		private int pageCount;
		private int handle;
		private bool error = true;
		private bool newFileCreated;
		private bool ready;


		public ApplicationForm()
		{
			InitializeComponent();
			// setting the form to be double buffered, for flicker free graphics
			this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.UserPaint | ControlStyles.DoubleBuffer, true);
			// initialize the graphics object for the panel that contains the music sheet
			graphics = this.musicSheetPanel.CreateGraphics();

			// some form elements are disabled by default
			this.statusLabel.Text = this.Text;
			this.previousButton.Enabled = false;
			this.redrawButton.Enabled = false;
			this.nextButton.Enabled = false;
			this.playButton.Enabled = false;
			this.recordButton.Enabled = false;
			this.pageTextBox.Enabled = false;
			this.goButton.Enabled = false;

			audioConsole = new AudioConsoleForm(helpForm);
		}


		private void musicSheetPanel_Paint(object sender, PaintEventArgs e)
		{
			// the paint event appears when the panel needs to be redrawn
			if (displayElements != null)
				displayElements.DrawElements(graphics);
		}

		private void previousButton_Click(object sender, EventArgs e)
		{
			// display the previous page of sheet music, that is the previous two measures
			// (only two measures are displayed at a time)
			if (currentMeasure - 2 >= 0)
			{
				currentMeasure = currentMeasure - 2;
				displayElements.GenerateMusicalElements(currentMeasure); // generate the notes and rests that correspond to the measures on that page
				musicSheetPanel.Invalidate(); // redraw the panel
				int x = currentMeasure / 2 + 1; // determine the current page
				pageTextBox.Text = x.ToString();
			}
		}

		private void nextButton_Click(object sender, EventArgs e)
		{
			// display the previous page of sheet music, that is the previous two measures
			// (only two measures are displayed at a time)
			if (currentMeasure + 2 < measureCount)
			{
				currentMeasure = currentMeasure + 2;
				displayElements.GenerateMusicalElements(currentMeasure);
				musicSheetPanel.Invalidate();
				int x = currentMeasure / 2 + 1; // the current page
				pageTextBox.Text = x.ToString();
			}
		}

		private void playButton_Click(object sender, EventArgs e)
		{
			// starts or stops the playing of the decoded MIDI file
			if (playMidi != null)
			{
				if (!playMidi.Playing)
				{
					// start playing
					this.pageTextBox.Text = "1";
					goButton_Click(null, null); // go to the first page
					this.playButton.Image = global::DigitalSynth.Properties.Resources.stop; // set the button to show the 'stop' icon
					playMidi.currentEffect = audioConsole.CurrentEffect; // update the value of the currently selected effect
					playMidi.currentVoice = audioConsole.CurrentVoice; // update the value of the currently selected voice
					playMidi.StartPlaying();
					musicSheetPanel.Invalidate();
					playTimer.Start();
					previousButton.Enabled = false; // disable some of the form elements while playing
					nextButton.Enabled = false;
					pageTextBox.Enabled = false;
					recordButton.Enabled = false;
					goButton.Enabled = false;
					newMenu.Enabled = false;
					openMenu.Enabled = false;
					usbCommunicationMenu.Enabled = false;
					audioConsoleMenu.Enabled = false;
					playTimer.Interval = (39 * 96) / midiDecoder.Tempo;
				}
				else
				{
					// stop playing
					this.playButton.Image = global::DigitalSynth.Properties.Resources.play; // set the button's icon to 'play'
					playMidi.StopPlaying();
					playTimer.Stop();
					EnableButtons();
					currentMeasure = 0; // go to the first page, that is to measure 0
					pageNumber = 1;
					displayElements.MovePlayBar(playMidi.CurrentMeasurePlaying); // bring the bar that indicates the currently played measure to the first page
					musicSheetPanel.Invalidate();
					pageTextBox.Text = "1";
					goButton_Click(null, null);
					newMenu.Enabled = true; // enable some form elements
					openMenu.Enabled = true;
					recordButton.Enabled = true;
					usbCommunicationMenu.Enabled = true;
					audioConsoleMenu.Enabled = true;
				}
			}
		}

		private void recordButton_Click(object sender, EventArgs e)
		{
			// starts or stops the recording of a new MIDI file
			// every time a new recording is started, the user must create a new file
			if (!newFileCreated)
			{
				CloseFiles(); // dispose of other 'newFile 'objects, and clear the panel
				CreateNewMidiFile();
			}

			if (recordMidi != null)
			{
				if (!recordMidi.Recording)
				{
					// start recording
					this.recordButton.Image = global::DigitalSynth.Properties.Resources.recOn; // set the button's icon to 'stop recording'
					recordMidi.currentVoice = audioConsole.CurrentVoice;
					recordMidi.StartRecording();
					musicSheetPanel.Invalidate();
					recordTimer.Start();
					playButton.Enabled = false;
					newMenu.Enabled = false;
					openMenu.Enabled = false;
					usbCommunicationMenu.Enabled = false;
					audioConsoleMenu.Enabled = false;
				}
				else
				{
					// stop recording
					this.recordButton.Image = global::DigitalSynth.Properties.Resources.rec;
					recordMidi.StopRecording();
					recordTimer.Stop();
					playButton.Enabled = true;
					newMenu.Enabled = true;
					openMenu.Enabled = true;
					usbCommunicationMenu.Enabled = true;
					audioConsoleMenu.Enabled = true;

					// the newly created file is displayed in the sheet panel
					if (recordMidi.MidiFileCreated)
					{
						MessageBox.Show("File has been successfully created.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
						if (String.IsNullOrEmpty(newFileForm.FileName))
							OpenMidiFile("Recordings\\Untitled.mid"); // if the file hasn't received a particular name, it will be named 'Untitled.mid'
						else
							OpenMidiFile("Recordings\\" + newFileForm.FileName + ".mid");
						newFileCreated = false;
						newFileForm.Dispose(); // dispose of the 'newFile' object
						this.musicSheetPanel.Invalidate(); // redraw the panel
					}
					else
						// some error has occured
						MessageBox.Show("File hasn't been created.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
				}
			}
		}

		private void openMenu_Click(object sender, EventArgs e)
		{
			// opens a MIDI file that will be decoded and displayed as a sheet music
			// the user must initialize the USB communication first
			if (!usbCommunicationForm.DpcReady)
			{
				MessageBox.Show("Initialize and start the USB communication first.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
				usbCommunicationMenu_Click(null, null);
			}

			// if the USB communication has been already initialized
			if (usbCommunicationForm.DpcReady)
			{
				if (openFileDialog.ShowDialog() == DialogResult.OK)
					OpenMidiFile(openFileDialog.FileName);
				else
					error = true;
			}
			this.musicSheetPanel.Invalidate();
		}

		private void OpenMidiFile(string path)
		{
			// decodes the MIDI file
			// the temporary information that will be used for interpreting the MIDI file is stored in the 'Temporary' folder
			midiDecoder = new MidiDecoder(path, "Temporary\\temp.tmp");
			if (midiDecoder.DecodeMidiFile() == 1)
			{
				// decoding has been successful
				midiInterpreter = new MidiInterpreter("Temporary\\temp.tmp", midiDecoder.DeltaTicks, midiDecoder.TotalDeltaTicks, midiDecoder.QuartersPerMeasure);
				if (midiInterpreter.InterpretMidi() == 1)
				{
					// interpreting has been also successful
					// gather all the information needed for displaying the sheet, such as the time signature, number of measures etc.
					string timeSignature = midiDecoder.TimeSignature;
					int upperTimeSignature = int.Parse(timeSignature.Substring(0, timeSignature.IndexOf('/')));
					int lowerTimeSignature = int.Parse(timeSignature.Substring(timeSignature.IndexOf('/') + 1, 1));

					currentMeasure = 0;
					measureCount = midiInterpreter.NumberOfMeasures;
					pageNumber = 1;
					pageCount = measureCount / 2 + measureCount % 2;
					pageTextBox.Text = pageNumber.ToString();
					pageLabel.Text = "of " + pageCount.ToString();
					statusLabel.Text = openFileDialog.FileName;

					// create the object responsible with the display of graphical elements
					displayElements = new DisplayElements(upperTimeSignature, lowerTimeSignature, midiInterpreter.NumberOfMeasures, midiInterpreter.MeasuresTrack1,
						midiInterpreter.MeasuresTrack2, midiInterpreter.MeasuresTrack3, midiInterpreter.MeasuresTrack4);
					// generate the first page of sheet music
					displayElements.GenerateMusicalElements(currentMeasure);
					musicSheetPanel.Invalidate();

					// create a 'PlayMidi' object
					playMidi = new PlayMidi(midiDecoder.TotalDeltaTicks, midiInterpreter.Notes, midiInterpreter.SlotAssignment, (int)midiDecoder.QuartersPerMeasure, handle, ready);

					this.redrawButton.Enabled = true;
					this.pageTextBox.Enabled = true;
					this.goButton.Enabled = true;
					EnableButtons();
					newFileCreated = false;
					error = false;
				}
				else
				{
					// interpreting hasn't been successful
					error = true;
					MessageBox.Show(midiInterpreter.ErrorString, this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
					musicSheetPanel.Invalidate();
				}
			}
			else
			{
				// decoding hasn't been successful
				error = true;
				MessageBox.Show(midiDecoder.ErrorString, this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
				musicSheetPanel.Invalidate();
			}
		}

		private void usbCommunicationMenu_Click(object sender, EventArgs e)
		{
			// initializes and starts the USB communication
			usbCommunicationForm.ShowDialog();
			handle = usbCommunicationForm.DpcHandle; // get the handle needed for the DPCUTIL methods
			ready = usbCommunicationForm.DpcReady; // get the status of the USB communication

			if (playMidi != null)
			{
				// if the USB is ready, MIDI files can be played on the FPGA board
				playMidi.ready = ready;
				playButton.Enabled = ready;
			}

			if (recordMidi != null)
				// if the USB is ready, new MIDI files can be recorded
				recordMidi.ready = ready;
			recordButton.Enabled = ready;
		}

		private void goButton_Click(object sender, EventArgs e)
		{
			// goes to the page specified in the text box
			// generates the measures that correspond to that specific page
			string str = pageTextBox.Text;
			int page;

			if (int.TryParse(str, out page))
			{
				if (page <= pageCount)
				{
					pageNumber = page;
					currentMeasure = (page - 1) * 2;

					displayElements.GenerateMusicalElements(currentMeasure);
					musicSheetPanel.Invalidate();
				}
				else
					// if a wrong number has been inserted, the text box will be set to the current page
					pageTextBox.Text = pageNumber.ToString();
			}
			else
				// if the text box didn't contain a number, it will be set to '1'
				pageTextBox.Text = "1";
		}

		private void exitMenu_Click(object sender, EventArgs e)
		{
			// closes the application
			ApplicationForm_FormClosing(null, null);
			this.Close();
		}

		private void reloadButton_Click(object sender, EventArgs e)
		{
			// redraw the panel
			musicSheetPanel.Invalidate();
		}

		private void playTimer_Tick(object sender, EventArgs e)
		{
			// for every timer tick, a MIDI message is being sent to the FPGA board
			if (playMidi.Playing)
			{
				playMidi.Play();
				Animate();
			}
			else
			{
				// the end of the file has been reached, so playing stops
				playTimer.Stop();
				this.playButton.Image = global::DigitalSynth.Properties.Resources.play;
				EnableButtons();
				newMenu.Enabled = true;
				openMenu.Enabled = true;
				recordButton.Enabled = true;
				usbCommunicationMenu.Enabled = true;
				audioConsoleMenu.Enabled = true;
			}
		}

		private void recordTimer_Tick(object sender, EventArgs e)
		{
			// for every timer tick, a MIDI message is being read from the FPGA board
			if (recordMidi.Recording)
				recordMidi.Record();
			else
			{
				// recording has been stopped
				recordTimer.Stop();
				this.recordButton.Image = global::DigitalSynth.Properties.Resources.rec;
				newMenu.Enabled = true;
				openMenu.Enabled = true;
				usbCommunicationMenu.Enabled = true;
				audioConsoleMenu.Enabled = true;
				playButton.Enabled = true;
			}
		}

		private void newMenu_Click(object sender, EventArgs e)
		{
			// creates a new MIDI file, that will be rendered to file if recording is successful
			// the dialog appears only if the USB commmunication is initialized
			if (!usbCommunicationForm.DpcReady)
			{
				MessageBox.Show("Initialize and start the USB communication first.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
				usbCommunicationMenu_Click(null, null);
			}
			if (usbCommunicationForm.DpcReady)
				CreateNewMidiFile();
			this.musicSheetPanel.Invalidate();
		}

		private void CloseFiles()
		{
			graphics.Clear(Color.White); // clear the panel
			if (newFileForm != null)
				newFileForm.Dispose(); // dispose 
		}
		
		private void CreateNewMidiFile()
		{
			// displays the 'New File' dialog
			newFileForm = new NewFileForm();
			newFileForm.ShowDialog();
			if (newFileForm.NewFileCreated)
			{
				// display a blank sheet, with the elements selected by the user
				graphics.Clear(Color.White);
				displayElements = new DisplayElements(newFileForm.TimeSignature, 4, 0, null, null, null, null);
				displayElements.DrawElements(graphics);
				musicSheetPanel.Invalidate();
				// create a new 'RecordMidi' object, so that the user can record MIDI messages from the FPGA board
				recordMidi = new RecordMidi(newFileForm.FileName, newFileForm.Title, newFileForm.TrackName,
					newFileForm.TimeSignature, newFileForm.InstrumentVoice, handle, ready);
				newFileCreated = true;
				this.playButton.Enabled = false;
			}
		}

		private void ApplicationForm_FormClosing(object sender, FormClosingEventArgs e)
		{
			// before exiting the application, these operations must be done:

			// stop playing and recording
			if (playMidi != null && playMidi.Playing)
				playMidi.StopPlaying();
			if (recordMidi != null && recordMidi.Recording)
				recordMidi.StopRecording();

			// close USB communication
			usbCommunicationForm.CloseCommunication();
		}

		private void EnableButtons()
		{
			// sets the state of some form elements
			if (measureCount <= 2)
			{
				nextButton.Enabled = false;
				previousButton.Enabled = false;
				pageTextBox.Enabled = false;
				goButton.Enabled = false;
			}
			else
			{
				nextButton.Enabled = true;
				previousButton.Enabled = true;
				pageTextBox.Enabled = true;
				goButton.Enabled = true;
			}

			if (ready)
			{
				this.playButton.Enabled = true;
				this.recordButton.Enabled = true;
			}
		}

		private void Animate()
		{
			// displays pages and the graphical element that show the current measure,
			// according to the position in the MIDI file that is currently being played
			if (currentMeasure != playMidi.CurrentMeasurePlaying)
			{
				currentMeasure = playMidi.CurrentMeasurePlaying;
				displayElements.MovePlayBar(playMidi.CurrentMeasurePlaying);
				musicSheetPanel.Invalidate();
			}
			int newPage = playMidi.CurrentMeasurePlaying / 2 + 1;
			if (pageNumber != newPage)
			{
				pageTextBox.Text = newPage.ToString();
				goButton_Click(null, null);
			}
		}

		private void audioEffectsMenu_Click(object sender, EventArgs e)
		{
			// displays the form that allows the user to select an audio effect
			if ((playMidi == null || !playMidi.Playing) && (recordMidi == null || !recordMidi.Recording))
			{
				if (!usbCommunicationForm.DpcReady)
				{
					MessageBox.Show("Initialize and start the USB communication first.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
					usbCommunicationMenu_Click(null, null);
				}
				if (usbCommunicationForm.DpcReady)
				{
					audioConsole.CreateAudioEffectForms(handle);
					audioConsole.ShowDialog();
				}
			}
		}

		private void contentsMenu_Click(object sender, EventArgs e)
		{
			// open the PDF document
			System.Diagnostics.Process.Start("UsersManual\\User's Manual.pdf");
		}

		private void aboutMenu_Click(object sender, EventArgs e)
		{
			AboutForm aboutForm = new AboutForm();
			aboutForm.ShowDialog();
		}

		private void ApplicationForm_KeyPress(object sender, KeyPressEventArgs e)
		{
			if (e.KeyChar == ' ')
				playButton_Click(null, null);
		}
	}
}