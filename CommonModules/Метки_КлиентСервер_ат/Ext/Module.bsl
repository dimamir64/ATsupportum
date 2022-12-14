
Процедура УстановитьОтборСпискаПоСпискуЗначений(ОбъектФормыСписок, ИмяЭлементаОтбора, Знач СписокЗначений, ОтборПоКлючам = Ложь, ДобавлятьНулевоеЗначение = Истина) Экспорт
	
	ЭлементОтбора = Неопределено;
	
	Для Каждого ТекущийЭлементОтбора Из ОбъектФормыСписок.Отбор.Элементы Цикл
		
		Если ТипЗнч(ТекущийЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекущийЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяЭлементаОтбора) Тогда
			ЭлементОтбора = ТекущийЭлементОтбора;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭлементОтбора = Неопределено Тогда
		
		ЭлементОтбора = ОбъектФормыСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяЭлементаОтбора);
		
	КонецЕсли;
	
	СписокАктивныхОтборов = ПолучитьСписокАктивныхОтборов(СписокЗначений);
	
	Если ОтборПоКлючам Тогда
		
		СписокЗначений = Метки_ВызовСервера_ат.ПолучитьСписокКлючейДляОтбора(ИмяЭлементаОтбора, СписокЗначений, СписокАктивныхОтборов);
		Если ЗначениеЗаполнено(СписокЗначений)
			И ДобавлятьНулевоеЗначение Тогда // Если список заполнен, нужно отбирать и значения без ВС (0).
			
			СписокЗначений.Добавить(0);
			
		КонецЕсли;
		
	Иначе
		
		СписокЗначений = СписокАктивныхОтборов;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СписокЗначений) И ТипЗнч(СписокЗначений) = Тип("СписокЗначений") Тогда
		
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.ПравоеЗначение = СписокЗначений;
		
	Иначе
		
		ЭлементОтбора.Использование = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

Функция   ПолучитьСписокАктивныхОтборов(СписокОтборов) Экспорт
	
	СписокАктивныхОтборов = Новый СписокЗначений;
	Для Каждого ЭлементСпискаОтборов Из СписокОтборов Цикл
		
		Если ЭлементСпискаОтборов.Пометка Тогда
			СписокАктивныхОтборов.Добавить(ЭлементСпискаОтборов.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокАктивныхОтборов;
	
КонецФункции

Процедура УстановитьОтборСпискаПоТаблицеЗначений(Список, ТипЗначенияОбъекта, ТипЗначенияМеток,
	ИмяРеквизитаОтбора, ТаблицаЗначенийОтбора, ОтбиратьПоКлючу, ДобавлятьНулевоеЗначение, ОтключитьОтбор = Ложь,
	ГруппаОтбораПоМеткам = Неопределено, ПредставлениеОтбора = "Нет отбора") Экспорт
		
	Если НЕ ОтключитьОтбор Тогда
		
		МассивЗначенийИ		= Новый Массив;
		МассивЗначенийИЛИ	= Новый Массив;
		МассивЗначенийНЕ	= Новый Массив;
		ОтборыВключены		= Ложь;
		
		Для Каждого СтрокаТаблицыЗначенийОтборов Из ТаблицаЗначенийОтбора Цикл
			
			Если СтрокаТаблицыЗначенийОтборов.ИспользоватьИ Тогда
				МассивЗначенийИ.Добавить(СтрокаТаблицыЗначенийОтборов.Значение);
			ИначеЕсли СтрокаТаблицыЗначенийОтборов.ИспользоватьИЛИ Тогда
				МассивЗначенийИЛИ.Добавить(СтрокаТаблицыЗначенийОтборов.Значение);
			ИначеЕсли СтрокаТаблицыЗначенийОтборов.ИспользоватьНЕ Тогда
				МассивЗначенийНЕ.Добавить(СтрокаТаблицыЗначенийОтборов.Значение);
			КонецЕсли;
			
		КонецЦикла;
		
		НайденныеОбъекты = Метки_ВызовСервера_ат.ПолучитьСписокОбъектовОтбора(ТипЗначенияОбъекта, ТипЗначенияМеток,
			МассивЗначенийИ, МассивЗначенийИЛИ, МассивЗначенийНЕ, ДобавлятьНулевоеЗначение, ОтборыВключены);
		
	КонецЕсли;
	
	ЭлементОтбора = Неопределено;
	
	Для Каждого ТекущийЭлементОтбора Из Список.Отбор.Элементы Цикл
		
		Если ТипЗнч(ТекущийЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекущийЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка") Тогда
			ЭлементОтбора = ТекущийЭлементОтбора;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка")
	КонецЕсли;
	
	Если НЕ ОтключитьОтбор И (ОтборыВключены ИЛИ ДобавлятьНулевоеЗначение) Тогда
		
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.ПравоеЗначение = НайденныеОбъекты;
		
	Иначе
		
		ЭлементОтбора.Использование = Ложь;
		
	КонецЕсли;
	
	Если НЕ ГруппаОтбораПоМеткам = Неопределено Тогда
		
		Если НЕ ОтключитьОтбор И (ОтборыВключены ИЛИ ДобавлятьНулевоеЗначение) Тогда
			
			Если СтрНайти(ГруппаОтбораПоМеткам.Заголовок, " (!)") = 0 Тогда
				ГруппаОтбораПоМеткам.Заголовок = ГруппаОтбораПоМеткам.Заголовок + " (!)";
			КонецЕсли;
			
			ГруппаОтбораПоМеткам.Подсказка = ПредставлениеОтбора;
			
		Иначе
			
			ГруппаОтбораПоМеткам.Заголовок = СтрЗаменить(ГруппаОтбораПоМеткам.Заголовок, " (!)", "");
			ГруппаОтбораПоМеткам.Подсказка = ПредставлениеОтбора;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПредставленияВыбранныхМеток(Форма) Экспорт
	
	Для Каждого СтрокаВыборанныхМеток Из Форма.ВыбранныеМетки Цикл
		
		СтрокаВыборанныхМеток.Представление = Метки_ВызовСервера_ат.ПолучитьПредставлениеМеткиРекурсивно(СтрокаВыборанныхМеток.Значение);
		
	КонецЦикла;
	
КонецПроцедуры
