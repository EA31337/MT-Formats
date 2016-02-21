//+------------------------------------------------------------------+
//| read_write_symbols_sel.mq4 |
//| amenbo |
//| 泉の森の弁財天池 |
//+------------------------------------------------------------------+
#property copyright "amenbo"
#property link "泉の森の弁財天池"
#property show_inputs
//
extern string Symbol_name="USDJPYFXF";//デフォルトの為替ペア
extern double spread_=9.0;
extern int r0_w1_=0; //0=read、1=wriet
//
int sector=0x80;//=128 １為替ペアのレコード・サイズ
int version_offset=4;//4 ﾊﾞｲﾄ ファイルの先頭に４バイトのバージョン情報あり
//
int start()
 {
 //
 int hFile = FileOpenHistory("symbols.sel", FILE_BIN|FILE_READ|FILE_WRITE);
 int symbols_number=(FileSize(hFile)-4)/sector;//いくつの為替ペア情報があるか
 //
 FileSeek(hFile,0, SEEK_SET);
 string version=FileReadInteger(hFile,LONG_VALUE);
 Print("Version NO= ",version);
 //
 FileSeek(hFile,version_offset, SEEK_SET);
 //
 for(int i=0;i<symbols_number;i++)
 {
 //
 int offset=FileTell(hFile);
 string short_name=FileReadString(hFile, 12);
 //
 if(short_name==Symbol_name)
 {
 //
 Print("-------START-------");
 //
 Print("ShortName= ",short_name);
 //
 FileSeek(hFile,(offset+0x0c), SEEK_SET);
 int digits_=FileReadInteger(hFile, LONG_VALUE);
 Print("Digits= ",digits_);
 //
 FileSeek(hFile,(offset+0x20), SEEK_SET);
 double point_=FileReadDouble(hFile, DOUBLE_VALUE);
 Print("Point= ",point_);
 //
 FileSeek(hFile,(offset+0x38), SEEK_SET);
 datetime time_current=FileReadInteger(hFile, LONG_VALUE);
 //Print("TimeCurrent() in symbols.sel_file= ",time_current);
 //
 int year_=TimeYear(time_current);
 int month_=TimeMonth(time_current);
 int day_=TimeDay(time_current);
 int hour_=TimeHour(time_current);
 int minute_=TimeMinute(time_current);
2013.06.09 ©2011 amenbo the 3rd
21／23
 int second_=TimeSeconds(time_current);
 Print("Time_in_symbols.sel_file:",year_,"年",month_,"月",day_,"日",hour_,"時
",minute_,"分",second_,"秒");
 //-------------------------------------
 FileSeek(hFile,(offset+0x50), SEEK_SET);
 double high_0=FileReadDouble(hFile, DOUBLE_VALUE);
 double low_0=FileReadDouble(hFile, DOUBLE_VALUE);
 Print("High[0]= ",high_0," || Low[0]= ",low_0);
 //-----------------------------------
 //
 if(r0_w1_==0)
 {
 //
 FileSeek(hFile,(offset+0x40), SEEK_SET);
 double bid_1=FileReadDouble(hFile, DOUBLE_VALUE);
 double ask_1=FileReadDouble(hFile, DOUBLE_VALUE);
 Print("Bid_1= ",bid_1," || ask_1= ",ask_1);
 //
 Sleep(100);
 //
 FileSeek(hFile,(offset+0x70), SEEK_SET);
 double bid_2=FileReadDouble(hFile, DOUBLE_VALUE);
 double ask_2=FileReadDouble(hFile, DOUBLE_VALUE);
 Print("Bid_2= ",bid_2," || ask_2= ",ask_2);
 //
 }else{
 //
 FileSeek(hFile,(offset+0x40), SEEK_SET);
 double bid_3=FileReadDouble(hFile, DOUBLE_VALUE);
 double ask_3=NormalizeDouble(bid_3+spread_*point_,digits_);
 FileSeek(hFile,(offset+0x48), SEEK_SET);
 FileWriteDouble(hFile,ask_3,DOUBLE_VALUE);
 FileFlush(hFile);
 //
 Sleep(100);
 //
 FileSeek(hFile,(offset+0x70), SEEK_SET);
 double bid_4=FileReadDouble(hFile, DOUBLE_VALUE);
 double ask_4=NormalizeDouble(bid_4+spread_*point_,digits_);
 FileSeek(hFile,(offset+0x78), SEEK_SET);
 FileWriteDouble(hFile,ask_4,DOUBLE_VALUE);
 FileFlush(hFile);
 //
 Sleep(100);
 //
 }
 //-------------------------------------
 Print("---------------END---");
 //
 break;
 }
 FileSeek(hFile,(sector-12),SEEK_CUR);

 }

 FileClose(hFile);

 PlaySound("alert2.wav");
 return(0);
}
//-------------
