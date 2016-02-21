//+------------------------------------------------------------------+
//| access_to_FXTfile_02.mq4 |
//| amenbo |
//| 泉の森の弁財天池 |
//+------------------------------------------------------------------+
#property copyright "amenbo"
#property link "泉の森の弁財天池"
#property show_inputs
#import "kernel32.dll"
 int _lopen(string patg,int of);
 int _lcreat(string path,int attrib);
 int _llseek(int handle,int offset,int origin);
 int _lread(int handle,int& buffer[],int bytes);
 int _lwrite(int handle,string buffer,int bytes);
 int _lclose(int handle);
#import
extern string FXT_="USDJPYFXF5_0.fxt";
int start()
 {
 Print("-------START Win32API-------");
 //
 int buffer[2];
 //
 string path=TerminalPath()+"\\tester\\history\\"+FXT_;
 //
 Print("win32api_File_Path= ",path);
 //
 int fileHandle=_lopen(path,0);
 //------------------------------------------------
 int adjustCursor1=_llseek(fileHandle,0xfc,0);//16 進表示
 int ret_read1=_lread(fileHandle,buffer,8);
 Print("spread= ",buffer[0]);
 Print("digits= ",buffer[1]);
 //-----------------------------------------------
 int ret_close=_lclose(fileHandle);
 //
 PlaySound("alert2.wav");
 //
 return(0);
}
