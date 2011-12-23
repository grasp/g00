package montnets;
import java.lang.*;
public class mondem
{
	public native int SetModemType(int ComNo,int ModemType);
	public native int GetModemType(int ComNo);
	public native int InitModem (int PortNo);
	public native int SendMsg (int PortNo, String strHeader, String strMsg);
	public native String[]ReadMsgEx (int PortNo);
	public native int CloseModem (int PortNo);
	public native int GetPortMax();
	public native int GetStatus (int PortNo);
	public native int GetSndCount (int PortNo);
	public native int GetRecCount (int PortNo);
	public native int ClrSndBuf (int PortNo);
	public native int ClrRecBuf (int PortNo);
	public native int SetReceive (int Type);
	public native int CancelSend (int Count);
	public native int SetDelayTime(int PortNo,int DelayTime);
	public native String[]WapPushCvt(String strTitle,String strUrl);
	public native int SetThreadMode(int Mode);
	
	
	//public native int MonInitModem(String strDev,int num);
	//public native int MonSendMsg(int Chno,String strHeader,String strMsg);
	//public native String[] MonGetMsg(int Chno);
	//public native int MonCloseModem();
	static
	{
		System.loadLibrary("mondem");
	}
	public static void main(String args[])
	{
	}
}