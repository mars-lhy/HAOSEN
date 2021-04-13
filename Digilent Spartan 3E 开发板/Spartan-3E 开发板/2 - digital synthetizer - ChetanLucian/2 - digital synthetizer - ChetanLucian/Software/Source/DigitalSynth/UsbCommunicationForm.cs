using System;
using System.Text;
using System.Windows.Forms;
using DigitalSynth;

namespace DigitalSynth
{
	public partial class UsbCommunicationForm : Form
	{
		private int errorCode;
		private int deviceCount;
		private int deviceType;
		private int handle;
		private StringBuilder deviceName = new StringBuilder();
		private bool initialized;
		private bool ready;

		public bool DpcReady
		{
			get { return ready; }
		}
		public int DpcHandle
		{
			get { return handle; }
		}


		public UsbCommunicationForm()
		{
			InitializeComponent();
			initialized = false;
		}


		private void initButton_Click(object sender, EventArgs e)
		{
			startStopButton.Text = "Start";
			devicesComboBox.Enabled = true;
			devicesComboBox.Items.Clear();
			if (DPCUTIL.DpcInit(ref errorCode))
			{
				deviceCount = DPCUTIL.DvmgGetDevCount(ref errorCode);
				Console.WriteLine("Number of devices: " + deviceCount);

				for (int deviceIndex = 0; deviceIndex < deviceCount; deviceIndex++)
					if (DPCUTIL.DvmgGetDevName(deviceIndex, deviceName, ref errorCode))
					{
						DPCUTIL.DvmgGetDevType(deviceIndex, ref deviceType, ref errorCode);
						devicesComboBox.Items.Add(deviceName.ToString());
					}
					else
					{
						MessageBox.Show("An error occured while trying to read the attached devices. Please try initializing again.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
						return;
					}

				devicesComboBox.SelectedIndex = DPCUTIL.DvmgGetDefaultDev(ref errorCode);
				DPCUTIL.DpcOpenData(ref handle, deviceName, ref errorCode, 0);
				initialized = true;
			}
		}

		private void startStopButton_Click(object sender, EventArgs e)
		{
			if (initialized)
			{
				//deviceName = new StringBuilder(devicesComboBox.SelectedItem.ToString());
				devicesComboBox.SelectedItem = deviceName.ToString();

				if (startStopButton.Text == "Start")
				{
					if (!DPCUTIL.DpcOpenData(ref handle, deviceName, ref errorCode, 0))
					{
						if (DPCUTIL.DpcOpenData(ref handle, deviceName, ref errorCode, 0))
						{
							ready = true;
							DPCUTIL.DpcPutReg(handle, 0x00, 0x00, ref errorCode, 0);
							DPCUTIL.DpcPutReg(handle, 0x83, 0xFF, ref errorCode, 0);
						}
						else
						{
							ready = false;
							MessageBox.Show("An error occured while trying to establish a connection\nwith the selected device. Please try again.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
							return;
						}
					}
					startStopButton.Text = "Stop";
					devicesComboBox.Enabled = false;
					initializeButton.Enabled = false;
				}
				else
				{
					if (!DPCUTIL.DpcCloseData(handle, ref errorCode))
					{
						MessageBox.Show("An error occured while trying to close communication. Please try again.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
						return;
					}
					ready = false;
					startStopButton.Text = "Start";
					devicesComboBox.Enabled = true;
					initializeButton.Enabled = true;
				}
			}
			else
				MessageBox.Show("Press \"Initialize\" to search for FPGA devices.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
		}

		private void okButton_Click(object sender, EventArgs e)
		{
			this.Hide();

		}

		public void CloseCommunication()
		{
			//DPCUTIL.DpcCloseData(handle, ref errorCode);
			DPCUTIL.DpcTerm();
		}

		private void devicesComboBox_SelectedIndexChanged(object sender, EventArgs e)
		{
			deviceName = new StringBuilder(devicesComboBox.SelectedItem.ToString());
		}
	}
}