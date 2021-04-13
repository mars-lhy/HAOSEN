using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DigitalSynth;

namespace DigitalSynth
{
	public partial class AudioConsoleForm : Form
	{
		public int handle;
		private int errorCode;
		private int currentEffect;
		private byte currentVoice;
		public int CurrentEffect
		{
			get { return currentEffect; }
		}
		public byte CurrentVoice
		{
			get { return currentVoice; }
		}

		private ReverbEffectForm reverbForm;
		private DelayEffectForm delayForm;
		private EchoEffectForm echoForm;
		private VibratoEffectForm vibratoForm;
		private FlangeEffectForm flangerForm;

		private HelpForm helpForm;


		public AudioConsoleForm(HelpForm helpForm)
		{
			InitializeComponent();
			this.helpForm = helpForm;
		}

		public void CreateAudioEffectForms(int handle)
		{
			reverbForm = new ReverbEffectForm(handle, helpForm);
			delayForm = new DelayEffectForm(handle, helpForm);
			echoForm = new EchoEffectForm(handle, helpForm);
			vibratoForm = new VibratoEffectForm(handle, helpForm);
			flangerForm = new FlangeEffectForm(handle, helpForm);
			this.handle = handle;
		}


		private void okButton_Click(object sender, EventArgs e)
		{
			if (playCheckBox.Checked)
			{
				// determine the current selected effect
				if (delayRadioButton.Checked || echoRadioButton.Checked)
					currentEffect = 1;
				else if (flangerRadioButton.Checked || vibratoRadioButton.Checked)
					currentEffect = 2;
				else if (reverbRadioButton.Checked)
					currentEffect = 3;
				else
					currentEffect = 0;
			}
			else
				currentEffect = 0;

			helpForm.Hide();
			this.Hide();
		}

		private void reverbRadioButton_Click(object sender, EventArgs e)
		{
			reverbForm.currentVoice = currentVoice;
			if (reverbRadioButton.Checked == true)
				reverbForm.ShowDialog();
			// if the user clicked "Cancel", then the "noneRadioButton" will be selected
			if (!reverbForm.EffectOn)
				noneRadioButton.Checked = true;
		}

		private void delayRadioButton_Click(object sender, EventArgs e)
		{
			delayForm.currentVoice = currentVoice;
			if (delayRadioButton.Checked == true)
				delayForm.ShowDialog();
			if (!delayForm.EffectOn)
				noneRadioButton.Checked = true;
		}

		private void echoRadioButton_Click(object sender, EventArgs e)
		{
			echoForm.currentVoice = currentVoice;
			if (echoRadioButton.Checked == true)
				echoForm.ShowDialog();
			if (!echoForm.EffectOn)
				noneRadioButton.Checked = true;
		}

		private void vibratoRadioButton_Click(object sender, EventArgs e)
		{
			vibratoForm.currentVoice = currentVoice;
			if (vibratoRadioButton.Checked == true)
				vibratoForm.ShowDialog();
			if (!vibratoForm.EffectOn)
				noneRadioButton.Checked = true;
		}

		private void flangerRadioButton_Click(object sender, EventArgs e)
		{
			flangerForm.currentVoice = currentVoice;
			if (flangerRadioButton.Checked == true)
				flangerForm.ShowDialog();
			if (!flangerForm.EffectOn)
				noneRadioButton.Checked = true;
		}

		private void noneRadioButton_Click(object sender, EventArgs e)
		{
			// if no effect is selected, the board will be set to the default values (only the voice remains the same)
			if (!DPCUTIL.DpcPutReg(handle, 0x00, currentVoice, ref errorCode, 0) | !DPCUTIL.DpcPutReg(handle, 0x83, 0xFF, ref errorCode, 0))
				MessageBox.Show("An error occured while trying to apply the changes.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
		}

		private void helpButton_Click(object sender, EventArgs e)
		{
			helpForm.LoadHelp("Effects");
			helpForm.Show();
		}

		private void sawtoothRadioButton_Click(object sender, EventArgs e)
		{
			currentVoice = 0x00; // the eighth bit is '0'
			byte currentControlByte = 0x00;
			// read the current control byte
			DPCUTIL.DpcGetReg(handle, 0x00, ref currentControlByte, ref errorCode, 0);
			if (currentControlByte >= 0x80)
			{
				// set the eighth bit to '0' (sawtooth voice)
				currentControlByte -= 128;
				if (!DPCUTIL.DpcPutReg(handle, 0x00, currentControlByte, ref errorCode, 0))
					MessageBox.Show("An error occured while trying to apply the changes.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private void squareRadioButton_Click(object sender, EventArgs e)
		{
			currentVoice = 0x80; // the eighth bit is '1'
			byte currentControlByte = 0x00;
			// read the current control byte
			DPCUTIL.DpcGetReg(handle, 0x00, ref currentControlByte, ref errorCode, 0);
			if (currentControlByte < 0x80)
			{
				// set the eighth bit to '1' (square voice)
				currentControlByte += 128;
				if (!DPCUTIL.DpcPutReg(handle, 0x00, currentControlByte, ref errorCode, 0))
					MessageBox.Show("An error occured while trying to apply the changes.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}
	}
}