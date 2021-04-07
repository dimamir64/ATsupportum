
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И Параметры.ЗначенияЗаполнения.Свойство("Наименование") Тогда
		
		Объект.Наименование = Параметры.ЗначенияЗаполнения.Наименование;
	КонецЕсли;
	
	Если НЕ Параметры.СкрытьВладельца Тогда
		Элементы.Владелец.Видимость = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ПоказатьВес) = Тип("Булево") Тогда
		Если Параметры.ПоказатьВес Тогда
			Элементы.Вес.Видимость = Истина;
		Иначе
			Объект.Вес = 0;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменение_ЗначениеХарактеризуетсяВесовымКоэффициентом"
	   И Источник = Объект.Свойство Тогда
		
		Если Параметр = Истина Тогда
			Элементы.Вес.Видимость = Истина;
		Иначе
			Элементы.Вес.Видимость = Ложь;
			Объект.Вес = 0;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ЗначенияСвойствОбъектовИерархия",
		Новый Структура("Ссылка", Объект.Ссылка), Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УстановитьЗаголовок()
	
	ЗначенияРеквизитов = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
		Объект.Владелец, "Заголовок, ЗаголовокФормыЗначения");
	
	ИмяСвойства = СокрЛП(ЗначенияРеквизитов.ЗаголовокФормыЗначения);
	
	Если НЕ ПустаяСтрока(ИмяСвойства) Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (%2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	Иначе
		ИмяСвойства = Строка(ЗначенияРеквизитов.Заголовок);
		
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (Значение свойства %2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Значение свойства %1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
