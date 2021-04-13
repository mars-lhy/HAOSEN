using System.Drawing;

namespace DigitalSynth
{
	class PlayBar : IDrawingElement
	{
		private Rectangle boundingRectangle;

		public PlayBar()
		{
			boundingRectangle = new Rectangle(new Point(75, 20), new Size(35, 35));
		}

		public void MovePlayBar(int newPositionX)
		{
			boundingRectangle.X = newPositionX;
		}

		public void Draw(Graphics g)
		{
			SolidBrush blueBrush = new SolidBrush(Color.Blue);
			Font font = new Font("Wingdings 3", 20);

			g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;
			g.DrawString("À", font, blueBrush, boundingRectangle);
		}
	}
}
