namespace DigitalSynth
{
	partial class HelpForm
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.closeButton = new System.Windows.Forms.Button();
			this.helpBrowser = new System.Windows.Forms.WebBrowser();
			this.SuspendLayout();
			// 
			// closeButton
			// 
			this.closeButton.Location = new System.Drawing.Point(384, 305);
			this.closeButton.Name = "closeButton";
			this.closeButton.Size = new System.Drawing.Size(75, 23);
			this.closeButton.TabIndex = 1;
			this.closeButton.Text = "Close";
			this.closeButton.UseVisualStyleBackColor = true;
			this.closeButton.Click += new System.EventHandler(this.closeButton_Click);
			// 
			// helpBrowser
			// 
			this.helpBrowser.Location = new System.Drawing.Point(12, 12);
			this.helpBrowser.MinimumSize = new System.Drawing.Size(20, 20);
			this.helpBrowser.Name = "helpBrowser";
			this.helpBrowser.Size = new System.Drawing.Size(447, 287);
			this.helpBrowser.TabIndex = 2;
			// 
			// HelpForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(471, 340);
			this.ControlBox = false;
			this.Controls.Add(this.helpBrowser);
			this.Controls.Add(this.closeButton);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Name = "HelpForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Help";
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.Button closeButton;
		private System.Windows.Forms.WebBrowser helpBrowser;


	}
}