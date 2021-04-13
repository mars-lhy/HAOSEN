namespace DigitalSynth
{
	partial class UsbCommunicationForm
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
			this.devicesGroupBox = new System.Windows.Forms.GroupBox();
			this.startStopButton = new System.Windows.Forms.Button();
			this.initializeButton = new System.Windows.Forms.Button();
			this.devicesComboBox = new System.Windows.Forms.ComboBox();
			this.devicesLabel = new System.Windows.Forms.Label();
			this.okButton = new System.Windows.Forms.Button();
			this.devicesGroupBox.SuspendLayout();
			this.SuspendLayout();
			// 
			// devicesGroupBox
			// 
			this.devicesGroupBox.Controls.Add(this.startStopButton);
			this.devicesGroupBox.Controls.Add(this.initializeButton);
			this.devicesGroupBox.Controls.Add(this.devicesComboBox);
			this.devicesGroupBox.Controls.Add(this.devicesLabel);
			this.devicesGroupBox.Location = new System.Drawing.Point(12, 12);
			this.devicesGroupBox.Name = "devicesGroupBox";
			this.devicesGroupBox.Size = new System.Drawing.Size(290, 88);
			this.devicesGroupBox.TabIndex = 1;
			this.devicesGroupBox.TabStop = false;
			this.devicesGroupBox.Text = "Digilent FPGA Devices";
			// 
			// startStopButton
			// 
			this.startStopButton.Location = new System.Drawing.Point(152, 49);
			this.startStopButton.Name = "startStopButton";
			this.startStopButton.Size = new System.Drawing.Size(75, 23);
			this.startStopButton.TabIndex = 4;
			this.startStopButton.Text = "Start";
			this.startStopButton.UseVisualStyleBackColor = true;
			this.startStopButton.Click += new System.EventHandler(this.startStopButton_Click);
			// 
			// initializeButton
			// 
			this.initializeButton.Location = new System.Drawing.Point(66, 49);
			this.initializeButton.Name = "initializeButton";
			this.initializeButton.Size = new System.Drawing.Size(75, 23);
			this.initializeButton.TabIndex = 0;
			this.initializeButton.Text = "Initialize";
			this.initializeButton.UseVisualStyleBackColor = true;
			this.initializeButton.Click += new System.EventHandler(this.initButton_Click);
			// 
			// devicesComboBox
			// 
			this.devicesComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.devicesComboBox.FormattingEnabled = true;
			this.devicesComboBox.Location = new System.Drawing.Point(120, 22);
			this.devicesComboBox.Name = "devicesComboBox";
			this.devicesComboBox.Size = new System.Drawing.Size(107, 21);
			this.devicesComboBox.TabIndex = 1;
			this.devicesComboBox.SelectedIndexChanged += new System.EventHandler(this.devicesComboBox_SelectedIndexChanged);
			// 
			// devicesLabel
			// 
			this.devicesLabel.AutoSize = true;
			this.devicesLabel.Location = new System.Drawing.Point(63, 26);
			this.devicesLabel.Name = "devicesLabel";
			this.devicesLabel.Size = new System.Drawing.Size(49, 13);
			this.devicesLabel.TabIndex = 0;
			this.devicesLabel.Text = "Devices:";
			// 
			// okButton
			// 
			this.okButton.Location = new System.Drawing.Point(227, 106);
			this.okButton.Name = "okButton";
			this.okButton.Size = new System.Drawing.Size(75, 23);
			this.okButton.TabIndex = 2;
			this.okButton.Text = "OK";
			this.okButton.UseVisualStyleBackColor = true;
			this.okButton.Click += new System.EventHandler(this.okButton_Click);
			// 
			// UsbCommunicationForm
			// 
			this.AcceptButton = this.okButton;
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(314, 139);
			this.ControlBox = false;
			this.Controls.Add(this.okButton);
			this.Controls.Add(this.devicesGroupBox);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "UsbCommunicationForm";
			this.ShowIcon = false;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "USB Communication";
			this.devicesGroupBox.ResumeLayout(false);
			this.devicesGroupBox.PerformLayout();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox devicesGroupBox;
		private System.Windows.Forms.Button startStopButton;
		private System.Windows.Forms.Button initializeButton;
		private System.Windows.Forms.ComboBox devicesComboBox;
		private System.Windows.Forms.Label devicesLabel;
		private System.Windows.Forms.Button okButton;
	}
}