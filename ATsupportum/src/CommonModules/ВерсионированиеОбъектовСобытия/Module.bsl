////////////////////////////////////////////////////////////////////////////////
// Подсистема "Версионирование объектов".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Записывает версию объекта в информационную базу.
//
// Параметры
//  Источник - Объект - записываемый объект ИБ;
//  Отказ    - Булево - признак отказа от записи объекта.
//
Процедура ЗаписатьВерсиюОбъекта(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("СведенияОВерсииОбъекта") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииВерсииОбъекта(Источник);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему

// Записывает версию объекта в информационную базу. Вызывается при выполнении
// обмена данными с другой информационной базой.
//
// Параметры
//  Источник - Объект - записываемый объект ИБ;
//  Отказ    - Булево - признак отказа от записи объекта.
//
Процедура ЗаписатьВерсиюОбъектаПриОбменеДанными(Источник, Отказ) Экспорт
	
	Если Источник.ДополнительныеСвойства.Свойство("СведенияОВерсииОбъекта") Тогда
		
		ВерсионированиеОбъектов.ПриСозданииВерсииОбъектаПоОбменуДанными(Источник);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события

// Только для внутреннего использования
//
Процедура УдалитьИнформациюОбАвтореВерсии(Источник, Отказ) Экспорт
	
	РегистрыСведений.ВерсииОбъектов.УдалитьИнформациюОбАвтореВерсии(Источник.Ссылка);
	
КонецПроцедуры

