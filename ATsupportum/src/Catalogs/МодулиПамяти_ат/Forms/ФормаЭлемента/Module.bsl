
&НаКлиенте
Процедура ТипПамятиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	группа = "ТипПамяти";
	РаботаССерверамиСлужебный_ат.ОбработкаВыбораПараметровЖелеза(Элемент, ДанныеВыбора, СтандартнаяОбработка, группа);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ПоддержкаECC) ТОГДА
		Элементы.ПоддержкаECC.Доступность = ложь;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.ТипПамяти) ТОГДА
		Элементы.ТипПамяти.Доступность = Ложь;
	КонецЕсли;	
			
КОнецПроцедуры
	
