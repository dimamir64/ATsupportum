
////////////////////////////////////////////////////////////////////////////////
// ОСНОВНЫЕ ОБРАБОТЧИКИ СОБЫТИЙ

#Область  ОсновныеОбработчикиСобытий

// Универсальный обработчик событий "ПриОткрытии" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	Отказ - Булево - Признак отказа от открытия формы.
//
Процедура ПриОткрытии(ЭтаФорма, Отказ) Экспорт
	
	Если ЭтаФорма.ДополнительныеСвойстваФормы.Свойство("ТипФормы") Тогда
		
		Если ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка" Тогда
			
			Список = ЭтаФорма[ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы];
			Список_ЭлементФормы = ЭтаФорма.Элементы.Найти(ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойЭлементФормы);
			
		ИначеЕсли ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаОбъекта"
			И ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы = "Отчет" Тогда
			
			Объект = ЭтаФорма.Отчет;
			
		ИначеЕсли ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаОбъекта"
			И ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы <> Неопределено Тогда
			
			Объект = ЭтаФорма[ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы];
			
		КонецЕсли;
		
	КонецЕсли;

	Если Объект <> Неопределено И Объект.Свойство("ПометкаУдаления") И Объект.ПометкаУдаления Тогда
		Предупреждение("Внимание! Объект помечен на удаление!", 3);
	КонецЕсли;
	
КонецПроцедуры

// Универсальный обработчик событий "ПриЗакрытии" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//
Процедура ПриЗакрытии(ЭтаФорма) Экспорт

	//Если ЭтаФорма.ДополнительныеСвойстваФормы.Реквизиты.Найти("СохраняемыеНастройки") <> Неопределено Тогда
	//	ОбработчикиСобытий.СохранитьНастройкиОбъекта(ЭтаФорма, ЭтаФорма.СохраняемыеНастройки);
	//КонецЕсли;
	
КонецПроцедуры

// Универсальный обработчик событий "ПередЗаписью" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	Отказ - Булево - Признак отказа от открытия формы.
//  ПараметрыЗаписи - Структура - Структура, содержащая параметры записи.
//
Процедура ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи) Экспорт
	
	Возврат; //пока выключим, не очень хорошо работает
	
	Попытка
		
		Если ЭтаФорма.ВладелецФормы <> Неопределено И ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") Тогда
			ЭтаФорма.ВладелецФормы.Активизировать();
		Иначе
			ВызватьИсключение "Ищем основное окно";
		КонецЕсли;
		
	Исключение
		
		ОписаниеОбъекта = ЭтаФорма.Заголовок;
		
		Если ПустаяСтрока(ОписаниеОбъекта) Тогда
			
			Попытка
				ОписаниеОбъекта = Строка(ЭтаФорма.Объект.Ссылка);
			Исключение
			КонецПопытки;
			
		КонецЕсли;
		
		Если ПустаяСтрока(ОписаниеОбъекта) Тогда
			ОписаниеОбъекта = "объекта";
		КонецЕсли;
		
		ОписаниеОбъекта = "Сообщения при записи " + ОписаниеОбъекта;
		
		ОкноНайдено = Ложь;
		ОкнаКлиентскогоПриложения = ПолучитьОкна();
		Для Каждого ОкноКлиентскогоПриложения Из ОкнаКлиентскогоПриложения Цикл
			Если ОкноКлиентскогоПриложения.НачальнаяСтраница //Основное Тогда //1CBUG - Основное не желает активизироваться :(
				ИЛИ ОкноКлиентскогоПриложения.ПолучитьНавигационнуюСсылку() = "e1c://ОкноСообщений_ат" Тогда
				
				ОкноКлиентскогоПриложения.Активизировать();
				ОкноНайдено = Истина;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ ОкноНайдено И
			ВнутреннегоИспользования_ВызовСервера_ат.ПолучитьФлагИспользованияОтдельногоОкнаСообщений() Тогда
			
			Форма = ОткрытьФорму("ОбщаяФорма.ОкноСообщений_ат",,,,, "e1c://ОкноСообщений_ат",, РежимОткрытияОкнаФормы.Независимый);
			Форма.Заголовок = ОписаниеОбъекта;
			
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

// Универсальный обработчик событий "Выбор" в модулях форм списка объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	Элемент - ТаблицаФормы - Таблица формы в которой осуществлён выбор.
//	ВыбраннаяСтрока - Значение выбранной строки. Тип значения зависит от типа данных, отображаемых в таблице. 
//	Поле - ПолеФормы - Активное поле.
//	СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
//
Процедура СписокВыбор(ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	//СтандартнаяОбработка = Ложь;
	//Ссылка = Элемент.ТекущиеДанные.Ссылка;
	//Если ЭтаФорма.Параметры.Свойство("РежимВыбора") И ЭтаФорма.Параметры.РежимВыбора Тогда
	//	ЭтаФорма.ОповеститьОВыборе(Ссылка);	
	//Иначе
	//	ПараметрыФормы = Новый Структура("Ключ", Ссылка);
	//	ПолучитьФорму(мюУпрФормы_Сервер.ПолучитьПолноеИмяМетаданногоОбъекта(Ссылка)+".ФормаОбъекта",ПараметрыФормы,ЭтаФорма).Открыть();
	//КонецЕсли;
	
КонецПроцедуры

// Универсальный обработчик событий "ПослеЗаписи" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	ПараметрыЗаписи - Структура - Структура, содержащая параметры записи.
//
Процедура ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи) Экспорт
	
	Если НЕ ЭтаФорма.Окно = АктивноеОкно() Тогда
		ЭтаФорма.Окно.Активизировать();
	КонецЕсли;
	
	Попытка
		Оповестить("ЗаписьОбъекта", ЭтаФорма.Объект.Ссылка, ЭтаФорма.Объект.Ссылка);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

// Универсальный обработчик событий "ПриПовторномОткрытии" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//
Процедура ПриПовторномОткрытии(ЭтаФорма) Экспорт
	
	// Вставить содержимое обработчика.
	
КонецПроцедуры

// Универсальный обработчик событий "ПередЗакрытием" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	Отказ - Булево - Признак отказа от открытия формы.
//	СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
//
Процедура ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы = Ложь, ТекстПредупреждения = "") Экспорт
	
	ДопПараметры = Новый Структура("ЗакрываемаяФорма", ЭтаФорма);
	
	Попытка
		
		Если Строка(ЭтаФорма.ДополнительныеСвойстваФормы.ТекущийПользователь) = "Администратор" //!!!!!!!переделать в настройку
			И НЕ ЗавершениеРаботы
			И ЭтаФорма.ВладелецФормы = Неопределено
			И ЭтаФорма.Список.Отбор.Элементы.Количество() = 0
			И ЭтаФорма.ДополнительныеСвойстваФормы.Свойство("ТипФормы")
			И ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка"
			И ЭтаФорма.НавигационнаяСсылка <> "НеЗадаватьВопросПриЗакрытии" Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьЗакрытие", УправляемыеФормы_Клиент_ат, ДопПараметры);
			ПоказатьВопрос(ОписаниеОповещения, "Закрыть список?", РежимДиалогаВопрос.ДаНет, 5, КодВозвратаДиалога.Да,, КодВозвратаДиалога.Нет);
			
			Отказ = Истина;
			
		КонецЕсли;
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ПродолжитьЗакрытие(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ДополнительныеПараметры.ЗакрываемаяФорма.НавигационнаяСсылка = "НеЗадаватьВопросПриЗакрытии";
		ДополнительныеПараметры.ЗакрываемаяФорма.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

// Универсальный обработчик событий "ОбработкаВыбора" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	ВыбранноеЗначение = Произвольный - Результат выбора в подчиненной форме.
//	ИсточникВыбора - Произвольный - Форма, где осуществлен выбор.
//
Процедура ОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	// Вставить содержимое обработчика.
	
КонецПроцедуры

// Универсальный обработчик событий "ОбработкаОповещения" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	ИмяСобытия - Строка - Имя события.
//	Параметр - Параметр сообщения.
//	Источник - Источник события.
//
Процедура ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник) Экспорт
	
	//Перем Список, Список_ЭлементФормы, Объект;
	//
	////Для начала определим, что у нас есть на форме.
	//Если ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка" Тогда
	//	Список = ЭтаФорма[ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы];		
	//  Список_ЭлементФормы = ЭтаФорма.Элементы.Найти(ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойЭлементФормы);
	//	//Список_ЭлементФормы = ЭтаФорма.Элементы[ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы];		
	//ИначеЕсли ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаОбъекта" 
	//И ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное.СохраняемыйОбъект Тогда	
	//	Объект = ЭтаФорма.Объект;
	//КонецЕсли;
	//
	////Проверим, имеет ли вообще событие к нам отношение? 
	//Если ИмяСобытия = "Запись"
	//И ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное.СохраняемыйОбъект
	//И ТипЗнч(Параметр) = Тип(ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное.Ссылка) Тогда
	//	//Значит что-то произошло, связанное с нашим ссылочным типом. Надобно что-то обновить:
	//	Если НЕ Список_ЭлементФормы = Неопределено Тогда
	//		//Либо - наш список
	//		Список_ЭлементФормы.Обновить();
	//	ИначеЕсли НЕ Объект = Неопределено Тогда
	//		//Либо - наш объект
	//		Если Объект.Ссылка = Параметр Тогда
	//			ЭтаФорма.Прочитать();
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

// Универсальный обработчик событий "ОбработкаАктивизации" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	АктивныйОбъект - Произвольный - Активный объект.
//	Источник - УправляемаяФорма, Форма - Форма - источник сообщения. 
//
Процедура ОбработкаАктивизации(ЭтаФорма, АктивныйОбъект, Источник) Экспорт
	
	// Вставить содержимое обработчика.
	
КонецПроцедуры

// Универсальный обработчик событий "ОбработкаЗаписиНового" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	НовыйОбъект - Произвольный - Добавленный в подчиненной форме объект.
//	Источник - УправляемаяФорма, Форма - Форма - источник сообщения. 
//	СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаписиНового(ЭтаФорма, НовыйОбъект, Источник, СтандартнаяОбработка) Экспорт
	
	// Вставить содержимое обработчика.
	
КонецПроцедуры

// Универсальный обработчик событий "ВнешнееСобытие" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	Источник - Строка - Источник внешнего события.
//	Событие - Строка - Наименование события.
//	Данные - Строка - Данные для события.
//
Процедура ВнешнееСобытие(ЭтаФорма, Источник, Событие, Данные) Экспорт
	
	// Вставить содержимое обработчика.
	
КонецПроцедуры

// Универсальный обработчик событий "ПослеЗаписи" в модулях форм объектов
//
// Параметры:
//	ЭтаФорма - УправляемаяФорма - Форма из которой вызван обработчик.
//	Отказ - Булево - Признак отказа от открытия формы.
//
Процедура ПередВыполнением(ЭтаФорма, Отказ) Экспорт
	
	// Вставить содержимое обработчика.
	
КонецПроцедуры

#КонецОбласти 


////////////////////////////////////////////////////////////////////////////////
// УНИВЕРСАЛЬНОЕ СОХРАНЕНИЕ И ВОССТАНОВЛЕНИЕ НАСТРОЕК ДИНАМИЧЕСКИХ СПИСКОВ

#Область  УниверсальноеСохранениеИВосстановлениеНастроекДинамическихСписков

//Процедура сохраняет настройки динамического списка.
Процедура СохранитьНастройкиДинамическогоСписка(ЭтаФорма, Список, Объект, КомандаФормы) //!ЗАКОММЕНТИРОВАНА
	
	//НастраиваемыйОбъект = ?(ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка",
	//	ЭтаФорма.ИмяФормы + "/НастройкиДинамическогоСписка", ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное.Объект);
	//	
	//СохранениеНастроек_Клиент.ВыбратьНастройкуФормы(ЭтаФорма.СохраненнаяНастройка, ЭтаФорма, НастраиваемыйОбъект, Истина);
	//Если НЕ ЭтаФорма.СохраненнаяНастройка = Неопределено  Тогда 
	//	// сохранение настроек динамического списка
	//	Если ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка" Тогда
	//		СтруктураНастроек = Новый Структура("Отбор,Группировка,Порядок,УсловноеОформление");
	//		ЗаполнитьЗначенияСвойств(СтруктураНастроек,Список);
	//		СохранениеНастроек.СохранитьНастройкуОбъекта(ЭтаФорма.СохраненнаяНастройка, СтруктураНастроек);
	//	Иначе		
	//		ЭтаФорма.ОбработчикУниверсальныхДействий_Сервер(КомандаФормы);
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

//Процедура восстанавливает настройки указанного динамического списка.
Процедура ВосстановитьНастройкиДинамическогоСписка(ЭтаФорма, Список, Объект, КомандаФормы) //!ЗАКОММЕНТИРОВАНА
	
	//НастраиваемыйОбъект = ?(ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка",
	//	ЭтаФорма.ИмяФормы + "/НастройкиДинамическогоСписка", ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное.Объект);
	//	
	//СохранениеНастроек_Клиент.ВыбратьНастройкуФормы(ЭтаФорма.СохраненнаяНастройка, ЭтаФорма, НастраиваемыйОбъект, Ложь);
	//
	//Если НЕ ЭтаФорма.СохраненнаяНастройка = Неопределено  Тогда
	//	Если ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка" Тогда
	//		Список.Отбор.Элементы.Очистить();
	//		СтруктураПараметров = ЭтаФорма.СохраненнаяНастройка.ХранилищеНастроек.Получить();
	//		ЗаполнитьЗначенияНастроекДинамическогоСписка(Список,СтруктураПараметров);
	//	Иначе
	//		ЭтаФорма.ОбработчикУниверсальныхДействий_Сервер(КомандаФормы);
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

//Заполнение настроек динамического списка из структуры параметров
Процедура ЗаполнитьЗначенияНастроекДинамическогоСписка(Список, СтруктураПараметров, ИспользованиеОтборов = Ложь) Экспорт //!ЗАКОММЕНТИРОВАНА
	
	////Очистим старые настройки.
	////Список.Отбор.Элементы.Очистить();
	//Список.Порядок.Элементы.Очистить();
	//Список.УсловноеОформление.Элементы.Очистить();
	//Список.Группировка.Элементы.Очистить();
	//
	////Заполним новыми значениями
	//ЗаполнитьЗначенияОтбораДинамическогоСписка(СтруктураПараметров.Отбор,Список.Отбор,ИспользованиеОтборов);	
	//ЗаполнитьЗначенияПорядкаДинамическогоСписка(СтруктураПараметров.Порядок,Список.Порядок);	
	//ЗаполнитьЗначенияУсловногоОформленияДинамическогоСписка(СтруктураПараметров.УсловноеОформление,Список.УсловноеОформление);	
	//ЗаполнитьЗначенияГруппировкиДинамическогоСписка(СтруктураПараметров.Группировка,Список.Группировка);	
	
КонецПроцедуры

//Перенос отборов динамического списка из структуры.
Процедура ЗаполнитьЗначенияОтбораДинамическогоСписка(ЭлементОтбораИсточник, ЭлементОтбораПриемник, ИспользованиеОтборов) //!ЗАКОММЕНТИРОВАНА
	
	//Для й = 0 ПО ЭлементОтбораИсточник.Элементы.Количество() - 1 Цикл // Получение по стандартному итератору не работает.
	//	//Добавим текущий поднод
	//	ЭлементИсточника = ЭлементОтбораИсточник.Элементы[й];
	//	ЭлементПриемника = ЭлементОтбораПриемник.Элементы.Добавить(ТипЗнч(ЭлементИсточника));
	//	ЗаполнитьЗначенияСвойств(ЭлементПриемника,ЭлементИсточника);
	//	ЭлементПриемника.Использование = ИспользованиеОтборов;
	//	Если НЕ ТипЗнч(ЭлементИсточника) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
	//		//Если поднод является группой, значит необходимо обработать его рекурсивно.
	//		ЗаполнитьЗначенияОтбораДинамическогоСписка(ЭлементИсточника,ЭлементПриемника,ИспользованиеОтборов); 
	//	КонецЕсли;
	//КонецЦикла;
	
КонецПроцедуры

//Перенос порядка динамического списка из структуры
Процедура ЗаполнитьЗначенияПорядкаДинамическогоСписка(ЭлементПорядкаИсточник, ЭлементПорядкаПриемник) //!ЗАКОММЕНТИРОВАНА
	
	//Для Каждого ЭлементИсточника ИЗ ЭлементПорядкаИсточник.Элементы Цикл
	//	ЭлементПриемника = ЭлементПорядкаПриемник.Элементы.Добавить(ТипЗнч(ЭлементИсточника));
	//	ЗаполнитьЗначенияСвойств(ЭлементПриемника,ЭлементИсточника);
	//КонецЦикла;
	
КонецПроцедуры

//Перенос группировок динамического списка из структуры
Процедура ЗаполнитьЗначенияГруппировкиДинамическогоСписка(ЭлементПорядкаИсточник, ЭлементПорядкаПриемник) //!ЗАКОММЕНТИРОВАНА
	
	//Для Каждого ЭлементИсточника ИЗ ЭлементПорядкаИсточник.Элементы Цикл
	//	ЭлементПриемника = ЭлементПорядкаПриемник.Элементы.Добавить(ТипЗнч(ЭлементИсточника));
	//	ЗаполнитьЗначенияСвойств(ЭлементПриемника,ЭлементИсточника);
	//КонецЦикла;
	
КонецПроцедуры

//Перенос условного оформления динамического списка из структуры
Процедура ЗаполнитьЗначенияУсловногоОформленияДинамическогоСписка(ЭлементУсловногоОформленияИсточник,ЭлементУсловногоОформленияПриемник) //!ЗАКОММЕНТИРОВАНА
	
	//Для Каждого ЭлементИсточника ИЗ ЭлементУсловногоОформленияИсточник.Элементы Цикл
	//	ЭлементПриемника = ЭлементУсловногоОформленияПриемник.Элементы.Добавить();
	//	ЗаполнитьЗначенияСвойств(ЭлементПриемника,ЭлементИсточника);
	//	//Заполним сложные поля.
	//	ЗаполнитьЗначенияОтбораДинамическогоСписка(ЭлементИсточника.Отбор,ЭлементПриемника.Отбор,Истина);
	//	Для Каждого ЭлементОформленияИсточника ИЗ ЭлементИсточника.Оформление.Элементы Цикл
	//		Если НЕ ЭлементОформленияИсточника.Использование Тогда Продолжить; КонецЕсли;
	//		ЭлементОформленияПриемника = ЭлементПриемника.Оформление.Элементы.Найти(ЭлементОформленияИсточника.Параметр);
	//		ЗаполнитьЗначенияСвойств(ЭлементОформленияПриемника,ЭлементОформленияИсточника);
	//	КонецЦикла;
	//	Для Каждого ЭлементПоляИсточника ИЗ ЭлементИсточника.Поля.Элементы Цикл
	//		ЭлементПоляПриемника = ЭлементПриемника.Поля.Элементы.Добавить();	
	//		ЗаполнитьЗначенияСвойств(ЭлементПоляПриемника,ЭлементПоляИсточника);
	//	КонецЦикла;
	//КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 


////////////////////////////////////////////////////////////////////////////////
////УПРАВЛЕНИЕ ОТБОРАМИ

#Область  УправлениеОтборами

Процедура УстановитьВидимостьОтборовДинамическогоСписка(ЭтаФорма)
	
	Пометка = НЕ ЭтаФорма.Элементы.ПоказатьОтборыДинамическогоСписка.Пометка;
	ЭтаФорма.Элементы.ПоказатьОтборыДинамическогоСписка.Пометка = Пометка;
	ЭтаФорма.ПоказыватьОтборыДинамическогоСписка = Пометка;
	
	ГруппаПользовательскихНастроек = ЭтаФорма.Элементы[ЭтаФорма.ИмяГруппыПользовательскихНастроек];
	ГруппаПользовательскихНастроек.Видимость = Пометка;
	
	МассивИменОтборов = УправляемыеФормы_Клиент_Переопределяемый_ат.ПолучитьМассивИменДоступныхДляРедактированияОтборовПоТипуОбъекта(
		Тип(ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное.Ссылка));
	
	УстановитьДоступностьПользовательскихОтборовРекурсивно(ГруппаПользовательскихНастроек.ПодчиненныеЭлементы, МассивИменОтборов);
	
КонецПроцедуры

Процедура УстановитьДоступностьПользовательскихОтборовРекурсивно(ПодчиненныеЭлементы, МассивИменОтборов, ЗначениеДоступности = Ложь)
	
	Для Каждого ПодчиненныйЭлемент Из ПодчиненныеЭлементы Цикл
		
		ЗначениеДоступности = Ложь;
		
		Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
			
			УстановитьДоступностьПользовательскихОтборовРекурсивно(ПодчиненныйЭлемент.ПодчиненныеЭлементы, МассивИменОтборов, ЗначениеДоступности);
			
			Если НЕ ЗначениеДоступности Тогда // Если редактирование доступно - не нужно убирать доступность у родительских элементов.
				
				ЗначениеДоступности = НЕ МассивИменОтборов.Найти(ПодчиненныйЭлемент.Заголовок) = Неопределено;
				ПодчиненныйЭлемент.Доступность = ЗначениеДоступности;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 


////////////////////////////////////////////////////////////////////////////////
// УНИВЕРСАЛЬНЫЙ ОБРАБОТЧИК ДЕЙСТВИЙ
 
#Область  УниверсальныйОбработчикДействий

Процедура ДополнительныеДействияФормы(ЭтаФорма, Элемент) Экспорт

	КомандаФормы = Новый Структура("Действие, ИзменяетСохраняемыеДанные, Имя");
	ЗаполнитьЗначенияСвойств(КомандаФормы, Элемент);
	
	Объект = Неопределено;
	
	Метаданное = ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное;
	
	Если ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаСписка" Тогда
		
		Список = ЭтаФорма[ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы];		
		Список_ЭлементФормы = ЭтаФорма.Элементы.Найти(ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойЭлементФормы);
		
	ИначеЕсли ЭтаФорма.ДополнительныеСвойстваФормы.ТипФормы = "ФормаОбъекта"
		И ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы <> Неопределено Тогда
		
		Объект = ЭтаФорма[ЭтаФорма.ДополнительныеСвойстваФормы.ОсновнойРеквизитФормы];
		
	КонецЕсли;
	
	//в связи с отсутствие кнопки - см. ОМ.УправляемыеФормы_Сервер_ат.Процедура ЗаполнитьКоманднуюПанель_ПросмотрПУ
	//Если Элемент.Имя = "ПросмотрПУ" Тогда
	//	
	//	Кнопка = ЭтаФорма.Элементы.ПросмотрПУ;
	//	Кнопка.Пометка = Не Кнопка.Пометка;
	//	
	//	УправляемыеФормы_КлиентСервер_ат.ИзменитьИспользованиеОтбораДинамическогоСписка(
	//		Список, "Скрыть помеченные на удаление", Не Кнопка.Пометка);
	//	
	//	Иначе
	Если Элемент.Имя = "ПодсчетКоличестваСтрок" Тогда
		
		Количество = ЭтаФорма.ОбработчикУниверсальныхДействий_Сервер(КомандаФормы);
		Предупреждение("Количество строк в текущем списке: " + Количество, 10);
		
	ИначеЕсли Элемент.Имя = "ПоказатьОтборыДинамическогоСписка" Тогда
		
		УстановитьВидимостьОтборовДинамическогоСписка(ЭтаФорма);
		
	//ИначеЕсли Элемент.Имя = "СоздатьНапоминание" Тогда
	//
	//	ОбработчикиСобытий_Клиент.СоздатьНапоминание(ЭтаФорма, , Новый Структура("Объект", ЭтаФорма.Объект.Ссылка));
	//ИначеЕсли Элемент.Имя = "SA_Выбрать" Тогда
	//	Если НЕ Список_ЭлементФормы = Неопределено Тогда
	//		ЭтаФорма.ОповеститьОВыборе(Список_ЭлементФормы.ТекущиеДанные.Ссылка); //ТекущаяСтрока не работает.
	//	КонецЕсли;
	//
	//ИначеЕсли Элемент.Имя = "УправлениеРежимомБыстрогоВыбораЭлементов" Тогда
	//
	//	Кнопка = ЭтаФорма.Элементы["УправлениеРежимомБыстрогоВыбораЭлементов"];
	//	Кнопка.Пометка = НЕ Кнопка.Пометка;	
	//	ЭтаФорма.РежимБыстрогоВыбораЭлементов = Кнопка.Пометка;
	//	ЭтаФорма.ОбработчикУниверсальныхДействий_Сервер(КомандаФормы);
	//
	//ИначеЕсли Элемент.Имя = "СохранитьНастройкиДинамическогоСписка" Тогда
	//	
	//	СохранитьНастройкиДинамическогоСписка(ЭтаФорма, Список, Объект, КомандаФормы);	
	//	
	//ИначеЕсли Элемент.Имя = "ВосстановитьНастройкиДинамическогоСписка" Тогда
	//	
	//	ВосстановитьНастройкиДинамическогоСписка(ЭтаФорма, Список, Объект, КомандаФормы);
	//	
	//#Если ТолстыйКлиентОбычноеПриложение Тогда
	//ИначеЕсли Элемент.Имя = "УправлениеНастройкамиФормы_СохранитьНастройкиФормы" Тогда
	//	
	//	ИмяНастройки = "";
	//	Если ВвестиСтроку(ИмяНастройки, "Введите название настройки", 0) Тогда
	//		НастройкиФормы = ХранилищеСистемныхНастроек.Загрузить(ЭтаФорма.ИмяФормы+"/НастройкиФормы",""); 
	//		ХранилищеСистемныхНастроек.Сохранить(ЭтаФорма.ИмяФормы+"/НастройкиФормы",ИмяНастройки,НастройкиФормы); 
	//	КонецЕсли;
	//
	//ИначеЕсли Элемент.Имя = "УправлениеНастройкамиФормы_ЗагрузитьНастройкиФормы" Тогда
	//
	//	СписокНастроек = ХранилищеСистемныхНастроек.ПолучитьСписок(ЭтаФорма.ИмяФормы+"/НастройкиФормы");
	//	ИмяНастройки = СписокНастроек.ВыбратьЭлемент();
	//	Если НЕ ИмяНастройки = Неопределено Тогда
	//		НастройкиФормы = ХранилищеСистемныхНастроек.Загрузить(ЭтаФорма.ИмяФормы+"/НастройкиФормы",ИмяНастройки); 
	//		ХранилищеСистемныхНастроек.Сохранить(ЭтаФорма.ИмяФормы+"/НастройкиФормы","",НастройкиФормы ); 
	//	КонецЕсли;
	//
	//ИначеЕсли Элемент.Имя = "УправлениеНастройкамиФормы_УдалитьНастройкуФормы" Тогда
	//
	//	СписокНастроек = ХранилищеСистемныхНастроек.ПолучитьСписок(ЭтаФорма.ИмяФормы+"/НастройкиФормы");
	//	ИмяНастройки = СписокНастроек.ВыбратьЭлемент();
	//	Если НЕ ИмяНастройки = Неопределено Тогда
	//		ХранилищеСистемныхНастроек.Удалить(ЭтаФорма.ИмяФормы+"/НастройкиФормы", ИмяНастройки, ЭтаФорма.ДополнительныеСвойстваФормы.ТекущийПользователь.Наименование)     
	//	КонецЕсли;
	//
	//ИначеЕсли Элемент.Имя = "УправлениеСохраненнымиНастройками_ВосстановитьНастройку" Тогда
	//	СохранитьНастройкиОтчета(ЭтаФорма, Объект);
	//	СохраненнаяНастройка = Неопределено;
	//	СохранениеНастроек_Клиент.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, Ложь);	
	//	// перенести на сервер!!!
	//	_Объект = ДанныеФормыВЗначение(Объект, Тип(ЭтаФорма.ДополнительныеСвойстваФормы.Метаданное.Объект));
	//	_Объект.СохраненнаяНастройка = СохраненнаяНастройка;
	//	_Объект.ПрименитьНастройку();
	//	ЗначениеВДанныеФормы(_Объект, Объект);
	//
	//ИначеЕсли Элемент.Имя = "УправлениеСохраненнымиНастройками_СохранитьНастройку" Тогда
	//
	//	СохранениеНастроек_Клиент.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, Истина);
	//	
	//	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	//
	//#КонецЕсли //ТолстыйКлиентОбычноеПриложение
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 


//!!!TODO: перенести в @librorum в Формы_ат

Функция   ПолучитьУИОкнаПоЗаголовку(Заголовок, АктивизироватьНайденное = Ложь) Экспорт
	
	УИдОкна = Неопределено;
	
	Для Каждого ОкноПриложения Из ПолучитьОкна() Цикл
		
		Если ОкноПриложения.Заголовок = Заголовок Тогда
			
			УИдОкна = Строки_КлиентСервер_ат.ПолучитьСтрУИдПоНавСсылке(ОкноПриложения.ПолучитьНавигационнуюСсылку());
			
			Если АктивизироватьНайденное Тогда
				ОкноПриложения.Активизировать();
			КонецЕсли;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат УИдОкна;
	
КонецФункции

// Определяет значение "ТолькоПросмотр" по элементу и его родителям
//
Функция   ТолькоПросмотр(Элемент) Экспорт
	
	Если Элемент.ТолькоПросмотр ИЛИ НЕ Элемент.Доступность Тогда
		
		Возврат Истина;
		
	Иначе
		
		ТипФормы = Неопределено;
		
		#Если НЕ ВебКлиент Тогда
		Информация = Новый СистемнаяИнформация;
		ЗначенияНомеровВерсии = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Информация.ВерсияПриложения, ".", Истина);
		
		Если ЗначенияНомеровВерсии.Количество() = 4 Тогда
			Если Число(ЗначенияНомеровВерсии[3]) >= 14 Тогда
				Выполнить("ТипФормы = Тип(""ФормаКлиентскогоПриложения"")");
			Иначе
				Выполнить("ТипФормы = Тип(""УправляемаяФорма"")");
			КонецЕсли;
		КонецЕсли;
		#КонецЕсли
		
		Если ТипФормы = Неопределено ИЛИ ТипЗнч(Элемент) = ТипФормы Тогда
			
			Возврат Ложь;
			
		Иначе
			
			ТолькоПосмотрРодителя = ТолькоПросмотр(Элемент.Родитель);
			
			Если НЕ ТолькоПосмотрРодителя И ТипЗнч(Элемент) = Тип("ТаблицаФормы") Тогда
				Возврат НЕ Элемент.ИзменятьСоставСтрок;
			Иначе
				Возврат ТолькоПосмотрРодителя;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции
