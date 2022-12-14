
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправляемыеФормы_Сервер_ат.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	#Область Комментарии
	
	ЗагрузитьКомментарии(Ложь);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	#Область Комментарии
	
	ЗагрузитьКомментарии(Истина);
	
	#КонецОбласти
	
	ОбновитьИтоги(ЭтаФорма);
	
	Уведомлять = Уведомления_ат.НужноОтправлятьУведомлениеОПоступленииСписанииДенежныхСредств(Объект.Ссылка);
	Элементы.Уведомлять.Видимость = ВнутреннегоИспользования_КлиентСерверПовтИсп_ат.СотрудникОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправляемыеФормы_Сервер_ат.ПриЗаписиНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	#Область Комментарии
	
	Комментарии_ат.СохранитьКомментарий(ЭтаФорма, ТекущийОбъект.Ссылка);
	Комментарии_ат.СохранитьКомментарийКлиента(ЭтаФорма, ТекущийОбъект.Ссылка);
	
	#КонецОбласти
	
	Уведомления_ат.ЗаписатьЗначениеНеобходимостиОтправкиУведомленийПоДокументу(ТекущийОбъект.Ссылка, Уведомлять);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДействийПользователя

&НаКлиенте
Процедура РасшифровкаПлатежаПриИзменении(Элемент)
	
	ОбновитьИтоги(ЭтаФорма);	
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если УправляемыеФормы_Клиент_ат.ТолькоПросмотр(Элемент) Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элементы.РасшифровкаПлатежа.ТекущиеДанные.Реализация);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
	
	
	
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)

	Форма.ИтогиВсего = Форма.Объект.РасшифровкаПлатежа.Итог("Сумма");

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

#КонецОбласти

#Область Комментарии

&НаСервере
Процедура ЗагрузитьКомментарии(СозданиеФормы)
	
	Если НЕ СозданиеФормы Тогда
		
		Комментарии_ат.ЗагрузитьКомментарий(ЭтаФорма, Объект.Ссылка);
		Комментарии_ат.ЗагрузитьКомментарийКлиента(ЭтаФорма, Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
