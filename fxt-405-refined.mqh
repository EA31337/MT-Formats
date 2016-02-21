//+------------------------------------------------------------------+ 
//| History Files in FXT Format                                      | 
//+------------------------------------------------------------------+ 
// Documentation on the format can be found in terminal Help (Client terminal - Auto Trading - Strategy Testing - History Files FXT).
// However the obtained data shows that the data does not match the declared format.
// In the eye catches the fact that the work is carried out over time in both formats: the new and the old MQL4.
// So, members of fromdate and todate structure TestHistoryHeader , and ctm structure TestHistory use the old (4 hbaytny) date / time format, but a member of otm structure TestHistory written in the new (8-byte) date / time format.
// It is unclear whether the correct type of selected members unknown.
// The FXT as teak prices recorded only Bid, but its spread is written in the Volume field.
// By breaking MT4 is obtained to ensure that the MT4-tester figured on each tick Ask, how the Bid + the Volume (that's the trick).
// Source: https://forum.mql4.com/ru/64199/page3
struct TestHistoryHeader
{
   int               version;            // 405
   char              copyright[64];      // copyright
   char              description[128];   // server name
// 196
   char              symbol[12];         
   int               period;
   int               model;              // for what modeling type was the ticks sequence generated
   int               bars;               // amount of bars in history
   int               fromdate;
   int               todate;
   int               totalTicks;
   double            modelquality;       // modeling quality
// 240
   //---- general parameters
   char              currency[12];       // currency base
   int               spread;
   int               digits;
   int               unknown1;
   double            point;
   int               lot_min;            // minimum lot size
   int               lot_max;            // maximum lot size
   int               lot_step;
   int               stops_level;        // stops level value
   int               gtc_pendings;       // instruction to close pending orders at the end of day
// 292
   //---- profit calculation parameters
   int               unknown2;
   double            contract_size;      // contract size
   double            tick_value;         // value of one tick
   double            tick_size;          // size of one tick
   int               profit_mode;        // profit calculation mode        { PROFIT_CALC_FOREX, PROFIT_CALC_CFD, PROFIT_CALC_FUTURES }
// 324 
   //---- swap calculation
   int               swap_enable;        // enable swap
   int               swap_type;          // type of swap                   { SWAP_BY_POINTS, SWAP_BY_DOLLARS, SWAP_BY_INTEREST }
   int               unknown3;
   double            swap_long;
   double            swap_short;         // swap overnight value
   int               swap_rollover3days; // three-days swap rollover
// 356   
   //---- margin calculation
   int               leverage;           // leverage
   int               free_margin_mode;   // free margin calculation mode   { MARGIN_DONT_USE, MARGIN_USE_ALL, MARGIN_USE_PROFIT, MARGIN_USE_LOSS }
   int               margin_mode;        // margin calculation mode        { MARGIN_CALC_FOREX,MARGIN_CALC_CFD,MARGIN_CALC_FUTURES,MARGIN_CALC_CFDINDEX };
   int               margin_stopout;     // margin stopout level
   int               margin_stopout_mode;// stop out check mode            { MARGIN_TYPE_PERCENT, MARGIN_TYPE_CURRENCY }
   double            margin_initial;     // margin requirements
   double            margin_maintenance; // margin maintenance requirements
   double            margin_hedged;      // margin requirements for hedged positions
   double            margin_divider;     // margin divider
   char              margin_currency[12];// margin currency
// 420   
   //---- commission calculation
   double            comm_base;          // basic commission
   int               comm_type;          // basic commission type          { COMM_TYPE_MONEY, COMM_TYPE_PIPS, COMM_TYPE_PERCENT }
   int               comm_lots;          // commission per lot or per deal { COMMISSION_PER_LOT, COMMISSION_PER_DEAL }
// 436   
   //---- for internal use
   int               from_bar;           // fromdate bar number
   int               to_bar;             // todate bar number
   int               start_period[6];    // number of bar at which the smaller period modeling started
   int               set_from;           // begin date from tester settings
   int               set_to;             // end date from tester settings
// 476
   //----
   int               end_of_test;
   int               freeze_level;       // order's freeze level in points
   int               generating_errors;  
// 488   
   //----
   int               reserved[60];
};
struct TestHistory
{
   datetime          otm;                // время бара
   double            open;               // значения OHLCV
   double            high;
   double            low;
   double            close;
   long              volume;
   int               ctm;                // текущее рабочее время внутри бара
   int               flag;               // флаг запуска эксперта (0-бар модифицируем, а эксперта не запускаем)
};
