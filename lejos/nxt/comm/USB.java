package lejos.nxt.comm;

public class USB {

	private USB()
	{		
	}
	
	public static native void usbWaitForConnection();
	public static native int usbRead(byte [] buf, int len);
	public static native void usbWrite(byte [] buf, int len);
}
