using System.Drawing;

namespace DigitalSynth
{
	class Staff : IDrawingElement
	{
		// Staff properties
		private Point staffPosition;
		private int length;
		private int timeSignatureFirst, timeSignatureSecond;


		public Staff(Point staffPosition, int length, int timeSignatureFirst, int timeSignatureSecond)
		{
			this.staffPosition = staffPosition;
			this.length = length;
			this.timeSignatureFirst = timeSignatureFirst;
			this.timeSignatureSecond = timeSignatureSecond;
		}


		public void Draw(Graphics g)
		{
			SolidBrush blackBrush = new SolidBrush(Color.Black);
			Pen grayPen = new Pen(Color.Gray, 1);
			Font font = new Font("Aloisen New", 24);

			g.DrawLine(grayPen, staffPosition.X + 10, staffPosition.Y + 14, staffPosition.X + 10, staffPosition.Y + 46);
			g.DrawLine(grayPen, staffPosition.X + 10, staffPosition.Y + 14, staffPosition.X + length, staffPosition.Y + 14);
			g.DrawLine(grayPen, staffPosition.X + 10, staffPosition.Y + 22, staffPosition.X + length, staffPosition.Y + 22);
			g.DrawLine(grayPen, staffPosition.X + 10, staffPosition.Y + 30, staffPosition.X + length, staffPosition.Y + 30);
			g.DrawLine(grayPen, staffPosition.X + 10, staffPosition.Y + 38, staffPosition.X + length, staffPosition.Y + 38);
			g.DrawLine(grayPen, staffPosition.X + 10, staffPosition.Y + 46, staffPosition.X + length, staffPosition.Y + 46);

			g.DrawString("", font, blackBrush, staffPosition.X + 13, staffPosition.Y - 8); // Sol key

			g.DrawString(timeSignatureFirst.ToString(), font, blackBrush, staffPosition.X + 40, staffPosition.Y - 23);
			g.DrawString(timeSignatureSecond.ToString(), font, blackBrush, staffPosition.X + 40, staffPosition.Y - 7);
		}
	}
}