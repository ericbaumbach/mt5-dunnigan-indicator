//+------------------------------------------------------------------+
//|                                           Dunnigan Indicator.mq5 |
//|                                 Copyright 2019, Leonardo Sposina |
//|           https://www.mql5.com/en/users/leonardo_splinter/seller |
//+------------------------------------------------------------------+

#property copyright "Copyright 2019, Leonardo Sposina"
#property link      "https://www.mql5.com/en/users/leonardo_splinter/seller"
#property version   "1.0"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2

#property indicator_label1  "Buy Signal"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrLimeGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "Sell Signal"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

input int evaluatedPeriod = 50; // Evaluated Period

double buySignalBuffer[];
double sellSignalBuffer[];
bool firstUpBar = true;
bool firstDownBar = true;

int OnInit() {

   SetIndexBuffer(0,buySignalBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,sellSignalBuffer,INDICATOR_DATA);   
   PlotIndexSetInteger(0,PLOT_ARROW,225);
   PlotIndexSetInteger(1,PLOT_ARROW,226);
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,4);
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,-4);
   return(INIT_SUCCEEDED);

}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  
   if (evaluatedPeriod > 0 && !IsStopped()) {

      int firstBar = rates_total - evaluatedPeriod;

      ArrayInitialize(buySignalBuffer, EMPTY_VALUE);
      ArrayInitialize(sellSignalBuffer, EMPTY_VALUE);

      for (int i = firstBar; i < rates_total ; i++) {
      
         if (isBuySignal(i, high, low, close) && firstUpBar) {
            buySignalBuffer[i] = high[i - 1];
            Comment("# Buy Signal!");
            firstUpBar = false;
            firstDownBar = true;
         }
         
         else if (isSellSignal(i, high, low, close) && firstDownBar) {
            sellSignalBuffer[i] = low[i - 1];
            Comment("# Sell Signal!");
            firstDownBar = false;
            firstUpBar = true;
         }
         
         else Comment("");
      }

   }

   return(rates_total);

}

bool isBuySignal (int i,const double &max[],const double &min[],const double &close[]) {

   return (min[i] > min[i - 1] && max[i] > max[i - 1]) && (close[i] > max[i - 1]);

}

bool isSellSignal (int i,const double &max[],const double &min[],const double &close[]) {

   return (min[i] < min[i - 1] && max[i] < max[i - 1]) && (close[i] < min[i - 1]);

}