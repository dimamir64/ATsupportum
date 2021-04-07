////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки", процедуры и функции специфичные
// для использования подсистемы в автономном рабочем месте
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОтправкеДанныхГлавному"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОтправкеДанныхПодчиненному"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииДанныхОтГлавного"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииДанныхОтПодчиненного"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииОбязательныхОбъектовПланаОбмена"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииОбъектовИсключенийПланаОбмена"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииОбъектовНачальногоОбразаПланаОбмена"].Добавить(
			"ДополнительныеОтчетыИОбработкиВАвтономномРежиме");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Процедура является обработчиком одноименного события, возникающего при обмене данными в распределенной информационной базе.
//
// Параметры:
// см. описание обработчика события ПриОтправкеДанныхГлавному() в синтаксис-помощнике.
// 
Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента, Получатель) Экспорт
	
	Если ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать Тогда
		//
	ИначеЕсли АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ДополнительныеОтчетыИОбработки") Тогда
			
			Если Не ЭтоОбработкаСервиса(ЭлементДанных.Ссылка) Тогда
				ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура является обработчиком одноименного события, возникающего при обмене данными в распределенной информационной базе.
//
// Параметры:
// см. описание обработчика события ПриОтправкеДанныхПодчиненному() в синтаксис-помощнике.
// 
Процедура ПриОтправкеДанныхПодчиненному(ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза, Получатель) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтправкаЭлемента = ОтправкаЭлементаДанных.Удалить
		ИЛИ ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать Тогда
		
		// Стандартную обработку не переопределяем
		
	Иначе
		
		Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ДополнительныеОтчетыИОбработки") Тогда
			
			Если ДополнительныеОтчетыИОбработкиВМоделиСервиса.ЭтоПоставляемаяОбработка(ЭлементДанных.Ссылка) Тогда
				
				ПараметрыЗапускаОбработки = ДополнительныеОтчетыИОбработки.ОпределитьПараметрыЗапуска(ЭлементДанных.Ссылка);
				ЗаполнитьЗначенияСвойств(ЭлементДанных, ПараметрыЗапускаОбработки);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТипЗнч(ЭлементДанных) = Тип("КонстантаМенеджерЗначения.ИспользоватьДополнительныеОтчетыИОбработки") Тогда
			
			Если Не СозданиеНачальногоОбраза Тогда
				ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура является обработчиком одноименного события, возникающего при обмене данными в распределенной информационной базе.
//
// Параметры:
// см. описание обработчика события ПриПолученииДанныхОтГлавного() в синтаксис-помощнике.
// 
Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Отправитель) Экспорт
	
	Если ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать Тогда
		
		// Стандартную обработку не переопределяем
		
	ИначеЕсли АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ДополнительныеОтчетыИОбработки") Тогда
			
			Если ЗначениеЗаполнено(ЭлементДанных.Ссылка) Тогда
				СсылкаОбработки = ЭлементДанных.Ссылка;
			Иначе
				СсылкаОбработки = ЭлементДанных.ПолучитьСсылкуНового();
			КонецЕсли;
			
			ЗарегистрироватьОбработкуСервиса(СсылкаОбработки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура является обработчиком одноименного события, возникающего при обмене данными в распределенной информационной базе.
//
// Параметры:
// см. описание обработчика события ПриПолученииДанныхОтПодчиненного() в синтаксис-помощнике.
// 
Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Отправитель) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать Тогда
		
		// Стандартную обработку не переопределяем
		
	Иначе
		
		Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ДополнительныеОтчетыИОбработки") Тогда
			
			Если ДополнительныеОтчетыИОбработкиВМоделиСервиса.ЭтоПоставляемаяОбработка(ЭлементДанных.Ссылка) Тогда
				
				ПараметрыЗапускаОбработки = ДополнительныеОтчетыИОбработки.ОпределитьПараметрыЗапуска(ЭлементДанных.Ссылка);
				ЗаполнитьЗначенияСвойств(ЭлементДанных, ПараметрыЗапускаОбработки);
				ЭлементДанных.ХранилищеОбработки = Неопределено;
				
			Иначе
				
				Если Не Константы.НезависимоеИспользованиеДополнительныхОтчетовИОбработокВМоделиСервиса.Получить() Тогда
					ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Используется для получения объектов метаданных обязательных для плана обмена.
// Если подсистема имеет объекты метаданных обязательные для включения в состав плана обмена,
// то в параметр <Объект> необходимо добавить эти объекты метаданных.
//
// Параметры:
// Объекты – Массив. Массив объектов метаданных конфигурации, которые необходимо включить в состав плана обмена.
// РаспределеннаяИнформационнаяБаза (только чтение) – Булево. Признак получения объектов для плана обмена РИБ.
// Истина – требуется получить список объектов плана обмена РИБ;
// Ложь – требуется получить список для плана обмена НЕ РИБ.
//
Процедура ПриПолученииОбязательныхОбъектовПланаОбмена(Объекты, Знач РаспределеннаяИнформационнаяБаза) Экспорт
	
	Если РаспределеннаяИнформационнаяБаза Тогда
		
		Объекты.Добавить(Метаданные.Справочники.ДополнительныеОтчетыИОбработки);
		Объекты.Добавить(Метаданные.РегистрыСведений.НазначениеДополнительныхОбработок);
		Объекты.Добавить(Метаданные.РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам);
		
	КонецЕсли;
	
КонецПроцедуры

// Используется для получения объектов метаданных, которые не следует включать в состав плана обмена.
// Если подсистема имеет объекты метаданных, которые не следует включать в состав плана обмена,
// то в параметр <Объект> необходимо добавить эти объекты метаданных.
//
// Параметры:
// Объекты – Массив. Массив объектов метаданных конфигурации, которые не следует включать в состав плана обмена.
// РаспределеннаяИнформационнаяБаза (только чтение) – Булево. Признак получения объектов для плана обмена РИБ.
// Истина – требуется получить список объектов-исключений плана обмена РИБ;
// Ложь – требуется получить список для плана обмена НЕ РИБ.
//
Процедура ПриПолученииОбъектовИсключенийПланаОбмена(Объекты, Знач РаспределеннаяИнформационнаяБаза) Экспорт
	
	Если РаспределеннаяИнформационнаяБаза Тогда
		
		Объекты.Добавить(Метаданные.Константы.ИспользованиеКаталогаДополнительныхОтчетовИОбработокВМоделиСервиса);
		Объекты.Добавить(Метаданные.Константы.МинимальныйИнтервалРегламентныхЗаданийДополнительныхОтчетовИОбработокВМоделиСервиса);
		Объекты.Добавить(Метаданные.Константы.НезависимоеИспользованиеДополнительныхОтчетовИОбработокВМоделиСервиса);
		Объекты.Добавить(Метаданные.Константы.РазрешитьВыполнениеДополнительныхОтчетовИОбработокРегламентнымиЗаданиямиВМоделиСервиса);
		
		Объекты.Добавить(Метаданные.Справочники.ПоставляемыеДополнительныеОтчетыИОбработки);
		
		Объекты.Добавить(Метаданные.РегистрыСведений.ИспользованиеДополнительныхОтчетовИОбработокСервисаВАвтономномРабочемМесте);
		Объекты.Добавить(Метаданные.РегистрыСведений.ИспользованиеПоставляемыхДополнительныхОтчетовИОбработокВОбластяхДанных);
		Объекты.Добавить(Метаданные.РегистрыСведений.ОчередьИнсталляцииПоставляемыхДополнительныхОтчетовИОбработокВОбластиДанных);
		
	КонецЕсли;
	
КонецПроцедуры

// Используется для получения объектов метаданных, которые должны входить в состав плана обмена
// и НЕ должны входить в состав подписок на события регистрации изменений для этого плана обмена.
// Эти объекты метаданных используются только в момент создания начального образа подчиненного узла
// и не мигрируют в процессе обмена.
// Если подсистема имеет объекты метаданных, которые участвуют только в создании начального образа подчиненного узла,
// то в параметр <Объект> необходимо добавить эти объекты метаданных.
//
// Параметры:
// Объекты – Массив. Массив объектов метаданных конфигурации.
//
Процедура ПриПолученииОбъектовНачальногоОбразаПланаОбмена(Объекты) Экспорт
	
	Объекты.Добавить(Метаданные.Константы.ИспользоватьДополнительныеОтчетыИОбработки);
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.5.2";
	Обработчик.Процедура = "ДополнительныеОтчетыИОбработкиВАвтономномРежиме.ЗарегистрироватьИзмененияПриОбновлении";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов

// Вызывается при определении наличия у текущего пользователя права на добавление дополнительного
// отчета или обработки в область данных.
//
// Параметры:
//  ДополнительнаяОбработка - СправочникОбъект.ДополнительныеОтчетыИОбработки, элемент справочника,
//    который записывается пользователем.
//  Результат - Булево, в этот параметр в данной процедуре устанавливается флаг наличия права,
//  СтандартнаяОбработка - Булево, в этот параметр в данной процедуре устанавливается флаг выполнения
//    стандартной обработки проверки права.
//
Процедура ПриПроверкеПраваДобавления(Знач ДополнительнаяОбработка = Неопределено, Результат, СтандартнаяОбработка) Экспорт
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		Результат = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при проверке возможности загрузки дополнительного отчета или обработки из файла
//
// Параметры:
//  ДополнительнаяОбработка - СправочникСсылка.ДополнительныеОтчетыИОбработки,
//  Результат - Булево, в этот параметр в данной процедуре устанавливается флаг наличия возможности
//    загрузки дополнительного отчета или обработки из файла,
//  СтандартнаяОбработка - Булево, в этот параметр в данной процедуре устанавливается флаг выполнения
//    стандартной обработки проверки возможности загрузки дополнительного отчета или обработки из файла.
//
Процедура ПриПроверкеВозможностиЗагрузкиОбработкиИзФайла(Знач ДополнительнаяОбработка, Результат, СтандартнаяОбработка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		Результат = Не ЭтоОбработкаСервиса(ДополнительнаяОбработка);
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при проверке возможности выгрузки дополнительного отчета или обработки в файл
//
// Параметры:
//  ДополнительнаяОбработка - СправочникСсылка.ДополнительныеОтчетыИОбработки,
//  Результат - Булево, в этот параметр в данной процедуре устанавливается флаг наличия возможности
//    выгрузки дополнительного отчета или обработки в файл,
//  СтандартнаяОбработка - Булево, в этот параметр в данной процедуре устанавливается флаг выполнения
//    стандартной обработки проверки возможности выгрузки дополнительного отчета или обработки в файл.
//
Процедура ПриПроверкеВозможностиВыгрузкиОбработкиВФайл(Знач ДополнительнаяОбработка, Результат, СтандартнаяОбработка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		Результат = Не ЭтоОбработкаСервиса(ДополнительнаяОбработка);
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при проверке необходимости отображения расширенной информации о дополнительных
// отчетах и обработках в пользовательском интерфейсе.
//
// Параметры:
//  ДополнительнаяОбработка - СправочникСсылка.ДополнительныеОтчетыИОбработки,
//  Результат - Булево, в этот параметр в данной процедуре устанавливается флаг наличия необходимости
//    отображения расширенной информации о дополнительных отчетах и обработках в пользовательском
//    интерфейсе.
//  СтандартнаяОбработка - Булево, в этот параметр в данной процедуре устанавливается флаг выполнения
//    стандартной обработки проверки наличия необходимости отображения расширенной информации о
//    дополнительных отчетах и обработках в пользовательском интерфейсе.
//
Процедура ПриПроверкеНеобходимостиОтображенияРасширеннойИнформации(Знач ДополнительнаяОбработка, Результат, СтандартнаяОбработка) Экспорт
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		Результат = Не ЭтоОбработкаСервиса(ДополнительнаяОбработка);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает виды публикации дополнительных отчетов и обработок, недоступные для использования
// в текущей модели информационной базы.
//
Функция НедоступныеВидыПубликации() Экспорт
	
	Результат = Новый Массив;
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		Результат.Добавить("РежимОтладки");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Вызывается при определении параметров запуска для дополнительного отчета или обработки.
//
Функция ОпределениеПараметровЗапуска(Ссылка, Результат, СтандартнаяОбработка) Экспорт
	
	
	
КонецФункции

// Вызывается при получении регистрационных данных для нового дополнительного отчета
// или обработки.
//
Процедура ПриПолученииРегистрационныхДанных(Объект, РегистрационныеДанные, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при проверке возможности выполнения дополнительного отчета или обработки.
//
Процедура ПроверитьВозможностьВыполнения(Ссылка) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при формировании текста запроса формы списка справочника ДополнительныеОтчетыИОбработки.
//
// Параметры:
//  ТекстЗапроса - Строка, текст запроса.
//
Процедура ПриДополненииТекстаЗапросаФормыСпискаДополнительныхОтчетовИОбработок(ТекстЗапроса) Экспорт
	
	Если АвтономнаяРаботаСлужебный.АвтономнаяРаботаПоддерживается() И АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЛОЖЬ КАК ФлагПредопределенного", "ЕСТЬNULL(ИспользованиеВАРМ.Поставляемый, Ложь) КАК ФлагПредопределенного");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.ДополнительныеОтчетыИОбработки КАК Таблица", "Справочник.ДополнительныеОтчетыИОбработки КАК Таблица ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИспользованиеДополнительныхОтчетовИОбработокСервисаВАвтономномРабочемМесте КАК ИспользованиеВАРМ ПО Таблица.Ссылка = ИспользованиеВАРМ.ДополнительныйОтчетИлиОбработка");
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура должна вызываться из события ПередУдалением справочника
//  ДополнительныеОтчетыИОбработки.
//
// Параметры:
//  Источник - СправочникОбъект.ДополнительныеОтчетыИОбработки,
//  Отказ - булево, флаг отказа от выполнения удаления элемента справочника из информационной базы.
//
Процедура ПередУдалениемДополнительнойОбработки(Источник, Отказ) Экспорт
	
	
	
КонецПроцедуры

// Процедура должна вызываться из события ПередЗаписью справочника
//  ДополнительныеОтчетыИОбработки, выполняет проверку правомерности изменения реквизитов
//  элементов данного справочника для дополнительных обработок, полученных из
//  каталога дополнительных обработок менеджера сервиса.
//
// Параметры:
//  Источник - СправочникОбъект.ДополнительныеОтчетыИОбработки,
//  Отказ - булево, флаг отказа от выполнения записи элемента справочника.
//
Процедура ПередЗаписьюДополнительнойОбработки(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		
		Если (Источник.ПометкаУдаления ИЛИ Источник.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена) И ЭтоОбработкаСервиса(Источник.Ссылка) Тогда
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дополнительный отчет или обработка %1 был загружен из сервиса и не может быть отключен из автономного рабочего места!
                      |Для удаления дополнительного отчета или обработки необходимо выполнить операцию отключения в
                      |приложении сервиса и провести синхронизацию данных автономного рабочего места с сервисом.'"),
				Источник.Наименование);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления ИБ.

// Выполняет начальную регистрацию изменений в объектах подсистемы ДополнительныеОтчетыИОбработки
// при обновлении на новую версию БСП.
//
Функция ЗарегистрироватьИзмененияПриОбновлении() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбменДаннымиПовтИсп.АвтономнаяРаботаПоддерживается() Тогда
		
		ПланОбменаАРМ = АвтономнаяРаботаСлужебный.ПланОбменаАвтономнойРаботы();
		УзелСервиса = ПланыОбмена[ПланОбменаАРМ].ЭтотУзел();
		
		УзлыАРМ = Новый Массив();
		ВыборкаУзлов = ПланыОбмена[ПланОбменаАРМ].Выбрать();
		Пока ВыборкаУзлов.Следующий() Цикл
			Если ВыборкаУзлов.Ссылка <> УзелСервиса Тогда
				УзлыАРМ.Добавить(ВыборкаУзлов.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыАРМ, Метаданные.Справочники.ДополнительныеОтчетыИОбработки);
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыАРМ, Метаданные.РегистрыСведений.НазначениеДополнительныхОбработок);
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыАРМ, Метаданные.РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам);
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыАРМ, Метаданные.Константы.ИспользоватьДополнительныеОтчетыИОбработки);
		
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Регистрирует дополнительный отчет иди обработку в качестве обработки, полученной
// в автономное рабочее место из сервиса.
//
// Параметры:
//  Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки.
//
Процедура ЗарегистрироватьОбработкуСервиса(Знач Ссылка)
	
	Набор = РегистрыСведений.ИспользованиеДополнительныхОтчетовИОбработокСервисаВАвтономномРабочемМесте.СоздатьНаборЗаписей();
	Набор.Отбор.ДополнительныйОтчетИлиОбработка.Установить(Ссылка);
	Запись = Набор.Добавить();
	Запись.ДополнительныйОтчетИлиОбработка = Ссылка;
	Запись.Поставляемый = Истина;
	Набор.Записать();
	
КонецПроцедуры

// Функция проверяет, была ли дополнительная обработка получена в автономное рабочее место из сервиса.
//
// Параметры:
// Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки.
//
// Возвращаемое значение:
//  Булево.
//
Функция ЭтоОбработкаСервиса(Ссылка)
	
	Менеджер = РегистрыСведений.ИспользованиеДополнительныхОтчетовИОбработокСервисаВАвтономномРабочемМесте.СоздатьМенеджерЗаписи();
	Менеджер.ДополнительныйОтчетИлиОбработка = Ссылка;
	Менеджер.Прочитать();
	
	Если Менеджер.Выбран() Тогда
		Возврат Менеджер.Поставляемый;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции