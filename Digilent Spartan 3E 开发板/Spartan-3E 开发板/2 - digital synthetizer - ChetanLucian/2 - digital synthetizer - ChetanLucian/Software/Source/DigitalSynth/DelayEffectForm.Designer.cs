namespace DigitalSynth
{
	partial class DelayEffectForm
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
			this.delay320RadioButton = new System.Windows.Forms.RadioButton();
			this.delay160RadioButton = new System.Windows.Forms.RadioButton();
			this.delay80RadioButton = new System.Windows.Forms.RadioButton();
			this.delay40RadioButton = new System.Windows.Forms.RadioButton();
			this.label1 = new System.Windows.Forms.Label();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.wetLabel = new System.Windows.Forms.Label();
			this.dryLabel = new System.Windows.Forms.Label();
			this.wetTrackBar = new System.Windows.Forms.TrackBar();
			this.dryTrackBar = new System.Windows.Forms.TrackBar();
			this.label3 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.applyButton = new System.Windows.Forms.Button();
			this.okButton = new System.Windows.Forms.Button();
			this.cancelButton = new System.Windows.Forms.Button();
			this.helpButton = new System.Windows.Forms.Button();
			this.groupBox1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.wetTrackBar)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dryTrackBar)).BeginInit();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.delay320RadioButton);
			this.groupBox1.Controls.Add(this.delay160RadioButton);
			this.groupBox1.Controls.Add(this.delay80RadioButton);
			this.groupBox1.Controls.Add(this.delay40RadioButton);
			this.groupBox1.Controls.Add(this.label1);
			this.groupBox1.Location = new System.Drawing.Point(12, 12);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(311, 120);
			this.groupBox1.TabIndex = 1;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Parameters";
			// 
			// delay320RadioButton
			// 
			this.delay320RadioButton.AutoSize = true;
			this.delay320RadioButton.Checked = true;
			this.delay320RadioButton.Location = new System.Drawing.Point(160, 90);
			this.delay320RadioButton.Name = "delay320RadioButton";
			this.delay320RadioButton.Size = new System.Drawing.Size(59, 17);
			this.delay320RadioButton.TabIndex = 4;
			this.delay320RadioButton.TabStop = true;
			this.delay320RadioButton.Text = "320 ms";
			this.delay320RadioButton.UseVisualStyleBackColor = true;
			this.delay320RadioButton.Click += new System.EventHandler(this.delay320RadioButton_Click);
			// 
			// delay160RadioButton
			// 
			this.delay160RadioButton.AutoSize = true;
			this.delay160RadioButton.Location = new System.Drawing.Point(160, 66);
			this.delay160RadioButton.Name = "delay160RadioButton";
			this.delay160RadioButton.Size = new System.Drawing.Size(59, 17);
			this.delay160RadioButton.TabIndex = 3;
			this.delay160RadioButton.Text = "160 ms";
			this.delay160RadioButton.UseVisualStyleBackColor = true;
			this.delay160RadioButton.Click += new System.EventHandler(this.delay160RadioButton_Click);
			// 
			// delay80RadioButton
			// 
			this.delay80RadioButton.AutoSize = true;
			this.delay80RadioButton.Location = new System.Drawing.Point(160, 42);
			this.delay80RadioButton.Name = "delay80RadioButton";
			this.delay80RadioButton.Size = new System.Drawing.Size(53, 17);
			this.delay80RadioButton.TabIndex = 2;
			this.delay80RadioButton.Text = "80 ms";
			this.delay80RadioButton.UseVisualStyleBackColor = true;
			this.delay80RadioButton.Click += new System.EventHandler(this.delay80RadioButton_Click);
			// 
			// delay40RadioButton
			// 
			this.delay40RadioButton.AutoSize = true;
			this.delay40RadioButton.Location = new System.Drawing.Point(160, 19);
			this.delay40RadioButton.Name = "delay40RadioButton";
			this.delay40RadioButton.Size = new System.Drawing.Size(53, 17);
			this.delay40RadioButton.TabIndex = 1;
			this.delay40RadioButton.Text = "40 ms";
			this.delay40RadioButton.UseVisualStyleBackColor = true;
			this.delay40RadioButton.Click += new System.EventHandler(this.delay40RadioButton_Click);
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(91, 21);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(63, 13);
			this.label1.TabIndex = 0;
			this.label1.Text = "Delay Time:";
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.wetLabel);
			this.groupBox2.Controls.Add(this.dryLabel);
			this.groupBox2.Controls.Add(this.wetTrackBar);
			this.groupBox2.Controls.Add(this.dryTrackBar);
			this.groupBox2.Controls.Add(this.label3);
			this.groupBox2.Controls.Add(this.label2);
			this.groupBox2.Location = new System.Drawing.Point(12, 138);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(311, 124);
			this.groupBox2.TabIndex = 2;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Mix";
			// 
			// wetLabel
			// 
			this.wetLabel.AutoSize = true;
			this.wetLabel.Location = new System.Drawing.Point(247, 86);
			this.wetLabel.Name = "wetLabel";
			this.wetLabel.Size = new System.Drawing.Size(25, 13);
			this.wetLabel.TabIndex = 5;
			this.wetLabel.Text = "X %";
			// 
			// dryLabel
			// 
			this.dryLabel.AutoSize = true;
			this.dryLabel.Location = new System.Drawing.Point(247, 35);
			this.dryLabel.Name = "dryLabel";
			this.dryLabel.Size = new System.Drawing.Size(25, 13);
			this.dryLabel.TabIndex = 2;
			this.dryLabel.Text = "X %";
			// 
			// wetTrackBar
			// 
			this.wetTrackBar.LargeChange = 20;
			this.wetTrackBar.Location = new System.Drawing.Point(75, 70);
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
			// dryTrackBar
			// 
			this.dryTrackBar.LargeChange = 20;
			this.dryTrackBar.Location = new System.Drawing.Point(75, 19);
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
			this.label3.Location = new System.Drawing.Point(39, 86);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(30, 13);
			this.label3.TabIndex = 3;
			this.label3.Text = "Wet:";
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(43, 35);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(26, 13);
			this.label2.TabIndex = 0;
			this.label2.Text = "Dry:";
			// 
			// applyButton
			// 
			this.applyButton.Location = new System.Drawing.Point(248, 268);
			this.applyButton.Name = "applyButton";
			this.applyButton.Size = new System.Drawing.Size(75, 22);
			this.applyButton.TabIndex = 6;
			this.applyButton.Text = "Apply";
			this.applyButton.UseVisualStyleBackColor = true;
			this.applyButton.Click += new System.EventHandler(this.applyButton_Click);
			// 
			// okButton
			// 
			this.okButton.Location = new System.Drawing.Point(86, 268);
			this.okButton.Name = "okButton";
			this.okButton.Size = new System.Drawing.Size(75, 22);
			this.okButton.TabIndex = 7;
			this.okButton.Text = "OK";
			this.okButton.UseVisualStyleBackColor = true;
			this.okButton.Click += new System.EventHandler(this.okButton_Click);
			// 
			// cancelButton
			// 
			this.cancelButton.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.cancelButton.Location = new System.Drawing.Point(167, 268);
			this.cancelButton.Name = "cancelButton";
			this.cancelButton.Size = new System.Drawing.Size(75, 22);
			this.cancelButton.TabIndex = 8;
			this.cancelButton.Text = "Cancel";
			this.cancelButton.UseVisualStyleBackColor = true;
			this.cancelButton.Click += new System.EventHandler(this.cancelButton_Click);
			// 
			// helpButton
			// 
			this.helpButton.Location = new System.Drawing.Point(12, 268);
			this.helpButton.Name = "helpButton";
			this.helpButton.Size = new System.Drawing.Size(46, 22);
			this.helpButton.TabIndex = 9;
			this.helpButton.Text = "Help...";
			this.helpButton.UseVisualStyleBackColor = true;
			this.helpButton.Click += new System.EventHandler(this.helpButton_Click);
			// 
			// DelayEffectForm
			// 
			this.AcceptButton = this.applyButton;
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.CancelButton = this.cancelButton;
			this.ClientSize = new System.Drawing.Size(335, 302);
			this.ControlBox = false;
			this.Controls.Add(this.applyButton);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.okButton);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.cancelButton);
			this.Controls.Add(this.helpButton);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Name = "DelayEffectForm";
			this.ShowIcon = false;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Delay";
			this.groupBox1.ResumeLayout(false);
			this.groupBox1.PerformLayout();
			this.groupBox2.ResumeLayout(false);
			this.groupBox2.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.wetTrackBar)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dryTrackBar)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.RadioButton delay80RadioButton;
		private System.Windows.Forms.RadioButton delay40RadioButton;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.Label wetLabel;
		private System.Windows.Forms.Label dryLabel;
		private System.Windows.Forms.TrackBar wetTrackBar;
		private System.Windows.Forms.TrackBar dryTrackBar;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Button applyButton;
		private System.Windows.Forms.Button okButton;
		private System.Windows.Forms.Button cancelButton;
		private System.Windows.Forms.Button helpButton;
		private System.Windows.Forms.RadioButton delay320RadioButton;
		private System.Windows.Forms.RadioButton delay160RadioButton;

	}
}