//梦网科技有限公司
import java.lang.*;
import montnets.*;
public class test
{
    public static void main(String args[])
    {

	System.out.println("argv[0]="+args[0]);
	System.out.println("argv[1]="+args[1]);

	
	mondem Mytest =new mondem();  //创建一个 mondem 对象， 这个对象最大可以支持64个端口发送
	int rc;
	String[] wapResult=new String[3];
	
	rc=Mytest.SetThreadMode(1);   //开启线程模式
	if(rc==0){
	    System.out.println("设置线程模式成功");
	} else {
	    System.out.println("设置线程模式失败");
	    return;
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
	
	if((rc=(Mytest.InitModem(-1)))==0)//初始化短信猫
	{
	    System.out.println("初始化成功");
	    
	    //--------普通短信测试-------------
	  // rc=Mytest.SendMsg(-1,"15967126712","测试信息，恭喜发财!");  //发送一条信息,从可以使用的任意端口
	  rc=Mytest.SendMsg(2,args[0],args[1]);  //发送一条信息,从可以使用的任意端口
	    //rc=Mytest.SendMsg(0,"13691000000","测试信息，恭喜发财!"); //发送一条信息,指定第一个端口
	    //rc=Mytest.SendMsg(1,"13691000000","测试信息，恭喜发财!"); //发送一条信息,制定第二个端口
	    
	    //--Wap Push 测试------------------------
	    //wapResult=Mytest.WapPushCvt("测试网站发送", "http://wap.mbook.cn"); //生产Push编码
	    //rc=Mytest.SendMsg(-1,"13691000000,001,2,123321,1,0",wapResult[1]);  //发送push信息
	    
	    if(rc>=0){
		System.out.println("提交成功, rc="+rc);

		while(true) //循环等待发送成功,并显示接收信息, Ctrl-C 退出循环
		{
		   String [] s = Mytest.ReadMsgEx(-1);
		   if(s[0].equals("-1")) {
		   	System.out.println("-无信息-----");
		   } else {
		   	System.out.println(s[0]);
		   	System.out.println(s[1]);
		   	System.out.println(s[2]);
		   }
		   System.out.println("...."+    //显示各个端口的状态
		   	Mytest.GetStatus(0)+","+
		   	Mytest.GetStatus(1)+","+
		   	Mytest.GetStatus(2)+","+
		   	Mytest.GetStatus(3)+","+
		   	Mytest.GetStatus(4)+","+
		   	Mytest.GetStatus(5)+","+
		   	Mytest.GetStatus(6)+","+
		   	Mytest.GetStatus(7)+
		   	"...."
		   	);
		   try{Thread.sleep(5000);}catch(InterruptedException e){} //延时等待
		}

	    } else {
		System.out.println("提交错误, rc="+rc);
	    }
	} else {
	    System.out.println("初始化错误!"+rc);
	}   
    }
}
