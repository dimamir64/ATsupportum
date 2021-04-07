
#Область  ПрограммныйИнтерфейс

Функция   ПолучитьСтруктуруСинхронизацииСИБ(ИБ, МассивОшибок = Неопределено) Экспорт
	
	Если МассивОшибок = Неопределено Тогда
		МассивОшибок = Новый Массив;
	КонецЕсли;
	
	МодульВзаимодействия = Неопределено;
	
	Подключение = ПодключениеКИБ_ат.УстановитьПодключение(ИБ);
	
	Если ТипЗнч(Подключение) = Тип("Строка") Тогда
		
		МассивОшибок.Добавить(Подключение);
		
	Иначе
		
		Попытка
			
			МодульВзаимодействия = Подключение.РасшАТsup_СинхронизацияВнешнееСоединение;
			
			ВерсияМодуля = МодульВзаимодействия.ВерсияМодуля();
			ПоддерживаемаяВерсия = "1.0.2.1";
			
			Если ВерсияМодуля <> ПоддерживаемаяВерсия Тогда
				
				МассивОшибок.Добавить("Версия модуля ""РасшАТsup_СинхронизацияВнешнееСоединение"" (" +
					ВерсияМодуля + ") не соответствует поддерживаемой (" + ПоддерживаемаяВерсия + ")!");
				
			КонецЕсли;
			
		Исключение
			
			МассивОшибок.Добавить("В ИБ (расширении) Бухгалтерии Предприятия <" + ИБ + "> для синхронизации не найден модуль " + 
				"""РасшАТsup_СинхронизацияВнешнееСоединение""!");
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Новый Структура("Подключение, МодульВзаимодействия, Ошибки", Подключение, МодульВзаимодействия, МассивОшибок);
	
КонецФункции

// Возвращает для переданной ссылки структуру данных из регистра синхронизации.
//
// Параметры:
//	Ссылка - Ссылка на синхронизированный объект.
//	ИБ - СправочникСсылка.БазыДанных_ат - База данных с объектами которых синхронизированны переданные ссылки.
//	ИмяРегистраСинхронизации - Строка - Имя регистри сведений в котором будет осуществлен поиск данных синхронизации.
//
// Возвращаемое значение:
//	Структура если данные синхронизации найдены.
//	Неопределено если данные синхронизации не найдены.
//	
Функция   ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Ссылка, ИмяРегистраСинхронизации) Экспорт
	
	Возврат ПолучитьСоответствиеСтруктурДанныхСинхронизацииСсылкам(Ссылка, ИмяРегистраСинхронизации)[Ссылка];
	
КонецФункции

// Возвращает соответствие переданных ссылок структурам данных из регистра синхронизации.
//
// Параметры:
//	Ссылки - Ссылка или массив ссылок на синхронизированные объекты.
//	ИБ - СправочникСсылка.БазыДанных_ат - База данных с объектами которых синхронизированны переданные ссылки.
//	ИмяРегистраСинхронизации - Строка - Имя регистри сведений в котором будет осуществлен поиск данных синхронизации.
//
// Возвращаемое значение:
//	Соответствие где ключами являются переданные ссылки, а значениями - структуры в случае если данные найдены и неопределено если нет.
//
Функция   ПолучитьСоответствиеСтруктурДанныхСинхронизацииСсылкам(Ссылки, ИмяРегистраСинхронизации)
	
	ВозвращаемоеСоответствие = Новый Соответствие;
	
	Если ТипЗнч(Ссылки) = Тип("Массив") Тогда
		
		Для Каждого Ссылка Из Ссылки Цикл
			ВозвращаемоеСоответствие.Вставить(Ссылка, Неопределено);
		КонецЦикла;
		
	Иначе
		
		ВозвращаемоеСоответствие.Вставить(Ссылки, Неопределено);
		
		Попытка
			
			Если Ссылки.Пустая() Тогда
				Возврат ВозвращаемоеСоответствие;
			КонецЕсли;
			
		Исключение // если объект или ещё что
			
			Возврат ВозвращаемоеСоответствие;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РегистрСинхронизации.Ссылка,
		|	РегистрСинхронизации.Идентификатор,
		|	РегистрСинхронизации.НавигационнаяСсылка
		|ИЗ
		|	РегистрСведений." + ИмяРегистраСинхронизации + " КАК РегистрСинхронизации
		|ГДЕ
		|	РегистрСинхронизации.Ссылка В (&Ссылки)");
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеСинхронизации = Новый Структура;
		
		ДанныеСинхронизации.Вставить("Ссылка", 				Выборка.Ссылка);
		ДанныеСинхронизации.Вставить("Идентификатор", 		Выборка.Идентификатор);
		ДанныеСинхронизации.Вставить("НавигационнаяСсылка", Выборка.НавигационнаяСсылка);
		
		ВозвращаемоеСоответствие[Выборка.Ссылка] = ДанныеСинхронизации;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеСоответствие;
	
КонецФункции

//

Процедура ПроверкаОплатыСчетов() Экспорт
	
	МассивОшибок = ОбновитьДанныеОплатыСчетов();
	
	Для Каждого Ошибка Из МассивОшибок Цикл
		ЗаписьЖурналаРегистрации("Регламентное задание.Проверка оплаты счетов", УровеньЖурналаРегистрации.Ошибка, , , Ошибка);
	КонецЦикла;
	
КонецПроцедуры

Функция   ОбновитьДанныеОплатыСчетов() Экспорт
	
	ИБ = Константы.БухгалтерияДляСинхронизации_ат.Получить();
	
	Если ИБ.Пустая() Тогда
		
		МассивОшибок = Новый Массив;
		МассивОшибок.Добавить("ИБ Бухгалтерии Предприятия для синхронизации не указана!");
		
		Возврат МассивОшибок;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СчетНаОплатуДокумент.Ссылка
		|ИЗ
		|	Документ.СчетНаОплату_ат КАК СчетНаОплатуДокумент
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыСчетовНаОплату_ат КАК СтатусыСчетовНаОплату
		|			ПО СчетНаОплатуДокумент.Ссылка = СтатусыСчетовНаОплату.Счет
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СинхронизацияСчетовНаОплату_ат КАК СинхронизацияСчетовНаОплату
		|			ПО СчетНаОплатуДокумент.Ссылка = СинхронизацияСчетовНаОплату.Ссылка
		|ГДЕ
		|	СчетНаОплатуДокумент.Проведен
		|	И НЕ СинхронизацияСчетовНаОплату.НомерСчета ЕСТЬ NULL
		|	И (СтатусыСчетовНаОплату.Статус ЕСТЬ NULL 
		|		ИЛИ (СтатусыСчетовНаОплату.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыОплатыСчетов_ат.Отменен)
		|			И СтатусыСчетовНаОплату.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыОплатыСчетов_ат.Оплачен)))");
	
	Возврат ОбновитьДанныеОплатыСчетовВ_БП(ИБ, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецФункции

// Производит поиск Поступлений денежных средств для переданных счетов в переданной базе.
//
// Параметры:
//	ИБ - СправочникСсылка.БазыДанных_ат - БП для синхронизации.
//	Счета - ДокументСсылка.СчетНаОплату_ат, Массив - Ссылка или массив ссылок на Счета.
//
// Возвращаемое значение:
//  Массив - Массив строк с описанием ошибок.
//
Функция   ОбновитьДанныеОплатыСчетовВ_БП(ИБ, Счета) Экспорт
	
	Если ИБ.Пустая() Тогда
		
		МассивОшибок = Новый Массив;
		МассивОшибок.Добавить("Не указана используемая для синхронизации ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
		Возврат Новый Структура("Ошибки", МассивОшибок);
		
	КонецЕсли;
	
	СтруктураСинхронизации = ПолучитьСтруктуруСинхронизацииСИБ(ИБ);
	
	Если СтруктураСинхронизации.Ошибки.Количество() > 0 Тогда
		Возврат СтруктураСинхронизации.Ошибки;
	КонецЕсли;
	
	СоответствиеИдентификаторовСчетам = Новый Соответствие;
	ИдентификаторыСчетов = СтруктураСинхронизации.Подключение.NewObject("Массив");
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СинхронизацияСчетовНаОплату.Ссылка КАК Счет,
		|	СинхронизацияСчетовНаОплату.Идентификатор КАК ИдентификаторСчета
		|ИЗ
		|	РегистрСведений.СинхронизацияСчетовНаОплату_ат КАК СинхронизацияСчетовНаОплату
		|ГДЕ
		|	СинхронизацияСчетовНаОплату.Ссылка В(&Счета)");
	Запрос.УстановитьПараметр("Счета", Счета);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СоответствиеИдентификаторовСчетам.Вставить(Выборка.ИдентификаторСчета, Выборка.Счет);
		ИдентификаторыСчетов.Добавить(Выборка.ИдентификаторСчета);
		
	КонецЦикла;
	
	Результат = СтруктураСинхронизации.МодульВзаимодействия.ПолучитьДанныеОПоступленияхПоСчетамНаОплатуПокупателям(ИдентификаторыСчетов);
	Для Каждого Ошибка Из Результат.Ошибки Цикл
		СтруктураСинхронизации.Ошибки.Добавить(Ошибка);
	КонецЦикла;
	
	СоответствиеПоступлений = Новый Соответствие;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПоступлениеНаСчетКлиентаРасшифровкаПлатежа.СчетНаОплату КАК Счет,
		|	СинхронизацияПоступленийНаРасчетныйСчет.Идентификатор КАК ИдентификаторПоступления
		|ИЗ
		|	Документ.ПоступлениеНаСчетКлиента_ат.РасшифровкаПлатежа КАК ПоступлениеНаСчетКлиентаРасшифровкаПлатежа
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СинхронизацияПоступленийНаРасчетныйСчет_ат КАК СинхронизацияПоступленийНаРасчетныйСчет
		|		ПО (СинхронизацияПоступленийНаРасчетныйСчет.Ссылка = ПоступлениеНаСчетКлиентаРасшифровкаПлатежа.Ссылка)
		|ГДЕ
		|	ПоступлениеНаСчетКлиентаРасшифровкаПлатежа.СчетНаОплату В(&Счета)");
	Запрос.УстановитьПараметр("Счета", Счета);
	
	ТаблицаСуществующийПоступлений = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Результат.ТаблицаПоступлений Цикл
		
		Счет = СоответствиеИдентификаторовСчетам[Строка.ИдентификаторСчета];
		ИдентификаторПоступления = Строка.ИдентификаторПоступления;
		
		Отбор = Новый Структура("Счет, ИдентификаторПоступления", Счет, ИдентификаторПоступления);
		
		Если ТаблицаСуществующийПоступлений.НайтиСтроки(Отбор).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НовоеПоступление = СоответствиеПоступлений.Получить(Строка.ИдентификаторПоступления);
		
		Если НовоеПоступление = Неопределено Тогда
			
			СоответствиеПоступлений.Вставить(ИдентификаторПоступления, Документы.ПоступлениеНаСчетКлиента_ат.СоздатьДокумент());
			НовоеПоступление = СоответствиеПоступлений[ИдентификаторПоступления]; 
			
			НовоеПоступление.Организация = Счет.Организация;
			НовоеПоступление.Клиент = Счет.Клиент;
			
		КонецЕсли;
		
		НоваяСтрокаРасшифровки = НовоеПоступление.РасшифровкаПлатежа.Добавить();
		
		НоваяСтрокаРасшифровки.СчетНаОплату = Счет;
		НоваяСтрокаРасшифровки.Сумма = Строка.СуммаПлатежа;
		
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из СоответствиеПоступлений Цикл
		
		ДанныеСинхронизации = Результат.ТаблицаПоступлений.Найти(КлючИЗначение.Ключ, "ИдентификаторПоступления"); 
		
		НачатьТранзакцию();
		Попытка
			
			НовоеПоступлениеСсылка = Документы.ПоступлениеНаСчетКлиента_ат.ПолучитьСсылку(Новый УникальныйИдентификатор); // выделить
			НовоеПоступлениеОбъект = КлючИЗначение.Значение;
			НовоеПоступлениеОбъект.Дата = ТекущаяДатаСеанса();
			НовоеПоступлениеОбъект.УстановитьСсылкуНового(НовоеПоступлениеСсылка);
			НовоеПоступлениеОбъект.УстановитьНовыйНомер();
			
			НаборЗаписейСинхронизации = РегистрыСведений.СинхронизацияПоступленийНаРасчетныйСчет_ат.СоздатьНаборЗаписей(); // выделить
			НаборЗаписейСинхронизации.Отбор.Ссылка.Установить(НовоеПоступлениеСсылка);
			НаборЗаписейСинхронизации.Прочитать();
			
			НоваяЗаписьСинхронизации = НаборЗаписейСинхронизации.Добавить();
			
			НоваяЗаписьСинхронизации.Ссылка 				= НовоеПоступлениеСсылка;
			НоваяЗаписьСинхронизации.Идентификатор 			= ДанныеСинхронизации.ИдентификаторПоступления;
			НоваяЗаписьСинхронизации.НавигационнаяСсылка 	= ДанныеСинхронизации.НавигационнаяСсылка;
			НоваяЗаписьСинхронизации.ДатаПоступления 		= ДанныеСинхронизации.ДатаПоступления;
			НоваяЗаписьСинхронизации.НомерПоступления 		= ДанныеСинхронизации.НомерПоступления;
			НоваяЗаписьСинхронизации.СуммаПоступления 		= ДанныеСинхронизации.СуммаПоступления;
			
			НаборЗаписейСинхронизации.Записать();
			
			НовоеПоступлениеОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			СтруктураСинхронизации.Ошибки.Добавить(ОписаниеОшибки());
			
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат СтруктураСинхронизации.Ошибки;
	
КонецФункции

Функция   ОбновитьДанныеПодписанийРеализаций() Экспорт
	
	ИБ = Константы.БухгалтерияДляСинхронизации_ат.Получить();
	
	Если ИБ.Пустая() Тогда
		
		МассивОшибок = Новый Массив;
		МассивОшибок.Добавить("ИБ Бухгалтерии Предприятия для синхронизации не указана!");
		
		Возврат МассивОшибок;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РеализацияДокумент.Ссылка
		|ИЗ
		|	Документ.Реализация_ат КАК РеализацияДокумент
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СинхронизацияРеализаций_ат КАК СинхронизацияРеализаций
		|			ПО РеализацияДокумент.Ссылка = СинхронизацияРеализаций.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСтатусовОтправкиФинДокументов_ат.СрезПоследних КАК ИсторияСтатусовОтправкиФинДокументовСрезПоследних
		|			ПО РеализацияДокумент.Ссылка = ИсторияСтатусовОтправкиФинДокументовСрезПоследних.Ссылка
		|ГДЕ
		|	РеализацияДокумент.Проведен
		|	И НЕ СинхронизацияРеализаций.НомерРеализации ЕСТЬ NULL
		|	И ИсторияСтатусовОтправкиФинДокументовСрезПоследних.Статус.ТипСтатуса = ЗНАЧЕНИЕ(Перечисление.ТипыСтатусовОтправкиФинДокументов_ат.НеФинальный)
		|");
	
	Возврат ОбновитьДанныеПодписанийРеализацийВ_БП(ИБ, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецФункции

Функция   ОбновитьДанныеПодписанийРеализацийВ_БП(ИБ, Реализации) Экспорт
	
	Если ИБ.Пустая() Тогда
		
		МассивОшибок = Новый Массив;
		МассивОшибок.Добавить("Не указана используемая для синхронизации ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
		Возврат Новый Структура("Ошибки", МассивОшибок);
		
	КонецЕсли;
	
	СтруктураСинхронизации = ПолучитьСтруктуруСинхронизацииСИБ(ИБ);
	
	Если СтруктураСинхронизации.Ошибки.Количество() > 0 Тогда
		Возврат СтруктураСинхронизации.Ошибки;
	КонецЕсли;
	
	СоответствиеИдентификаторовРеализациям = Новый Соответствие;
	ИдентификаторыРеализаций = СтруктураСинхронизации.Подключение.NewObject("Массив");
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СинхронизацияРеализаций.Ссылка КАК Реализация,
		|	СинхронизацияРеализаций.Идентификатор КАК ИдентификаторРеализации
		|ИЗ
		|	РегистрСведений.СинхронизацияРеализаций_ат КАК СинхронизацияРеализаций
		|ГДЕ
		|	СинхронизацияРеализаций.Ссылка В(&Реализации)");
	Запрос.УстановитьПараметр("Реализации", Реализации);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СоответствиеИдентификаторовРеализациям.Вставить(Выборка.ИдентификаторРеализации, Выборка.Реализация);
		ИдентификаторыРеализаций.Добавить(Выборка.ИдентификаторРеализации);
		
	КонецЦикла;
	
	Результат = СтруктураСинхронизации.МодульВзаимодействия.ПолучитьДанныеОПодписанииРеализаций(ИдентификаторыРеализаций);
	Для Каждого Ошибка Из Результат.Ошибки Цикл
		СтруктураСинхронизации.Ошибки.Добавить(Ошибка);
	КонецЦикла;
	
	////////////
	
	Возврат Новый Структура();
	//Для Каждого Строка Из Результат.ТаблицаПоступлений Цикл
	//	
	//	Счет = СоответствиеИдентификаторовРеализациям[Строка.ИдентификаторРеализации];
	//	ИдентификаторПоступления = Строка.ИдентификаторПоступления;
	//	
	//	Отбор = Новый Структура("Счет, ИдентификаторПоступления", Счет, ИдентификаторПоступления);
	//	
	//	Если ТаблицаСуществующийПоступлений.НайтиСтроки(Отбор).Количество() > 0 Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	
	//	НовоеПоступление = СоответствиеПоступлений.Получить(Строка.ИдентификаторПоступления);
	//	
	//	Если НовоеПоступление = Неопределено Тогда
	//		
	//		СоответствиеПоступлений.Вставить(ИдентификаторПоступления, Документы.ПоступлениеНаСчетКлиента_ат.СоздатьДокумент());
	//		НовоеПоступление = СоответствиеПоступлений[ИдентификаторПоступления]; 
	//		
	//		НовоеПоступление.Организация 	= Счет.Организация;
	//		НовоеПоступление.Клиент 		= Счет.Клиент;
	//		
	//	КонецЕсли;
	//	
	//	НоваяСтрокаРасшифровки = НовоеПоступление.РасшифровкаПлатежа.Добавить();
	//	
	//	НоваяСтрокаРасшифровки.СчетНаОплату = Счет;
	//	НоваяСтрокаРасшифровки.Сумма 		= Строка.СуммаПлатежа;
	//	
	//КонецЦикла;
	//
	//Для Каждого КлючИЗначение Из СоответствиеПоступлений Цикл
	//	
	//	ДанныеСинхронизации = Результат.ТаблицаПоступлений.Найти(КлючИЗначение.Ключ, "ИдентификаторПоступления"); 
	//	
	//	НачатьТранзакцию();
	//	Попытка
	//		
	//		НовоеПоступлениеСсылка = Документы.ПоступлениеНаСчетКлиента_ат.ПолучитьСсылку(Новый УникальныйИдентификатор); // выделить
	//		НовоеПоступлениеОбъект = КлючИЗначение.Значение;
	//		НовоеПоступлениеОбъект.Дата = ТекущаяДатаСеанса();
	//		НовоеПоступлениеОбъект.УстановитьСсылкуНового(НовоеПоступлениеСсылка);
	//		НовоеПоступлениеОбъект.УстановитьНовыйНомер();
	//		
	//		НаборЗаписейСинхронизации = РегистрыСведений.СинхронизацияПоступленийНаРасчетныйСчет_ат.СоздатьНаборЗаписей(); // выделить
	//		НаборЗаписейСинхронизации.Отбор.Ссылка.Установить(НовоеПоступлениеСсылка);
	//		НаборЗаписейСинхронизации.Прочитать();
	//		
	//		НоваяЗаписьСинхронизации = НаборЗаписейСинхронизации.Добавить();
	//		
	//		НоваяЗаписьСинхронизации.Ссылка 				= НовоеПоступлениеСсылка;
	//		НоваяЗаписьСинхронизации.Идентификатор 			= ДанныеСинхронизации.ИдентификаторПоступления;
	//		НоваяЗаписьСинхронизации.НавигационнаяСсылка 	= ДанныеСинхронизации.НавигационнаяСсылка;
	//		НоваяЗаписьСинхронизации.ДатаПоступления 		= ДанныеСинхронизации.ДатаПоступления;
	//		НоваяЗаписьСинхронизации.НомерПоступления 		= ДанныеСинхронизации.НомерПоступления;
	//		НоваяЗаписьСинхронизации.СуммаПоступления 		= ДанныеСинхронизации.СуммаПоступления;
	//		
	//		НаборЗаписейСинхронизации.Записать();
	//		
	//		НовоеПоступлениеОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
	//		
	//		ЗафиксироватьТранзакцию();
	//		
	//	Исключение
	//		
	//		ОтменитьТранзакцию();
	//		
	//		СтруктураСинхронизации.Ошибки.Добавить(ОписаниеОшибки());
	//		
	//	КонецПопытки;
	//	
	//КонецЦикла;
	//
	//Возврат СтруктураСинхронизации.Ошибки;
	
КонецФункции

//

Функция   ПолучитьСинхронизированнуюПечатнуюФорму(Ссылка, РегистрСинхронизации, ИмяМакета, ЭтоВнешняяПечатнаяФорма = Ложь) Экспорт
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("ТекстОшибки", "");
	ВозвращаемаяСтруктура.Вставить("ТабличныйДокумент", Новый ТабличныйДокумент);
	ВозвращаемаяСтруктура.Вставить("ПредставлениеДокумента", "");
	ВозвращаемаяСтруктура.Вставить("ЭДО", Ложь);
	
	ИБ = Константы.БухгалтерияДляСинхронизации_ат.Получить();
	Если ИБ.Пустая() Тогда
		
		ВозвращаемаяСтруктура.ТекстОшибки = "ИБ Бухгалтерии Предприятия для синхронизации не указана!";
		Возврат ВозвращаемаяСтруктура;
		
	КонецЕсли;
	
	Если РегистрСинхронизации = "СинхронизацияСчетовНаОплату_ат" Тогда
		
		ТекстОшибкиОтсутствияСинхронизированногоОбъекта = Строка(Ссылка) + " не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!";
		ИмяСинхронизированногоДокумента = "СчетНаОплатуПокупателю";
		
	ИначеЕсли РегистрСинхронизации = "СинхронизацияРеализаций_ат" Тогда
		
		ТекстОшибкиОтсутствияСинхронизированногоОбъекта = Строка(Ссылка) + " не синхронизирована с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!";
		ИмяСинхронизированногоДокумента = "РеализацияТоваровУслуг";
		
	Иначе
		
		ВозвращаемаяСтруктура.ТекстОшибки = "Неопознанный тип данных синхронизации. Печать не возможна!";
		Возврат ВозвращаемаяСтруктура;
		
	КонецЕсли;
	
	КаталогОбмена = Константы.КаталогДляОбменаСБухгалтерией_ат.Получить();
	Если НЕ ЗначениеЗаполнено(КаталогОбмена) Тогда
		
		ВозвращаемаяСтруктура.ТекстОшибки = "Не определён каталог для обмена с ИБ Бухгалтерии Предприятия <" + ИБ + ">!";
		Возврат ВозвращаемаяСтруктура;
		
	КонецЕсли;
	
	ДанныеСинхронизации = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Ссылка, РегистрСинхронизации);
	Если ДанныеСинхронизации = Неопределено Тогда
		
		ВозвращаемаяСтруктура.ТекстОшибки = ТекстОшибкиОтсутствияСинхронизированногоОбъекта;
		Возврат ВозвращаемаяСтруктура;
		
	КонецЕсли;
	
	СтруктураСинхронизации = ПолучитьСтруктуруСинхронизацииСИБ(ИБ);
	Если СтруктураСинхронизации.Ошибки.Количество() > 0 Тогда
		
		ВозвращаемаяСтруктура.ТекстОшибки = СтруктураСинхронизации.Ошибки[0];
		Возврат ВозвращаемаяСтруктура;
		
	КонецЕсли;
	
	ПутьКФайлу = КаталогОбмена + Формат(ТекущаяДатаСеанса(), "ДФ=yyyyMMddHHmmss") + "_" + ДанныеСинхронизации.Идентификатор + ".mxl";
	
	Результат = СтруктураСинхронизации.МодульВзаимодействия.ПолучитьПечатнуюФормуДокумента(ДанныеСинхронизации.Идентификатор,
		ИмяСинхронизированногоДокумента, ?(ЭтоВнешняяПечатнаяФорма, "ВнешняяПечатнаяФорма.", "") + ИмяМакета, ПутьКФайлу);
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		
		ВозвращаемаяСтруктура.ТекстОшибки = Результат.ТекстОшибки;
		
	Иначе
		
		ВозвращаемаяСтруктура.ТабличныйДокумент.Прочитать(ПутьКФайлу);
		ВозвращаемаяСтруктура.ПредставлениеДокумента = Результат.ПредставлениеДокумента;
		ВозвращаемаяСтруктура.ЭДО = Результат.ЭДО;
		
		УдалитьФайлы(ПутьКФайлу);
		
	КонецЕсли;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

//

Функция   СинхронизироватьСчетНаОплату(Счет, ИБ, ИдентификаторСчета = "", Проведение = Неопределено, КомментарийСинхронизируемый = "") Экспорт
	
	Ошибки = Новый Массив;
	
	Если ПустаяСтрока(ИдентификаторСчета) Тогда
		
		ДанныеСинхронизацииСчета = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Счет,
			"СинхронизацияСчетовНаОплату_ат");
		Если ДанныеСинхронизацииСчета = Неопределено Тогда
			ИдентификаторСчета = Неопределено;
		Иначе
			ИдентификаторСчета = ДанныеСинхронизацииСчета.Идентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСинхронизацииОрганизации = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Счет.Организация,
		"СинхронизацияОрганизаций_ат");
	Если ДанныеСинхронизацииОрганизации = Неопределено Тогда
		Ошибки.Добавить("Организация указанная в Счёте не синхронизированна с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	ДанныеСинхронизацииКонтрагента = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Счет.Клиент,
		"СинхронизацияКонтрагентов_ат");
	Если ДанныеСинхронизацииКонтрагента = Неопределено Тогда
		Ошибки.Добавить("Контрагент указанный в Счёте не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	Если НЕ Константы.СоздаватьДоговорДляКаждогоСчета_ат.Получить() Тогда
		
		Договор = ?(Счет.Договор.Родитель.Пустая(), Счет.Договор, Счет.Договор.Родитель); // В БП всегда передаём головной договор.
		
		ДанныеСинхронизацииДоговора = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Договор,
			"СинхронизацияДоговоров_ат");
		Если ДанныеСинхронизацииДоговора = Неопределено Тогда
			
			ПредставлениеДоговора = ?(Счет.Договор.Родитель.Пустая(), "Договор", "Родительский договор");
			Ошибки.Добавить(ПредставлениеДоговора + " в Счёте не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
			
		КонецЕсли;
		
	Иначе
		
		ДанныеСинхронизацииДоговора = Новый Структура("Идентификатор", "");
		
	КонецЕсли;
	
	СоответствиеУслугДаннымСинхронизации = ПолучитьСоответствиеСтруктурДанныхСинхронизацииСсылкам(
		Счет.Услуги.ВыгрузитьКолонку("Номенклатура"), "СинхронизацияНоменклатуры_ат");
	
	Для каждого КлючИЗначение Из СоответствиеУслугДаннымСинхронизации Цикл
		
		Если КлючИЗначение.Значение = Неопределено Тогда
			Ошибки.Добавить("Услуга """ + КлючИЗначение.Ключ
				+ """ не синхронизированна с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
		КонецЕсли;
		
	КонецЦикла;
	
	СинхронизируемыйКомментарий = Счет.ВнешнийНомер + " | " + КомментарийСинхронизируемый;
	
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	СтруктураСинхронизации = ПолучитьСтруктуруСинхронизацииСИБ(ИБ, Ошибки);
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	Если Счет.Основания.Количество() > 0 Тогда //TODO: сделать опциональным
		
		Если НЕ ПустаяСтрока(КомментарийСинхронизируемый) Тогда
			КомментарийСинхронизируемый = КомментарийСинхронизируемый + Символы.ПС;
		КонецЕсли;
		
		КомментарийСинхронизируемый = КомментарийСинхронизируемый + "#!# Данные для счёта основаны на следующих документах: ";
		
		Для Каждого Основание Из Счет.Основания Цикл
			КомментарийСинхронизируемый = КомментарийСинхронизируемый + " " + Строка(Основание.Основание) + ", ";
		КонецЦикла;
		
		Если Прав(СинхронизируемыйКомментарий, 2) = ", " Тогда
			СинхронизируемыйКомментарий = Строки_КлиентСервер_ат.ВернутьОбрезаннуюСтроку(СинхронизируемыйКомментарий, 2);
		КонецЕсли;
		
	КонецЕсли;
	
	//
	
	Если СтрНайти(КомментарийСинхронизируемый, "#!# ") = 0 Тогда
		КомментарийСинхронизируемый = КомментарийСинхронизируемый + "#!# ";
	КонецЕсли;
	
	Если Счет.Основания.Количество() = 1 И ТипЗнч(Счет.Основания[0].Основание) = Тип("ДокументСсылка.Согласование_ат")
		И ЗначениеЗаполнено(Счет.Основания[0].Основание.ДатаСогласования) Тогда
		
		КомментарийСинхронизируемый = КомментарийСинхронизируемый + Символы.ПС
			+ "Оперативный остаток на балансе клиента по договору счёта после принятия Согласования-основания: "
			+ " " + Финансы_ат.ПолучитьОстатокНаСчетеКлиентаПоДоговоруНаДату(Счет.Договор, Счет.Основания[0].Основание.ДатаСогласования) + " руб"
			+ " #!#";
		
	Иначе
		
		КомментарийСинхронизируемый = КомментарийСинхронизируемый
			+ "Оперативный остаток на балансе клиента по договору счёта на начало дня даты счёта: "
			+ "  " + Финансы_ат.ПолучитьОстатокНаСчетеКлиентаПоДоговоруНаДату(Счет.Договор, НачалоДня(Счет.Дата)) + " руб"
			+ " #!#";
		
	КонецЕсли; 
	
	//
	
	Услуги = СформироватьМассивУслугДляПередачи(СтруктураСинхронизации.Подключение, Счет.Услуги, СоответствиеУслугДаннымСинхронизации);
	
	Если Проведение = Неопределено Тогда
		Проведение = Счет.Проведен;
	КонецЕсли;
	
	РезультатСинхронизации = СтруктураСинхронизации.МодульВзаимодействия.СинхронизироватьСчетНаОплатуПокупателю(ИдентификаторСчета,
		Проведение, Счет.Дата, Счет.ДатаОплатыПланируемая, ДанныеСинхронизацииОрганизации.Идентификатор, ДанныеСинхронизацииКонтрагента.Идентификатор,
		Услуги, ДанныеСинхронизацииДоговора.Идентификатор, ПолучитьИмяГруппыСинхронизируемыхДоговоров(), КомментарийСинхронизируемый);
	
	Возврат РезультатСинхронизации;
	
КонецФункции

Функция   СинхронизироватьРеализацию(Реализация, ИБ, ИдентификаторРеализации = "", Проведение = Неопределено, КомментарийСинхронизируемый = "") Экспорт
	
	Ошибки = Новый Массив;
	
	Если ПустаяСтрока(ИдентификаторРеализации) Тогда
		
		ДанныеСинхронизацииРеализации = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Реализация,
			"СинхронизацияРеализаций_ат");
		Если ДанныеСинхронизацииРеализации = Неопределено Тогда
			ИдентификаторРеализации = Неопределено;
		Иначе
			ИдентификаторРеализации = ДанныеСинхронизацииРеализации.Идентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСинхронизацииОрганизации = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Реализация.Организация,
		"СинхронизацияОрганизаций_ат");
	Если ДанныеСинхронизацииОрганизации = Неопределено Тогда
		Ошибки.Добавить("Организация указанная в Реализации не синхронизированна с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	ДанныеСинхронизацииКонтрагента = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Реализация.Клиент,
		"СинхронизацияКонтрагентов_ат");
	Если ДанныеСинхронизацииКонтрагента = Неопределено Тогда
		Ошибки.Добавить("Контрагент указанный в Реализации не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	Если Реализация.СчетаНаОплату.Количество() = 1 Тогда
		
		ОтсутствуетСчет = Ложь;
		
		ДанныеСинхронизацииСчета = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Реализация.СчетаНаОплату[0].СчетНаОплату,
			"СинхронизацияСчетовНаОплату_ат");
		Если ДанныеСинхронизацииСчета = Неопределено Тогда
			ИдентификаторСчета = Неопределено;
		Иначе
			ИдентификаторСчета = ДанныеСинхронизацииСчета.Идентификатор;
		КонецЕсли;
		
	Иначе
		
		ОтсутствуетСчет = Истина;
		ИдентификаторСчета = Неопределено;
		
	КонецЕсли;
	
	Если Константы.СоздаватьДоговорДляКаждогоСчета_ат.Получить() Тогда
		
		Если ОтсутствуетСчет = Неопределено Тогда
			Ошибки.Добавить("В Реализации не указан Счёт!");
		ИначеЕсли ИдентификаторСчета = Неопределено Тогда
			Ошибки.Добавить("Счёт указанный в Реализации не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
		КонецЕсли;
		
		ИдентификаторДоговора = Неопределено;
		
	Иначе
		
		Договор = ?(Реализация.Договор.Родитель.Пустая(), Реализация.Договор, Реализация.Договор.Родитель); // В БП всегда передаём головной договор.
		
		ДанныеСинхронизацииДоговора = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Договор,
			"СинхронизацияДоговоров_ат");
		Если ДанныеСинхронизацииДоговора = Неопределено Тогда
			
			ПредставлениеДоговора = ?(Реализация.Договор.Родитель.Пустая(), "Договор", "Родительский договор");
			Ошибки.Добавить(ПредставлениеДоговора + " в Реализации не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
			
		Иначе
			
			ИдентификаторДоговора = ДанныеСинхронизацииДоговора.Идентификатор;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СоответствиеУслугДаннымСинхронизации = ПолучитьСоответствиеСтруктурДанныхСинхронизацииСсылкам(
		Реализация.Услуги.ВыгрузитьКолонку("Номенклатура"), "СинхронизацияНоменклатуры_ат");
	
	Для каждого КлючИЗначение Из СоответствиеУслугДаннымСинхронизации Цикл
		
		Если КлючИЗначение.Значение = Неопределено Тогда
			Ошибки.Добавить("Услуга """ + КлючИЗначение.Ключ + """ не синхронизированна с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
		КонецЕсли;
		
	КонецЦикла;
	
	СинхронизируемыйКомментарий = Реализация.ВнешнийНомер + " | " + КомментарийСинхронизируемый;
	
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	СтруктураСинхронизации = ПолучитьСтруктуруСинхронизацииСИБ(ИБ, Ошибки);
	
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	Если Реализация.Основания.Количество() > 0 Тогда //TODO: сделать опциональным
		
		Если Не ПустаяСтрока(КомментарийСинхронизируемый) Тогда
			СинхронизируемыйКомментарий = СинхронизируемыйКомментарий + " ";
		КонецЕсли;
		
		СинхронизируемыйКомментарий = СинхронизируемыйКомментарий + "#!# Данные для реализации основаны на следующих документах: ";
		
		Для Каждого Основание Из Реализация.Основания Цикл
			СинхронизируемыйКомментарий = СинхронизируемыйКомментарий + " " + Строка(Основание.Основание) + ", ";
		КонецЦикла;
		
		Если Прав(СинхронизируемыйКомментарий, 2) = ", " Тогда
			СинхронизируемыйКомментарий = Строки_КлиентСервер_ат.ВернутьОбрезаннуюСтроку(СинхронизируемыйКомментарий, 2);
		КонецЕсли;
		
		СинхронизируемыйКомментарий = СинхронизируемыйКомментарий + " #!#";
		
	КонецЕсли;
	
	Услуги = СформироватьМассивУслугДляПередачи(СтруктураСинхронизации.Подключение, Реализация.Услуги, СоответствиеУслугДаннымСинхронизации);
	
	Если Проведение = Неопределено Тогда
		Проведение = Реализация.Проведен;
	КонецЕсли;
	
	РезультатСинхронизации = СтруктураСинхронизации.МодульВзаимодействия.СинхронизироватьРеализацию(ИдентификаторРеализации,
		Проведение, Реализация.Дата, ДанныеСинхронизацииОрганизации.Идентификатор, ДанныеСинхронизацииКонтрагента.Идентификатор,
		Услуги, ИдентификаторДоговора, ИдентификаторСчета, СинхронизируемыйКомментарий);
	
	Возврат РезультатСинхронизации;
	
КонецФункции

Функция   СинхронизироватьНоменклатуру(Номенклатура, ИБ, ИдентификаторНоменклатуры = "" , СоздаватьНовый = Истина) Экспорт
	
	Ошибки = Новый Массив;
	
	Если ПустаяСтрока(ИдентификаторНоменклатуры) Тогда
		
		ДанныеСинхронизацииНоменклатуры = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Номенклатура,
			"СинхронизацияНоменклатуры_ат");
		Если ДанныеСинхронизацииНоменклатуры = Неопределено Тогда
			
			Если НЕ СоздаватьНовый Тогда
				Возврат Новый Структура("Ошибки", Ошибки);
			КонецЕсли;
			
			ИдентификаторНоменклатуры = Неопределено;
			
		Иначе
			
			ИдентификаторНоменклатуры = ДанныеСинхронизацииНоменклатуры.Идентификатор;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСинхронизацииВидаНоменклатуры = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Номенклатура.ВидНоменклатуры,
		"СинхронизацияВидовНоменклатуры_ат");
	Если ДанныеСинхронизацииВидаНоменклатуры = Неопределено Тогда
		Ошибки.Добавить("Вид номенклатуры указанный в Номенклатуре не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	ДанныеСинхронизацииЕдиницыИзмерения = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Номенклатура.ЕдиницаИзмерения,
		"СинхронизацияЕдиницИзмерения_ат");
	Если ДанныеСинхронизацииЕдиницыИзмерения = Неопределено Тогда
		Ошибки.Добавить("Единица измерения указанная в Номенклатуре не синхронизирована с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	Если Номенклатура.НоменклатурнаяГруппа.Пустая() Тогда
		
		ИдентификаторНоменклатурнойГруппы = Неопределено;
		
	Иначе
		
		ДанныеСинхронизацииНоменклатурнойГруппы = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Номенклатура.НоменклатурнаяГруппа,
			"СинхронизацияНоменклатурныхГрупп_ат");
		Если ДанныеСинхронизацииНоменклатурнойГруппы = Неопределено Тогда
			Ошибки.Добавить("Номенклатурная группа указанная в Номенклатуре не синхронизирована с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
		Иначе
			ИдентификаторНоменклатурнойГруппы = ДанныеСинхронизацииНоменклатурнойГруппы.Идентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Номенклатура.СтатьяЗатрат.Пустая() Тогда
		
		ИдентификаторСтатьиЗатарат = Неопределено;
		
	Иначе
		
		ДанныеСинхронизацииСтатьиЗатарат = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Номенклатура.СтатьяЗатрат,
			"СинхронизацияСтатейЗатрат_ат");
		
		Если ДанныеСинхронизацииСтатьиЗатарат = Неопределено Тогда
			Ошибки.Добавить("Статья затрат указанная в Номенклатуре не синхронизирована с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
		Иначе
			ИдентификаторСтатьиЗатарат = ДанныеСинхронизацииСтатьиЗатарат.Идентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	СтруктуреСинхронизации = ПолучитьСтруктуруСинхронизацииСИБ(ИБ, Ошибки);
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	РезультатСинхронизации = СтруктуреСинхронизации.МодульВзаимодействия.СинхронизироватьНоменклатуру(
		ИдентификаторНоменклатуры, Номенклатура.ПометкаУдаления, Номенклатура.Наименование, Номенклатура.НаименованиеПолное,
		Номенклатура.Артикул, ДанныеСинхронизацииВидаНоменклатуры.Идентификатор, ДанныеСинхронизацииЕдиницыИзмерения.Идентификатор,
		XMLСтрока(Номенклатура.СтавкаНДС), ИдентификаторНоменклатурнойГруппы, ИдентификаторСтатьиЗатарат);
	
	Возврат РезультатСинхронизации;
	
КонецФункции

Функция   СинхронизироватьДоговорСКонтрагентом(Договор, ИБ, ИдентификаторДоговора = "" , СоздаватьНовый = Истина) Экспорт
	
	Ошибки = Новый Массив;
	
	Если ПустаяСтрока(ИдентификаторДоговора) Тогда
		
		ДанныеСинхронизацииДоговора = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Договор,
			"СинхронизацияДоговоров_ат");
		Если ДанныеСинхронизацииДоговора = Неопределено Тогда
			
			Если НЕ СоздаватьНовый Тогда
				Возврат Новый Структура("Ошибки", Ошибки);
			КонецЕсли;
			
			ИдентификаторДоговора = Неопределено;
			
		Иначе
			
			ИдентификаторДоговора = ДанныеСинхронизацииДоговора.Идентификатор;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСинхронизацииОрганизации = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Договор.Организация,
		 "СинхронизацияОрганизаций_ат");
	Если ДанныеСинхронизацииОрганизации = Неопределено Тогда
		Ошибки.Добавить("Организация указанная в Договоре не синхронизированна с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	ДанныеСинхронизацииКонтрагента = ПолучитьСтруктуруДанныхСинхронизацииДляСсылки(Договор.Владелец,
		"СинхронизацияКонтрагентов_ат");
	Если ДанныеСинхронизацииКонтрагента = Неопределено Тогда
		Ошибки.Добавить("Контрагент указанный в Договоре не синхронизирован с выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!");
	КонецЕсли;
	
	ТекстОшибки = "";
	
	КомментарийСинхронизируемый = Комментарии_ат.ПолучитьКомментарийПоВиду(Договор, "КомментарийСинхронизируемый", , ТекстОшибки, Ложь);
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		Ошибки.Добавить(ТекстОшибки);
	КонецЕсли;
	
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	СтруктураСинхронизации = ПолучитьСтруктуруСинхронизацииСИБ(ИБ, Ошибки);
	
	Если Ошибки.Количество() > 0 Тогда
		Возврат Новый Структура("Ошибки", Ошибки);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Договор.НомерДоговора) Тогда
		
		НомерДоговора = "б/н";
		
	ИначеЕсли Договор.Родитель.Пустая() Тогда
		
		НомерДоговора = Строка(Договор.НомерДоговора) + Договор.ПостфиксНомера;
		
	Иначе
		
		НомерДоговора = Строка(Договор.Родитель.НомерДоговора) + Договор.Родитель.ПостфиксНомера + "_" + Договор.НомерДоговора;
		
	КонецЕсли;
	
	СрокДействияДоговора = ?(ЗначениеЗаполнено(Договор.ДатаРасторжения), Договор.ДатаРасторжения, Договор.СрокДоговора);
	
	РезультатСинхронизации = СтруктураСинхронизации.МодульВзаимодействия.СинхронизироватьДоговорКонтрагента(
		ИдентификаторДоговора, Договор.ПометкаУдаления, ДанныеСинхронизацииОрганизации.Идентификатор,
		ДанныеСинхронизацииКонтрагента.Идентификатор, XMLСтрока(Договор.РодДоговора), НомерДоговора,
		Договор.НаименованиеПолное, Договор.ДатаНачала, СрокДействияДоговора, КомментарийСинхронизируемый,
		ПолучитьИмяГруппыСинхронизируемыхДоговоров());
	
	Возврат РезультатСинхронизации;
	
КонецФункции

#КонецОбласти

#Область  СлужебныеПроцедурыИФункции

Функция   СформироватьМассивУслугДляПередачи(Подключение, Услуги, СоответствиеУслугДаннымСинхронизации)
	
	МассивУслуг = Подключение.NewObject("Массив");
		
	Для Каждого СтрокаУслуги Из Услуги Цикл
		
		СтруктураУслуги = Подключение.NewObject("Структура");
		
		СтруктураУслуги.Вставить("ИдентификаторНоменклатуры", СоответствиеУслугДаннымСинхронизации[СтрокаУслуги.Номенклатура].Идентификатор);
		СтруктураУслуги.Вставить("СтавкаНДС", XMLСтрока(СтрокаУслуги.СтавкаНДС));
		СтруктураУслуги.Вставить("Содержание", СтрокаУслуги.Содержание);
		СтруктураУслуги.Вставить("Количество", СтрокаУслуги.Количество);
		СтруктураУслуги.Вставить("Цена", СтрокаУслуги.Цена);
		СтруктураУслуги.Вставить("Сумма", СтрокаУслуги.Сумма);
		СтруктураУслуги.Вставить("СуммаНДС", СтрокаУслуги.СуммаНДС);
		
		МассивУслуг.Добавить(СтруктураУслуги);
		
	КонецЦикла;
	
	Возврат МассивУслуг;
	
КонецФункции

Функция   ПолучитьИмяГруппыСинхронизируемыхДоговоров()
	
	Возврат Метаданные.Справочники.Договоры_ат.Синоним + " " + Метаданные.Синоним;
	
КонецФункции 

#КонецОбласти
