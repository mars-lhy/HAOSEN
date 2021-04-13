using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace DigitalSynth
{
	public partial class HelpForm : Form
	{
		public HelpForm()
		{
			InitializeComponent();
		}

		private void closeButton_Click(object sender, EventArgs e)
		{
			this.Hide();
		}

		public void LoadHelp(string help)
		{
			// load help from HTML files and display them in the browser
			string currentDirectory = System.IO.Directory.GetCurrentDirectory();
			string uri = "file:\\" + currentDirectory + "\\Help\\" + help + ".htm";
			helpBrowser.Navigate(uri);
		}
	}
}