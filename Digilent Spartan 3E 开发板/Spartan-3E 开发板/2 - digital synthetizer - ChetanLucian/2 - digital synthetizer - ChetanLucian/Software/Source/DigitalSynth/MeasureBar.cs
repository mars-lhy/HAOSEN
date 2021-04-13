using System.Drawing;

namespace DigitalSynth
{
	class MeasureBar : IDrawingElement
	{
		private int positionX;
		private int startY;
		private int endY;
		public int X
		{
			get { return positionX; }
		}

		public MeasureBar(int positionX, int startY, int endY)
		{
			this.positionX = positionX;
			this.startY = startY;
			this.endY = endY;
		}


		public void Draw(Graphics g)
		{
			Pen grayPen = new Pen(Color.Gray, 1);
			g.DrawLine(grayPen, positionX, startY, positionX, endY);
		}
	}
}