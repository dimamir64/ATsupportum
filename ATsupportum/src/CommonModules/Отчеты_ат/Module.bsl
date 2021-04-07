
////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с Отчётами.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
 
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Форма.Отчет.РежимРасшифровки = (Форма.Параметры.Расшифровка <> Неопределено);
	
	ОтчетОбъект = Форма.РеквизитФормыВЗначение("Отчет");
	Форма.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, Форма.УникальныйИдентификатор);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОтчетОбъект, "Группировка")  Тогда
		
		ЗаполнитьГруппировокиИзКомпановщика(Форма.Отчет);
		
	КонецЕсли;
	
	Если ЕстьЭлементФормы(Форма, "ГруппировкаТипГруппировки") Тогда
		
		УстановитьУсловноеОформлениеТипГруппировки(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСохраненииВариантаНаСервере(Форма, Настройки) Экспорт
	
	ОтчетОбъект = Форма.РеквизитФормыВЗначение("Отчет");
	ОтчетМетаданные = ОтчетОбъект.Метаданные();
	
	ДополнительныеСвойства = Новый Структура;
	
	Для Каждого Реквизит Из ОтчетМетаданные.Реквизиты Цикл
		
		Если Реквизит.Имя <> "РежимРасшифровки" Тогда
			
			ДополнительныеСвойства.Вставить(Реквизит.Имя, ОтчетОбъект[Реквизит.Имя]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Реквизит Из ОтчетМетаданные.ТабличныеЧасти Цикл
		
		ДополнительныеСвойства.Вставить(Реквизит.Имя, ОтчетОбъект[Реквизит.Имя].Выгрузить());
		
	КонецЦикла;
	
	Настройки.ДополнительныеСвойства.Вставить("ДанныеОтчета", Новый ХранилищеЗначения(ДополнительныеСвойства));	
	
КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(Форма, Настройки) Экспорт
	
	Если Настройки = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Настройки.ДополнительныеСвойства.Свойство("ДанныеОтчета") Тогда
		
		ДополнительныеСвойства = Настройки.ДополнительныеСвойства.ДанныеОтчета.Получить();
		
		Для Каждого ЭлементСтруктуры Из ДополнительныеСвойства Цикл
			
			Если Форма.Отчет.Свойство(ЭлементСтруктуры.Ключ) Тогда
				
				Если ТипЗнч(ЭлементСтруктуры.Значение) = Тип("ТаблицаЗначений") Тогда
					
					Форма.Отчет[ЭлементСтруктуры.Ключ].Загрузить(ЭлементСтруктуры.Значение);
					
				ИначеЕсли ЭлементСтруктуры.Ключ <> "РежимРасшифровки" Тогда
					
					Форма.Отчет[ЭлементСтруктуры.Ключ] = ЭлементСтруктуры.Значение;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(Отчет) Экспорт
	
	Если Отчет.РежимРасшифровки ИЛИ Отчет.РасширеныеНастройки Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Структура = Неопределено;
	
	ЗаполнитьНастройкиИзГруппировок(Отчет, Структура);
	ПеренестиВыбранныеПоляВНастройки(Отчет.СхемаКомпоновкиДанных, Отчет.КомпоновщикНастроек, Структура);		
	
КонецПроцедуры

Процедура ЗаполнитьГруппировокиИзКомпановщика(Отчет) Экспорт
	
	Отчет.Группировка.Очистить();
	
	Для Каждого ЭлементСтруктуры Из Отчет.КомпоновщикНастроек.Настройки.Структура Цикл
		
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
			
			Для Каждого Серия Из ЭлементСтруктуры.Серии Цикл
				
				ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Серия, Отчет.Группировка);
					
				Прервать;
				
			КонецЦикла;
			
			Для Каждого Точка Из ЭлементСтруктуры.Точки Цикл
				
				ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Точка, Отчет.Группировка);
				
				Прервать;
				
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
			
			Для Каждого Колонка Из ЭлементСтруктуры.Колонки Цикл
				
				ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Колонка, Отчет.Группировка);
				
				Прервать;
				
			КонецЦикла;
			
			Для Каждого Строка Из ЭлементСтруктуры.Строки Цикл
				
				ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Строка, Отчет.Группировка);
				
				Прервать;
				
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") Тогда
			
			ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, ЭлементСтруктуры, Отчет.Группировка);
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры 

Процедура ЗаполнитьНастройкиИзГруппировок(Отчет, Структура = Неопределено) Экспорт
	
	Отчет.КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	Структура = Отчет.КомпоновщикНастроек.Настройки;
	
	Для Каждого ПолеВыбраннойГруппировки Из Отчет.Группировка Цикл 
		
		Если ПолеВыбраннойГруппировки.Использование Тогда
			
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
				
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
				
			Иначе
				
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
				
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры 

Процедура ПеренестиВыбранныеПоляВНастройки(СхемаКомпоновкиДанных, КомпоновщикНастроек, Структура) Экспорт
	
	ЕстьВыбранныеПоля = Ложь;
	ПроверитьВыбранныеПоля(КомпоновщикНастроек.Настройки.Выбор.Элементы, ЕстьВыбранныеПоля, СхемаКомпоновкиДанных);
	
	Если ЕстьВыбранныеПоля Тогда
		
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));

		ПолеГруппировкиДетально = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировкиДетально.Использование  = Истина;
		ПолеГруппировкиДетально.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
	КонецЕсли;		
	
	ДобавитьВыбранныеПоля(КомпоновщикНастроек.Настройки.Выбор.Элементы, Структура.Выбор);	
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция   ЕстьЭлементФормы(Форма, ИмяЭлемента)
	
	Возврат Форма.Элементы.Найти(ИмяЭлемента) <> Неопределено;
	
КонецФункции

Процедура УстановитьУсловноеОформлениеТипГруппировки(Форма)

	УсловноеОформление = Форма.УсловноеОформление;

	
	// Тип группировки "Без групп"

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ГруппировкаТипГруппировки");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Отчет.Группировка.ТипГруппировки", ВидСравненияКомпоновкиДанных.Равно, 0);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Без групп'"));


	// Тип группировки "С группами"

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ГруппировкаТипГруппировки");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Отчет.Группировка.ТипГруппировки", ВидСравненияКомпоновкиДанных.Равно, 1);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'С группами'"));


	// Тип группировки "Только группы"

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ГруппировкаТипГруппировки");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Отчет.Группировка.ТипГруппировки", ВидСравненияКомпоновкиДанных.Равно, 2);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Только группы'"));

КонецПроцедуры

Функция   ДобавитьОформляемоеПоле(КоллекцияОформляемыхПолей, ИмяПоля)
	
	ПолеЭлемента 		= КоллекцияОформляемыхПолей.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных(ИмяПоля);

	Возврат ПолеЭлемента;
	
КонецФункции

Процедура ЗаполнитьГруппировкиИзНастроек(КомпоновщикНастроек, Структура, Группировка)
	
	Если Структура.ПоляГруппировки.Элементы.Количество() > 0 Тогда
		
		Поле = Строка(Структура.ПоляГруппировки.Элементы[0].Поле);
		
		НоваяСтрока = Группировка.Добавить();
		
		НоваяСтрока.Использование  = Структура.Использование;
		НоваяСтрока.Поле           = Поле;
		НоваяСтрока.Представление  = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);
		ТипГруппировки = Структура.ПоляГруппировки.Элементы[0].ТипГруппировки;
		
		Если ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия Тогда
			НоваяСтрока.ТипГруппировки = 1;
		ИначеЕсли ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия Тогда
			НоваяСтрока.ТипГруппировки = 2;
		Иначе
			НоваяСтрока.ТипГруппировки = 0;
		КонецЕсли;
		
		Если Структура.Структура.Количество() > 0 Тогда
			ЗаполнитьГруппировкиИзНастроек(КомпоновщикНастроек, Структура.Структура[0], Группировка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция   ПолучитьСвойствоПоля(ЭлементСтруктура, Поле, Свойство = "Заголовок") Экспорт
	
	Если ТипЗнч(ЭлементСтруктура) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Коллекция = ЭлементСтруктура.Настройки.ДоступныеПоляВыбора;
	Иначе
		Коллекция = ЭлементСтруктура;
	КонецЕсли;
	
	ПолеСтрокой = Строка(Поле);
	ПозицияКвадратнойСкобки = СтрНайти(ПолеСтрокой, "[");
	Окончание = "";
	Заголовок = "";
	
	Если ПозицияКвадратнойСкобки > 0 Тогда
		Окончание = Сред(ПолеСтрокой, ПозицияКвадратнойСкобки);
		ПолеСтрокой = Лев(ПолеСтрокой, ПозицияКвадратнойСкобки - 2);
	КонецЕсли;
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолеСтрокой, ".");
	
	Если НЕ ПустаяСтрока(Окончание) Тогда
		МассивСтрок.Добавить(Окончание);
	КонецЕсли;
	
	ДоступныеПоля = Коллекция.Элементы;
	ПолеПоиска = "";
	
	Для Индекс = 0 По МассивСтрок.Количество() - 1 Цикл
		
		ПолеПоиска = ПолеПоиска + ?(Индекс = 0, "", ".") + МассивСтрок[Индекс];
		ДоступноеПоле = ДоступныеПоля.Найти(ПолеПоиска);
		
		Если ДоступноеПоле <> Неопределено Тогда
			ДоступныеПоля = ДоступноеПоле.Элементы;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДоступноеПоле <> Неопределено Тогда
		
		Если Свойство = "ДоступноеПоле" Тогда
			Результат = ДоступноеПоле;
		Иначе
			Результат = ДоступноеПоле[Свойство]; 
		КонецЕсли;
		
	Иначе
		
		Результат = Неопределено;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура проверяет, есть ли выбранные поля 
Процедура ПроверитьВыбранныеПоля(Элементы, ЕстьВыбранныеПоля, Схема = Неопределено)
	
	Для Каждого Элемент Из Элементы Цикл
		
		Если Элемент.Использование Тогда
			
			ЭтоГруппа = (ТипЗнч(Элемент) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			
			Если НЕ ЭтоГруппа И Схема.ПоляИтога.Найти(Строка(Элемент.Поле)) = Неопределено Тогда
				
				ЕстьВыбранныеПоля = Истина; 
				
				Возврат;
				
			КонецЕсли;
			
			Если ЭтоГруппа Тогда
				
				ПроверитьВыбранныеПоля(Элемент.Элементы, ЕстьВыбранныеПоля, Схема);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Процедура добавляет выбранные поля в набор выбранных полей
Процедура ДобавитьВыбранныеПоля(Элементы, ЭлементСтруктуры)
	
	ВыбранныеПоля = ЭлементСтруктуры;
	
	Для Каждого Элемент Из Элементы Цикл
		
		Если Элемент.Использование Тогда
			
			ЭтоГруппа = (ТипЗнч(Элемент) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			
			Если ЭтоГруппа Тогда
				
				ВыбранноеПоле = ВыбранныеПоля.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				ВыбранноеПоле.Использование = Истина;
				ВыбранноеПоле.Расположение  = Элемент.Расположение;

			Иначе
				
				ВыбранноеПоле = ВыбранныеПоля.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				ВыбранноеПоле.Поле = Элемент.Поле;
				
			КонецЕсли;	
			
			Если Элемент.Заголовок <> Неопределено Тогда
				
				ВыбранноеПоле.Заголовок = Элемент.Заголовок;
				
			КонецЕсли;
			
			Если ЭтоГруппа Тогда
				
				ДобавитьВыбранныеПоля(Элемент.Элементы, ВыбранноеПоле);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
