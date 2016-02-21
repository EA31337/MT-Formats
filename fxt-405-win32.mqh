typedef enum profit_mode_enum {  PROFIT_CALC_FOREX=0, PROFIT_CALC_CFD=1, PROFIT_CALC_FUTURES=2 };
typedef enum swap_type_enum{  SWAP_BY_POINTS=0, SWAP_BY_DOLLARS=1, SWAP_BY_INTEREST=2 };
typedef enum free_margin_mode_enum { MARGIN_DONT_USE=0, MARGIN_USE_ALL=1, MARGIN_USE_PROFIT=2, MARGIN_USE_LOSS=3 };
typedef enum margin_mode_enum { MARGIN_CALC_FOREX=0,MARGIN_CALC_CFD=1,MARGIN_CALC_FUTURES=2,MARGIN_CALC_CFDINDEX=3 };
typedef enum margin_stopout_mode_enum { MARGIN_TYPE_PERCENT=0, MARGIN_TYPE_CURRENCY=1 };
typedef enum comm_type_enum { COMM_TYPE_MONEY=0, COMM_TYPE_PIPS=1, COMM_TYPE_PERCENT=2 };
typedef enum comm_lots_enum { COMMISSION_PER_LOT=0, COMMISSION_PER_DEAL=1 };

typedef time_t time_t32 __attribute__((mode (SI)));

#ifdef _WIN32
#pragma pack(push, 8)
#else
#pragma pack(8)
#endif // _WIN32

typedef struct tagBarData {
  struct tm tm;
  time_t32 otm;
  double o, h, l, c;
  double v;
} BarData, *lpBarData;

typedef struct tagTickData {
  double p;
  time_t32 otm;
} TickData, *lpTickData;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
typedef struct tagTestHistoryHeader
  {
   int               version;            // 405
   char              copyright[64];      // copyright
   char              description[128];
   //---- general parameters
   char              currency[12];       // currency base

   int               period;
   int               model;              // for what modeling type was the ticks sequence generated
   int               bars;               // amount of bars in history
   time_t32            fromdate;           // ticks generated from this date
   time_t32            todate;             // ticks generating stopped at this date
   double            modelquality;       // modeling quality
   int totalticks;   //??
   int unknown2;
   int unknown3;

   int               spread;                                                                                     
   int               digits;
   double            point;
   int               lot_min;            // minimum lot size
   int               lot_max;            // maximum lot size
   int               lot_step;
   int               stops_level;        // stops level value
   int               gtc_pendings;       // instruction to close pending orders at the end of day
   //---- profit calculation parameters
   double            contract_size;      // contract size
   //int unknown6;
   double            tick_value;         // value of one tick
   double            tick_size;          // size of one tick
   profit_mode_enum  profit_mode;         // profit calculation mode        { PROFIT_CALC_FOREX, PROFIT_CALC_CFD, PROFIT_CALC_FUTURES }
   //---- swap calculation
   int               swap_enable;        // enable swap
   swap_type_enum    swap_type;          // type of swap                   { SWAP_BY_POINTS, SWAP_BY_DOLLARS, SWAP_BY_INTEREST }
   double            swap_long;
   double            swap_short;         // swap overnight value
   int               swap_rollover3days; // three-days swap rollover
   //---- margin calculation
   int               leverage;           // leverage
   free_margin_mode_enum free_margin_mode;   // free margin calculation mode   { MARGIN_DONT_USE, MARGIN_USE_ALL, MARGIN_USE_PROFIT, MARGIN_USE_LOSS }
   margin_mode_enum  margin_mode;        // margin calculation mode        { MARGIN_CALC_FOREX,MARGIN_CALC_CFD,MARGIN_CALC_FUTURES,MARGIN_CALC_CFDINDEX };
   int               margin_stopout;     // margin stopout level
   margin_stopout_mode_enum  margin_stopout_mode;// stop out check mode            { MARGIN_TYPE_PERCENT, MARGIN_TYPE_CURRENCY }
   double            margin_initial;     // margin requirements
   double            margin_maintenance; // margin maintenance requirements
   double            margin_hedged;      // margin requirements for hedged positions
   double            margin_divider;     // margin divider
   char              margin_currency[12];// margin currency
   //---- commission calculation
   double            comm_base;          // basic commission
   comm_type_enum    comm_type;          // basic commission type          { COMM_TYPE_MONEY, COMM_TYPE_PIPS, COMM_TYPE_PERCENT }
   comm_lots_enum    comm_lots;          // commission per lot or per deal { COMMISSION_PER_LOT, COMMISSION_PER_DEAL }
   //---- for internal use
   int               from_bar;           // fromdate bar number
   int               to_bar;             // todate bar number
   int               start_period[6];    // number of bar at which the smaller period modeling started
   int               set_from;           // begin date from tester settings
   int               set_to;             // end date from tester settings
   //----
   int               freeze_level;       // order's freeze level in points
   //----
   int               reserved[60];
  } TestHistoryHeader, *lpTestHistoryHeader;

#ifdef _WIN32
#pragma pack(pop)
#pragma pack(push, 1)
#else
#pragma pack()
#pragma pack(1)
#endif // _WIN32

typedef struct tagTestHistory
{
   time_t32  otm;                // bar time
   double    open;               // OHLCV value
   double    low;
   double    high;
   double    close;
   double    volume;
   time_t32  ctm;                // bar work time
   int       flag;               // expert flag 0-bar is modified, but expert is not run
} TestHistory, *lpTestHistory;

#ifdef _WIN32
#pragma pack(pop)
#else
#pragma pack()
#endif // _WIN32
