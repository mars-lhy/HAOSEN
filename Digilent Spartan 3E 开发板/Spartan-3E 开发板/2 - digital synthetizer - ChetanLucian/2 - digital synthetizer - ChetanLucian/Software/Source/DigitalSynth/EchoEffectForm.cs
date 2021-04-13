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
	public partial class EchoEffectForm : Form
	{
		HelpForm helpForm;

		private byte delayTimeValue;
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

		public EchoEffectForm(int handle, HelpForm helpForm)
		{
			InitializeComponent();

			this.helpForm = helpForm;

			this.handle = handle;
			this.feedbackLabel.Text = this.feedbackTrackBar.Value.ToString() + "%";
			this.dryLabel.Text = this.dryTrackBar.Value.ToString() + "%";
			this.wetLabel.Text = this.wetTrackBar.Value.ToString() + "%";

			delayTimeValue = 3;
			feedbackValue = (byte)(this.feedbackTrackBar.Value * 255 / 100);
			dryValue = (byte)(this.dryTrackBar.Value * 255 / 100);
			wetValue = (byte)(this.wetTrackBar.Value * 255 / 100);
		}

		private void delay40RadioButton_Click(object sender, EventArgs e)
		{
			if (delay40RadioButton.Checked)
			{
				delayTimeValue = 0;
				applyButton.Enabled = true;
			}
		}

		private void delay80RadioButton_Click(object sender, EventArgs e)
		{
			if (delay80RadioButton.Checked)
			{
				delayTimeValue = 1;
				applyButton.Enabled = true;
			}
		}

		private void delay160RadioButton_Click(object sender, EventArgs e)
		{
			if (delay160RadioButton.Checked)
			{
				delayTimeValue = 2;
				applyButton.Enabled = true;
			}
		}

		private void delay320RadioButton_Click(object sender, EventArgs e)
		{
			if (delay320RadioButton.Checked)
			{
				delayTimeValue = 3;
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
			// set the echo effect and the current voice on the FPGA board
			if (!DPCUTIL.DpcPutReg(handle, 0x00, (byte)(0x02 + currentVoice), ref errorCode, 0))
			{
				MessageBox.Show("An error occured while trying to apply these changes. Please try again.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				return;
			}

			writeAddress = 0x80;
			writeData = (byte)(delayTimeValue << 6); // bits 8 and 7 represent the delay time parameter
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
			helpForm.LoadHelp("Echo");
			helpForm.Show();
		}
	}
}