
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ЗначениеЗаполнено(Параметры.Продукт) Тогда
		
		Продукт = Параметры.Продукт;
		
		Список.Параметры.УстановитьЗначениеПараметра("Продукт", Продукт);
		
		ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт( , , Истина));
		ЭлементУсловия = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Продукт");
		ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементУсловия.ПравоеЗначение = Продукт;
		ЭлементУсловногоОформления.Использование = Истина;
		
	КонецЕсли;
	
	Если Параметры.Список Тогда
		
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОтборПоПоставщикам) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Продукт.Поставщик");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.ПравоеЗначение = Коллекции_ат.СкопироватьВМассив(Параметры.ОтборПоПоставщикам);
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.Использование = Истина;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОтборПоВладельцу) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КонтрагентВладелец");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Параметры.ОтборПоПоставщику;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.Использование = Истина;
		
	КонецЕсли;
	
	ВнутреннегоИспользования_ВызовСервера_ат.УстановитьОтборПоКлиентуДляОтбора(ЭтаФорма, , "КонтрагентВладелец");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КлиентДляОтбораИзменен" И НЕ Элементы.Список.РежимВыбора Тогда
		
		ВнутреннегоИспользования_Клиент_ат.ИзменитьОтборПоКлиентуДляОтбора(Список, "КонтрагентВладелец", Параметр);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	УправляемыеФормы_Клиент_ат.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьПоставку(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Продукт", Продукт);
	
	Оповещение = Новый ОписаниеОповещения("ПослеСозданияПоставок", ЭтаФорма);
	
	ОткрытьФорму("Справочник.ПоставкиПродуктов_ат.Форма.ФормаГрупповогоСозданияПоставок", ПараметрыОткрытия,
		ЭтаФорма, УникальныйИдентификатор, , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеСозданияПоставок(Результат, ПередаваемыеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
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
