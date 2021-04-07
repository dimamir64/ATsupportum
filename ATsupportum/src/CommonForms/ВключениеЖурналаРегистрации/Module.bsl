////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьКоличествоАктивныхПользователейСервер();
	СписокПроверок = Параметры.СписокПроверок;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьКоличествоАктивныхПользователей", 5 * 60); // раз в 5 минут
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуАктивныхПользователей(Команда)
	
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей();
	ОбновитьКоличествоАктивныхПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура Повторить(Команда)
	Закрыть();
	ОбщегоНазначенияКлиент.ПроверитьВключениеЖурналаРегистрации(СписокПроверок, Ложь);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьКоличествоАктивныхПользователей()
	ОбновитьКоличествоАктивныхПользователейСервер();
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличествоАктивныхПользователейСервер()
	СеансыИнфоБазы = ПолучитьСеансыИнформационнойБазы();
	
	Если СеансыИнфоБазы = Неопределено Тогда
		Элементы.КнопкаАктивныхПользователей.Заголовок = 1; 
	Иначе
		Элементы.КнопкаАктивныхПользователей.Заголовок = СеансыИнфоБазы.Количество();
	КонецЕсли;
КонецПроцедуры

