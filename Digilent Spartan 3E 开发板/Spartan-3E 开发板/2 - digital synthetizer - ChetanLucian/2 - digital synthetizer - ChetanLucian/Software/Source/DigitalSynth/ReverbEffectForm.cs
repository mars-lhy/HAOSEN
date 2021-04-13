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
	public partial class ReverbEffectForm : Form
	{
		HelpForm helpForm;

		private byte decayTypeValue;
		private byte feedbackValue;
		private byte dryValue;
		private byte wetValue;
		private bool effectOn;

		public bool EffectOn
		{
			get { return effectOn; }
		}

		private int handle;
		private int errorCode;
		private byte writeAddress;
		private byte writeData;

		public byte currentVoice;

		public ReverbEffectForm(int handle, HelpForm helpForm)
		{
			InitializeComponent();

			this.helpForm = helpForm;

			this.handle = handle;
			this.feedbackLabel.Text = this.feedbackTrackBar.Value.ToString() + "%";
			this.dryLabel.Text = this.dryTrackBar.Value.ToString() + "%";
			this.wetLabel.Text = this.wetTrackBar.Value.ToString() + "%";

			decayTypeValue = 0;
			feedbackValue = (byte)(this.feedbackTrackBar.Value * 255 / 100);
			dryValue = (byte)(this.dryTrackBar.Value * 255 / 100);
			wetValue = (byte)(this.wetTrackBar.Value * 255 / 100);
		}

		private void noneRadioButton_Click(object sender, EventArgs e)
		{
			if (noneRadioButton.Checked)
			{
				decayTypeValue = 0;
				applyButton.Enabled = true;
			}
		}

		private void exponentialRadioButton_Click(object sender, EventArgs e)
		{
			if (exponentialRadioButton.Checked)
			{
				decayTypeValue = 1;
				applyButton.Enabled = true;
			}
		}

		private void feedbackTrackBar_Scroll(object sender, EventArgs e)
		{
			this.feedbackLabel.Text = this.feedbackTrackBar.Value.ToString() + "%";
			feedbackValue = (byte)(this.feedbackTrackBar.Value * 255 / 100);
			applyButton.Enabled = true;
		}

		private void dryTrackBar_Scroll(object sender, EventArgs e)
		{
			this.dryLabel.Text = this.dryTrackBar.Value.ToString() + "%";
			dryValue = (byte)(this.dryTrackBar.Value * 255 / 100);
			applyButton.Enabled = true;
		}

		private void wetTrackBar_Scroll(object sender, EventArgs e)
		{
			this.wetLabel.Text = this.wetTrackBar.Value.ToString() + "%";
			wetValue = (byte)(this.wetTrackBar.Value * 255 / 100);
			applyButton.Enabled = true;
		}

		private void applyButton_Click(object sender, EventArgs e)
		{
			if (!DPCUTIL.DpcPutReg(handle, 0x00, (byte)(0x06 + currentVoice), ref errorCode, 0))
			{
				MessageBox.Show("An error occured while trying to apply these changes. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				return;
			}

			writeAddress = 0x80;
			writeData = decayTypeValue;
			DPCUTIL.DpcPutReg(handle, writeAddress, writeData, ref errorCode, 0);

			writeAddress = 0x81;
			writeData = feedbackValue;
			DPCUTIL.DpcPutReg(handle, writeAddress, writeData, ref errorCode, 0);

			writeAddress = 0x82;
			writeData = wetValue;
			DPCUTIL.DpcPutReg(handle, writeAddress, writeData, ref errorCode, 0);

			writeAddress = 0x83;
			writeData = dryValue;
			DPCUTIL.DpcPutReg(handle, writeAddress, writeData, ref errorCode, 0);

			effectOn = true; 
			applyButton.Enabled = false;
		}

		private void cancelButton_Click(object sender, EventArgs e)
		{
			if (!DPCUTIL.DpcPutReg(handle, 0x00, currentVoice, ref errorCode, 0) | !DPCUTIL.DpcPutReg(handle, 0x83, 0xFF, ref errorCode, 0))
				MessageBox.Show("An error occured while trying to apply the changes.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
			effectOn = false;
			this.applyButton.Enabled = true;
			helpForm.Hide();
			this.Hide();
		}

		private void okButton_Click(object sender, EventArgs e)
		{
			applyButton_Click(null, null);
			this.applyButton.Enabled = true;
			helpForm.Hide();
			this.Hide();
		}

		private void helpButton_Click(object sender, EventArgs e)
		{
			helpForm.LoadHelp("Reverb");
			helpForm.Show();
		}
	}
}