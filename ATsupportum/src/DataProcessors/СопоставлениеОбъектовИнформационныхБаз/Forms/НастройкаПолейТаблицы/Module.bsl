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
	
	МассивОтмеченныхЭлементовСписка = ОбщегоНазначенияКлиентСервер.ПолучитьМассивОтмеченныхЭлементовСписка(СписокПолей);
	
	Если МассивОтмеченныхЭлементовСписка.Количество() = 0 Тогда
		
		НСтрока = НСтр("ru = 'Следует указать хотя бы одно поле'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтрока,,"СписокПолей");
		
		Возврат;
		
	КонецЕсли;
	
	ОповеститьОВыборе(СписокПолей.Скопировать());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры
