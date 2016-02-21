<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
   <title>MQL5 Site / simple_csv2fxt.mq4 - Скачать бесплатно скрипт &#39;simple csv2fxt&#39; от &#39;stringo&#39; для MetaTrader 4 в MQL5 Code Base</title>
       
	<link href="https://c.mql5.com/styles/core.acbf900ef006921ed9013b8ed86910b3.css" type="text/css" rel="stylesheet" media="all">
	
	<link href="https://c.mql5.com/styles/all.9b1426a5925d16bbeda96faa0f3c2faf.css" type="text/css" rel="stylesheet" media="all">
	
   <style type="text/css">
     html {height:auto;}
     body {margin:0;padding:0;height: 100%;}
   </style>
   <script type="text/javascript">
        var mqGlobal = {};
        mqGlobal.AddOnLoad = function(callback)
        {
            if(!this._onload) this._onload = [];
            this._onload[this._onload.length] = callback;
        };
        mqGlobal.AddOnReady = function(callback)
        {
            if(!this._onready) this._onready = [];
            this._onready[this._onready.length] = callback;
        };
        mqGlobal.AddOnActiveWindowChange = function(callback)
        {
            if(!this._onvisibility) this._onvisibility = [];
            this._onvisibility[this._onvisibility.length] = callback;
        };
    </script>
</head>
<body>
   
<div style="height:100%;">
  <div class="code" id="code_content"style="left:5px;">
//+------------------------------------------------------------------+<br>//|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;simple_csv2fxt.mq4&nbsp;|<br>//|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Copyright&nbsp;&#169;&nbsp;2006,&nbsp;MetaQuotes&nbsp;Software&nbsp;Corp.&nbsp;|<br>//|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;http://www.metaquotes.net&nbsp;|<br>//+------------------------------------------------------------------+<br>#property&nbsp;copyright&nbsp;&quot;Copyright&nbsp;&#169;&nbsp;2006,&nbsp;MetaQuotes&nbsp;Software&nbsp;Corp.&quot;<br>#property&nbsp;link&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;http://www.metaquotes.net&quot;<br>#property&nbsp;show_inputs<br><br>#include&nbsp;&lt;FXTHeader.mqh&gt;<br>extern&nbsp;string&nbsp;ExtCsvFile=&quot;&quot;;<br>extern&nbsp;string&nbsp;ExtDelimiter=&quot;;&quot;;<br>extern&nbsp;bool&nbsp;&nbsp;&nbsp;ExtCreateHst=true;<br><br>int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtTicks;<br>int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtBars;<br>int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtCsvHandle=-1;<br>int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtHstHandle=-1;<br>int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtHandle=-1;<br>string&nbsp;&nbsp;&nbsp;ExtFileName;<br>int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtPeriodSeconds;<br>datetime&nbsp;ExtLastTime;<br>datetime&nbsp;ExtLastBarTime;<br>double&nbsp;&nbsp;&nbsp;ExtLastOpen;<br>double&nbsp;&nbsp;&nbsp;ExtLastLow;<br>double&nbsp;&nbsp;&nbsp;ExtLastHigh;<br>double&nbsp;&nbsp;&nbsp;ExtLastClose;<br>double&nbsp;&nbsp;&nbsp;ExtLastVolume;<br>//+------------------------------------------------------------------+<br>//|&nbsp;script&nbsp;program&nbsp;start&nbsp;function&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br>//+------------------------------------------------------------------+<br>int&nbsp;start()<br>&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;datetime&nbsp;cur_time,cur_open;<br>&nbsp;&nbsp;&nbsp;double&nbsp;&nbsp;&nbsp;tick_price;<br>&nbsp;&nbsp;&nbsp;int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;delimiter=&#39;;&#39;;<br>//----<br>&nbsp;&nbsp;&nbsp;ExtTicks=0;<br>&nbsp;&nbsp;&nbsp;ExtBars=0;<br>&nbsp;&nbsp;&nbsp;ExtLastTime=0;<br>&nbsp;&nbsp;&nbsp;ExtLastBarTime=0;<br>//----&nbsp;open&nbsp;input&nbsp;csv-file<br>&nbsp;&nbsp;&nbsp;if(StringLen(ExtCsvFile)&lt;=0)&nbsp;&nbsp;ExtCsvFile=Symbol()+&quot;_ticks.csv&quot;;<br>&nbsp;&nbsp;&nbsp;if(StringLen(ExtDelimiter)&gt;0)&nbsp;delimiter=StringGetChar(ExtDelimiter,0);<br>&nbsp;&nbsp;&nbsp;if(delimiter==&#39;&nbsp;&#39;)&nbsp;&nbsp;delimiter=&#39;;&#39;;<br>&nbsp;&nbsp;&nbsp;if(delimiter==&#39;\\&#39;)&nbsp;delimiter=&#39;\t&#39;;<br>&nbsp;&nbsp;&nbsp;ExtCsvHandle=FileOpen(ExtCsvFile,FILE_CSV|FILE_READ,delimiter);<br>&nbsp;&nbsp;&nbsp;if(ExtCsvHandle&lt;0)&nbsp;return(-1);<br>//----&nbsp;open&nbsp;output&nbsp;fxt-file<br>&nbsp;&nbsp;&nbsp;ExtFileName=Symbol()+Period()+&quot;_0.fxt&quot;;<br>&nbsp;&nbsp;&nbsp;ExtHandle=FileOpen(ExtFileName,FILE_BIN|FILE_WRITE);<br>&nbsp;&nbsp;&nbsp;if(ExtHandle&lt;0)&nbsp;return(-1);<br>//----<br>&nbsp;&nbsp;&nbsp;ExtPeriodSeconds=Period()*60;<br>&nbsp;&nbsp;&nbsp;WriteHeader(ExtHandle,Symbol(),Period(),0);<br>//----&nbsp;open&nbsp;hst-file&nbsp;and&nbsp;write&nbsp;it&#39;s&nbsp;header<br>&nbsp;&nbsp;&nbsp;if(ExtCreateHst)&nbsp;WriteHstHeader();<br>//----&nbsp;csv&nbsp;read&nbsp;loop<br>&nbsp;&nbsp;&nbsp;while(!IsStopped())<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//----&nbsp;if&nbsp;end&nbsp;of&nbsp;file&nbsp;reached&nbsp;exit&nbsp;from&nbsp;loop<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(!ReadNextTick(cur_time,tick_price))&nbsp;break;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//----&nbsp;calculate&nbsp;bar&nbsp;open&nbsp;time&nbsp;from&nbsp;tick&nbsp;time<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cur_open=cur_time/ExtPeriodSeconds;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cur_open*=ExtPeriodSeconds;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//----&nbsp;new&nbsp;bar?<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(ExtLastBarTime!=cur_open)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(ExtBars&gt;0)&nbsp;WriteBar();<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastBarTime=cur_open;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastOpen=tick_price;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastLow=tick_price;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastHigh=tick_price;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastClose=tick_price;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastVolume=1;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WriteTick();<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtBars++;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;else<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//----&nbsp;check&nbsp;for&nbsp;minimum&nbsp;and&nbsp;maximum<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(ExtLastLow&gt;tick_price)&nbsp;&nbsp;ExtLastLow=tick_price;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(ExtLastHigh&lt;tick_price)&nbsp;ExtLastHigh=tick_price;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastClose=tick_price;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ExtLastVolume++;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WriteTick();<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>//----&nbsp;finalize<br>&nbsp;&nbsp;&nbsp;WriteBar();<br>&nbsp;&nbsp;&nbsp;if(ExtHstHandle&gt;0)&nbsp;FileClose(ExtHstHandle);<br>&nbsp;&nbsp;&nbsp;FileClose(ExtCsvHandle);<br>//----&nbsp;store&nbsp;processed&nbsp;bars&nbsp;amount<br>&nbsp;&nbsp;&nbsp;FileFlush(ExtHandle);<br>&nbsp;&nbsp;&nbsp;FileSeek(ExtHandle,88,SEEK_SET);<br>&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHandle,ExtBars,LONG_VALUE);<br>&nbsp;&nbsp;&nbsp;FileClose(ExtHandle);<br>&nbsp;&nbsp;&nbsp;Print(ExtTicks,&quot;&nbsp;ticks&nbsp;added.&nbsp;&quot;,ExtBars,&quot;&nbsp;bars&nbsp;finalized&nbsp;in&nbsp;the&nbsp;header&quot;);<br>//----<br>&nbsp;&nbsp;&nbsp;return(0);<br>&nbsp;&nbsp;}<br>//+------------------------------------------------------------------+<br>//|&nbsp;YYYY.MM.DD&nbsp;HH:MI:SS;1.2345&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br>//+------------------------------------------------------------------+<br>bool&nbsp;ReadNextTick(datetime&amp;&nbsp;cur_time,&nbsp;double&amp;&nbsp;tick_price)<br>&nbsp;&nbsp;{<br>//----<br>&nbsp;&nbsp;&nbsp;while(!IsStopped())<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//----&nbsp;first&nbsp;read&nbsp;date&nbsp;and&nbsp;time<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;string&nbsp;date_time=FileReadString(ExtCsvHandle);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(FileIsEnding(ExtCsvHandle))&nbsp;return(false);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cur_time=StrToTime(date_time);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//----&nbsp;read&nbsp;tick&nbsp;price<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tick_price=FileReadNumber(ExtCsvHandle);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(FileIsEnding(ExtCsvHandle))&nbsp;return(false);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//----&nbsp;time&nbsp;must&nbsp;go&nbsp;forward.&nbsp;if&nbsp;no&nbsp;then&nbsp;read&nbsp;further<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(cur_time&gt;ExtLastTime)&nbsp;break;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>//----&nbsp;price&nbsp;must&nbsp;be&nbsp;normalized<br>&nbsp;&nbsp;&nbsp;tick_price=NormalizeDouble(tick_price,Digits);<br>&nbsp;&nbsp;&nbsp;ExtLastTime=cur_time;<br>&nbsp;&nbsp;&nbsp;return(true);<br>&nbsp;&nbsp;}<br>//+------------------------------------------------------------------+<br>//|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br>//+------------------------------------------------------------------+<br>void&nbsp;WriteTick()<br>&nbsp;&nbsp;{<br>//----&nbsp;current&nbsp;bar&nbsp;state<br>&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHandle,&nbsp;ExtLastBarTime,&nbsp;LONG_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHandle,&nbsp;ExtLastOpen,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHandle,&nbsp;ExtLastLow,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHandle,&nbsp;ExtLastHigh,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHandle,&nbsp;ExtLastClose,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHandle,&nbsp;ExtLastVolume,&nbsp;DOUBLE_VALUE);<br>//----&nbsp;incoming&nbsp;tick&nbsp;time<br>&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHandle,&nbsp;ExtLastTime,&nbsp;LONG_VALUE);<br>//----&nbsp;flag&nbsp;4&nbsp;(it&nbsp;must&nbsp;be&nbsp;not&nbsp;equal&nbsp;to&nbsp;0)<br>&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHandle,&nbsp;4,&nbsp;LONG_VALUE);<br>//----&nbsp;ticks&nbsp;counter<br>&nbsp;&nbsp;&nbsp;ExtTicks++;<br>&nbsp;&nbsp;}<br>//+------------------------------------------------------------------+<br>//|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br>//+------------------------------------------------------------------+<br>void&nbsp;WriteHstHeader()<br>&nbsp;&nbsp;{<br>//----&nbsp;History&nbsp;header<br>&nbsp;&nbsp;&nbsp;int&nbsp;&nbsp;&nbsp;&nbsp;i_version=400;<br>&nbsp;&nbsp;&nbsp;string&nbsp;c_copyright;<br>&nbsp;&nbsp;&nbsp;string&nbsp;c_symbol=Symbol();<br>&nbsp;&nbsp;&nbsp;int&nbsp;&nbsp;&nbsp;&nbsp;i_period=Period();<br>&nbsp;&nbsp;&nbsp;int&nbsp;&nbsp;&nbsp;&nbsp;i_digits=Digits;<br>&nbsp;&nbsp;&nbsp;int&nbsp;&nbsp;&nbsp;&nbsp;i_unused[16];<br>//----&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;ExtHstHandle=FileOpen(c_symbol+i_period+&quot;.hst&quot;,&nbsp;FILE_BIN|FILE_WRITE);<br>&nbsp;&nbsp;&nbsp;if(ExtHstHandle&nbsp;&lt;&nbsp;0)&nbsp;return;<br>//----&nbsp;write&nbsp;history&nbsp;file&nbsp;header<br>&nbsp;&nbsp;&nbsp;c_copyright=&quot;(C)opyright&nbsp;2003,&nbsp;MetaQuotes&nbsp;Software&nbsp;Corp.&quot;;<br>&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHstHandle,&nbsp;i_version,&nbsp;LONG_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteString(ExtHstHandle,&nbsp;c_copyright,&nbsp;64);<br>&nbsp;&nbsp;&nbsp;FileWriteString(ExtHstHandle,&nbsp;c_symbol,&nbsp;12);<br>&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHstHandle,&nbsp;i_period,&nbsp;LONG_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHstHandle,&nbsp;i_digits,&nbsp;LONG_VALUE);<br>&nbsp;&nbsp;&nbsp;FileWriteArray(ExtHstHandle,&nbsp;i_unused,&nbsp;0,&nbsp;16);<br>&nbsp;&nbsp;}<br>//+------------------------------------------------------------------+<br>//|&nbsp;write&nbsp;corresponding&nbsp;hst-file&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br>//+------------------------------------------------------------------+<br>void&nbsp;WriteBar()<br>&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;if(ExtHstHandle&gt;0)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FileWriteInteger(ExtHstHandle,&nbsp;ExtLastBarTime,&nbsp;LONG_VALUE);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHstHandle,&nbsp;ExtLastOpen,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHstHandle,&nbsp;ExtLastLow,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHstHandle,&nbsp;ExtLastHigh,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHstHandle,&nbsp;ExtLastClose,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FileWriteDouble(ExtHstHandle,&nbsp;ExtLastVolume,&nbsp;DOUBLE_VALUE);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;}<br>//+------------------------------------------------------------------+</div>
</div>
<script src="https://c.mql5.com/js/dalet.ru.e405bc808c7d49dac42221c93db53323.js" type="text/javascript"></script>
<script type="text/javascript">
  
  function coloriseBlock(text)
    {
     return(MQTE.Highlight('mql',text).value.replace(/\n/g,'<br>').replace(/  /g,"&nbsp;&nbsp;"));
    }
  
   mqGlobal.AddOnLoad(function()
    {
     var d = document.getElementById("code_content"),
         text = d.innerHTML.replace(/\<br\>/gi,"\n").replace(/&([#a-z0-9]+);/gi,
                       function (str,p)
                         {
                          switch(p.toUpperCase())
                            {
                             case 'AMP':
                               return '&';
                             case 'QUOT':
                               return '"';
                             case 'LT':
                               return '<';
                             case 'GT':
                               return '>';
                             case '#039':
                               return "'";
                             case 'NBSP':
                               return ' ';
                             }
                          return p;
                         }
                     );
     //---
     d.innerHTML = coloriseBlock(text);
    });

    function LoadCode(link) {
      Ajax.get(link.href, { tmp: Math.round(Math.random() * 10000) },
       {
         onready: function(text) {
           var d = document.getElementById("code_content");
           d.innerHTML = coloriseBlock(text);
           d = link.parentNode.firstChild;
           while (d) {
             if (d.nodeType == 1)
               {
                if (d == link) d.className = "attachItem selected";
                else d.className = "attachItem";
               }
             d = d.nextSibling;
           }
         },
         onerror: function() {

         }
       });
     return(false);
    }
</script>

   <script src="https://c.mql5.com/js/all.108b146fecbc1f1f7f8dffdf8b5479b1.js" type="text/javascript"></script>
    
</body>
</html>
<!-- Generated in 2 ms -->