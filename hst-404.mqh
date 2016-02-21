struct HistoryHeader
{
  int version; // database version
  char copyright[64]; // copyright info
  char symbol[12]; // symbol name
  int period; // symbol timeframe
  int digits; // the amount of digits after decimal point in the symbol
  time_t timesign; // timesign of the database creation
  time_t last_sync; // the last synchronization time
  int unused[13]; // to be used in future
};

// then goes the bars array (single-byte justification)
#pragma pack(push,1)
//---- standard representation of the quote in the database struct RateInfo
{
  time_t ctm; // current time in seconds double open;
  double low;
  double high;
  double close;
  double vol;
};
#pragma pack(pop)
