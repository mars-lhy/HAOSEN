using System.Runtime.InteropServices;
using System.Text;

namespace DigitalSynth
{
	public sealed class DPCUTIL
	{
		private DPCUTIL()
		{
		}

		#region API Startup/Cleanup calls
		
		/// <summary>
		/// This method performs startup initialization of the DLL. It must be called before any of the other API calls can be used.
		/// </summary>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <returns>Returns "true" if DLL instance is properly initialized. Returns "false" otherwise.</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcInit(ref int errorCode);
		
		/// <summary>
		/// This method must be called to clean up resources when application is done using the DLL.
		/// </summary>
		[DllImport("dpcutil.dll")]
		public static extern void DpcTerm();
		#endregion

		#region API Device Manager calls
		
		/// <summary>
		/// This method gets the total number of devices in the device table.
		/// </summary>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <returns>Returns the number of devices in the device table.</returns>
		[DllImport("dpcutil.dll")]
		public static extern int DvmgGetDevCount(ref int errorCode);
		
		/// <summary>
		/// This method gets the name of a device from its index into the device table.
		/// </summary>
		/// <param name="deviceIndex">Index of device to query.</param>
		/// <param name="deviceName">String to store device name.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise.</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DvmgGetDevName(int deviceIndex, StringBuilder deviceName, ref int errorCode);
		
		/// <summary>
		/// This method gets the type of a particular device, given its index in the device table.
		/// </summary>
		/// <param name="deviceIndex">Index of device to query.</param>
		/// <param name="deviceType">Pointer to store device type.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise.</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DvmgGetDevType(int deviceIndex, ref int deviceType, ref int errorCode);
		
		/// <summary>
		/// This method gets the index of the default device in the device table.
		/// </summary>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <returns>Returns the index of the default device in the device table.</returns>
		[DllImport("dpcutil.dll")]
		public static extern int DvmgGetDefaultDev(ref int errorCode);
		#endregion

		#region API Data Transfer calls
		
		/// <summary>
		/// Opens the data transfer interface for access. No other data transfer functions can be used until a communications device has been opened.
		/// </summary>
		/// <param name="handle">Pointer to store handle to data interface.</param>
		/// <param name="deviceName">The name of the device to open. (The string contained by the StringBuilder objects can be changed.)</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <param name="transactionId">Pointer to store the transaction ID.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise.</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcOpenData(ref int handle, StringBuilder deviceName, ref int errorCode, short transactionId);
		
		/// <summary>
		/// Releases the data transfer interface specified by "handle" and closes the communications module.
		/// </summary>
		/// <param name="handle">Handle to data interface.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise.</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcCloseData(int handle, ref int errorCode);
		
		/// <summary>
		/// Sends a single data byte to a register specified by its address.
		/// </summary>
		/// <param name="handle">Handle to data interface.</param>
		/// <param name="registerAddress">The address of the register at which to send the byte.</param>
		/// <param name="registerData">The data to send to the selected register.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <param name="transactionId">Pointer to store the transaction ID.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcPutReg(int handle, byte registerAddress, byte registerData, ref int errorCode, short transactionId);
		
		/// <summary>
		/// Gets a single data byte from a register specified by its address.
		/// </summary>
		/// <param name="handle">Handle to data interface.</param>
		/// <param name="registerAddress">The address of the register at which to send the byte.</param>
		/// <param name="registerData">The data read from the selected register.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <param name="transactionId">Pointer to store the transaction ID.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcGetReg(int handle, byte registerAddress, ref byte registerData, ref int errorCode, short transactionId);
		
		/// <summary>
		/// Sends many data bytes to many specified addresses (one byte to each of the addresses).
		/// </summary>
		/// <param name="handle">Handle to data interface.</param>
		/// <param name="registerAddress">The addresses of the registers at which to send the bytes.</param>
		/// <param name="registerData">The data to send to the selected registers.</param>
		/// <param name="count">The number of bytes to be sent.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <param name="transactionId">Pointer to store the transaction ID.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcPutRegSet(int handle, byte[] registerAddress, byte[] registerData, int count, ref int errorCode, short transactionId);
		
		/// <summary>
		/// Gets many data bytes from many specified addresses (one byte from each of the addresses).
		/// </summary>
		/// <param name="handle">Handle to data interface.</param>
		/// <param name="registerAddress">The addresses of the registers from which to read the bytes.</param>
		/// <param name="registerData">The data read from the selected registers.</param>
		/// <param name="count">The number of bytes to be read.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <param name="transactionId">Pointer to store the transaction ID.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcGetRegSet(int handle, byte[] registerAddress, byte[] registerData, int count, ref int errorCode, short transactionId);
		
		/// <summary>
		/// Sends a stream of data bytes to a single, specified register address.
		/// </summary>
		/// <param name="handle">Handle to data interface.</param>
		/// <param name="registerAddress">The address of the register at which to send the bytes.</param>
		/// <param name="registerData">The data to send to the selected register.</param>
		/// <param name="count">The number of bytes to sent.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <param name="transactionId">Pointer to store the transaction ID.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcPutRegRepeat(int handle, byte registerAddress, byte[] registerData, int count, ref int errorCode, short transactionId);
		
		/// <summary>
		/// Gets a stream of data bytes from a single, specified register address.
		/// </summary>
		/// <param name="handle">Handle to data interface.</param>
		/// <param name="registerAddress">The address of the register from which to read the bytes.</param>
		/// <param name="registerData">The data read from the selected register.</param>
		/// <param name="count">The number of bytes to be read.</param>
		/// <param name="errorCode">Pointer to store the error code.</param>
		/// <param name="transactionId">Pointer to store the transaction ID.</param>
		/// <returns>Returns "true" if successful. Returns "false" otherwise</returns>
		[DllImport("dpcutil.dll")]
		public static extern bool DpcGetRegRepeat(int handle, byte registerAddress, byte[] registerData, int count, ref int errorCode, short transactionId);
		#endregion
	}
}