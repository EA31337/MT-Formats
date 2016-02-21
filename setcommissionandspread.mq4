#property strict

extern double Commission = 30; // per mio (full round), == 0 - will not change
extern bool ChangeSpread = FALSE;
extern int NewSpread = 5; // pips

#define SYMBOL_LENGTH 8
#define AMOUNT_DATA 15

#define BID 7
#define ASK 8

#define A_MILLION 0.000001

int GetLotDigits( string Symb )
{
  int LotDigits = 0;
  double LotStep = MarketInfo(Symb, MODE_LOTSTEP);

  if (LotStep > 0)
    while (LotStep < 1 - A_MILLION)
    {
      LotStep *= 10;
      LotDigits++;
    }

  return(LotDigits);
}

double GetMaxLot( string Symb )
{
  return (NormalizeDouble(MathMin(AccountEquity() / MarketInfo(Symb, MODE_MARGINREQUIRED) - MarketInfo(Symb, MODE_LOTSTEP),
                                  MarketInfo(Symb, MODE_MAXLOT)), GetLotDigits(Symb)));
}

bool OpenClose()
{
  string Symb = Symbol();
  double Lots = GetMaxLot(Symb);
  int Ticket = OrderSend(Symb, OP_SELL, Lots, Bid, 0, 0, 0);

  if (Ticket < 0)
    return(FALSE);

  if (!OrderClose(Ticket, Lots, Ask, 0))
    return(FALSE);

  return(OrderSelect(Ticket, SELECT_BY_TICKET, MODE_HISTORY));
}

double GetOrderCommission( bool Alternative = FALSE )
{
  double Comm;

  if (Alternative && (OrderProfit() != 0))
    Comm = MathAbs(OrderCommission() * (OrderClosePrice() - OrderOpenPrice()) / (OrderOpenPrice() * OrderProfit()));
  else
    Comm = -OrderCommission() * MarketInfo(OrderSymbol(), MODE_TICKSIZE) /
           (OrderOpenPrice() * OrderLots() * MarketInfo(OrderSymbol(), MODE_TICKVALUE));

  return(Comm);
}

bool SetCommissionAndSpread( string Symb, int Spread, bool ChgSpread, double Comm = 0, string PostFix = "Change" )
{
  if (IsOptimization() || !IsTesting())
    return(FALSE);

  if (!OpenClose())
    return(FALSE);

  string FileName = "symbols.sel";
  int hFileIn = FileOpenHistory(FileName, FILE_BIN|FILE_READ|FILE_SHARE_READ|FILE_ANSI);
  int hFileOut = FileOpenHistory(FileName + PostFix, FILE_BIN|FILE_WRITE|FILE_ANSI);
  double Data[AMOUNT_DATA];
  int SymbolsNumber = (int)((FileSize(hFileIn) - sizeof(int)) / (SYMBOL_LENGTH + sizeof(Data)));
  string SymbolRead;

  FileWriteInteger(hFileOut, FileReadInteger(hFileIn));

  for(int i = 0; i < SymbolsNumber; i++)
  {
    SymbolRead = FileReadString(hFileIn, SYMBOL_LENGTH);

    FileReadArray(hFileIn, Data, 0, ArraySize(Data));

    if (SymbolRead == Symb)
    {
      double CurrentComm = GetOrderCommission(TRUE);
      int digits = (int)MarketInfo(Symb, MODE_DIGITS);
      double dSpread = Data[ASK] - Data[BID];

      if (ChgSpread)
        dSpread = Spread * MarketInfo(Symb, MODE_POINT);

      if ((Comm != 0) && (CurrentComm != 0))
        Data[BID] = NormalizeDouble(Data[BID] * Comm * A_MILLION / CurrentComm, digits);

      Data[ASK] = NormalizeDouble(Data[BID] + dSpread, digits);
    }

    FileWriteString(hFileOut, SymbolRead, SYMBOL_LENGTH);
    FileWriteArray(hFileOut, Data);
  }

  FileClose(hFileIn);
  FileClose(hFileOut);

  return(TRUE);
}

void init()
{
  if (!SetCommissionAndSpread(Symbol(), NewSpread, ChangeSpread, Commission))
    Print(WindowExpertName() + ": Unknown Error!");

  return;
}

void start()
{
  return;
}
