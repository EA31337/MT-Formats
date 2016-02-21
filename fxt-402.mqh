//+------------------------------------------------------------------+ 
//|                                                                  | 
//+------------------------------------------------------------------+ 
struct TestHistoryHeader
  {
   int               version;            // must be 402
   char              copyright[64];
   char              symbol[12];
   int               period;
   int               model;              // 0-every tick  1-control points  2-open prices
   int               bars;               // bars processed
   time_t            fromdate;
   time_t            todate;
   double            modelquality;
   //---- common parameters
   char              currency[12];
   int               spread;
   int               digits;
   double            point;
   int               lot_min;            // minimal lot-size multiplied by 100
   int               lot_max;            // maximal lot-size multiplied by 100
   int               lot_step;
   int               stops_level;        // minimal stops indentation in points
   int               gtc_pendings;       // good till cancel
   //---- profit calculation parameters
   double            contract_size;
   double            tick_value;
   double            tick_size;
   int               profit_mode;        // profit calculation mode { PROFIT_CALC_FOREX=0, PROFIT_CALC_CFD=1, PROFIT_CALC_FUTURES=2 }
   //---- swaps calculation
   int               swap_enable;        // 0 - disable, 1-enable
   int               swap_type;          //  { SWAP_BY_POINTS=0, SWAP_BY_DOLLARS=1, SWAP_BY_INTEREST=2 }
   double            swap_long;
   double            swap_short;         // swap sizes
   int               swap_rollover3days; // day (usually 3) of treble swaps
   //---- margin calculation
   int               leverage;
   int               free_margin_mode;   // { MARGIN_DONT_USE=0, MARGIN_USE_ALL=1, MARGIN_USE_PROFIT=2, MARGIN_USE_LOSS=3 }
   int               margin_mode;        //  { MARGIN_CALC_FOREX=0, MARGIN_CALC_CFD=1, MARGIN_CALC_FUTURES=2, MARGIN_CALC_CFDINDEX=3 };
   int               margin_stopout;
   double            margin_initial;
   double            margin_maintenance;
   double            margin_hedged;
   double            margin_divider;
   char              margin_currency[12];
   //---- commission calculation
   double            comm_base;          // base commission
   int               comm_type;          // base commission type { COMM_TYPE_MONEY=0, COMM_TYPE_PIPS=1, COMM_TYPE_PERCENT=2 }
   int               comm_lots;          // per lot or per deal   { COMMISSION_PER_LOT=0, COMMISSION_PER_DEAL=1 }
   //---- generation info
   int               from_bar;           // bar number "fromdate"
   int               to_bar;             // bar number "todate"
   int               start_period[6];    // lesser period beginning bar number
   //----
   int               reserved[64];
  };
#pragma pack(push,1)
struct TestHistory
  {
   time_t            otm;                // open time
   double            open;               // current bar values
   double            low;
   double            high;
   double            close;
   double            volume;
   time_t            ctm;                // current time (time of this bar state)
   int               flag;               // expert launch flag (0-bar is modified but expert not launched)
  };
#pragma pack(pop)
