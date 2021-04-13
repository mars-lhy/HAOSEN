namespace DigitalSynth
{
	partial class ReverbEffectForm
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
			this.exponentialRadioButton = new System.Windows.Forms.RadioButton();
			this.noneRadioButton = new System.Windows.Forms.RadioButton();
			this.label1 = new System.Windows.Forms.Label();
			this.applyButton = new System.Windows.Forms.Button();
			this.okButton = new System.Windows.Forms.Button();
			this.cancelButton = new System.Windows.Forms.Button();
			this.helpButton = new System.Windows.Forms.Button();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.label6 = new System.Windows.Forms.Label();
			this.wetLabel = new System.Windows.Forms.Label();
			this.feedbackLabel = new System.Windows.Forms.Label();
			this.dryLabel = new System.Windows.Forms.Label();
			this.wetTrackBar = new System.Windows.Forms.TrackBar();
			this.feedbackTrackBar = new System.Windows.Forms.TrackBar();
			this.dryTrackBar = new System.Windows.Forms.TrackBar();
			this.label3 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.groupBox1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.wetTrackBar)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.feedbackTrackBar)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dryTrackBar)).BeginInit();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.exponentialRadioButton);
			this.groupBox1.Controls.Add(this.noneRadioButton);
			this.groupBox1.Controls.Add(this.label1);
			this.groupBox1.Location = new System.Drawing.Point(12, 12);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(311, 81);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Parameters";
			// 
			// exponentialRadioButton
			// 
			this.exponentialRadioButton.AutoSize = true;
			this.exponentialRadioButton.Location = new System.Drawing.Point(152, 48);
			this.exponentialRadioButton.Name = "exponentialRadioButton";
			this.exponentialRadioButton.Size = new System.Drawing.Size(80, 17);
			this.exponentialRadioButton.TabIndex = 2;
			this.exponentialRadioButton.TabStop = true;
			this.exponentialRadioButton.Text = "Exponential";
			this.exponentialRadioButton.UseVisualStyleBackColor = true;
			this.exponentialRadioButton.Click += new System.EventHandler(this.exponentialRadioButton_Click);
			// 
			// noneRadioButton
			// 
			this.noneRadioButton.AutoSize = true;
			this.noneRadioButton.Checked = true;
			this.noneRadioButton.Location = new System.Drawing.Point(152, 25);
			this.noneRadioButton.Name = "noneRadioButton";
			this.noneRadioButton.Size = new System.Drawing.Size(51, 17);
			this.noneRadioButton.TabIndex = 1;
			this.noneRadioButton.TabStop = true;
			this.noneRadioButton.Text = "None";
			this.noneRadioButton.UseVisualStyleBackColor = true;
			this.noneRadioButton.Click += new System.EventHandler(this.noneRadioButton_Click);
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(78, 27);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(68, 13);
			this.label1.TabIndex = 0;
			this.label1.Text = "Decay Type:";
			// 
			// applyButton
			// 
			this.applyButton.Location = new System.Drawing.Point(248, 281);
			this.applyButton.Name = "applyButton";
			this.applyButton.Size = new System.Drawing.Size(75, 22);
			this.applyButton.TabIndex = 2;
			this.applyButton.Text = "Apply";
			this.applyButton.UseVisualStyleBackColor = true;
			this.applyButton.Click += new System.EventHandler(this.applyButton_Click);
			// 
			// okButton
			// 
			this.okButton.Location = new System.Drawing.Point(86, 281);
			this.okButton.Name = "okButton";
			this.okButton.Size = new System.Drawing.Size(75, 22);
			this.okButton.TabIndex = 3;
			this.okButton.Text = "OK";
			this.okButton.UseVisualStyleBackColor = true;
			this.okButton.Click += new System.EventHandler(this.okButton_Click);
			// 
			// cancelButton
			// 
			this.cancelButton.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.cancelButton.Location = new System.Drawing.Point(167, 281);
			this.cancelButton.Name = "cancelButton";
			this.cancelButton.Size = new System.Drawing.Size(75, 22);
			this.cancelButton.TabIndex = 4;
			this.cancelButton.Text = "Cancel";
			this.cancelButton.UseVisualStyleBackColor = true;
			this.cancelButton.Click += new System.EventHandler(this.cancelButton_Click);
			// 
			// helpButton
			// 
			this.helpButton.Location = new System.Drawing.Point(12, 281);
			this.helpButton.Name = "helpButton";
			this.helpButton.Size = new System.Drawing.Size(46, 22);
			this.helpButton.TabIndex = 5;
			this.helpButton.Text = "Help...";
			this.helpButton.UseVisualStyleBackColor = true;
			this.helpButton.Click += new System.EventHandler(this.helpButton_Click);
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.label6);
			this.groupBox2.Controls.Add(this.wetLabel);
			this.groupBox2.Controls.Add(this.feedbackLabel);
			this.groupBox2.Controls.Add(this.dryLabel);
			this.groupBox2.Controls.Add(this.wetTrackBar);
			this.groupBox2.Controls.Add(this.feedbackTrackBar);
			this.groupBox2.Controls.Add(this.dryTrackBar);
			this.groupBox2.Controls.Add(this.label3);
			this.groupBox2.Controls.Add(this.label2);
			this.groupBox2.Location = new System.Drawing.Point(12, 99);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(311, 176);
			this.groupBox2.TabIndex = 1;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Mix";
			// 
			// label6
			// 
			this.label6.AutoSize = true;
			this.label6.Location = new System.Drawing.Point(25, 35);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(55, 13);
			this.label6.TabIndex = 6;
			this.label6.Text = "Feedback";
			// 
			// wetLabel
			// 
			this.wetLabel.AutoSize = true;
			this.wetLabel.Location = new System.Drawing.Point(258, 137);
			this.wetLabel.Name = "wetLabel";
			this.wetLabel.Size = new System.Drawing.Size(25, 13);
			this.wetLabel.TabIndex = 5;
			this.wetLabel.Text = "X %";
			// 
			// feedbackLabel
			// 
			this.feedbackLabel.AutoSize = true;
			this.feedbackLabel.Location = new System.Drawing.Point(260, 35);
			this.feedbackLabel.Name = "feedbackLabel";
			this.feedbackLabel.Size = new System.Drawing.Size(25, 13);
			this.feedbackLabel.TabIndex = 2;
			this.feedbackLabel.Text = "X %";
			// 
			// dryLabel
			// 
			this.dryLabel.AutoSize = true;
			this.dryLabel.Location = new System.Drawing.Point(258, 86);
			this.dryLabel.Name = "dryLabel";
			this.dryLabel.Size = new System.Drawing.Size(25, 13);
			this.dryLabel.TabIndex = 2;
			this.dryLabel.Text = "X %";
			// 
			// wetTrackBar
			// 
			this.wetTrackBar.LargeChange = 20;
			this.wetTrackBar.Location = new System.Drawing.Point(86, 121);
			this.wetTrackBar.Maximum = 100;
			this.wetTrackBar.Name = "wetTrackBar";
			this.wetTrackBar.Size = new System.Drawing.Size(166, 45);
			this.wetTrackBar.SmallChange = 10;
			this.wetTrackBar.TabIndex = 4;
			this.wetTrackBar.TickFrequency = 20;
			this.wetTrackBar.TickStyle = System.Windows.Forms.TickStyle.Both;
			this.wetTrackBar.Value = 100;
			this.wetTrackBar.Scroll += new System.EventHandler(this.wetTrackBar_Scroll);
			// 
			// feedbackTrackBar
			// 
			this.feedbackTrackBar.LargeChange = 20;
			this.feedbackTrackBar.Location = new System.Drawing.Point(86, 19);
			this.feedbackTrackBar.Maximum = 100;
			this.feedbackTrackBar.Name = "feedbackTrackBar";
			this.feedbackTrackBar.Size = new System.Drawing.Size(166, 45);
			this.feedbackTrackBar.SmallChange = 10;
			this.feedbackTrackBar.TabIndex = 1;
			this.feedbackTrackBar.TickFrequency = 20;
			this.feedbackTrackBar.TickStyle = System.Windows.Forms.TickStyle.Both;
			this.feedbackTrackBar.Scroll += new System.EventHandler(this.feedbackTrackBar_Scroll);
			// 
			// dryTrackBar
			// 
			this.dryTrackBar.LargeChange = 20;
			this.dryTrackBar.Location = new System.Drawing.Point(86, 70);
			this.dryTrackBar.Maximum = 100;
			this.dryTrackBar.Name = "dryTrackBar";
			this.dryTrackBar.Size = new System.Drawing.Size(166, 45);
			this.dryTrackBar.SmallChange = 10;
			this.dryTrackBar.TabIndex = 1;
			this.dryTrackBar.TickFrequency = 20;
			this.dryTrackBar.TickStyle = System.Windows.Forms.TickStyle.Both;
			this.dryTrackBar.Value = 90;
			this.dryTrackBar.Scroll += new System.EventHandler(this.dryTrackBar_Scroll);
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(50, 137);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(30, 13);
			this.label3.TabIndex = 3;
			this.label3.Text = "Wet:";
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(54, 86);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(26, 13);
			this.label2.TabIndex = 0;
			this.label2.Text = "Dry:";
			// 
			// ReverbEffectForm
			// 
			this.AcceptButton = this.applyButton;
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.CancelButton = this.cancelButton;
			this.ClientSize = new System.Drawing.Size(335, 315);
			this.ControlBox = false;
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.applyButton);
			this.Controls.Add(this.okButton);
			this.Controls.Add(this.cancelButton);
			this.Controls.Add(this.helpButton);
			this.Controls.Add(this.groupBox1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Name = "ReverbEffectForm";
			this.ShowIcon = false;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Reverb";
			this.groupBox1.ResumeLayout(false);
			this.groupBox1.PerformLayout();
			this.groupBox2.ResumeLayout(false);
			this.groupBox2.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.wetTrackBar)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.feedbackTrackBar)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dryTrackBar)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.RadioButton exponentialRadioButton;
		private System.Windows.Forms.RadioButton noneRadioButton;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Button applyButton;
		private System.Windows.Forms.Button okButton;
		private System.Windows.Forms.Button cancelButton;
		private System.Windows.Forms.Button helpButton;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TrackBar wetTrackBar;
		private System.Windows.Forms.TrackBar dryTrackBar;
		private System.Windows.Forms.Label wetLabel;
		private System.Windows.Forms.Label dryLabel;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Label feedbackLabel;
		private System.Windows.Forms.TrackBar feedbackTrackBar;
	}
}