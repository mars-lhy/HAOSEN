namespace DigitalSynth
{
	partial class NewFileForm
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
			this.radioButton34 = new System.Windows.Forms.RadioButton();
			this.radioButton44 = new System.Windows.Forms.RadioButton();
			this.optionsGroup = new System.Windows.Forms.GroupBox();
			this.titleLabel = new System.Windows.Forms.Label();
			this.titleTextBox = new System.Windows.Forms.TextBox();
			this.trackNameLabel = new System.Windows.Forms.Label();
			this.trackNameTextBox = new System.Windows.Forms.TextBox();
			this.timeSigLabel = new System.Windows.Forms.Label();
			this.inswtrumentVoiceLabel = new System.Windows.Forms.Label();
			this.instrumentVoiceList = new System.Windows.Forms.ListBox();
			this.okButton = new System.Windows.Forms.Button();
			this.cancelButton = new System.Windows.Forms.Button();
			this.optionsGroup.SuspendLayout();
			this.SuspendLayout();
			// 
			// radioButton34
			// 
			this.radioButton34.AutoSize = true;
			this.radioButton34.Location = new System.Drawing.Point(107, 79);
			this.radioButton34.Name = "radioButton34";
			this.radioButton34.Size = new System.Drawing.Size(42, 17);
			this.radioButton34.TabIndex = 2;
			this.radioButton34.Text = "3/4";
			this.radioButton34.UseVisualStyleBackColor = true;
			// 
			// radioButton44
			// 
			this.radioButton44.AutoSize = true;
			this.radioButton44.Checked = true;
			this.radioButton44.Location = new System.Drawing.Point(107, 102);
			this.radioButton44.Name = "radioButton44";
			this.radioButton44.Size = new System.Drawing.Size(42, 17);
			this.radioButton44.TabIndex = 3;
			this.radioButton44.TabStop = true;
			this.radioButton44.Text = "4/4";
			this.radioButton44.UseVisualStyleBackColor = true;
			// 
			// optionsGroup
			// 
			this.optionsGroup.Controls.Add(this.instrumentVoiceList);
			this.optionsGroup.Controls.Add(this.inswtrumentVoiceLabel);
			this.optionsGroup.Controls.Add(this.radioButton44);
			this.optionsGroup.Controls.Add(this.timeSigLabel);
			this.optionsGroup.Controls.Add(this.radioButton34);
			this.optionsGroup.Controls.Add(this.trackNameTextBox);
			this.optionsGroup.Controls.Add(this.trackNameLabel);
			this.optionsGroup.Controls.Add(this.titleTextBox);
			this.optionsGroup.Controls.Add(this.titleLabel);
			this.optionsGroup.Location = new System.Drawing.Point(12, 12);
			this.optionsGroup.Name = "optionsGroup";
			this.optionsGroup.Size = new System.Drawing.Size(364, 204);
			this.optionsGroup.TabIndex = 1;
			this.optionsGroup.TabStop = false;
			this.optionsGroup.Text = "Options";
			// 
			// titleLabel
			// 
			this.titleLabel.AutoSize = true;
			this.titleLabel.Location = new System.Drawing.Point(71, 30);
			this.titleLabel.Name = "titleLabel";
			this.titleLabel.Size = new System.Drawing.Size(30, 13);
			this.titleLabel.TabIndex = 0;
			this.titleLabel.Text = "Title:";
			// 
			// titleTextBox
			// 
			this.titleTextBox.Location = new System.Drawing.Point(107, 27);
			this.titleTextBox.Name = "titleTextBox";
			this.titleTextBox.Size = new System.Drawing.Size(224, 20);
			this.titleTextBox.TabIndex = 0;
			// 
			// trackNameLabel
			// 
			this.trackNameLabel.AutoSize = true;
			this.trackNameLabel.Location = new System.Drawing.Point(34, 56);
			this.trackNameLabel.Name = "trackNameLabel";
			this.trackNameLabel.Size = new System.Drawing.Size(69, 13);
			this.trackNameLabel.TabIndex = 2;
			this.trackNameLabel.Text = "Track Name:";
			// 
			// trackNameTextBox
			// 
			this.trackNameTextBox.Location = new System.Drawing.Point(107, 53);
			this.trackNameTextBox.Name = "trackNameTextBox";
			this.trackNameTextBox.Size = new System.Drawing.Size(224, 20);
			this.trackNameTextBox.TabIndex = 1;
			// 
			// timeSigLabel
			// 
			this.timeSigLabel.AutoSize = true;
			this.timeSigLabel.Location = new System.Drawing.Point(20, 81);
			this.timeSigLabel.Name = "timeSigLabel";
			this.timeSigLabel.Size = new System.Drawing.Size(81, 13);
			this.timeSigLabel.TabIndex = 4;
			this.timeSigLabel.Text = "Time Signature:";
			// 
			// inswtrumentVoiceLabel
			// 
			this.inswtrumentVoiceLabel.AutoSize = true;
			this.inswtrumentVoiceLabel.Location = new System.Drawing.Point(12, 125);
			this.inswtrumentVoiceLabel.Name = "inswtrumentVoiceLabel";
			this.inswtrumentVoiceLabel.Size = new System.Drawing.Size(89, 13);
			this.inswtrumentVoiceLabel.TabIndex = 5;
			this.inswtrumentVoiceLabel.Text = "Instrument Voice:";
			// 
			// instrumentVoiceList
			// 
			this.instrumentVoiceList.FormattingEnabled = true;
			this.instrumentVoiceList.Items.AddRange(new object[] {
            "Acoustic Grand Piano",
            "Acoustic Guitar",
            "Violin",
            "String Ensemble",
            "Brass Section"});
			this.instrumentVoiceList.Location = new System.Drawing.Point(107, 125);
			this.instrumentVoiceList.Name = "instrumentVoiceList";
			this.instrumentVoiceList.Size = new System.Drawing.Size(120, 69);
			this.instrumentVoiceList.TabIndex = 4;
			// 
			// okButton
			// 
			this.okButton.Location = new System.Drawing.Point(220, 222);
			this.okButton.Name = "okButton";
			this.okButton.Size = new System.Drawing.Size(75, 23);
			this.okButton.TabIndex = 5;
			this.okButton.Text = "OK";
			this.okButton.UseVisualStyleBackColor = true;
			this.okButton.Click += new System.EventHandler(this.okButton_Click);
			// 
			// cancelButton
			// 
			this.cancelButton.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.cancelButton.Location = new System.Drawing.Point(301, 222);
			this.cancelButton.Name = "cancelButton";
			this.cancelButton.Size = new System.Drawing.Size(75, 23);
			this.cancelButton.TabIndex = 6;
			this.cancelButton.Text = "Cancel";
			this.cancelButton.UseVisualStyleBackColor = true;
			this.cancelButton.Click += new System.EventHandler(this.cancelButton_Click);
			// 
			// NewFileForm
			// 
			this.AcceptButton = this.okButton;
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.CancelButton = this.cancelButton;
			this.ClientSize = new System.Drawing.Size(388, 257);
			this.ControlBox = false;
			this.Controls.Add(this.cancelButton);
			this.Controls.Add(this.okButton);
			this.Controls.Add(this.optionsGroup);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "NewFileForm";
			this.ShowIcon = false;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "New...";
			this.optionsGroup.ResumeLayout(false);
			this.optionsGroup.PerformLayout();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.RadioButton radioButton44;
		private System.Windows.Forms.RadioButton radioButton34;
		private System.Windows.Forms.GroupBox optionsGroup;
		private System.Windows.Forms.TextBox titleTextBox;
		private System.Windows.Forms.Label titleLabel;
		private System.Windows.Forms.TextBox trackNameTextBox;
		private System.Windows.Forms.Label trackNameLabel;
		private System.Windows.Forms.Label timeSigLabel;
		private System.Windows.Forms.ListBox instrumentVoiceList;
		private System.Windows.Forms.Label inswtrumentVoiceLabel;
		private System.Windows.Forms.Button okButton;
		private System.Windows.Forms.Button cancelButton;
	}
}