using System;

namespace DigitalSynth
{
	static class CONVERTER
	{
		public static int ConvertByteArrayToInt(byte[] byteArray)
		{
			int result = 0;

			for (int i = 0; i < byteArray.Length; i++)
				result += byteArray[i] * (int)Math.Pow(256, (double)(byteArray.Length - 1 - i));

			return result;
		}

		public static int ConvertByteToInt(byte b)
		{
			return (int)b;
		}
	}
}
