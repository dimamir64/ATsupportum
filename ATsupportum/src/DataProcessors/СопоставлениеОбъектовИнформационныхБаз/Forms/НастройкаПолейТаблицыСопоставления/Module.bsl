////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокПолей = Параметры.СписокПолей;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Применить(Команда)
	
	Отказ = Ложь;
	
	МассивОтмеченныхЭлементовСписка = ОбщегоНазначенияКлиентСервер.ПолучитьМассивОтмеченныхЭлементовСписка(СписокПолей);
	
	Если МассивОтмеченныхЭлементовСписка.Количество() = 0 Тогда
		
		НСтрока = НСтр("ru = 'Следует указать хотя бы одно поле'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтрока,,"СписокПолей",, Отказ);
		
	ИначеЕсли МассивОтмеченныхЭлементовСписка.Количество() > МаксимальноеКоличествоПользовательскихПолей() Тогда
		
		// значение должно быть не больше установленного
		СтрокаСообщения = НСтр("ru = 'Уменьшите количество полей (можно выбирать не более [КоличествоПолей] полей)'");
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "[КоличествоПолей]", Строка(МаксимальноеКоличествоПользовательскихПолей()));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,"СписокПолей",, Отказ);
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ОповеститьОВыборе(СписокПолей.Скопировать());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция МаксимальноеКоличествоПользовательскихПолей()
	
	Возврат ОбменДаннымиКлиент.МаксимальноеКоличествоПолейСопоставленияОбъектов();
	
КонецФункции
