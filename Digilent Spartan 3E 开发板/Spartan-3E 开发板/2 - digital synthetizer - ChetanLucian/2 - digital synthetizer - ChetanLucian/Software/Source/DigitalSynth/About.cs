using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace FPGA
{
	public partial class About : Form
	{
		public About()
		{
			InitializeComponent();
		}

		private void About_Click(object sender, EventArgs e)
		{
			this.Close();
		}
	}
}