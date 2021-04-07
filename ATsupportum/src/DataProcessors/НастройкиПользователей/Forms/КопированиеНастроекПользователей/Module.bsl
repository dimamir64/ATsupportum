///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьВнешнихПользователей = ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");
	ПереключательКомуКопироватьНастройки = "ВыбраннымПользователям";
	ПереключательКопируемыеНастройки = "СкопироватьВсе";
	РежимОткрытияФормы = Параметры.РежимОткрытияФормы;
	
	ПользователиПолучателиНастроек = Новый Структура;
	Если Параметры.Пользователь <> Неопределено Тогда
		МассивПользователей = Новый Массив;
		МассивПользователей.Добавить(Параметры.Пользователь);
		ПользователиПолучателиНастроек.Вставить("МассивПользователей", МассивПользователей);
		Элементы.ВыбратьПользователей.Заголовок = Строка(Параметры.Пользователь);
		КоличествоПользователей = 1;
		ТипПереданногоПользователя = ТипЗнч(Параметры.Пользователь);
		Элементы.ГруппаКомуКопировать.Доступность = Ложь;
	Иначе
		ПользовательСсылка = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ПользовательСсылка = Неопределено Тогда
		Элементы.ГруппаКопируемыеНастройки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("ВыборПользователя") Тогда
		ПользователиПолучателиНастроек = Новый Структура("МассивПользователей", Параметр.ПользователиПриемник);
		
		КоличествоПользователей = Параметр.ПользователиПриемник.Количество();
		Если КоличествоПользователей = 1 Тогда
			Элементы.ВыбратьПользователей.Заголовок = Строка(Параметр.ПользователиПриемник[0]);
		ИначеЕсли КоличествоПользователей > 1 Тогда
			
			ПрописьЧисла = ЧислоПрописью(
				КоличествоПользователей,
				"Л = ru_RU",
				НСтр("ru = ',,,,,,,,0'"));
			ПрописьЧислаИПредмета = ЧислоПрописью(
				КоличествоПользователей,
				"Л = ru_RU",
				НСтр("ru = 'пользователь,пользователя,пользователей,,,,,,0'"));
			ЧислоИПредмет = СтрЗаменить(
				ПрописьЧислаИПредмета,
				ПрописьЧисла,
				Формат(КоличествоПользователей, "ЧДЦ=0") + " ");
				
			Элементы.ВыбратьПользователей.Заголовок = ЧислоИПредмет;
		КонецЕсли;
		Элементы.ВыбратьПользователей.Подсказка = "";
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("ВыборНастроек") Тогда
		
		ВыбранныеНастройки = Новый Структура;
		ВыбранныеНастройки.Вставить("НастройкиОтчетов", Параметр.НастройкиОтчетов);
		ВыбранныеНастройки.Вставить("ВнешнийВид", Параметр.ВнешнийВид);
		ВыбранныеНастройки.Вставить("ПрочиеНастройки", Параметр.ПрочиеНастройки);
		ВыбранныеНастройки.Вставить("ПерсональныеНастройки", Параметр.ПерсональныеНастройки);
		ВыбранныеНастройки.Вставить("ТаблицаВариантовОтчетов", Параметр.ТаблицаВариантовОтчетов);
		ВыбранныеНастройки.Вставить("ВыбранныеВариантыОтчетов", Параметр.ВыбранныеВариантыОтчетов);
		ВыбранныеНастройки.Вставить("ПрочиеПользовательскиеНастройки",
			Параметр.ПрочиеПользовательскиеНастройки);
		
		КоличествоНастроек = Параметр.КоличествоНастроек;
		
		Если КоличествоНастроек = 0 Тогда
			ТекстЗаголовка = НСтр("ru='Выбрать'");
		ИначеЕсли КоличествоНастроек = 1 Тогда
			ПредставлениеНастройки = Параметр.ПредставленияНастроек[0];
			ТекстЗаголовка = ПредставлениеНастройки;
		Иначе
			ПрописьЧисла = ЧислоПрописью(
				КоличествоНастроек,
				"Л = ru_RU",
				НСтр("ru = ',,,,,,,,0'"));
			ПрописьЧислаИПредмета = ЧислоПрописью(
				КоличествоНастроек,
				"Л = ru_RU",
				НСтр("ru = 'настройка,настройки,настроек,,,,,,0'"));
			ТекстЗаголовка = СтрЗаменить(
				ПрописьЧислаИПредмета,
				ПрописьЧисла,
				Формат(КоличествоНастроек, "ЧДЦ=0") + " ");
		КонецЕсли;
		
		Элементы.ВыбратьНастройки.Заголовок = ТекстЗаголовка;
		Элементы.ВыбратьНастройки.Подсказка = "";
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("СкопироватьНастройкиАктивнымПользователям") Тогда
		
		СкопироватьНастройки(Параметр.Действие);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбранныйТипПользователей = Неопределено;
	
	Если КоличествоПользователей <> 0 Тогда
		СкрываемыеПользователи = Новый СписокЗначений;
		СкрываемыеПользователи.ЗагрузитьЗначения(ПользователиПолучателиНастроек.МассивПользователей);
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("ДоступКИнформационнойБазеРазрешен, РежимВыбора, СкрываемыеПользователи",
										Истина, Истина, СкрываемыеПользователи);
	
	Если ТипПереданногоПользователя = Неопределено Тогда
		
		Если ИспользоватьВнешнихПользователей Тогда
			ВыборТипаПользователей = Новый СписокЗначений;
			ВыборТипаПользователей.Добавить("ВнешниеПользователи", НСтр("ru = 'Внешние пользователи'"));
			ВыборТипаПользователей.Добавить("Пользователи", НСтр("ru = 'Пользователи'"));
			
			ВыбранныйВариант = ВыборТипаПользователей.ВыбратьЭлемент();
			Если ВыбранныйВариант = Неопределено Тогда
				Возврат;
			КонецЕсли;
			ВыбранныйТипПользователей = ВыбранныйВариант.Значение;
		Иначе
			ВыбранныйТипПользователей = "Пользователи";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВыбранныйТипПользователей = "Пользователи"
		Или ТипПереданногоПользователя = Тип("СправочникСсылка.Пользователи") Тогда
		ОткрытьФорму("Справочник.Пользователи.Форма.ФормаСписка", ПараметрыОтбора, Элементы.ПользовательСсылка);
	ИначеЕсли ВыбранныйТипПользователей = "ВнешниеПользователи"
		Или ТипПереданногоПользователя = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		ОткрытьФорму("Справочник.ВнешниеПользователи.Форма.ФормаСписка", ПараметрыОтбора, Элементы.ПользовательСсылка);
	КонецЕсли;
	ПользовательСсылкаСтарый = ПользовательСсылка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательСсылкаПриИзменении(Элемент)
	
	Если ПользовательСсылка <> Неопределено
		И ПользователиПолучателиНастроек <> Неопределено Тогда
		
		Для Каждого ПользовательПриемник Из ПользователиПолучателиНастроек.МассивПользователей Цикл
		
			Если ПользовательСсылка = ПользовательПриемник Тогда
				Предупреждение(НСтр("ru = 'Нельзя копировать настройки пользователя самому себе,
					|выберите другого пользователя.'"));
				ПользовательСсылка = ПользовательСсылкаСтарый;
				Возврат;
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ГруппаКопируемыеНастройки.Доступность = ПользовательСсылка <> Неопределено;
	
	ВыбранныеНастройки = Неопределено;
	КоличествоНастроек = 0;
	Элементы.ВыбратьНастройки.Заголовок = НСтр("ru='Выбрать'");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНастройки(Элемент)
	
	ПараметрыФормы = Новый Структура("Пользователь, ДействиеСНастройками", ПользовательСсылка, "Копирование");
	ОткрытьФорму("Обработка.НастройкиПользователей.Форма.ВыборНастроек", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователей(Элемент)
	
	ТипПользователя = ТипЗнч(ПользовательСсылка);
	
	ВыбранныеПользователи = Неопределено;
	ПользователиПолучателиНастроек.Свойство("МассивПользователей", ВыбранныеПользователи);
	
	ПараметрыФормы = Новый Структура("Пользователь, ТипПользователя, ТипДействия, ВыбранныеПользователи",
		ПользовательСсылка, ТипПользователя, "Копирование", ВыбранныеПользователи);
	ОткрытьФорму("Обработка.НастройкиПользователей.Форма.ВыборПользователей", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательКомуКопироватьНастройкиПриИзменении(Элемент)
	
	Если ПереключательКомуКопироватьНастройки = "ВыбраннымПользователям" Тогда
		Элементы.ВыбратьПользователей.Доступность = Истина;
	Иначе
		Элементы.ВыбратьПользователей.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательКопируемыеНастройкиПриИзменении(Элемент)
	
	Если ПереключательКопируемыеНастройки = "СкопироватьОтдельные" Тогда
		Элементы.ВыбратьНастройки.Доступность = Истина;
	Иначе
		Элементы.ВыбратьНастройки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Скопировать(Команда)
	
	ОчиститьСообщения();
	
	Если ПользовательСсылка = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выберите пользователя, чьи настройки необходимо скопировать.'"), , "ПользовательСсылка");
		Возврат;
	КонецЕсли;
	
	Если КоличествоПользователей = 0 И ПереключательКомуКопироватьНастройки <> "ВсемПользователям" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выберите одного или несколько пользователей, которым необходимо скопировать настройки.'"), , "Приемник");
		Возврат;
	КонецЕсли;
	
	Если ПереключательКопируемыеНастройки = "СкопироватьОтдельные" И КоличествоНастроек = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выберите настройки, которые необходимо скопировать.'"), , "ПереключательКопируемыеНастройки");
		Возврат;
	КонецЕсли;
	
	// При копировании настроек внешнего вида или всех настроек другим пользователям
	// проверяем работают они с программой или нет. Если работают - выводим сообщение об этом.
	ПроверитьАктивныхПользователей();
	Если РезультатПроверки = "ЕстьАктивныеПользователиПолучатели" Тогда
		
		Если ПереключательКопируемыеНастройки = "СкопироватьВсе" 
			Или (ПереключательКопируемыеНастройки = "СкопироватьОтдельные"
			И ВыбранныеНастройки.ВнешнийВид.Количество() <> 0) Тогда
			
			ПараметрыФормы = Новый Структура("Действие", Команда.Имя);
			ОткрытьФорму("Обработка.НастройкиПользователей.Форма.ПредупреждениеОКопированииНастроек", ПараметрыФормы);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СкопироватьНастройки(Команда.Имя);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура СкопироватьНастройки(ИмяКоманды)
	
	Состояние(НСтр("ru = 'Выполняется копирование настроек'"));
	
	Если ПереключательКомуКопироватьНастройки = "ВыбраннымПользователям" Тогда
		
		ПояснениеКомуСкопированыНастройки = НастройкиПользователейКлиент.ПояснениеПользователи(
			КоличествоПользователей, ПользователиПолучателиНастроек.МассивПользователей[0]);
		
	Иначе
		ПояснениеКомуСкопированыНастройки = НСтр("ru = 'всем пользователям'");
	КонецЕсли;
	
	Если ПереключательКопируемыеНастройки = "СкопироватьОтдельные" Тогда
		
		Отчет = Неопределено;
		СкопироватьВыбранныеНастройки(Отчет);
		
		Если Отчет <> Неопределено Тогда
			ТекстВопроса = НСтр("ru = 'Не все варианты отчетов и настройки были скопированы.'");
			КнопкиВопроса = Новый СписокЗначений;
			КнопкиВопроса.Добавить(НСтр("ru='ОК'"));
			КнопкиВопроса.Добавить(НСтр("ru='Показать отчет'"));
			Ответ = Вопрос(ТекстВопроса, КнопкиВопроса,, КнопкиВопроса[0].Значение);
			
			Если Ответ = КнопкиВопроса[0].Значение Тогда
				Возврат;
			Иначе
				Отчет.ОтображатьГруппировки = Истина;
				Отчет.ОтображатьСетку = Ложь;
				Отчет.ОтображатьЗаголовки = Ложь;
				Отчет.Показать();
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
			
		Если Отчет = Неопределено Тогда
			
			ТекстПояснения = НастройкиПользователейКлиент.ФормированиеПоясненияПриКопировании(
				ПредставлениеНастройки, КоличествоНастроек, ПояснениеКомуСкопированыНастройки);
			ПоказатьОповещениеПользователя(НСтр("ru = 'Копирование настроек'"), , ТекстПояснения, БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
		
	Иначе
		
		НастройкиСкопированы = КопированиеВсехНастроек();
		Если Не НастройкиСкопированы Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Настройки не были скопированы, так как у пользователя ""%1"" не было сохранено ни одной настройки.'");
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.
				ПодставитьПараметрыВСтроку(ТекстПредупреждения, Строка(ПользовательСсылка));
			Предупреждение(ТекстПредупреждения);
			
			Возврат;
		КонецЕсли;
			
		ТекстПояснения = НСтр("ru = 'Скопированы все настройки %1'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстПояснения, ПояснениеКомуСкопированыНастройки);
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Копирование настроек'"), , ТекстПояснения, БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	// При копировании настроек внешнего вида или всех настроек от другого пользователь предлагаем
	// перезапустить программу для их принятия.
	Если РезультатПроверки = "ТекущийПользовательПолучатель" Или РезультатПроверки = "ТекущийПользовательСредиПолучателей" Тогда
		
		Если ПереключательКопируемыеНастройки = "СкопироватьВсе" Тогда
			
			Если ПредложениеПерезапускаПрограммы() Тогда
				Возврат;
			КонецЕсли;
			
		ИначеЕсли ПереключательКопируемыеНастройки = "СкопироватьОтдельные" Тогда
			
			Если ВыбранныеНастройки.ВнешнийВид.Количество() <> 0
				Или ПереключательКопируемыеНастройки = "СкопироватьВсе" Тогда
				
				Если ПредложениеПерезапускаПрограммы() Тогда
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Если копирование настроек от другого пользователя, оповещаем об этом форму НастройкиПользователей.
	Если РежимОткрытияФормы = "СкопироватьОт" Тогда
		Оповестить("СкопированыНастройки", Истина);
	КонецЕсли;
	
	Если ИмяКоманды = "СкопироватьИЗакрыть" Тогда
		Закрыть();
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Функция ПредложениеПерезапускаПрограммы()
	
	ТекстСообщения = НСтр("ru = 'Для того чтобы скопированные настройки внешнего вида вступили в силу, необходимо перезапустить программу.
								|Перезапустить сейчас?'");
	КнопкиВопроса = Новый СписокЗначений;
	КнопкиВопроса.Добавить(НСтр("ru='Перезапустить сейчас'"));
	КнопкиВопроса.Добавить(НСтр("ru='Не перезапускать'"));
	Ответ = Вопрос(ТекстСообщения, КнопкиВопроса,, КнопкиВопроса[1].Значение);
	Если Ответ = КнопкиВопроса[0].Значение Тогда
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Истина, Истина);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура СкопироватьВыбранныеНастройки(Отчет)
	
	Пользователь = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательСсылка);
	
	Если ПереключательКомуКопироватьНастройки = "ВыбраннымПользователям" Тогда
		Приемники = ПользователиПолучателиНастроек.МассивПользователей;
	ИначеЕсли ПереключательКомуКопироватьНастройки = "ВсемПользователям" Тогда
		Приемники = Новый Массив;
		ТаблицаПользователей = Новый ТаблицаЗначений;
		ТаблицаПользователей.Колонки.Добавить("Пользователь");
		Обработки.НастройкиПользователей.ПользователиДляКопирования(ПользовательСсылка, ТаблицаПользователей,
			ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.ВнешниеПользователи"));
		
		Для Каждого СтрокаТаблицы Из ТаблицаПользователей Цикл
			Приемники.Добавить(СтрокаТаблицы.Пользователь);
		КонецЦикла;
		
	КонецЕсли;
	
	НеСкопированныеНастройкиОтчетов = Новый ТаблицаЗначений;
	НеСкопированныеНастройкиОтчетов.Колонки.Добавить("Пользователь");
	НеСкопированныеНастройкиОтчетов.Колонки.Добавить("СписокОтчетов", Новый ОписаниеТипов("СписокЗначений"));
	
	Если ВыбранныеНастройки.НастройкиОтчетов.Количество() > 0 Тогда
		
		Обработки.НастройкиПользователей.СкопироватьНастройкиОтчетовИПерсональныеНастройки(ХранилищеПользовательскихНастроекОтчетов,
			Пользователь, Приемники, ВыбранныеНастройки.НастройкиОтчетов, НеСкопированныеНастройкиОтчетов);
		
		Обработки.НастройкиПользователей.СкопироватьВариантыОтчетов(
			ВыбранныеНастройки.ВыбранныеВариантыОтчетов, ВыбранныеНастройки.ТаблицаВариантовОтчетов, Пользователь, Приемники);
	КонецЕсли;
		
	Если ВыбранныеНастройки.ВнешнийВид.Количество() > 0 Тогда
		Обработки.НастройкиПользователей.СкопироватьНастройкиВнешнегоВида(Пользователь, Приемники, ВыбранныеНастройки.ВнешнийВид);
	КонецЕсли;
	
	Если ВыбранныеНастройки.ПрочиеНастройки.Количество() > 0 Тогда
		Обработки.НастройкиПользователей.СкопироватьНастройкиВнешнегоВида(Пользователь, Приемники, ВыбранныеНастройки.ПрочиеНастройки);
	КонецЕсли;
	
	Если ВыбранныеНастройки.ПерсональныеНастройки.Количество() > 0 Тогда
		Обработки.НастройкиПользователей.СкопироватьНастройкиОтчетовИПерсональныеНастройки(ХранилищеОбщихНастроек,
			Пользователь, Приемники, ВыбранныеНастройки.ПерсональныеНастройки);
	КонецЕсли;
		
	Если ВыбранныеНастройки.ПрочиеПользовательскиеНастройки.Количество() > 0 Тогда
		ПользователиСлужебный.ПриСохраненииПрочихПользовательскихНастроек(
			ВыбранныеНастройки.ПрочиеПользовательскиеНастройки[0], Приемники);
	КонецЕсли;
		
	Если НеСкопированныеНастройкиОтчетов.Количество() <> 0 Тогда
		Отчет = Обработки.НастройкиПользователей.ФормированиеОтчетаОКопировании(
			НеСкопированныеНастройкиОтчетов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КопированиеВсехНастроек()
	
	Пользователь = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательСсылка);
	
	Если ПереключательКомуКопироватьНастройки = "ВыбраннымПользователям" Тогда
		Приемники = ПользователиПолучателиНастроек.МассивПользователей;
	Иначе
		Приемники = Новый Массив;
		ТаблицаПользователей = Новый ТаблицаЗначений;
		ТаблицаПользователей.Колонки.Добавить("Пользователь");
		ТаблицаПользователей = Обработки.НастройкиПользователей.ПользователиДляКопирования(ПользовательСсылка, ТаблицаПользователей, 
			ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.ВнешниеПользователи"));
		
		Для Каждого СтрокаТаблицы Из ТаблицаПользователей Цикл
			Приемники.Добавить(СтрокаТаблицы.Пользователь);
		КонецЦикла;
		
	КонецЕсли;
	
	КопируемыеНастройки = Новый Массив;
	КопируемыеНастройки.Добавить("НастройкиОтчетов");
	КопируемыеНастройки.Добавить("НастройкиВнешнегоВида");
	КопируемыеНастройки.Добавить("ПерсональныеНастройки");
	КопируемыеНастройки.Добавить("Избранное");
	КопируемыеНастройки.Добавить("НастройкиПечати");
	КопируемыеНастройки.Добавить("ПрочиеПользовательскиеНастройки");
	
	НастройкиСкопированы = Обработки.НастройкиПользователей.
		КопированиеНастроекПользователей(ПользовательСсылка, Приемники, КопируемыеНастройки);
		
	Возврат НастройкиСкопированы;
	
КонецФункции

&НаСервере
Процедура ПроверитьАктивныхПользователей()
	
	Если ПользователиПолучателиНастроек <> Неопределено Тогда
		МассивПользователей = ПользователиПолучателиНастроек.МассивПользователей;
	КонецЕсли;
	
	Если ПереключательКомуКопироватьНастройки = "ВсемПользователям" Тогда
		
		МассивПользователей = Новый Массив;
		ТаблицаПользователей = Новый ТаблицаЗначений;
		ТаблицаПользователей.Колонки.Добавить("Пользователь");
		ТаблицаПользователей = Обработки.НастройкиПользователей.ПользователиДляКопирования(ПользовательСсылка, ТаблицаПользователей, 
			ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.ВнешниеПользователи"));
		
		Для Каждого СтрокаТаблицы Из ТаблицаПользователей Цикл
			МассивПользователей.Добавить(СтрокаТаблицы.Пользователь);
		КонецЦикла;
		
	КонецЕсли;
	
	Если МассивПользователей.Количество() = 1 
		И МассивПользователей[0] = Пользователи.ТекущийПользователь() Тогда
		
		РезультатПроверки = "ТекущийПользовательПолучатель";
		Возврат;
		
	КонецЕсли;
		
	ЕстьАктивныеПользователиПолучатели = Ложь;
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	Для Каждого Получатель Из МассивПользователей Цикл
		Если Получатель = Пользователи.ТекущийПользователь() Тогда
			РезультатПроверки = "ТекущийПользовательСредиПолучателей";
			Возврат;
		КонецЕсли;
		Для Каждого Сеанс Из Сеансы Цикл
			Если Получатель.ИдентификаторПользователяИБ = Сеанс.Пользователь.УникальныйИдентификатор Тогда
				ЕстьАктивныеПользователиПолучатели = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	РезультатПроверки = ?(ЕстьАктивныеПользователиПолучатели, "ЕстьАктивныеПользователиПолучатели", "");
	
КонецПроцедуры
