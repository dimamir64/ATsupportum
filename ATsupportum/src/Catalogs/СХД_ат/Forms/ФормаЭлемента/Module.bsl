
&НаКлиенте
Процедура ДисковаяСистемаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Элемент.ТекущиеДанные.объем = ДисковаяСистемаПриОкончанииРедактированияНаСервере(
	Элемент.ТекущиеДанные.Количество, Элемент.ТекущиеДанные.HDD_ат, Элемент.ТекущиеДанные.Raid);	 
	
КонецПроцедуры

&НаСервере
Функция ДисковаяСистемаПриОкончанииРедактированияНаСервере(количество,HDD_ат,Raid)
	Возврат РаботаССерверами_ат.ОбъёмДисковойСистемы(количество,HDD_ат,Raid);
КонецФункции


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
//	ПередЗаписьюНаСервере();
Объект.ОбщийОбъем = Объект.ДисковаяСистема.Итог("Объем");
	//Элемент.ОбщийОбьем
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПередЗаписьюНаСервере(Объем)
//	Возврат Объект.ДисковаяСистема.Итог(Объем);	
КонецФункции
