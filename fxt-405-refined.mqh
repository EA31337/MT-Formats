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
   int               version;            // Version: 405
   char              copyright[64];      // Copyright.
   char              description[128];   // Server name.
// 196
   char              symbol[12];         // Symbol.
   int               period;             // Period of data aggregation in minutes.
   int               model;              // Model - for what modeling type was the ticks sequence generated (0 - every tick).
   int               bars;               // Bars - amount of bars in history.
   int               fromdate;           // Date of the first tick.
   int               todate;             // Date of the last tick.
   int               totalTicks;         // Total ticks.
   double            modelquality;       // Modeling quality
// 240
   //---- General parameters.
   char              currency[12];       // Currency base.
   int               spread;             // Spread in points.
   int               digits;             // Digits (default: 5).
   int               unknown1;           // Unknown.
   double            point;              // Point.
   int               lot_min;            // Minimum lot size.
   int               lot_max;            // Maximum lot size.
   int               lot_step;           // Lot step.
   int               stops_level;        // Stops level value.
   int               gtc_pendings;       // Instruction to close pending orders at the end of day (default: True).
// 292
   //---- Profit calculation parameters.
   int               unknown2;           // Unknown.
   double            contract_size;      // Contract size.
   double            tick_value;         // Value of one tick.
   double            tick_size;          // Size of one tick.
   int               profit_mode;        // Profit calculation mode        { PROFIT_CALC_FOREX, PROFIT_CALC_CFD, PROFIT_CALC_FUTURES }
// 324
   //---- Swap calculation.
   int               swap_enable;        // Enable swap (default: True).
   int               swap_type;          // Type of swap                   { SWAP_BY_POINTS, SWAP_BY_DOLLARS, SWAP_BY_INTEREST }
   int               unknown3;           // Unknown.
   double            swap_long;          // SwapLong.
   double            swap_short;         // Swap overnight value.
   int               swap_rollover3days; // Three-days swap rollover.
// 356
   //---- Margin calculation.
   int               leverage;           // Leverage (default: 100).
   int               free_margin_mode;   // Free margin calculation mode   { MARGIN_DONT_USE, MARGIN_USE_ALL, MARGIN_USE_PROFIT, MARGIN_USE_LOSS }
   int               margin_mode;        // Margin calculation mode        { MARGIN_CALC_FOREX,MARGIN_CALC_CFD,MARGIN_CALC_FUTURES,MARGIN_CALC_CFDINDEX };
   int               margin_stopout;     // Margin stopout level.
   int               margin_stopout_mode;// Stop out check mode            { MARGIN_TYPE_PERCENT, MARGIN_TYPE_CURRENCY }
   double            margin_initial;     // Margin requirements.
   double            margin_maintenance; // Margin maintenance requirements.
   double            margin_hedged;      // Margin requirements for hedged positions.
   double            margin_divider;     // Margin divider.
   char              margin_currency[12];// Margin currency.
// 420
   //---- Commission calculation.
   double            comm_base;          // Basic commission
   int               comm_type;          // Basic commission type          { COMM_TYPE_MONEY, COMM_TYPE_PIPS, COMM_TYPE_PERCENT }
   int               comm_lots;          // Commission per lot or per deal { COMMISSION_PER_LOT, COMMISSION_PER_DEAL }
// 436
   //---- For internal use.
   int               from_bar;           // FromdAte bar number.
   int               to_bar;             // ToDate bar number.
   int               start_period[6];    // Number of bar at which the smaller period modeling started.
   int               set_from;           // Begin date from tester settings.
   int               set_to;             // End date from tester settings.
// 476
   //----
   int               end_of_test;
   int               freeze_level;       // Order's freeze level in points.
   int               generating_errors;
// 488
   //----
   int               reserved[60];       // Reserved - space for future use.
};
#pragma pack(push,1)
struct TestHistory
{
   datetime          otm;                // Bar datetime.
   double            open;               // OHLCV values.
   double            high;
   double            low;
   double            close;
   long              volume;
   int               ctm;                // The current time within a bar.
   int               flag;               // Flag to launch an expert (0 - bar will be modified, but the expert will not be launched).
};
#pragma pack(pop)

