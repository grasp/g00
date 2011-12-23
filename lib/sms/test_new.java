//梦网科技有限公司
import java.lang.*;
import montnets.*;
public class test
{
    public static void main(String args[])
    {

	mondem Mytest =new mondem();  //创建一个 mondem 对象， 这个对象最大可以支持64个端口发送
	int rc;
	String[] wapResult=new String[3];
	
	rc=Mytest.SetThreadMode(1);   //开启线程模式
	if(rc==0){
	    System.out.println("设置线程模式成功");
	} else {
	    System.out.println("设置线程模式失败");
	   Mytest.CloseModem(2);
	    return ;
	}

	//全都设置成单口猫格式
	Mytest.SetModemType(0,0);
	Mytest.SetModemType(1,0);
	Mytest.SetModemType(2,0);
	Mytest.SetModemType(3,0);
	Mytest.SetModemType(4,0);
	Mytest.SetModemType(5,0);
	Mytest.SetModemType(6,0);
	Mytest.SetModemType(7,0);
//	for(int i=0;i<10;i++)
//	{
	if((rc=(Mytest.InitModem(-1)))!=0)
	{
	System.out.println(2+"初始化失败"+rc);
	//Mytest.CloseModem(2);
	return ;
	}
//	}
	
	 rc=Mytest.SendMsg(-1,args[0],args[1]);  //发送一条信息,从可以使用的任意端口
	 System.out.println("send message done, return="+rc);
	 
	try{Thread.sleep(5000);}catch(InterruptedException e){} 
		   String [] s = Mytest.ReadMsgEx(-1);
		   if(s[0].equals("-1")) {
		   	System.out.println("-无信息-----");
		   } else {
		   	System.out.println(s[0]);
		   	System.out.println(s[1]);
		   	System.out.println(s[2]);
		   }
		   	for(int i=0;i<10;i++)
			{
	Mytest.CloseModem(i);
	}
		return;
	}
	

}
