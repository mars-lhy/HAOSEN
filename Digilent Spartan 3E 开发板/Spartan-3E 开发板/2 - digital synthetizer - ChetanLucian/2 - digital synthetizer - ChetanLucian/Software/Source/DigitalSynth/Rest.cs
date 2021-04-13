using System.Drawing;

namespace DigitalSynth
{
	class Rest : IDrawingElement
	{
		// Rest properties
		private int restLength;
		private int restPosition;
		private int restHeight;
		private Rectangle boundingRectangle;


		public Rest(int restLength, int staffNumber, int restPosition)
		{
			this.restLength = restLength;
			this.restPosition = restPosition;
			restHeight = DetermineRestHeight(restLength);
			AssignToStaff(staffNumber);
			boundingRectangle = new Rectangle(new Point(restPosition, restHeight), new Size(40, 70));
		}


		private int DetermineRestHeight(int restLength)
		{
			switch (restLength)
			{
				case 1: return -2;
				case 2: return -2;
				case 4: return 0;
				case 8: return -7;
				case 16: return 1;
				default: return 0;
			}
		}

		private void AssignToStaff(int staffNumber)
		{
			switch (staffNumber)
			{
				case 1: restHeight += 50; break;
				case 2: restHeight += 150; break;
				case 3: restHeight += 250; break;
				case 4: restHeight += 350; break;
				default: break;
			}
		}

		private string DetermineRestString(int restLength)
		{
			switch (restLength)
			{
				case 1: return "a";
				case 2: return "b";
				case 4: return "c";
				case 8: return "d";
				case 16: return "e";
				default: return "";
			}
		}

		public void Draw(Graphics g)
		{
			SolidBrush blackBrush = new SolidBrush(Color.Black);
			Font font = new Font("Aloisen New", 24);
			StringFormat stringFormat = new StringFormat();

			stringFormat.LineAlignment = StringAlignment.Center;
			stringFormat.Alignment = StringAlignment.Center;
			g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;
			g.DrawString(DetermineRestString(restLength), font, blackBrush, boundingRectangle, stringFormat);
		}
	}
}