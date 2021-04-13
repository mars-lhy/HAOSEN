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
	public partial class DelayEffectForm : Form
	{
		HelpForm helpForm;
		
		private byte delayTimeValue;
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

		public DelayEffectForm(int handle, HelpForm helpForm)
		{
			InitializeComponent();

			this.helpForm = helpForm;

			this.handle = handle;
			this.dryLabel.Text = this.dryTrackBar.Value.ToString() + "%";
			this.wetLabel.Text = this.wetTrackBar.Value.ToString() + "%";

			delayTimeValue = 3;
			dryValue = (byte)(this.dryTrackBar.Value * 255 / 100);
			wetValue = (byte)(this.wetTrackBar.Value * 255 / 100);
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

		private void applyButton_Click(object sender, EventArgs e)
		{
			// send a control byte that selects the delay effect with the current voice
			if (!DPCUTIL.DpcPutReg(handle, 0x00, (byte)(0x02 + currentVoice), ref errorCode, 0))
			{
				MessageBox.Show("An error occured while trying to apply the changes. Please try again.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
				return;
			}

			writeAddress = 0x80;
			writeData = (byte)(delayTimeValue << 6); // bits 8 and 7 control the delay time parameter in the delay effect unit
			DPCUTIL.DpcPutReg(handle, writeAddress, writeData, ref errorCode, 0);

			writeAddress = 0x81;
			writeData = 0x00; // feedback parameter is zero
			DPCUTIL.DpcPutReg(handle, writeAddress, writeData, ref errorCode, 0);

			writeAddress = 0x82;
			writeData = wetValue; // wet parameter
			DPCUTIL.DpcPutReg(handle, writeAddress, writeData, ref errorCode, 0);

			writeAddress = 0x83;
			writeData = dryValue; // dry parameter
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
			helpForm.LoadHelp("Delay");
			helpForm.Show();
		}

		private byte EncodeData(byte value)
		{
			switch (value)
			{
				case 0: return 0x00;
				case 1: return 0x40;
				case 2: return 0x80;
				default: return 0xC0;
			}
		}
	}
}