using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace DigitalSynth
{
	public partial class NewFileForm : Form
	{
		private bool newFileCreated;
		private string fileName;
		private string title;
		private string trackName;
		private int timeSignature = 4;
		private int instrumentVoice;

		public bool NewFileCreated
		{
			get { return newFileCreated; }
		}
		public string FileName
		{
			get { return fileName; }
		}
		public string Title
		{
			get { return title; }
		}
		public string TrackName
		{
			get { return trackName; }
		}
		public int TimeSignature
		{
			get { return timeSignature; }
		}
		public int InstrumentVoice
		{
			get { return instrumentVoice; }
		}

		public NewFileForm()
		{
			InitializeComponent();
			this.instrumentVoiceList.SelectedIndex = 0;
		}

		private void cancelButton_Click(object sender, EventArgs e)
		{
			newFileCreated = false;
			this.Close();
		}

		private void okButton_Click(object sender, EventArgs e)
		{
			newFileCreated = true;
			fileName = titleTextBox.Text;
			title = titleTextBox.Text;
			trackName = trackNameTextBox.Text;
			if (radioButton34.Checked)
				timeSignature = 3;
			else
				timeSignature = 4;

			// the instrument voice will be encoded in the resulting MIDI file
			switch (instrumentVoiceList.SelectedIndex)
			{
				case 0: instrumentVoice = 0; break; // Acoustic Grand Piano
				case 1: instrumentVoice = 24; break; // Acoustic Guitar
				case 2: instrumentVoice = 40; break; // Violin
				case 3: instrumentVoice = 48; break; // String Ensemble
				case 4: instrumentVoice = 61; break; // Brass Section
				default: instrumentVoice = 0; break;
			}

			this.Close();
		}
	}
}