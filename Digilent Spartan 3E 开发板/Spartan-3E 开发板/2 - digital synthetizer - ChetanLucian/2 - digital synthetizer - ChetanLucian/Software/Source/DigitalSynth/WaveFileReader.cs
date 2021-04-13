using System.IO;
using System;

namespace FPGA
{
	class WaveFileReader
	{
		private FileStream fileStream;
		private BinaryReader binaryReader;

		private byte[] riffChunkId = new byte[4] { (byte)'R', (byte)'I', (byte)'F', (byte)'F' };
		private int riffFileSize;

		private byte[] riffFormat = new byte[4] { (byte)'W', (byte)'A', (byte)'V', (byte)'E' };
		private byte[] fmtChunkId = new byte[4] { (byte)'f', (byte)'m', (byte)'t', (byte)' ' };
		private int fmtChunkSize;
		private int fmtAudioFormat;
		private int fmtChannelsCount;
		private int fmtSampleRate;
		private int fmtByteRate;
		private int fmtBlockAlign;
		private int fmtBitsPerSample;

		private byte[] dataChunkId = new byte[] { (byte)'d', (byte)'a', (byte)'t', (byte)'a' };
		private int dataChunkSize;


		public WaveFileReader(string filePath)
		{
			fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
			binaryReader = new BinaryReader(fileStream);
		}

		private int ReadRiffChunk()
		{
			if (binaryReader.ReadBytes(4) != riffChunkId)
				return -1;
			riffFileSize = ReadLittleEndian(binaryReader.ReadBytes(4)) + 8;
			if (binaryReader.ReadBytes(4) != riffFormat)
				return -1;
			return 0;
		}

		private void ReadFmtChunk()
		{
			fmtChunkSize = ReadLittleEndian(binaryReader.ReadBytes(4));
			fmtAudioFormat = ReadLittleEndian(binaryReader.ReadBytes(2));
			fmtChannelsCount = ReadLittleEndian(binaryReader.ReadBytes(2));
			fmtSampleRate = ReadLittleEndian(binaryReader.ReadBytes(4));
			fmtByteRate = ReadLittleEndian(binaryReader.ReadBytes(4));
			fmtBlockAlign = ReadLittleEndian(binaryReader.ReadBytes(2));
			fmtBitsPerSample = ReadLittleEndian(binaryReader.ReadBytes(2));
		}

		private void ReadDataChunk()
		{
			dataChunkSize = ReadLittleEndian(binaryReader.ReadBytes(4));
			byte[] data = new byte[dataChunkSize];
			data = binaryReader.ReadBytes(dataChunkSize);
		}

		private int ReadLittleEndian(byte[] b)
		{
			int k =0;
			for (int i = 0; i < b.Length; i++)
				k += b[i] * (256 << i);

			return k;
		}

		public bool ReadWaveFile()
		{	
			if (ReadRiffChunk() != 0)
				return false;

			byte[] nextChunkId = binaryReader.ReadBytes(4);
			if (nextChunkId == fmtChunkId)
				ReadFmtChunk();
			else if (nextChunkId == dataChunkId)
				ReadDataChunk();

			nextChunkId = binaryReader.ReadBytes(4);
			if (nextChunkId == fmtChunkId)
				ReadFmtChunk();
			else if (nextChunkId == dataChunkId)
				ReadDataChunk();

			binaryReader.Close();
			fileStream.Close();
			return true;
		}
	}
}
