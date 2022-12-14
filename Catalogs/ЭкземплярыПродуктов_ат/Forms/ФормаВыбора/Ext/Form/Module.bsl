
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("Клиент") Тогда
		Параметры.Отбор.Вставить("Клиент", Параметры.Клиент);
	КонецЕсли;
	
	Если Параметры.Свойство("ТипРолиСервера") Тогда
		
		Параметры.Отбор.Вставить("ТипПродукта",
			УчетПродуктов_ат.ПолучитьТипыПродуктовПоТипуРолиСервера(Параметры.ТипРолиСервера));
			
	ИначеЕсли Параметры.Свойство("ВидРолиСервера") Тогда
		
		Параметры.Отбор.Вставить("ТипПродукта",
			УчетПродуктов_ат.ПолучитьТипыПродуктовПоТипуРолиСервера(Параметры.ВидРолиСервера.ТипРолиСервера));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область УниверсальныеОбработчикиДействий

&НаКлиенте
Процедура ОбработчикУниверсальныхДействий(Команда)
	
	УправляемыеФормы_Клиент_ат.ДополнительныеДействияФормы(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Функция   ОбработчикУниверсальныхДействий_Сервер(Элемент) Экспорт
	
	Возврат УправляемыеФормы_Сервер_ат.ДополнительныеДействияФормы(ЭтаФорма, Команды[Элемент.Имя]);
	
КонецФункции

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	а= 1;
	
КонецПроцедуры

#КонецОбласти
