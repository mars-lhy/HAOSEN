using System.Collections;
using System.Drawing;
using DigitalSynth;

namespace DigitalSynth
{
	class DisplayElements
	{
		private ArrayList staffElements1 = new ArrayList();
		private ArrayList staffElements2 = new ArrayList();
		private ArrayList staffElements3 = new ArrayList();
		private ArrayList staffElements4 = new ArrayList();

		private ArrayList measureBars = new ArrayList();
		private ArrayList track1, track2, track3, track4;
		private Staff staff1, staff2, staff3, staff4;
		private PlayBar playBar;

		private bool drawBar;

		private int numberOfMeasures;


		public DisplayElements(int upperTimeSignature, int lowerTimeSignature, int numberOfMeasures, ArrayList track1, ArrayList track2, ArrayList track3, ArrayList track4)
		{
			this.numberOfMeasures = numberOfMeasures;
			this.track1 = track1;
			this.track2 = track2;
			this.track3 = track3;
			this.track4 = track4;

			playBar = new PlayBar();
			staff1 = new Staff(new Point(10, 50), 850, upperTimeSignature, lowerTimeSignature);
			staff2 = new Staff(new Point(10, 150), 850, upperTimeSignature, lowerTimeSignature);
			staff3 = new Staff(new Point(10, 250), 850, upperTimeSignature, lowerTimeSignature);
			staff4 = new Staff(new Point(10, 350), 850, upperTimeSignature, lowerTimeSignature);
		}


		public void GenerateMusicalElements(int measureNumber)
		{
			// clear the arrays
			staffElements1.Clear();
			staffElements2.Clear();
			staffElements3.Clear();
			staffElements4.Clear();
			measureBars.Clear();

			// fill the arrays with the new data (measures, notes, bars etc.)
			drawBar = true;
			GenerateMusicalElements(track1, measureNumber, staffElements1, 1);
			drawBar = false;
			GenerateMusicalElements(track2, measureNumber, staffElements2, 2);
			GenerateMusicalElements(track3, measureNumber, staffElements3, 3);
			GenerateMusicalElements(track4, measureNumber, staffElements4, 4);
		}
		
		private void GenerateMusicalElements(ArrayList source, int measureNumber, ArrayList destination, int staffNumber)
		{
			int screenOffset = 75; // 75 pixels between the margin of the form and the first musical element
			if (source != null)
				for (int i = measureNumber; i < measureNumber + 2; i++) // display only 2 measures
				{
					if (i < numberOfMeasures)
						foreach (MidiInterpreter.MusicalElement elem in (ArrayList)source[i])
						{
							// the source contains both rests and notes (the destination will also contain notes and rests)
							// create notes and rests
							Note note;
							Rest rest;
							if (elem.elementType == 0) // the element from the array is a note
							{
								// MIDI notes are from 0 to 127. Notes on the FPGA board start at 0. The first note that the FPGA board recognizes is 53.
								note = new Note(elem.noteValue - 53, elem.length, elem.isTiedToNext, staffNumber, screenOffset);
								destination.Add(note);
							}
							else // the element from the array is a rest 
							{
								rest = new Rest(elem.length, staffNumber, screenOffset);
								destination.Add(rest);
							}
							if (elem.length != 0)
								screenOffset += 16 * 23 / elem.length; // determine the position of the next musical element
						}
					if (screenOffset != 75 & drawBar)
					{
						// draw a vertical bar after every measure
						screenOffset = screenOffset + 10;
						MeasureBar mb = new MeasureBar(screenOffset, 64, 396);
						measureBars.Add(mb);
					}
				}
		}

		public void DrawElements(Graphics graphics)
		{
			// draw all the musical elements
			staff1.Draw(graphics); // the four horizontal staffs
			staff2.Draw(graphics);
			staff3.Draw(graphics);
			staff4.Draw(graphics);

			playBar.Draw(graphics); // the play bar

			foreach (IDrawingElement n in staffElements1) // the elements of the four staffs
				n.Draw(graphics);
			foreach (IDrawingElement n in staffElements2)
				n.Draw(graphics);
			foreach (IDrawingElement n in staffElements3)
				n.Draw(graphics);
			foreach (IDrawingElement n in staffElements4)
				n.Draw(graphics);

			foreach (MeasureBar m in measureBars) // the measure bars
				m.Draw(graphics);
		}

		public void MovePlayBar(int measureNumber)
		{
			if (measureNumber % 2 == 0)
				playBar.MovePlayBar(75); // the measure number is even, so it is the first measure displayed on the screen
			else
				//if (measureNumber <= measureBars.Count)
					//playBar.MovePlayBar(((MeasureBar)measureBars[measureNumber - 1]).X); // the measure number is odd, so it is the second measure displayed on the screen
				playBar.MovePlayBar(((MeasureBar)measureBars[0]).X); // the measure number is odd, so it is the second measure displayed on the screen
		}
	}
}