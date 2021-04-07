////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Проверяет наличие обновления конфигурации при запуске программы.
//
Процедура ПроверитьОбновлениеКонфигурации() Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Возврат;
	КонецЕсли;
	
#Если НЕ ВебКлиент Тогда
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.РазделениеВключено Или Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	ДоступноеОбновлениеКонфигурации = Неопределено;
	НастройкиОбновления = ПараметрыРаботыКлиента.НастройкиОбновления;
	НаличиеОбновления = НастройкиОбновления.ПроверитьПрошлыеОбновленияБазы;
	
	Если НаличиеОбновления Тогда
		// Надо завершить предыдущее обновление.
		ОткрытьФорму("Обработка.ОбновлениеКонфигурации.Форма.Форма");
		Возврат;
	КонецЕсли;
	
	Если НЕ НаличиеОбновления И НастройкиОбновления.ЕстьДоступДляОбновления Тогда
		НаличиеОбновления = НастройкиОбновления.КонфигурацияИзменена;
	КонецЕсли;
	
	НаименованиеСтраницыДоступногоОбновления	= "ДоступноеОбновление";
	НаименованиеСтраницыФайлОбновления			= "ФайлОбновления";
	ЕстьДоступноеОбновлениеВИнтернете			= Ложь;
	НастройкиОбновленияКонфигурации				= НастройкиОбновления.НастройкиОбновленияКонфигурации;
	
	Если НЕ НаличиеОбновления И НастройкиОбновленияКонфигурации <> Неопределено
		И НастройкиОбновления.ЕстьДоступДляПроверкиОбновления И
		(НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = 1 ИЛИ
		 НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = 2) Тогда
		 
		// Подключение обработчика ожидания для проверки наличия обновления в сети Интернет.
		Если НастройкиОбновленияКонфигурации <> Неопределено Тогда
			Если НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = 1  
				И НастройкиОбновленияКонфигурации.РасписаниеПроверкиНаличияОбновления <> Неопределено Тогда
				ПодключитьОтключитьПроверкуПоРасписанию(Истина);
			КонецЕсли;
		КонецЕсли;
		
		Параметры = ПолучитьДоступноеОбновлениеКонфигурации();
		// Если расписание не задано, то проверяем наличие обновления сейчас.
		Если НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске = 2 Тогда
			ПроверитьНаличиеОбновленияЧерезИнтернет();
			ЕстьДоступноеОбновлениеВИнтернете = НастройкиОбновленияКонфигурации.ИсточникОбновления <> -1 
				И Параметры.ИмяСтраницы = НаименованиеСтраницыДоступногоОбновления;
			Если НЕ НаличиеОбновления И ЕстьДоступноеОбновлениеВИнтернете Тогда
				НаличиеОбновления = ЕстьДоступноеОбновлениеВИнтернете;
			КонецЕсли;
		КонецЕсли;
		Если Не НаличиеОбновления Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НастройкиОбновления.КонфигурацияИзменена И НастройкиОбновления.ЕстьДоступДляПроверкиОбновления Тогда
		Настройки = ОбновлениеКонфигурацииКлиентСервер.ПолучитьОбновленныеНастройкиОбновленияКонфигурации(НастройкиОбновленияКонфигурации);
		Настройки.ИсточникОбновления	= 2;  // локальный или сетевой каталог
		Настройки.НуженФайлОбновления	= Ложь;
		ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации);
		
		Параметры = ПолучитьДоступноеОбновлениеКонфигурации();
		Параметры.ИсточникОбновления = НастройкиОбновленияКонфигурации.ИсточникОбновления;
		Параметры.НуженФайлОбновления = НастройкиОбновленияКонфигурации.НуженФайлОбновления;
		Параметры.ФлагАвтоПереходаНаСтраницуСОбновлением = Истина;
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление конфигурации'"),
			"e1cib/app/Обработка.ОбновлениеКонфигурации",
			НСтр("ru = 'Конфигурация отличается от основной конфигурации информационной базы.'"), 
			БиблиотекаКартинок.Информация32);
		Возврат;
	КонецЕсли;	
	
	Если ЕстьДоступноеОбновлениеВИнтернете И НастройкиОбновления.ЕстьДоступДляПроверкиОбновления Тогда
		Настройки = ОбновлениеКонфигурацииКлиентСервер.ПолучитьОбновленныеНастройкиОбновленияКонфигурации(НастройкиОбновленияКонфигурации);
		Настройки.ИсточникОбновления	= 0;  // Интернет
		ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации);
		
		Параметры = ПолучитьДоступноеОбновлениеКонфигурации();
		Параметры.ИсточникОбновления = НастройкиОбновленияКонфигурации.ИсточникОбновления;
		Параметры.НуженФайлОбновления = НастройкиОбновленияКонфигурации.НуженФайлОбновления;
		Параметры.ФлагАвтоПереходаНаСтраницуСОбновлением = Истина;
		ПоказатьОповещениеПользователя(НСтр("ru = 'Доступно обновление конфигурации'"),
			"e1cib/app/Обработка.ОбновлениеКонфигурации",
			НСтр("ru = 'Версия:'") + " " + Параметры.ПараметрыФайлаПроверкиОбновления.Version, 
			БиблиотекаКартинок.Информация32);
		Возврат;	
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему

// Обновляет конфигурацию базы данных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - если в процедуре установить данному параметру значение Ложь, то инструкция по
//                                  "ручному" обновлению показана не будет.
Процедура ПриВыполненииОбновленияИнформационнойБазы(СтандартнаяОбработка, ЗавершениеРаботыСистемы = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗавершениеРаботыСистемы Тогда
		ПараметрыФормы = Новый Структура("ЗавершениеРаботыСистемы, ПолученоОбновлениеКонфигурации", Истина, Истина);
		ОткрытьФормуМодально("Обработка.ОбновлениеКонфигурации.Форма.Форма", ПараметрыФормы);
	Иначе
		ОткрытьФорму("Обработка.ОбновлениеКонфигурации.Форма.Форма");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает общие параметры обновления.
//
Функция ПолучитьПараметрыОбновления(ПроверитьОбновленияДля83 = Ложь) Экспорт
	#Если НЕ ВебКлиент Тогда
		
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ДатаВремяОбновленияУстановлена"	, Ложь);
	
	// Интернет
	СтруктураПараметров.Вставить("ИмяZipФайлаСпискаШаблонов"		, "v8upd11.zip");
	СтруктураПараметров.Вставить("ИмяФайлаСпискаШаблонов"			, "v8cscdsc.xml");
	СтруктураПараметров.Вставить("ИмяФайлаОписанияОбновления"		, "news.htm");
	СтруктураПараметров.Вставить("ИмяФайлаПорядкаОбновления"		, "update.htm");

	// Имена служебных файлов
	СтруктураПараметров.Вставить("ИмяИсполняемогоФайлаКонфигуратора",	"1cv8.exe");
	СтруктураПараметров.Вставить("ИмяИсполняемогоФайлаКлиента",			СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИмяИсполняемогоФайлаКлиента);
	
	СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации"		, НСтр("ru = 'Обновление информационной базы'"));
	
	// Определение каталога временных файлов.
	СтруктураПараметров.Вставить("КаталогФайловОбновления"			, КаталогLocalAppData() + "1C\1Cv8Update\"); 
	КаталогВременныхФайловОбновления = КаталогВременныхФайлов() + "1Cv8Update." + Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДФ=ггММддЧЧммсс") + "\";
	СтруктураПараметров.Вставить("КаталогВременныхФайловОбновления"	, КаталогВременныхФайловОбновления);
	
	СтруктураПараметров.Вставить("АдресРесурсовДляПроверкиНаличияОбновления"						, АдресРесурсовДляПроверкиНаличияОбновления(ПроверитьОбновленияДля83));
	СтруктураПараметров.Вставить("АдресСтраницыИнформацииОПолученииДоступаКПользовательскомуСайту"	, АдресСтраницыИнформацииОПолученииДоступаКПользовательскомуСайту());
	СтруктураПараметров.Вставить("АдресКаталогаШаблоновНаСервереОбновлений"							, АдресКаталогаШаблоновНаСервереОбновлений());
	СтруктураПараметров.Вставить("АдресСервераОбновлений"											, АдресСервераОбновлений());
	СтруктураПараметров.Вставить("ИмяФайлаПроверкиНаличияОбновления"								, ИмяФайлаПроверкиНаличияОбновления());
	
	// ИТС
	СтруктураПараметров.Вставить("ИмяФайлаАдресовРелизовИТС", "AutoUpdate.xml");
	
	Возврат СтруктураПараметров;
	#КонецЕсли
КонецФункции

// Возвращает параметры найденного (доступного) обновления конфигурации.
Функция ПолучитьДоступноеОбновлениеКонфигурации() Экспорт
	
	Если ДоступноеОбновлениеКонфигурации = Неопределено Тогда
		ДоступноеОбновлениеКонфигурации = Новый Структура(
			"ИсточникОбновления,НуженФайлОбновления,ФлагАвтоПереходаНаСтраницуСОбновлением," + 
			"ПараметрыФайлаПроверкиОбновления,ИмяСтраницы,ВремяПолученияОбновления,ПоследняяВерсияКонфигурации",
			-1,   // ИсточникОбновления
			Ложь, // НуженФайлОбновления
			Ложь, // ФлагАвтоПереходаНаСтраницуСОбновлением
			Неопределено, // ПараметрыФайлаПроверкиОбновления
			"",   // ИмяСтраницы
			ОбщегоНазначенияКлиент.ДатаСеанса(), // ВремяПолученияОбновления
			""); // ПоследняяВерсияКонфигурации
	КонецЕсли;
	Возврат ДоступноеОбновлениеКонфигурации;
	
КонецФункции

// Получить адрес страницы на веб-сервере поставщика конфигурации, на которой находится
// информация о доступных обновлениях.
//
// Возвращаемое значение:
//   Строка   – адрес веб-страницы.
//
Функция АдресРесурсовДляПроверкиНаличияОбновления(ПроверитьОбновленияДля83 = Ложь) Экспорт
	НастройкиОбновления = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиОбновления;
	КороткоеИмяКонфигурации = НастройкиОбновления.КороткоеИмяКонфигурации;
	КороткоеИмяКонфигурации = СтрЗаменить(КороткоеИмяКонфигурации, "\", "/");
	Если ПроверитьОбновленияДля83 Тогда
		Количество82 = СтрЧислоВхождений(КороткоеИмяКонфигурации, "82");
		Если Количество82 = 1 Тогда
			КороткоеИмяКонфигурации = СтрЗаменить(КороткоеИмяКонфигурации, "82", "83");
		ИначеЕсли Количество82 > 1 Тогда
			КороткоеИмяКонфигурации = ЗаменитьРелизПлатформы(КороткоеИмяКонфигурации);
		КонецЕсли;
	КонецЕсли;
	Результат = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(НастройкиОбновления.АдресРесурсаДляПроверкиНаличияОбновления) +
		КороткоеИмяКонфигурации + "/";	
	Возврат Результат;
КонецФункции

// Получить адрес веб-страницы с информацией о том, как получить доступ к 
// пользовательскому разделу на сайте поставщика конфигурации.
//
// Возвращаемое значение:
//   Строка   – адрес веб-страницы.
Функция АдресСтраницыИнформацииОПолученииДоступаКПользовательскомуСайту() Экспорт
	
	Значение = "http://users.v8.1c.ru/Rules.aspx";  // Значение по умолчанию
	
	ЗначениеПереопределяемогоМодуля = ОбновлениеКонфигурацииКлиентПереопределяемый.АдресСтраницыИнформацииОПолученииДоступаКПользовательскомуСайту();
	Если НЕ ПустаяСтрока(ЗначениеПереопределяемогоМодуля) Тогда  // Переопределяемое значение
		Значение = ЗначениеПереопределяемогоМодуля;
	КонецЕсли;
	
	Возврат Значение;
КонецФункции

// Получить адрес каталога файлов обновления на сервере обновлений.
//
// Возвращаемое значение:
//   Строка   – адрес каталога на веб-сервере.
//
Функция АдресКаталогаШаблоновНаСервереОбновлений() Экспорт
	
	СерверОбновлений = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиОбновления.КаталогОбновлений;
	
	Если Найти(СерверОбновлений, "ftp://") <> 0 Тогда
		Протокол = "ftp://";
	Иначе
		Протокол = "http://";
	КонецЕсли;
	
	СерверОбновлений = СтрЗаменить(СерверОбновлений, Протокол, "");
	КаталогШаблоновНаСервере = "";
	Позиция = Найти(СерверОбновлений, "/");
	Если Позиция > 0 Тогда
		КаталогШаблоновНаСервере = Сред(СерверОбновлений, Позиция, СтрДлина(СерверОбновлений));
	КонецЕсли;
	Возврат КаталогШаблоновНаСервере;
	
КонецФункции

// Получить адрес сервера обновлений.
//
// Возвращаемое значение:
//   Строка   – адрес веб-сервера.
//
Функция АдресСервераОбновлений() Экспорт
	
	СерверОбновлений = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиОбновления.КаталогОбновлений;
	
	Если Найти(СерверОбновлений, "ftp://") <> 0 Тогда
		Протокол = "ftp://";
	Иначе
		Протокол = "http://";
	КонецЕсли;
	
	СерверОбновлений = СтрЗаменить(СерверОбновлений, Протокол, "");
	Позиция = Найти(СерверОбновлений, "/");
	Если Позиция > 0 Тогда
		СерверОбновлений = Сред(СерверОбновлений, 1, Позиция - 1);
	КонецЕсли;
	
	Возврат Протокол + СерверОбновлений;
	
КонецФункции

// Получить имя файла с информацией о доступном обновлении на сайте поставщика
// конфигурации.
//
// Возвращаемое значение:
//   Строка   – имя файла.
//
Функция ИмяФайлаПроверкиНаличияОбновления() Экспорт
	
	Возврат "UpdInfo.txt";
	
КонецФункции

// Функция, выполняет включение и отключение проверки наличия обновления по расписанию
// 
// Параметры:
// ФлагПодключитьИЛИОтключить: Булево, если ИСТИНА - проводится включение проверки, иначе отключение
Функция ПодключитьОтключитьПроверкуПоРасписанию(ФлагПодключитьИЛИОтключить = Истина) Экспорт
	Если ФлагПодключитьИЛИОтключить Тогда
		ПодключитьОбработчикОжидания("ОбработатьПроверкуОбновленияПоРасписанию", 60 * 5); // каждые 5 минут
	Иначе
		ОтключитьОбработчикОжидания("ОбработатьПроверкуОбновленияПоРасписанию");
	КонецЕсли;
КонецФункции

// Процедура, выполняющая проверку наличия обновления для конфигурации через сеть Интернет.
//
// Параметры: 
//	ВыдаватьСообщения: Булево, признак вывода пользователю сообщений об ошибках
Процедура ПроверитьНаличиеОбновленияЧерезИнтернет(ВыдаватьСообщения = Ложь, ДоступноОбновлениеДля83 = Ложь) Экспорт
	
	Состояние("Проверка наличия обновления в Интернете..");
	Параметры = ПолучитьДоступноеОбновлениеКонфигурации(); 
	Если Параметры.ИсточникОбновления <> -1 Тогда
		ВремяПолученияОбновления = Параметры.ВремяПолученияОбновления;
		Если ВремяПолученияОбновления <> Неопределено И ОбщегоНазначенияКлиент.ДатаСеанса() - ВремяПолученияОбновления < 30 Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Параметры.ПараметрыФайлаПроверкиОбновления = ПолучитьФайлПроверкиНаличияОбновлений(ВыдаватьСообщения);
	Если ТипЗнч(Параметры.ПараметрыФайлаПроверкиОбновления) = Тип("Строка") Тогда
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Предупреждение",
			НСтр("ru = 'Невозможно подключиться к сети Интернет для проверки обновлений.'"));
		Параметры.ИмяСтраницы = "ПодключениеКИнтернет";
		Возврат;
	КонецЕсли;
	
	Параметры.ПоследняяВерсияКонфигурации = Параметры.ПараметрыФайлаПроверкиОбновления.Version;
	ВерсияКонфигурации = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ВерсияКонфигурации;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияКонфигурации, Параметры.ПоследняяВерсияКонфигурации) >= 0 Тогда
		
		ОбновленияНеОбнаружено = Истина;
		
		Если Не ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83() Тогда
			
			Параметры.ПараметрыФайлаПроверкиОбновления = ПолучитьФайлПроверкиНаличияОбновлений(Ложь, Истина);
			
			Если ТипЗнч(Параметры.ПараметрыФайлаПроверкиОбновления) <> Тип("Строка") Тогда
				
				Параметры.ПоследняяВерсияКонфигурации = Параметры.ПараметрыФайлаПроверкиОбновления.Version;
				ВерсияКонфигурации = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ВерсияКонфигурации;
				
				Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияКонфигурации, Параметры.ПоследняяВерсияКонфигурации) < 0 Тогда
					ОбновленияНеОбнаружено = Ложь;
					ДоступноОбновлениеДля83 = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ОбновленияНеОбнаружено Тогда
			
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Информация",
			НСтр("ru = 'Обновление не требуется: последняя версия конфигурации уже установлена.'"));
			
			Параметры.ИмяСтраницы = "ОбновленияНеОбнаружено";
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Информация",
		НСтр("ru = 'Обнаружена более новая версия конфигурации в Интернете:'") + " " +
			Параметры.ПоследняяВерсияКонфигурации + ".");
			
	Параметры.ИмяСтраницы = "ДоступноеОбновление";
	Параметры.ВремяПолученияОбновления = ОбщегоНазначенияКлиент.ДатаСеанса();
	
КонецПроцедуры

// Процедура проверяет возможность и при необходимости выполняет проверку наличия обновления конфигурации через сеть Интернет
Процедура ПроверитьОбновлениеПоРасписанию() Экспорт
	
	НастройкиОбновленияКонфигурации = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиОбновления.НастройкиОбновленияКонфигурации;
	ОбновлениеКонфигурацииКлиентСервер.ПолучитьОбновленныеНастройкиОбновленияКонфигурации(НастройкиОбновленияКонфигурации);
	РасписаниеПроверкиНаличияОбновления = НастройкиОбновленияКонфигурации.РасписаниеПроверкиНаличияОбновления;
	Если НастройкиОбновленияКонфигурации.ПроверятьНаличиеОбновленияПриЗапуске <> 1 
		ИЛИ РасписаниеПроверкиНаличияОбновления = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
			
	Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(РасписаниеПроверкиНаличияОбновления);
	ДатаПроверки = ОбщегоНазначенияКлиент.ДатаСеанса();
	Если НЕ Расписание.ТребуетсяВыполнение(ДатаПроверки, НастройкиОбновленияКонфигурации.ВремяПоследнейПроверкиОбновления) Тогда
		Возврат;	
	КонецЕсли;	
		
	НастройкиОбновленияКонфигурации.ВремяПоследнейПроверкиОбновления = ДатаПроверки;
	ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),, 
		НСтр("ru = 'Проверка наличия обновления в сети Интернет по расписанию.'"));
		
	НаименованиеСтраницыДоступногоОбновления = "ДоступноеОбновление";
	ПроверитьНаличиеОбновленияЧерезИнтернет();
	Параметры = ПолучитьДоступноеОбновлениеКонфигурации();
	Если Параметры.ИсточникОбновления <> -1 И Параметры.ИмяСтраницы = НаименованиеСтраницыДоступногоОбновления Тогда
			
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),,
			НСтр("ru = 'Обнаружена новая версия конфигурации:'") + " " +
				Параметры.ПараметрыФайлаПроверкиОбновления.Version);
				
		НастройкиОбновленияКонфигурации.ИсточникОбновления = 0;
		НастройкиОбновленияКонфигурации.РасписаниеПроверкиНаличияОбновления = РасписаниеПроверкиНаличияОбновления;
		ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации, СообщенияДляЖурналаРегистрации);
		
		Параметры.ИсточникОбновления = НастройкиОбновленияКонфигурации.ИсточникОбновления;
		Параметры.НуженФайлОбновления = НастройкиОбновленияКонфигурации.НуженФайлОбновления;
		Параметры.ФлагАвтоПереходаНаСтраницуСОбновлением = Истина;
		ПоказатьОповещениеПользователя(НСтр("ru = 'Доступно обновление конфигурации'"),
			"e1cib/app/Обработка.ОбновлениеКонфигурации",
			НСтр("ru = 'Версия:'") + " " + Параметры.ПараметрыФайлаПроверкиОбновления.Version, 
			БиблиотекаКартинок.Информация32);
	Иначе
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),, 
			НСтр("ru = 'Доступных обновлений не обнаружено.'"));
	КонецЕсли;
	ОбновлениеКонфигурацииВызовСервера.ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации, СообщенияДляЖурналаРегистрации);
	
КонецПроцедуры

Функция ПолучитьФайлПроверкиНаличияОбновлений(Знач ВыдаватьСообщения = Истина, ПроверитьОбновленияДля83 = Ложь)
	
	ПараметрыОбновления = ПолучитьПараметрыОбновления(ПроверитьОбновленияДля83);
	НастройкиОбновления = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиОбновления;
	
	ВременныйФайл = ПараметрыОбновления.КаталогФайловОбновления + ПараметрыОбновления.ИмяФайлаПроверкиНаличияОбновления;
	
	// при необходимости, создаем каталог для временного файла
	КаталогВременногоФайла = ПолучитьКаталогФайла(ВременныйФайл);
	КаталогВременногоФайлаОбъект = Новый Файл(КаталогВременногоФайла);
	Если НЕ КаталогВременногоФайлаОбъект.Существует() Тогда
		Попытка 
			СоздатьКаталог(КаталогВременногоФайла);
		Исключение
			ИнфоОбОшибке = ИнформацияОбОшибке();
			
			СообщениеОбОшибке = НСтр("ru = 'Не удалось создать временный каталог для проверки наличия обновлений.
				|%1'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка",
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ПодробноеПредставлениеОшибки(ИнфоОбОшибке)),, 
				Истина);
				
			СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, 
				КраткоеПредставлениеОшибки(ИнфоОбОшибке));
			Если ВыдаватьСообщения Тогда
				Предупреждение(СообщениеОбОшибке);
			КонецЕсли;
			Возврат СообщениеОбОшибке;
		КонецПопытки;
	КонецЕсли;
	
	// получаем сам файл из Интернета
	Результат = ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте(НастройкиОбновления.АдресСервераДляПроверкиНаличияОбновления +
		ПараметрыОбновления.АдресРесурсовДляПроверкиНаличияОбновления + ПараметрыОбновления.ИмяФайлаПроверкиНаличияОбновления,
		Новый Структура("ПутьДляСохранения", ? (ПустаяСтрока(ВременныйФайл), Неопределено, ВременныйФайл)));
		
	Если Результат.Статус <> Истина Тогда
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось проверить наличие обновлений.
				|%1'"), Результат.СообщениеОбОшибке);
		Если ВыдаватьСообщения Тогда
			Предупреждение(СообщениеОбОшибке);
		КонецЕсли;
		Возврат СообщениеОбОшибке;
	КонецЕсли;																
	
	Возврат ПараметрыДистрибутива(ВременныйФайл);
	
КонецФункции

Функция ЗаменитьРелизПлатформы(ИмяКонфигурации)
	
	ОбщаяДлинаСтроки = СтрДлина(ИмяКонфигурации);
	ДлинаСтроки = ОбщаяДлинаСтроки;
	Пока ДлинаСтроки > 1 Цикл
		
		ТекущийСимвол = Сред(ИмяКонфигурации, ДлинаСтроки, 1);
		ПредыдущийСимвол = Сред(ИмяКонфигурации, ДлинаСтроки - 1, 1);
		Если ТекущийСимвол = "2" И ПредыдущийСимвол = "8" Тогда
			ШаблонИмениКонфигурации = "%1%2%3";
			КороткоеИмяКонфигурации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениКонфигурации,
				Лев(КороткоеИмяКонфигурации, ДлинаСтроки - 1), "3", Прав(КороткоеИмяКонфигурации, ОбщаяДлинаСтроки - ДлинаСтроки));
			Прервать;
		КонецЕсли;
		ДлинаСтроки = ДлинаСтроки - 1;
	КонецЦикла;
	
	Возврат ИмяКонфигурации;
	
КонецФункции

// Функция, выполняющая копирование заданного файла в другой.
//
// Параметры:
// ИмяФайлаИсточника: строка, путь к файлу, который нужно скопировать.
// ИмяФайлаНазначение: строка, путь к файлу в который нужно скопировать источник.
// ВыдаватьСообщения: Булево, признак вывода на экран сообщений об ошибках.
Функция СкопироватьФайл(ИмяФайлаИсточник, ИмяФайлаНазначение, ВыдаватьСообщения = Ложь) Экспорт
	Попытка
		СоздатьКаталог(ПолучитьКаталогФайла(ИмяФайлаНазначение));
		КопироватьФайл(ИмяФайлаИсточник, ИмяФайлаНазначение);
	Исключение
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при копировании: %1
				|(источник: %2; приемник: %3)'"), 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				ИмяФайлаИсточник, ИмяФайлаНазначение);
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Предупреждение", Сообщение);
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
КонецФункции

// Функция, возвращает структуру параметров обновления с диска ИТС.
// 
// Параметры: 
// КаталогОбновленияНаДискеИТС: Строка, путь к каталогу с обновлениями на диске ИТС
// ВыдаватьСообщения: Булево, признак вывода на экран сообщений об ошибках.
Функция ПолучитьПараметрыОбновленияИТС(КаталогОбновленияНаДискеИТС, Знач ВыдаватьСообщения = Истина) Экспорт
	
	Если ПустаяСтрока(КаталогОбновленияНаДискеИТС) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыОбновления = ПолучитьПараметрыОбновления();
	ВременныйФайл = ПараметрыОбновления.КаталогФайловОбновления + ПараметрыОбновления.ИмяФайлаПроверкиНаличияОбновления;
	Если НЕ СкопироватьФайл(КаталогОбновленияНаДискеИТС + ПараметрыОбновления.ИмяФайлаПроверкиНаличияОбновления, 
		ВременныйФайл, ВыдаватьСообщения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыДискИТС = ПараметрыДистрибутива(ВременныйФайл);
	Если ТипЗнч(ПараметрыДискИТС) = Тип("Строка") Тогда
		Возврат Неопределено;                     
	КонецЕсли;
	Возврат ПараметрыДискИТС;
	
КонецФункции

// Функция возвращает структуру параметров релизов на диске ИТС.
//
// Параметры: 
// ДискИТС:  строка, путь к диску ИТС.
// ВыдаватьСообщения: Булево, признак вывода на экран сообщений об ошибках.
Функция ПолучитьПараметрыРелизовНаДискеИТС(ДискИТС, Знач ВыдаватьСообщения = Истина) Экспорт
	
	Если ПустаяСтрока(ДискИТС) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыОбновления = ПолучитьПараметрыОбновления();
	ВременныйФайл = ПараметрыОбновления.КаталогФайловОбновления + ПараметрыОбновления.ИмяФайлаАдресовРелизовИТС;
	Если НЕ СкопироватьФайл(
		ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ДискИТС) + 
		ПараметрыОбновления.ИмяФайлаАдресовРелизовИТС, ВременныйФайл, ВыдаватьСообщения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыРелизовНаДискеИТС = ПрочитатьАдресаРелизовНаДискеИТС(ВременныйФайл, ДискИТС);
	Если ТипЗнч(ПараметрыРелизовНаДискеИТС) <> Тип("Структура") Тогда // ошибки при чтении файла
		Если ВыдаватьСообщения Тогда
			Предупреждение(НСтр("ru = 'Обновления на диске 1С:ИТС не найдены.'"));
		КонецЕсли;
		Возврат Неопределено;		
   	КонецЕсли;
	Возврат ПараметрыРелизовНаДискеИТС;
	
КонецФункции

Функция СуществуетФайлПроверкиНаличияОбновления(Знач ПутьККаталогу)
	ФайлПроверки = Новый Файл(ПутьККаталогу + ПолучитьПараметрыОбновления().ИмяФайлаПроверкиНаличияОбновления);
	Возврат ФайлПроверки.Существует();
КонецФункции

// Возвратить каталог файла - часть пути без имени файла.
//
// Параметры
//  ПутьКФайлу  – Строка – путь к файлу.
//
// Возвращаемое значение:
//   Строка   – каталог файла
Функция ПолучитьКаталогФайла(Знач ПутьКФайлу) Экспорт

	ПозицияСимвола = ПолучитьНомерПоследнегоСимвола(ПутьКФайлу, "\"); 
	Если ПозицияСимвола > 1 Тогда
		Возврат Сред(ПутьКФайлу, 1, ПозицияСимвола - 1); 
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

// Чтение данных по обновлению из файла ИмяФайлаПроверкиНаличияОбновления (UpdInfo.txt)
// Вычисляются: 
//		номер версии обновления на сервере, 
//		номера версий, с которых производится обновление (раздляются символом ";")
//		дата публикации обновления
//
// Параметры:
//  ИмяФайла - полное имя файла UpdInfo.txt
// 
// Возвращаемое значение:
//  Структура: 
//		Version - версия обновления
//		FromVersions - с каких версий обновляет
//		UpdateDate - дата опубликования
//  Строка - описание ошибки, если файл не найден или не содержит нужных значений
//
Функция ПараметрыДистрибутива(Знач ИмяФайла)
	Файл = Новый Файл(ИмяФайла);
	Если НЕ Файл.Существует() Тогда
		Возврат НСтр("ru = 'Файл описания обновлений не получен'");
	КонецЕсли;	
	ТД = Новый ТекстовыйДокумент(); 
	ТД.Прочитать(Файл.ПолноеИмя);
	ПарКомпл = Новый Структура();
	Для Н = 1 По ТД.КоличествоСтрок() Цикл
		СтрТмп = НРег(СокрЛП(ТД.ПолучитьСтроку(Н)));
		Если ПустаяСтрока(СтрТмп) Тогда
			Продолжить;
		КонецЕсли;
		Если Найти(СтрТмп,"fromversions=")>0 Тогда
			СтрТМП = СокрЛП(Сред(СтрТмп,Найти(СтрТмп,"fromversions=")+СтрДлина("fromversions=")));
			СтрТМП = ?(Лев(СтрТМП,1)=";","",";") + СтрТмп + ?(Прав(СтрТМП,1)=";","",";");
			ПарКомпл.Вставить("FromVersions",СтрТМП);
		ИначеЕсли Найти(СтрТмп,"version=")>0 Тогда
			ПарКомпл.Вставить("Version",Сред(СтрТмп,Найти(СтрТмп,"version=")+СтрДлина("version=")));
		ИначеЕсли Найти(СтрТмп,"updatedate=")>0 Тогда
			// формат даты = Дата, 
			СтрТмп = Сред(СтрТмп,Найти(СтрТмп,"updatedate=")+СтрДлина("updatedate="));
			Если СтрДлина(СтрТмп)>8 Тогда
				Если Найти(СтрТмп,".")=5 Тогда
					// дата в формате  ГГГГ.ММ.ДД
					СтрТмп = СтрЗаменить(СтрТмп,".","");
				ИначеЕсли Найти(СтрТмп,".")=3 Тогда
					// дата в формате ДД.ММ.ГГГГ
					СтрТмп = Прав(СтрТмп,4)+Сред(СтрТмп,4,2)+Лев(СтрТмп,2);
				Иначе 
					// дата в формате ГГГГММДД
				КонецЕсли;
			КонецЕсли;
			ПарКомпл.Вставить("UpdateDate",Дата(СтрТмп));
		Иначе
			Возврат НСтр("ru = 'Неверный формат сведений о наличии обновлений'");
		КонецЕсли;
	КонецЦикла;
	Если ПарКомпл.Количество() <> 3 Тогда 
		Возврат НСтр("ru = 'Неверный формат сведений о наличии обновлений'");
	КонецЕсли;
	Возврат ПарКомпл;
КонецФункции

Функция ПрочитатьАдресаРелизовНаДискеИТС(Знач ИмяФайла, Знач ДискИТС)
	Файл = Новый Файл(ИмяФайла);
	Если НЕ Файл.Существует() Тогда
		Возврат НСтр("ru = 'Файл описания обновлений не получен'");
	КонецЕсли;	
	
	КороткоеИмяКонфигурации = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().НастройкиОбновления.КороткоеИмяКонфигурации;
	КороткоеИмяКонфигурации = СтрЗаменить(КороткоеИмяКонфигурации, "/", "\");	
	КороткоеИмяКонфигурации = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КороткоеИмяКонфигурации);
	ВозвращаемаяСтруктура = Новый Структура("ПутьКФайламОбновленияНаДискеИТС, ПутьКСтатьеПеречнюРелизов", "", "");
	Попытка
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(Файл.ПолноеИмя);
		ЧтениеXML.Прочитать();
		
		// Путь к статье с перечнем релизов на диске ИТС
		ПутьКСтатьеПеречнюРелизов = ЧтениеXML.ПолучитьАтрибут("UpdateListFile");
		Если НЕ ПустаяСтрока(ПутьКСтатьеПеречнюРелизов) Тогда
			ВозвращаемаяСтруктура.Вставить("ПутьКСтатьеПеречнюРелизов", ПутьКСтатьеПеречнюРелизов);
		КонецЕсли;
		
		// Читаем начало элемента Update или конец элемента UpdateList.
		Пока ЧтениеXML.Прочитать() Цикл
			Если ЧтениеXML.Имя = "UpdateSourceList" Тогда
				Прервать;					
			КонецЕсли;
			Если ЧтениеXML.Имя <> "source" Тогда
				Продолжить;
			КонецЕсли;
				
			ЧтениеXML.Прочитать();
			ЗначениеПутиКаталога = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ДискИТС) + 
				ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(
					СокрЛП(ЧтениеXML.Значение))) + 
				КороткоеИмяКонфигурации;
			Если НЕ ПустаяСтрока(ЗначениеПутиКаталога) И СуществуетФайлПроверкиНаличияОбновления(ЗначениеПутиКаталога) Тогда
				ВозвращаемаяСтруктура.Вставить("ПутьКФайламОбновленияНаДискеИТС", ЗначениеПутиКаталога);
				Прервать;
			КонецЕсли;
			ЧтениеXML.Прочитать();
		КонецЦикла;
		ЧтениеXML.Закрыть();
	Исключение
		ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Ошибка", 
			НСтр("ru = ' ПрочитатьАдресаРелизовНаДискеИТС:'")
				+ " " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ВозвращаемаяСтруктура;
КонецФункции

Функция ПолучитьНомерПоследнегоСимвола(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
			Возврат ПозицияСимвола; 
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;	
	КонецЦикла;

	Возврат 0;
  	
КонецФункции

// Функция, возвращает путь к каталогу временных файлов для проведения обновления.
Функция КаталогLocalAppData() Экспорт
	App			= Новый COMОбъект("Shell.Application");
	Folder		= App.Namespace(28);
	Результат	= Folder.Self.Path;
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Результат);
КонецФункции

//Функция, открывает интерактивно адрес в сети Интернет
//
//Параметры : 
//АдресСтраницы - строка, путь к странице в сети Интернет, которую надо открыть
//Заголовок - строка, заголовок окна "браузера"
Процедура ОткрытьВебСтраницу(Знач АдресСтраницы, Знач Заголовок = "") Экспорт
	
	ОткрытьФорму("Обработка.ОбновлениеКонфигурации.Форма.Обозреватель", 
		Новый Структура("АдресСтраницы,Заголовок", АдресСтраницы, Заголовок));

КонецПроцедуры

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат НСтр("ru = 'Обновление конфигурации'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецФункции

// Вызывается при завершении работы системы, чтобы запросить список предупреждений,
// выводимых пользователю пользователю.
//
// Параметры:
//  см. ПриПолученииСпискаПредупрежденийЗавершенияРаботы.
//
// Примечание:
//  Процедура очищает список ранее добавленных предупреждений.
Процедура ПриЗавершенииРаботыСистемы(Предупреждения) Экспорт
	
	Если ПредлагатьОбновлениеИнформационнойБазыПриЗавершенииСеанса = Истина Тогда
		Предупреждения.Очистить();
		ТекстФлажка  = НСтр("ru = 'Установить обновление конфигурации'");
		ДействиеПриУстановленномФлажке = Новый Структура;
		ДействиеПриУстановленномФлажке.Вставить("Форма", "Обработка.ОбновлениеКонфигурации.Форма.Форма");
		ДействиеПриУстановленномФлажке.Вставить("ПараметрыФормы", Новый Структура("ЗавершениеРаботыСистемы, ВыполнитьОбновление", Истина, Истина));
		
		ПараметрыПредупреждения = Новый Структура;
		ПараметрыПредупреждения.Вставить("ТекстФлажка", ТекстФлажка);
		ПараметрыПредупреждения.Вставить("ДействиеПриУстановленномФлажке", ДействиеПриУстановленномФлажке);
		ПараметрыПредупреждения.Вставить("Приоритет", 50);
		ПараметрыПредупреждения.Вставить("ВывестиОдноПредупреждение", Истина);
		
		Предупреждения.Добавить(ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Проверяет легальность получения обновления. При отсутствии подсистемы
// проверки легальности возвращает Истина
//
Функция ПроверитьЛегальностьПолученияОбновления() Экспорт
	
	ОбновлениеПолученоЛегально = Истина;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления") Тогда
		МодульПроверкаЛегальностиПолученияОбновленияКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПроверкаЛегальностиПолученияОбновленияКлиент");
		ОбновлениеПолученоЛегально = МодульПроверкаЛегальностиПолученияОбновленияКлиент.ПроверитьЛегальностьПолученияОбновления();
		
		Если ОбновлениеПолученоЛегально = Неопределено Тогда
			ОбновлениеПолученоЛегально = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОбновлениеПолученоЛегально;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Доопределяет список предупреждений пользователю перед завершением работы системы.
//
// Параметры:
//  Предупреждения - Массив, в который можно добавить элементы типа Структура с полями:
//    ТекстФлажка      - Строка - текст флажка.
//    ПоясняющийТекст  - Строка - текст, выводимый в форме сверху
//                       управляющего элемента (флажок или гиперссылка).
//    ТекстГиперссылки - Строка - текст гиперссылки.
//    ДействиеПриУстановленномФлажке - Структура с полями:
//      Форма          - путь к открываемой форме.
//      ПараметрыФормы - произвольная структура параметров формы Форма. 
//    ДействиеПриНажатииГиперссылки - Структура с полями:
//      Форма          - Строка    - путь к форме, которая должна открываться по нажатию на гиперссылку.
//      ПараметрыФормы - Структура - произвольная структура параметров для вышеописанной формы.
//      ПрикладнаяФормаПредупреждения - Строка - путь к форме, которая должна открываться сразу
//                                      вместо универсальной формы в случае, когда в списке 
//                                      предупреждений оказывается только одно данное предупреждение.
//      ПараметрыПрикладнойФормыПредупреждения - Структура - произвольная структура
//                                               параметров для вышеописанной формы.
//
Процедура ПриПолученииСпискаПредупрежденийЗавершенияРаботы(Предупреждения) Экспорт
	
	// Предупреждение: при выставлении своего флажка подсистема "Обновление конфигурации" очищает список
	// всех ранее добавленных предупреждений.
	ПриЗавершенииРаботыСистемы(Предупреждения);
	
КонецПроцедуры

// Вызывается при интерактивном начале работы пользователя с областью данных.
// Соответствует событию ПриНачалеРаботыСистемы модулей приложения.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПроверитьОбновлениеКонфигурации();
	
КонецПроцедуры

