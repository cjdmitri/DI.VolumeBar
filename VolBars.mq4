//+------------------------------------------------------------------+
//|                                                      VolBars.mq4 |
//|                                   Copyright 2013, Iglakov Dmitry |
//|                                               cjdmitri@gmail.com |
//+------------------------------------------------------------------+
#property copyright  "Copyright 2013, Iglakov Dmitry"
#property link       "cjdmitri@gmail.com"
#property version    "1.1"
#property indicator_chart_window


extern color      ColorL      = DarkTurquoise;
extern int        Position    = 0;
extern int        FontSize    = 7;
extern int        ANGLE       = 0;

string   Txt[1000];
string   TxtVol[1000];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
   CreateStart();
  }
  
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsDeleteAll(0,OBJ_TEXT);//удаление старых объектов
   return(0);
  }
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   CreateStart();
   return(0);
  }
  
//Метод вычисляет и показывает объем бара в пунктах.
void CreateStart()
  {
   int    counted_bars=IndicatorCounted();
   ObjectsDeleteAll(0, OBJ_TEXT);      //удаление старых объектов
   string      Text;                   //Текст метки
   datetime    _time;                  //Время, координата метки
   double      _price;                 //Цена, координата метки
   double      _price2;                //Цена, координата метки объема тиков

   for(int i=WindowBarsPerChart(); i>0; i--) //Перечисляем все видимые бары
     {
      double h = iHigh(Symbol(), 0, i);   //Максимальная цена текущего бара
      double l = iLow(Symbol(), 0, i);    //Минимальная цена текущего бара
      double Vol = h - l;                 //Объем текущего бара
      if(Digits==2){Text=DoubleToStr(Vol*100,0);}      //Получаем чистое количество пунктов, в зависимости от знака после запятой
      if(Digits == 3){Text = DoubleToStr(Vol * 1000, 0);}
      if(Digits == 4){Text = DoubleToStr(Vol * 10000, 0);}
      if(Digits == 5){Text = DoubleToStr(Vol * 100000, 0);}
      if(Position==0 || Position>1)
        {
         _price=iLow(Symbol(),0,i)-5*Point;
         _price2=_price -(FontSize*Point);
        }   //Если показываем снизу бара
      if(Position==1)
        {
         _price=iHigh(Symbol(),0,i)+4*FontSize*Point;
         _price2=_price+2*FontSize*Point;
        }      //Если показываем сверху бара
      _time = iTime(Symbol(), 0, i);               //Получаем временную координату
      Txt[i] = StringConcatenate("Lbl", i);        //Присваиваем имя текущей метке
      ObjectCreate(Txt[i], OBJ_TEXT, 0, _time, _price);        //Создаем сам объект метки
      ObjectSetText(Txt[i], Text, FontSize, "Tahoma", ColorL); //Указываем параметры
      ObjectSet(Txt[i], OBJPROP_ANGLE, ANGLE);                 //Указываем угол наклона метки
     }
   WindowRedraw();
  }
//+------------------------------------------------------------------+
