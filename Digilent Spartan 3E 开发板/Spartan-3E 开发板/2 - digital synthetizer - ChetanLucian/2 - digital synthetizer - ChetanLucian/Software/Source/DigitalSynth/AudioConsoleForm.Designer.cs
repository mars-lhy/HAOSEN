namespace DigitalSynth
{
	partial class AudioConsoleForm
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
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.vibratoRadioButton = new System.Windows.Forms.RadioButton();
			this.noneRadioButton = new System.Windows.Forms.RadioButton();
			this.delayRadioButton = new System.Windows.Forms.RadioButton();
			this.flangerRadioButton = new System.Windows.Forms.RadioButton();
			this.playCheckBox = new System.Windows.Forms.CheckBox();
			this.reverbRadioButton = new System.Windows.Forms.RadioButton();
			this.echoRadioButton = new System.Windows.Forms.RadioButton();
			this.okButton = new System.Windows.Forms.Button();
			this.helpButton = new System.Windows.Forms.Button();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.squareRadioButton = new System.Windows.Forms.RadioButton();
			this.sawtoothRadioButton = new System.Windows.Forms.RadioButton();
			this.groupBox1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.vibratoRadioButton);
			this.groupBox1.Controls.Add(this.noneRadioButton);
			this.groupBox1.Controls.Add(this.delayRadioButton);
			this.groupBox1.Controls.Add(this.flangerRadioButton);
			this.groupBox1.Controls.Add(this.playCheckBox);
			this.groupBox1.Controls.Add(this.reverbRadioButton);
			this.groupBox1.Controls.Add(this.echoRadioButton);
			this.groupBox1.Location = new System.Drawing.Point(12, 66);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(320, 100);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Audio Effects";
			// 
			// vibratoRadioButton
			// 
			this.vibratoRadioButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.vibratoRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.vibratoRadioButton.Location = new System.Drawing.Point(204, 19);
			this.vibratoRadioButton.Name = "vibratoRadioButton";
			this.vibratoRadioButton.Size = new System.Drawing.Size(75, 23);
			this.vibratoRadioButton.TabIndex = 4;
			this.vibratoRadioButton.Text = "Vibrato...";
			this.vibratoRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.vibratoRadioButton.UseVisualStyleBackColor = true;
			this.vibratoRadioButton.Click += new System.EventHandler(this.vibratoRadioButton_Click);
			// 
			// noneRadioButton
			// 
			this.noneRadioButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.noneRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.noneRadioButton.Checked = true;
			this.noneRadioButton.Location = new System.Drawing.Point(42, 19);
			this.noneRadioButton.Name = "noneRadioButton";
			this.noneRadioButton.Size = new System.Drawing.Size(75, 23);
			this.noneRadioButton.TabIndex = 0;
			this.noneRadioButton.TabStop = true;
			this.noneRadioButton.Text = "None";
			this.noneRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.noneRadioButton.UseVisualStyleBackColor = true;
			this.noneRadioButton.Click += new System.EventHandler(this.noneRadioButton_Click);
			// 
			// delayRadioButton
			// 
			this.delayRadioButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.delayRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.delayRadioButton.Location = new System.Drawing.Point(123, 48);
			this.delayRadioButton.Name = "delayRadioButton";
			this.delayRadioButton.Size = new System.Drawing.Size(75, 23);
			this.delayRadioButton.TabIndex = 2;
			this.delayRadioButton.Text = "Delay...";
			this.delayRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.delayRadioButton.UseVisualStyleBackColor = true;
			this.delayRadioButton.Click += new System.EventHandler(this.delayRadioButton_Click);
			// 
			// flangerRadioButton
			// 
			this.flangerRadioButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.flangerRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.flangerRadioButton.Location = new System.Drawing.Point(204, 48);
			this.flangerRadioButton.Name = "flangerRadioButton";
			this.flangerRadioButton.Size = new System.Drawing.Size(75, 23);
			this.flangerRadioButton.TabIndex = 5;
			this.flangerRadioButton.Text = "Flanger...";
			this.flangerRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.flangerRadioButton.UseVisualStyleBackColor = true;
			this.flangerRadioButton.Click += new System.EventHandler(this.flangerRadioButton_Click);
			// 
			// playCheckBox
			// 
			this.playCheckBox.AutoSize = true;
			this.playCheckBox.Location = new System.Drawing.Point(54, 77);
			this.playCheckBox.Name = "playCheckBox";
			this.playCheckBox.Size = new System.Drawing.Size(212, 17);
			this.playCheckBox.TabIndex = 2;
			this.playCheckBox.Text = "Play MIDI files using the selected effect";
			this.playCheckBox.UseVisualStyleBackColor = true;
			// 
			// reverbRadioButton
			// 
			this.reverbRadioButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.reverbRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.reverbRadioButton.Location = new System.Drawing.Point(42, 48);
			this.reverbRadioButton.Name = "reverbRadioButton";
			this.reverbRadioButton.Size = new System.Drawing.Size(75, 23);
			this.reverbRadioButton.TabIndex = 1;
			this.reverbRadioButton.Text = "Reverb...";
			this.reverbRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.reverbRadioButton.UseVisualStyleBackColor = true;
			this.reverbRadioButton.Click += new System.EventHandler(this.reverbRadioButton_Click);
			// 
			// echoRadioButton
			// 
			this.echoRadioButton.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.echoRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.echoRadioButton.Location = new System.Drawing.Point(123, 19);
			this.echoRadioButton.Name = "echoRadioButton";
			this.echoRadioButton.Size = new System.Drawing.Size(75, 23);
			this.echoRadioButton.TabIndex = 3;
			this.echoRadioButton.Text = "Echo...";
			this.echoRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.echoRadioButton.UseVisualStyleBackColor = true;
			this.echoRadioButton.Click += new System.EventHandler(this.echoRadioButton_Click);
			// 
			// okButton
			// 
			this.okButton.Location = new System.Drawing.Point(257, 172);
			this.okButton.Name = "okButton";
			this.okButton.Size = new System.Drawing.Size(75, 23);
			this.okButton.TabIndex = 0;
			this.okButton.Text = "OK";
			this.okButton.UseVisualStyleBackColor = true;
			this.okButton.Click += new System.EventHandler(this.okButton_Click);
			// 
			// helpButton
			// 
			this.helpButton.Location = new System.Drawing.Point(12, 172);
			this.helpButton.Name = "helpButton";
			this.helpButton.Size = new System.Drawing.Size(75, 23);
			this.helpButton.TabIndex = 1;
			this.helpButton.Text = "Help...";
			this.helpButton.UseVisualStyleBackColor = true;
			this.helpButton.Click += new System.EventHandler(this.helpButton_Click);
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.squareRadioButton);
			this.groupBox2.Controls.Add(this.sawtoothRadioButton);
			this.groupBox2.Location = new System.Drawing.Point(12, 12);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(320, 48);
			this.groupBox2.TabIndex = 3;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Voice";
			// 
			// squareRadioButton
			// 
			this.squareRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.squareRadioButton.Location = new System.Drawing.Point(163, 19);
			this.squareRadioButton.Name = "squareRadioButton";
			this.squareRadioButton.Size = new System.Drawing.Size(75, 23);
			this.squareRadioButton.TabIndex = 1;
			this.squareRadioButton.Text = "Square";
			this.squareRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.squareRadioButton.UseVisualStyleBackColor = true;
			this.squareRadioButton.Click += new System.EventHandler(this.squareRadioButton_Click);
			// 
			// sawtoothRadioButton
			// 
			this.sawtoothRadioButton.Appearance = System.Windows.Forms.Appearance.Button;
			this.sawtoothRadioButton.Checked = true;
			this.sawtoothRadioButton.Location = new System.Drawing.Point(82, 19);
			this.sawtoothRadioButton.Name = "sawtoothRadioButton";
			this.sawtoothRadioButton.Size = new System.Drawing.Size(75, 23);
			this.sawtoothRadioButton.TabIndex = 0;
			this.sawtoothRadioButton.TabStop = true;
			this.sawtoothRadioButton.Text = "Sawtooth";
			this.sawtoothRadioButton.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.sawtoothRadioButton.UseVisualStyleBackColor = true;
			this.sawtoothRadioButton.Click += new System.EventHandler(this.sawtoothRadioButton_Click);
			// 
			// AudioConsoleForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(344, 207);
			this.ControlBox = false;
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.helpButton);
			this.Controls.Add(this.okButton);
			this.Controls.Add(this.groupBox1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "AudioConsoleForm";
			this.ShowIcon = false;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Audio Console";
			this.groupBox1.ResumeLayout(false);
			this.groupBox1.PerformLayout();
			this.groupBox2.ResumeLayout(false);
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.RadioButton echoRadioButton;
		private System.Windows.Forms.RadioButton delayRadioButton;
		private System.Windows.Forms.RadioButton reverbRadioButton;
		private System.Windows.Forms.RadioButton flangerRadioButton;
		private System.Windows.Forms.RadioButton vibratoRadioButton;
		private System.Windows.Forms.RadioButton noneRadioButton;
		private System.Windows.Forms.Button okButton;
		private System.Windows.Forms.Button helpButton;
		private System.Windows.Forms.CheckBox playCheckBox;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.RadioButton sawtoothRadioButton;
		private System.Windows.Forms.RadioButton squareRadioButton;
	}
}