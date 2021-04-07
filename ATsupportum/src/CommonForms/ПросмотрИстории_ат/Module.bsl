
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокВидовИсторий = Элементы.ВидИстории.СписокВыбора;
	СписокВидовИсторий.Добавить("ИсторияКомментариев_ат", "История комментариев");
	СписокВидовИсторий.Добавить("ИсторияКомментариевВнутренних_ат", "История комментариев внутренних");
	СписокВидовИсторий.Добавить("ИсторияКомментариевКлиентов_ат", "История комментариев клиентов");
	СписокВидовИсторий.Добавить("ИсторияКомментариевСинхронизируемых_ат", "История комментариев синхронизируемых");
	СписокВидовИсторий.Добавить("ИсторияСтатусовЗаявок_ат", "История статусов заявок");
	СписокВидовИсторий.Добавить("ИсторияСтатусовЗаданий_ат", "История статусов заданий");
	СписокВидовИсторий.Добавить("ИсторияСтатусовОтправкиФинДокументов_ат", "История статусов отправки фин.документов");
	
	ВидИстории = СписокВидовИсторий[0].Значение;
	
	УстановитьОграничениеТипаОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидИсторииПриИзменении(Элемент)
	
	УстановитьОграничениеТипаОбъекта();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОграничениеТипаОбъекта()
	
	Элементы.Объект.ОграничениеТипа = Метаданные.РегистрыСведений[ВидИстории].Измерения.Ссылка.Тип;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИсторию(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Новый Структура("Ссылка", Объект));
	
	ОткрытьФорму("РегистрСведений." + ВидИстории + ".ФормаСписка", ПараметрыОткрытия, ЭтаФорма,
		УникальныйИдентификатор, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
