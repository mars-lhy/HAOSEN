namespace DigitalSynth
{
	partial class ApplicationForm
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
			this.components = new System.ComponentModel.Container();
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ApplicationForm));
			this.menuStrip = new System.Windows.Forms.MenuStrip();
			this.fileMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.newMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.openMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
			this.exitMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.settingsMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.usbCommunicationMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripSeparator();
			this.audioConsoleMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.helpMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.usersManualMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripMenuItem3 = new System.Windows.Forms.ToolStripSeparator();
			this.aboutMenu = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStrip = new System.Windows.Forms.ToolStrip();
			this.previousButton = new System.Windows.Forms.ToolStripButton();
			this.redrawButton = new System.Windows.Forms.ToolStripButton();
			this.nextButton = new System.Windows.Forms.ToolStripButton();
			this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
			this.playButton = new System.Windows.Forms.ToolStripButton();
			this.recordButton = new System.Windows.Forms.ToolStripButton();
			this.goButton = new System.Windows.Forms.ToolStripButton();
			this.pageLabel = new System.Windows.Forms.ToolStripLabel();
			this.pageTextBox = new System.Windows.Forms.ToolStripTextBox();
			this.goLabel = new System.Windows.Forms.ToolStripLabel();
			this.musicSheetPanel = new System.Windows.Forms.Panel();
			this.playTimer = new System.Windows.Forms.Timer(this.components);
			this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
			this.statusBar = new System.Windows.Forms.StatusStrip();
			this.statusLabel = new System.Windows.Forms.ToolStripStatusLabel();
			this.recordTimer = new System.Windows.Forms.Timer(this.components);
			this.menuStrip.SuspendLayout();
			this.toolStrip.SuspendLayout();
			this.statusBar.SuspendLayout();
			this.SuspendLayout();
			// 
			// menuStrip
			// 
			this.menuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileMenu,
            this.settingsMenu,
            this.helpMenu});
			this.menuStrip.Location = new System.Drawing.Point(0, 0);
			this.menuStrip.Name = "menuStrip";
			this.menuStrip.Size = new System.Drawing.Size(927, 24);
			this.menuStrip.TabIndex = 0;
			this.menuStrip.Text = "Menu";
			// 
			// fileMenu
			// 
			this.fileMenu.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.newMenu,
            this.openMenu,
            this.toolStripMenuItem1,
            this.exitMenu});
			this.fileMenu.Name = "fileMenu";
			this.fileMenu.Size = new System.Drawing.Size(35, 20);
			this.fileMenu.Text = "File";
			// 
			// newMenu
			// 
			this.newMenu.Name = "newMenu";
			this.newMenu.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.N)));
			this.newMenu.Size = new System.Drawing.Size(163, 22);
			this.newMenu.Text = "New...";
			this.newMenu.ToolTipText = "Create a new MIDI file";
			this.newMenu.Click += new System.EventHandler(this.newMenu_Click);
			// 
			// openMenu
			// 
			this.openMenu.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.openMenu.Name = "openMenu";
			this.openMenu.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
			this.openMenu.Size = new System.Drawing.Size(163, 22);
			this.openMenu.Text = "Open...";
			this.openMenu.ToolTipText = "Open a MIDI file";
			this.openMenu.Click += new System.EventHandler(this.openMenu_Click);
			// 
			// toolStripMenuItem1
			// 
			this.toolStripMenuItem1.Name = "toolStripMenuItem1";
			this.toolStripMenuItem1.Size = new System.Drawing.Size(160, 6);
			// 
			// exitMenu
			// 
			this.exitMenu.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.exitMenu.Name = "exitMenu";
			this.exitMenu.Size = new System.Drawing.Size(163, 22);
			this.exitMenu.Text = "Exit";
			this.exitMenu.ToolTipText = "Close the application";
			this.exitMenu.Click += new System.EventHandler(this.exitMenu_Click);
			// 
			// settingsMenu
			// 
			this.settingsMenu.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.usbCommunicationMenu,
            this.toolStripMenuItem2,
            this.audioConsoleMenu});
			this.settingsMenu.Name = "settingsMenu";
			this.settingsMenu.Size = new System.Drawing.Size(58, 20);
			this.settingsMenu.Text = "Settings";
			// 
			// usbCommunicationMenu
			// 
			this.usbCommunicationMenu.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.usbCommunicationMenu.Name = "usbCommunicationMenu";
			this.usbCommunicationMenu.Size = new System.Drawing.Size(191, 22);
			this.usbCommunicationMenu.Text = "USB Communication...";
			this.usbCommunicationMenu.ToolTipText = "Configure the communication with the FPGA device";
			this.usbCommunicationMenu.Click += new System.EventHandler(this.usbCommunicationMenu_Click);
			// 
			// toolStripMenuItem2
			// 
			this.toolStripMenuItem2.Name = "toolStripMenuItem2";
			this.toolStripMenuItem2.Size = new System.Drawing.Size(188, 6);
			// 
			// audioConsoleMenu
			// 
			this.audioConsoleMenu.Name = "audioConsoleMenu";
			this.audioConsoleMenu.Size = new System.Drawing.Size(191, 22);
			this.audioConsoleMenu.Text = "Audio Console...";
			this.audioConsoleMenu.ToolTipText = "Configure the audio settings";
			this.audioConsoleMenu.Click += new System.EventHandler(this.audioEffectsMenu_Click);
			// 
			// helpMenu
			// 
			this.helpMenu.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.usersManualMenu,
            this.toolStripMenuItem3,
            this.aboutMenu});
			this.helpMenu.Name = "helpMenu";
			this.helpMenu.Size = new System.Drawing.Size(40, 20);
			this.helpMenu.Text = "Help";
			// 
			// usersManualMenu
			// 
			this.usersManualMenu.Name = "usersManualMenu";
			this.usersManualMenu.Size = new System.Drawing.Size(152, 22);
			this.usersManualMenu.Text = "User\'s Manual";
			this.usersManualMenu.ToolTipText = "Open the user\'s manual PDF document";
			this.usersManualMenu.Click += new System.EventHandler(this.contentsMenu_Click);
			// 
			// toolStripMenuItem3
			// 
			this.toolStripMenuItem3.Name = "toolStripMenuItem3";
			this.toolStripMenuItem3.Size = new System.Drawing.Size(149, 6);
			// 
			// aboutMenu
			// 
			this.aboutMenu.Name = "aboutMenu";
			this.aboutMenu.Size = new System.Drawing.Size(152, 22);
			this.aboutMenu.Text = "About...";
			this.aboutMenu.Click += new System.EventHandler(this.aboutMenu_Click);
			// 
			// toolStrip
			// 
			this.toolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden;
			this.toolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.previousButton,
            this.redrawButton,
            this.nextButton,
            this.toolStripSeparator1,
            this.playButton,
            this.recordButton,
            this.goButton,
            this.pageLabel,
            this.pageTextBox,
            this.goLabel});
			this.toolStrip.Location = new System.Drawing.Point(0, 24);
			this.toolStrip.Name = "toolStrip";
			this.toolStrip.Size = new System.Drawing.Size(927, 47);
			this.toolStrip.TabIndex = 1;
			this.toolStrip.Text = "Toolbar (Navigation buttons, Control buttons)";
			// 
			// previousButton
			// 
			this.previousButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.previousButton.Image = global::DigitalSynth.Properties.Resources.previous;
			this.previousButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.previousButton.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.previousButton.Name = "previousButton";
			this.previousButton.Size = new System.Drawing.Size(44, 44);
			this.previousButton.Text = "Previous Page";
			this.previousButton.ToolTipText = "Go to the previous page";
			this.previousButton.Click += new System.EventHandler(this.previousButton_Click);
			// 
			// redrawButton
			// 
			this.redrawButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.redrawButton.Image = global::DigitalSynth.Properties.Resources.redraw;
			this.redrawButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.redrawButton.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.redrawButton.Name = "redrawButton";
			this.redrawButton.Size = new System.Drawing.Size(44, 44);
			this.redrawButton.Text = "Redraw";
			this.redrawButton.ToolTipText = "Redraw the current page";
			this.redrawButton.Click += new System.EventHandler(this.reloadButton_Click);
			// 
			// nextButton
			// 
			this.nextButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.nextButton.Image = global::DigitalSynth.Properties.Resources.next;
			this.nextButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.nextButton.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.nextButton.Name = "nextButton";
			this.nextButton.Size = new System.Drawing.Size(44, 44);
			this.nextButton.Text = "Next Page";
			this.nextButton.ToolTipText = "Go to the next page";
			this.nextButton.Click += new System.EventHandler(this.nextButton_Click);
			// 
			// toolStripSeparator1
			// 
			this.toolStripSeparator1.Name = "toolStripSeparator1";
			this.toolStripSeparator1.Size = new System.Drawing.Size(6, 47);
			// 
			// playButton
			// 
			this.playButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.playButton.Image = global::DigitalSynth.Properties.Resources.play;
			this.playButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.playButton.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.playButton.Name = "playButton";
			this.playButton.Size = new System.Drawing.Size(44, 44);
			this.playButton.Text = "Play";
			this.playButton.ToolTipText = "Load the MIDI file on the FPGA device";
			this.playButton.Click += new System.EventHandler(this.playButton_Click);
			// 
			// recordButton
			// 
			this.recordButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.recordButton.Image = global::DigitalSynth.Properties.Resources.rec;
			this.recordButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.recordButton.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.recordButton.Name = "recordButton";
			this.recordButton.Size = new System.Drawing.Size(44, 44);
			this.recordButton.Text = "Record";
			this.recordButton.ToolTipText = "Record MIDI file from the FPGA device";
			this.recordButton.Click += new System.EventHandler(this.recordButton_Click);
			// 
			// goButton
			// 
			this.goButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
			this.goButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.goButton.Image = global::DigitalSynth.Properties.Resources.go;
			this.goButton.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
			this.goButton.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.goButton.Name = "goButton";
			this.goButton.Size = new System.Drawing.Size(44, 44);
			this.goButton.Text = "Go";
			this.goButton.ToolTipText = "Go to the selected page";
			this.goButton.Click += new System.EventHandler(this.goButton_Click);
			// 
			// pageLabel
			// 
			this.pageLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
			this.pageLabel.Name = "pageLabel";
			this.pageLabel.Size = new System.Drawing.Size(32, 44);
			this.pageLabel.Text = "of ...";
			// 
			// pageTextBox
			// 
			this.pageTextBox.AcceptsReturn = true;
			this.pageTextBox.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
			this.pageTextBox.AutoSize = false;
			this.pageTextBox.MaxLength = 3;
			this.pageTextBox.Name = "pageTextBox";
			this.pageTextBox.Size = new System.Drawing.Size(25, 47);
			this.pageTextBox.Text = "1";
			this.pageTextBox.TextBoxTextAlign = System.Windows.Forms.HorizontalAlignment.Center;
			this.pageTextBox.ToolTipText = "Enter the page number you want to go to";
			// 
			// goLabel
			// 
			this.goLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
			this.goLabel.Name = "goLabel";
			this.goLabel.Size = new System.Drawing.Size(64, 44);
			this.goLabel.Text = "Go to page:";
			// 
			// musicSheetPanel
			// 
			this.musicSheetPanel.BackColor = System.Drawing.Color.White;
			this.musicSheetPanel.Dock = System.Windows.Forms.DockStyle.Fill;
			this.musicSheetPanel.Location = new System.Drawing.Point(0, 71);
			this.musicSheetPanel.Name = "musicSheetPanel";
			this.musicSheetPanel.Size = new System.Drawing.Size(927, 471);
			this.musicSheetPanel.TabIndex = 2;
			this.musicSheetPanel.Paint += new System.Windows.Forms.PaintEventHandler(this.musicSheetPanel_Paint);
			// 
			// playTimer
			// 
			this.playTimer.Interval = 39;
			this.playTimer.Tick += new System.EventHandler(this.playTimer_Tick);
			// 
			// openFileDialog
			// 
			this.openFileDialog.DefaultExt = "*.mid";
			this.openFileDialog.Filter = "MIDI Files|*.mid";
			this.openFileDialog.InitialDirectory = "f:\\workspace";
			this.openFileDialog.RestoreDirectory = true;
			this.openFileDialog.Title = "Select a MIDI File...";
			// 
			// statusBar
			// 
			this.statusBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.statusLabel});
			this.statusBar.Location = new System.Drawing.Point(0, 520);
			this.statusBar.Name = "statusBar";
			this.statusBar.Size = new System.Drawing.Size(927, 22);
			this.statusBar.SizingGrip = false;
			this.statusBar.TabIndex = 3;
			this.statusBar.Text = "Status";
			// 
			// statusLabel
			// 
			this.statusLabel.Name = "statusLabel";
			this.statusLabel.Size = new System.Drawing.Size(0, 17);
			// 
			// recordTimer
			// 
			this.recordTimer.Interval = 39;
			this.recordTimer.Tick += new System.EventHandler(this.recordTimer_Tick);
			// 
			// ApplicationForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(927, 542);
			this.Controls.Add(this.statusBar);
			this.Controls.Add(this.musicSheetPanel);
			this.Controls.Add(this.toolStrip);
			this.Controls.Add(this.menuStrip);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MainMenuStrip = this.menuStrip;
			this.MaximizeBox = false;
			this.Name = "ApplicationForm";
			this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "DigitalSynth";
			this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.ApplicationForm_KeyPress);
			this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ApplicationForm_FormClosing);
			this.menuStrip.ResumeLayout(false);
			this.menuStrip.PerformLayout();
			this.toolStrip.ResumeLayout(false);
			this.toolStrip.PerformLayout();
			this.statusBar.ResumeLayout(false);
			this.statusBar.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.MenuStrip menuStrip;
		private System.Windows.Forms.ToolStripMenuItem fileMenu;
		private System.Windows.Forms.ToolStripMenuItem openMenu;
		private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
		private System.Windows.Forms.ToolStripMenuItem exitMenu;
		private System.Windows.Forms.ToolStripMenuItem settingsMenu;
		private System.Windows.Forms.ToolStripMenuItem usbCommunicationMenu;
		private System.Windows.Forms.ToolStripMenuItem helpMenu;
		private System.Windows.Forms.ToolStripMenuItem aboutMenu;
		private System.Windows.Forms.ToolStrip toolStrip;
		private System.Windows.Forms.ToolStripButton playButton;
		private System.Windows.Forms.ToolStripButton recordButton;
		private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
		private System.Windows.Forms.ToolStripButton previousButton;
		private System.Windows.Forms.ToolStripButton nextButton;
		private System.Windows.Forms.Panel musicSheetPanel;
		private System.Windows.Forms.Timer playTimer;
		private System.Windows.Forms.OpenFileDialog openFileDialog;
		private System.Windows.Forms.ToolStripTextBox pageTextBox;
		private System.Windows.Forms.ToolStripLabel pageLabel;
		private System.Windows.Forms.ToolStripLabel goLabel;
		private System.Windows.Forms.ToolStripButton goButton;
		private System.Windows.Forms.ToolStripMenuItem usersManualMenu;
		private System.Windows.Forms.ToolStripButton redrawButton;
		private System.Windows.Forms.StatusStrip statusBar;
		private System.Windows.Forms.ToolStripStatusLabel statusLabel;
		private System.Windows.Forms.Timer recordTimer;
		private System.Windows.Forms.ToolStripMenuItem newMenu;
		private System.Windows.Forms.ToolStripMenuItem audioConsoleMenu;
		private System.Windows.Forms.ToolStripSeparator toolStripMenuItem2;
		private System.Windows.Forms.ToolStripSeparator toolStripMenuItem3;
	}
}

