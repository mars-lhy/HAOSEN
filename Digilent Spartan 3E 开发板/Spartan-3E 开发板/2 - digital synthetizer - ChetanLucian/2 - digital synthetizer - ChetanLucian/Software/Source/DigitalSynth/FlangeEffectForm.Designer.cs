namespace DigitalSynth
{
	partial class FlangeEffectForm
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
			this.panel3 = new System.Windows.Forms.Panel();
			this.triangularRadioButton = new System.Windows.Forms.RadioButton();
			this.sinusoidalRadioButton = new System.Windows.Forms.RadioButton();
			this.label3 = new System.Windows.Forms.Label();
			this.panel2 = new System.Windows.Forms.Panel();
			this.label2 = new System.Windows.Forms.Label();
			this.modulation1RadioButton = new System.Windows.Forms.RadioButton();
			this.modulation16RadioButton = new System.Windows.Forms.RadioButton();
			this.modulation4RadioButton = new System.Windows.Forms.RadioButton();
			this.modulation8RadioButton = new System.Windows.Forms.RadioButton();
			this.panel1 = new System.Windows.Forms.Panel();
			this.label1 = new System.Windows.Forms.Label();
			this.delay5RadioButton = new System.Windows.Forms.RadioButton();
			this.delay10RadioButton = new System.Windows.Forms.RadioButton();
			this.delay20RadioButton = new System.Windows.Forms.RadioButton();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.label6 = new System.Windows.Forms.Label();
			this.wetLabel = new System.Windows.Forms.Label();
			this.feedbackLabel = new System.Windows.Forms.Label();
			this.dryLabel = new System.Windows.Forms.Label();
			this.wetTrackBar = new System.Windows.Forms.TrackBar();
			this.feedbackTrackBar = new System.Windows.Forms.TrackBar();
			this.dryTrackBar = new System.Windows.Forms.TrackBar();
			this.label4 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.applyButton = new System.Windows.Forms.Button();
			this.okButton = new System.Windows.Forms.Button();
			this.cancelButton = new System.Windows.Forms.Button();
			this.helpButton = new System.Windows.Forms.Button();
			this.groupBox1.SuspendLayout();
			this.panel3.SuspendLayout();
			this.panel2.SuspendLayout();
			this.panel1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.wetTrackBar)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.feedbackTrackBar)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dryTrackBar)).BeginInit();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.panel3);
			this.groupBox1.Controls.Add(this.panel2);
			this.groupBox1.Controls.Add(this.panel1);
			this.groupBox1.Location = new System.Drawing.Point(12, 12);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(311, 249);
			this.groupBox1.TabIndex = 4;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Parameters";
			// 
			// panel3
			// 
			this.panel3.Controls.Add(this.triangularRadioButton);
			this.panel3.Controls.Add(this.sinusoidalRadioButton);
			this.panel3.Controls.Add(this.label3);
			this.panel3.Location = new System.Drawing.Point(6, 197);
			this.panel3.Name = "panel3";
			this.panel3.Size = new System.Drawing.Size(299, 48);
			this.panel3.TabIndex = 11;
			// 
			// triangularRadioButton
			// 
			this.triangularRadioButton.AutoSize = true;
			this.triangularRadioButton.Location = new System.Drawing.Point(171, 26);
			this.triangularRadioButton.Name = "triangularRadioButton";
			this.triangularRadioButton.Size = new System.Drawing.Size(72, 17);
			this.triangularRadioButton.TabIndex = 2;
			this.triangularRadioButton.Text = "Triangular";
			this.triangularRadioButton.UseVisualStyleBackColor = true;
			this.triangularRadioButton.Click += new System.EventHandler(this.triangularRadioButton_Click);
			// 
			// sinusoidalRadioButton
			// 
			this.sinusoidalRadioButton.AutoSize = true;
			this.sinusoidalRadioButton.Checked = true;
			this.sinusoidalRadioButton.Location = new System.Drawing.Point(171, 3);
			this.sinusoidalRadioButton.Name = "sinusoidalRadioButton";
			this.sinusoidalRadioButton.Size = new System.Drawing.Size(73, 17);
			this.sinusoidalRadioButton.TabIndex = 1;
			this.sinusoidalRadioButton.TabStop = true;
			this.sinusoidalRadioButton.Text = "Sinusoidal";
			this.sinusoidalRadioButton.UseVisualStyleBackColor = true;
			this.sinusoidalRadioButton.Click += new System.EventHandler(this.sinusoidalRadioButton_Click);
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(76, 5);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(89, 13);
			this.label3.TabIndex = 0;
			this.label3.Text = "Modulation Type:";
			// 
			// panel2
			// 
			this.panel2.Controls.Add(this.label2);
			this.panel2.Controls.Add(this.modulation1RadioButton);
			this.panel2.Controls.Add(this.modulation16RadioButton);
			this.panel2.Controls.Add(this.modulation4RadioButton);
			this.panel2.Controls.Add(this.modulation8RadioButton);
			this.panel2.Location = new System.Drawing.Point(6, 97);
			this.panel2.Name = "panel2";
			this.panel2.Size = new System.Drawing.Size(299, 94);
			this.panel2.TabIndex = 10;
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(77, 5);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(88, 13);
			this.label2.TabIndex = 4;
			this.label2.Text = "Modulation Rate:";
			// 
			// modulation1RadioButton
			// 
			this.modulation1RadioButton.AutoSize = true;
			this.modulation1RadioButton.Checked = true;
			this.modulation1RadioButton.Location = new System.Drawing.Point(171, 3);
			this.modulation1RadioButton.Name = "modulation1RadioButton";
			this.modulation1RadioButton.Size = new System.Drawing.Size(47, 17);
			this.modulation1RadioButton.TabIndex = 5;
			this.modulation1RadioButton.TabStop = true;
			this.modulation1RadioButton.Text = "1 Hz";
			this.modulation1RadioButton.UseVisualStyleBackColor = true;
			this.modulation1RadioButton.Click += new System.EventHandler(this.modulation1RadioButton_Click);
			// 
			// modulation16RadioButton
			// 
			this.modulation16RadioButton.AutoSize = true;
			this.modulation16RadioButton.Location = new System.Drawing.Point(171, 72);
			this.modulation16RadioButton.Name = "modulation16RadioButton";
			this.modulation16RadioButton.Size = new System.Drawing.Size(53, 17);
			this.modulation16RadioButton.TabIndex = 8;
			this.modulation16RadioButton.Text = "16 Hz";
			this.modulation16RadioButton.UseVisualStyleBackColor = true;
			this.modulation16RadioButton.Click += new System.EventHandler(this.modulation16RadioButton_Click);
			// 
			// modulation4RadioButton
			// 
			this.modulation4RadioButton.AutoSize = true;
			this.modulation4RadioButton.Location = new System.Drawing.Point(171, 26);
			this.modulation4RadioButton.Name = "modulation4RadioButton";
			this.modulation4RadioButton.Size = new System.Drawing.Size(47, 17);
			this.modulation4RadioButton.TabIndex = 6;
			this.modulation4RadioButton.Text = "4 Hz";
			this.modulation4RadioButton.UseVisualStyleBackColor = true;
			this.modulation4RadioButton.Click += new System.EventHandler(this.modulation4RadioButton_Click);
			// 
			// modulation8RadioButton
			// 
			this.modulation8RadioButton.AutoSize = true;
			this.modulation8RadioButton.Location = new System.Drawing.Point(171, 49);
			this.modulation8RadioButton.Name = "modulation8RadioButton";
			this.modulation8RadioButton.Size = new System.Drawing.Size(47, 17);
			this.modulation8RadioButton.TabIndex = 7;
			this.modulation8RadioButton.Text = "8 Hz";
			this.modulation8RadioButton.UseVisualStyleBackColor = true;
			this.modulation8RadioButton.Click += new System.EventHandler(this.modulation8RadioButton_Click);
			// 
			// panel1
			// 
			this.panel1.Controls.Add(this.label1);
			this.panel1.Controls.Add(this.delay5RadioButton);
			this.panel1.Controls.Add(this.delay10RadioButton);
			this.panel1.Controls.Add(this.delay20RadioButton);
			this.panel1.Location = new System.Drawing.Point(6, 19);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(299, 72);
			this.panel1.TabIndex = 9;
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(55, 5);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(110, 13);
			this.label1.TabIndex = 0;
			this.label1.Text = "Maximum Delay Time:";
			// 
			// delay5RadioButton
			// 
			this.delay5RadioButton.AutoSize = true;
			this.delay5RadioButton.Checked = true;
			this.delay5RadioButton.Location = new System.Drawing.Point(171, 3);
			this.delay5RadioButton.Name = "delay5RadioButton";
			this.delay5RadioButton.Size = new System.Drawing.Size(47, 17);
			this.delay5RadioButton.TabIndex = 1;
			this.delay5RadioButton.TabStop = true;
			this.delay5RadioButton.Text = "5 ms";
			this.delay5RadioButton.UseVisualStyleBackColor = true;
			this.delay5RadioButton.Click += new System.EventHandler(this.delay5RadioButton_Click);
			// 
			// delay10RadioButton
			// 
			this.delay10RadioButton.AutoSize = true;
			this.delay10RadioButton.Location = new System.Drawing.Point(171, 26);
			this.delay10RadioButton.Name = "delay10RadioButton";
			this.delay10RadioButton.Size = new System.Drawing.Size(53, 17);
			this.delay10RadioButton.TabIndex = 2;
			this.delay10RadioButton.Text = "10 ms";
			this.delay10RadioButton.UseVisualStyleBackColor = true;
			this.delay10RadioButton.Click += new System.EventHandler(this.delay10RadioButton_Click);
			// 
			// delay20RadioButton
			// 
			this.delay20RadioButton.AutoSize = true;
			this.delay20RadioButton.Location = new System.Drawing.Point(171, 50);
			this.delay20RadioButton.Name = "delay20RadioButton";
			this.delay20RadioButton.Size = new System.Drawing.Size(53, 17);
			this.delay20RadioButton.TabIndex = 3;
			this.delay20RadioButton.Text = "20 ms";
			this.delay20RadioButton.UseVisualStyleBackColor = true;
			this.delay20RadioButton.Click += new System.EventHandler(this.delay20RadioButton_Click);
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
			this.groupBox2.Controls.Add(this.label4);
			this.groupBox2.Controls.Add(this.label5);
			this.groupBox2.Location = new System.Drawing.Point(12, 267);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(311, 174);
			this.groupBox2.TabIndex = 5;
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
			this.feedbackTrackBar.Value = 60;
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
			// label4
			// 
			this.label4.AutoSize = true;
			this.label4.Location = new System.Drawing.Point(50, 137);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(30, 13);
			this.label4.TabIndex = 3;
			this.label4.Text = "Wet:";
			// 
			// label5
			// 
			this.label5.AutoSize = true;
			this.label5.Location = new System.Drawing.Point(54, 86);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(26, 13);
			this.label5.TabIndex = 0;
			this.label5.Text = "Dry:";
			// 
			// applyButton
			// 
			this.applyButton.Location = new System.Drawing.Point(248, 447);
			this.applyButton.Name = "applyButton";
			this.applyButton.Size = new System.Drawing.Size(75, 22);
			this.applyButton.TabIndex = 15;
			this.applyButton.Text = "Apply";
			this.applyButton.UseVisualStyleBackColor = true;
			this.applyButton.Click += new System.EventHandler(this.applyButton_Click);
			// 
			// okButton
			// 
			this.okButton.Location = new System.Drawing.Point(86, 447);
			this.okButton.Name = "okButton";
			this.okButton.Size = new System.Drawing.Size(75, 22);
			this.okButton.TabIndex = 16;
			this.okButton.Text = "OK";
			this.okButton.UseVisualStyleBackColor = true;
			this.okButton.Click += new System.EventHandler(this.okButton_Click);
			// 
			// cancelButton
			// 
			this.cancelButton.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.cancelButton.Location = new System.Drawing.Point(167, 447);
			this.cancelButton.Name = "cancelButton";
			this.cancelButton.Size = new System.Drawing.Size(75, 22);
			this.cancelButton.TabIndex = 17;
			this.cancelButton.Text = "Cancel";
			this.cancelButton.UseVisualStyleBackColor = true;
			this.cancelButton.Click += new System.EventHandler(this.cancelButton_Click);
			// 
			// helpButton
			// 
			this.helpButton.Location = new System.Drawing.Point(12, 447);
			this.helpButton.Name = "helpButton";
			this.helpButton.Size = new System.Drawing.Size(46, 22);
			this.helpButton.TabIndex = 18;
			this.helpButton.Text = "Help...";
			this.helpButton.UseVisualStyleBackColor = true;
			this.helpButton.Click += new System.EventHandler(this.helpButton_Click);
			// 
			// FlangerEffectForm
			// 
			this.AcceptButton = this.applyButton;
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.CancelButton = this.cancelButton;
			this.ClientSize = new System.Drawing.Size(335, 481);
			this.ControlBox = false;
			this.Controls.Add(this.applyButton);
			this.Controls.Add(this.okButton);
			this.Controls.Add(this.cancelButton);
			this.Controls.Add(this.helpButton);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.groupBox1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Name = "FlangerEffectForm";
			this.ShowIcon = false;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Flanger";
			this.groupBox1.ResumeLayout(false);
			this.panel3.ResumeLayout(false);
			this.panel3.PerformLayout();
			this.panel2.ResumeLayout(false);
			this.panel2.PerformLayout();
			this.panel1.ResumeLayout(false);
			this.panel1.PerformLayout();
			this.groupBox2.ResumeLayout(false);
			this.groupBox2.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.wetTrackBar)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.feedbackTrackBar)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dryTrackBar)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.Panel panel3;
		private System.Windows.Forms.RadioButton triangularRadioButton;
		private System.Windows.Forms.RadioButton sinusoidalRadioButton;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Panel panel2;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.RadioButton modulation1RadioButton;
		private System.Windows.Forms.RadioButton modulation16RadioButton;
		private System.Windows.Forms.RadioButton modulation4RadioButton;
		private System.Windows.Forms.RadioButton modulation8RadioButton;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.RadioButton delay5RadioButton;
		private System.Windows.Forms.RadioButton delay10RadioButton;
		private System.Windows.Forms.RadioButton delay20RadioButton;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Label wetLabel;
		private System.Windows.Forms.Label feedbackLabel;
		private System.Windows.Forms.Label dryLabel;
		private System.Windows.Forms.TrackBar wetTrackBar;
		private System.Windows.Forms.TrackBar feedbackTrackBar;
		private System.Windows.Forms.TrackBar dryTrackBar;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Button applyButton;
		private System.Windows.Forms.Button okButton;
		private System.Windows.Forms.Button cancelButton;
		private System.Windows.Forms.Button helpButton;
	}
}