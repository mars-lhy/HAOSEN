using System.Drawing;

namespace DigitalSynth
{
	class Note : IDrawingElement
	{
		// Note properties
		private int notePitch;
		private int noteLength;
		private int notePosition;
		private int noteHeight;
		private bool isTiedToNext;
		private Rectangle boundingRectangle;


		public Note(int notePitch, int noteLength, bool isTiedToNext, int staffNumber, int notePosition)
		{
			this.notePitch = notePitch;
			this.noteLength = noteLength;
			this.isTiedToNext = isTiedToNext;
			this.notePosition = notePosition;
			this.noteHeight = DetermineNoteHeight(notePitch); // determine the position of the note in relation to the staff
			AssignToStaff(staffNumber); // determine the note position in relation to the page
			boundingRectangle = new Rectangle(new Point(notePosition, noteHeight), new Size(40, 70));
		}


		private int DetermineNoteHeight(int notePitch)
		{
			switch (notePitch)
			{
				case 0: return 38; // F3
				case 1: return 38; // F#3
				case 2: return 34; // G3
				case 3: return 34; // G#3
				case 4: return 30; // A3
				case 5: return 26; // Bb3
				case 6: return 26; // B3

				case 7: return 22; // C4
				case 8: return 22; // C#4
				case 9: return 18; // D4
				case 10: return 14; // Eb4
				case 11: return 14; // E4
				case 12: return 10; // F4
				case 13: return 10; // F#4
				case 14: return 6; // G4
				case 15: return 6; // G#4
				case 16: return 2; // A4
				case 17: return -2; // Bb4
				case 18: return -2; // B4
				case 19: return -6; // C5
				case 20: return -6; // C#5
				case 21: return -10; // D5
				case 22: return -14; // Eb5
				case 23: return -14; // E5

				case 24: return -18; // F5
				case 25: return -18; // F#5
				case 26: return -22; // G5
				case 27: return -22; // G#5
				case 28: return -26; // A5
				case 29: return -30; // Bb5
				case 30: return -30; // B5
				default: return 6;
			}
		}
		
		private void AssignToStaff(int staffNumber)
		{
			switch (staffNumber)
			{
				case 1: noteHeight += 50; break;
				case 2: noteHeight += 150; break;
				case 3: noteHeight += 250; break;
				case 4: noteHeight += 350; break;
				default: break;
			}
		}

		private string DetermineNoteString(int noteLength)
		{
			string result;

			switch (noteLength)
			{
				case 1:
					result = "A";
					break;
				case 2:
					if (notePitch < 17)
						result = "B";
					else
						result = "R";
					break;
				case 4:
					if (notePitch < 17)
						result = "C";
					else
						result = "S"; 
					break;
				case 8:
					if (notePitch < 17)
						result = "D";
					else
						result = "T";
					break;
				case 16:
					if (notePitch < 17)
						result = "E";
					else
						result = "U";
					break;
				default:
					result = "";
					break;
			}

			if (notePitch == 1 | notePitch == 3 | notePitch == 8 | notePitch == 13 | notePitch == 15 | notePitch == 20 | notePitch == 25 | notePitch == 27)
				return "!" + result; // # sharp
			if (notePitch == 5 | notePitch == 10 | notePitch == 17 | notePitch == 22 | notePitch == 29)
				return "\"" + result; // b flat
			return result;
		}

		public void Draw(Graphics g)
		{
			SolidBrush blackBrush = new SolidBrush(Color.Black);
			Font font = new Font("Aloisen New", 24);
			StringFormat stringFormat = new StringFormat();
			
			stringFormat.LineAlignment = StringAlignment.Center;
			stringFormat.Alignment = StringAlignment.Center;
			g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;
			if (isTiedToNext)
				// draw a "+" next to the note that is tied to the next note
				g.DrawString(DetermineNoteString(noteLength) + "Ë", font, blackBrush, boundingRectangle, stringFormat);
			else
				g.DrawString(DetermineNoteString(noteLength), font, blackBrush, boundingRectangle, stringFormat);

			// notes under and over the staff need additional horizontal lines
			if (notePitch == 0 | notePitch == 1) // F3, F#3
			{
				g.DrawString("ÈÈ", font, blackBrush, boundingRectangle, stringFormat);
				g.DrawString("ÈÈ", font, blackBrush, notePosition + 20, noteHeight + 27, stringFormat);
				g.DrawString("ÈÈ", font, blackBrush, notePosition + 20, noteHeight + 19, stringFormat);
			}
			else if (notePitch == 2 | notePitch == 3) // G3, G#3
			{
				g.DrawString("ÈÈ", font, blackBrush, notePosition + 20, noteHeight + 31, stringFormat);
				g.DrawString("ÈÈ", font, blackBrush, notePosition + 20, noteHeight + 23, stringFormat);
			}
			else if (notePitch == 4) // A3
			{
				g.DrawString("ÈÈ", font, blackBrush, boundingRectangle, stringFormat);
				g.DrawString("ÈÈ", font, blackBrush, notePosition + 20, noteHeight + 27, stringFormat);
			}
			else if (notePitch == 5 | notePitch == 6) // Bb3, B3
				g.DrawString("ÈÈ", font, blackBrush, notePosition + 20, noteHeight + 31, stringFormat);
			else if (notePitch == 7 | notePitch == 8 | notePitch == 28) // C4, C#4, A5
				g.DrawString("ÈÈ", font, blackBrush, boundingRectangle, stringFormat);
			else if (notePitch == 29 | notePitch == 30) // Bb5, B5
				g.DrawString("ÈÈ", font, blackBrush, notePosition + 20, noteHeight + 39, stringFormat);
		}
	}
}