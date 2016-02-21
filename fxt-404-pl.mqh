//+-------------------------------------------------+
//| |
//+-------------------------------------------------+
struct TestHistoryHeader
 {
 int version; // 404
 char copyright[64]; // prawa autorskie
 char symbol[12];
 int period;
 int model; // dla jakie go typu modelowania została wygenerowana sekwencja ticków
 int bars; // ilość słupków w historii
 time_t fromdate; // tic ki wygenerowane od tego czasu
 time_t todate; // ticki wygenerowane do tej daty
 double modelquality; // jakość modelowania
 //---- general parameters
 char currency[12]; // waluta bazowa
 int spread;
 int digits;
 double point;
 int lot_min; // minimalna ilość lotów
 int lot_max; // maksymalna ilość lotów
 int lot_step;
 int stops_level; // poziom zleceń stop
 int gtc_pendings; // zamykanie zlecenia oczekującego pod koniec dnia
 //---- profit calculation parameters
 double contract_size; // wielkość kontraktu
 double tick_value; // wartość ticka
 double tick_size; // wielkość ticka
 int profit_mode; // tryb obliczania wyniku { PROFIT_CALC_FOREX, PROFIT_CALC_CFD, PROFIT_CALC_FUTU RES }
 //---- swap calculation
 int swap_enable; // aktywuj punkty swapowe
 int swap_type; // typ punktów swapowych { SWAP_BY_POINTS, SWAP_BY_DOLLARS, SWAP_BY_I NTEREST }
 double swap_long;
 double swap_short; // wartość punktów swapowych - overnight
 int swap_rollover3days; // punkty swapowe za 3 dni
 //---- margin calculation
 int leverage; // dźwignia
 int free_margin_mode; // tryb obliczania wolnych środków { MARGIN_DONT_USE, MARGIN_USE_ALL, MARGIN_USE_PROFIT, MARGIN_USE_LOSS }
 int margin_mode; // tryb obliczania depozytu { MARGIN_CALC_FOREX,MARGIN_CALC_CFD,MARGIN_CALC_FUTURES,MARGIN_CALC_CFDINDEX };
 int margin_stopout; // poziom stopout
 int margin_stopout_mode;// tryb sprawdzania stop out { MARGIN_TYPE_PERCENT, MARGIN_TYPE_CURRENCY } // wymagany depozyt
 double margin_maintenance; // wymogi utrzymania depozytu
 double margin_hedged; // wymogi depozytu dla pozycji przeciwstawnych
 double margin_divider; // podzielność depozytu
 char margin_currency[12];// wlauta depozytowa
 //---- commission calculation
 double comm_base; // prowizja bazowa
 int comm_type; // typ prowizji bazowej { COMM_TYPE_MONEY, COMM_TYP E_PIPS, COMM_TYPE_PERCENT }
 int comm_lots; // prowizja za lot lub transakcję { COMMISSION_PER_LOT, COMMISSION_PER_DEAL }
 //---- for internal use
 int from_bar; // numer słupka od zadanej daty początkow ej
 int to_bar; // numer słupka do zadanej daty kocowej
 int start_period[6]; // number of bar at which the smaller period modeling started
 int set_from; // data początkowa z ustawie testera
 int set_to; // data kocowa z ustawie testera
 //----
 int freeze_level; // poziom zamrażania zlecenia( w punktach)
 //----
 int reserved[61];
 };
#pragma pack(push,1)
struct TestHistory
 {
 time_t otm; // czas dla słupka
 double open; // poziom cen OHLCV
 double low;
 double high;
 double close;
 double volume;
 time_t ctm; // aktualny czas dla słupka
 int flag; // odznacz słupek dla otwieranych strategii automatycznych (słupek zerowy zostanie zmodyfikowany, ale strategie automatyczne nie zostaną uruchomione)
 };
#pragma pack(pop)
