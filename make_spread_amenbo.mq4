//+------------------------------------------------------------------+
//| make_spread_amenbo.mq4 |
//| amenbo |
//| 泉の森の弁財天池 |
//+------------------------------------------------------------------+
#property copyright "amenbo"
#property link "泉の森の弁財天池"
#property show_inputs
extern double Spread = 30.0;
int start()
{
  double pip = Point;

  int fh = FileOpenHistory("symbols.sel",FILE_BIN|FILE_READ);
  int fs = FileOpen("symbols.sel",FILE_BIN|FILE_WRITE);

  int block[];
  int arraySize = FileSize(fh)/4;//block[]の各要素は４バイトなので、４で割る
  ArrayResize(block,arraySize);
  FileReadArray(fh,block,0,arraySize);
  FileWriteArray(fs,block,0,arraySize);
  FileClose(fs);
  FileClose(fh);
  //-------------------------------------------
  fs = FileOpen("symbols.sel",FILE_BIN|FILE_READ|FILE_WRITE);
  string temp, symbol;
  double bid, ask;
  FileSeek(fs,4,SEEK_SET);
  while(!IsStopped()) {
    temp = FileReadString(fs,12);
    if(FileIsEnding(fs)) break;
    symbol = StringSubstr(temp,0,StringFind(temp,"\x00",0));
    if(symbol==Symbol()){
      int pos = FileTell(fs)-12;
      FileSeek(fs,pos+0x40,SEEK_SET);
      bid = FileReadDouble(fs,DOUBLE_VALUE);
      ask = NormalizeDouble(bid+Spread*pip,Digits);
      FileSeek(fs,pos+0x40+DOUBLE_VALUE,SEEK_SET);
      FileWriteDouble(fs,ask,DOUBLE_VALUE);
      FileSeek(fs,pos+0x70+DOUBLE_VALUE,SEEK_SET);
      FileWriteDouble(fs,ask,DOUBLE_VALUE);
      break;
    }
    FileSeek(fs,0x80-12,SEEK_CUR);
  }
  FileClose(fs);
  PlaySound("alert2.wav");
  return(0);
}
