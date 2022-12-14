
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Сервер") И ЗначениеЗаполнено(Параметры.Сервер) Тогда
		
		Сервер = Параметры.Сервер;
		Элементы.Сервер.Доступность = Ложь;
	КонецЕсли;

	Если Параметры.Свойство("Пользователь") И ЗначениеЗаполнено(Параметры.Пользователь) Тогда
		
		Пользователь = Параметры.Пользователь;
		Элементы.Пользователь.Доступность = Ложь;
	КонецЕсли;
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СписокУведомляемыхОСтатусахСерверов_ат.Сервер,
		|	СписокУведомляемыхОСтатусахСерверов_ат.Пользователь,
		|	СписокУведомляемыхОСтатусахСерверов_ат.Параметр
		|ИЗ
		|	РегистрСведений.СписокУведомляемыхОСтатусахСерверов_ат КАК СписокУведомляемыхОСтатусахСерверов_ат
		|ГДЕ
		|	СписокУведомляемыхОСтатусахСерверов_ат.Пользователь = &Пользователь
		|	И СписокУведомляемыхОСтатусахСерверов_ат.Сервер = &Сервер";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Сервер", Сервер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВДЗ = РезультатЗапроса.Выбрать();
	
	Пока ВДЗ.Следующий() Цикл
		
		Если 			ВДЗ.Параметр = Перечисления.ПараметрыСерверов_ат.УведомлятьОбОтсутствииСвязи 								тогда
			ОНедоступностиСервера 			= Истина;
		ИначеЕсли 	ВДЗ.Параметр = Перечисления.ПараметрыСерверов_ат.УведомлятьОПредельнойЗагрузкеПроцессора					тогда
			ОВысокойНагрузкеCPU				= Истина;
		ИначеЕсли 	ВДЗ.Параметр = Перечисления.ПараметрыСерверов_ат.УведомлятьОПредельнойЗагрузкеПамяти						тогда
			ОВысокойНагруженностиПамяти 	= Истина;
		ИначеЕсли 	ВДЗ.Параметр = Перечисления.ПараметрыСерверов_ат.УведомлятьОПороговомЗаполненииДисковойПодсистемы		тогда
			ОВысокомНаполненииHDD			= Истина;
		ИначеЕсли 	ВДЗ.Параметр = Перечисления.ПараметрыСерверов_ат.УведомлятьОКритическойЗагрузкеПроцессора				тогда
			ОКритическойНагруженностиCPU 	= Истина;
		ИначеЕсли 	ВДЗ.Параметр = Перечисления.ПараметрыСерверов_ат.УведомлятьОКритическойЗагрузкеПамяти						тогда
			ОКритическойЗагруженностиПамяти= Истина;
		ИначеЕсли 	ВДЗ.Параметр = Перечисления.ПараметрыСерверов_ат.УведомлятьОКритическомЗаполненииДискокойПодсистемы	тогда
			ОКритическомЗаполненииHDD  		= Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
КонецПроцедуры

&НаСервере
Процедура СохранитьИЗакрытьНаСервере()
	
	НаборЗаписей = РегистрыСведений.СписокУведомляемыхОСтатусахСерверов_ат.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.Сервер.Установить(Сервер);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	Если ОНедоступностиСервера = истина тогда
		ОСН 						= НаборЗаписей.Добавить();
	    ОСН.Пользователь	= Пользователь;
		ОСН.Сервер			= Сервер;
		ОСН.Параметр			= Перечисления.ПараметрыСерверов_ат.УведомлятьОбОтсутствииСвязи;
	КонецЕсли;
	
	Если ОВысокойНагрузкеCPU = истина тогда
		ВНП 						= НаборЗаписей.Добавить();
	    ВНП.Пользователь	= Пользователь;
		ВНП.Сервер			= Сервер;
		ВНП.Параметр			= Перечисления.ПараметрыСерверов_ат.УведомлятьОПредельнойЗагрузкеПроцессора
	КонецЕсли;
	
	Если ОВысокойНагруженностиПамяти = истина тогда
		ВНМ 						= НаборЗаписей.Добавить();
	    ВНМ.Пользователь	= Пользователь;
		ВНМ.Сервер			= Сервер;
		ВНМ.Параметр			= Перечисления.ПараметрыСерверов_ат.УведомлятьОПредельнойЗагрузкеПамяти;
	КонецЕсли;
	
	Если ОВысокомНаполненииHDD = истина тогда
		ВНД 						= НаборЗаписей.Добавить();
	    ВНД.Пользователь	= Пользователь;
		ВНД.Сервер			= Сервер;
		ВНД.Параметр			= Перечисления.ПараметрыСерверов_ат.УведомлятьОПороговомЗаполненииДисковойПодсистемы	КонецЕсли;
	
	Если ОКритическойНагруженностиCPU = истина тогда
		КНП 						= НаборЗаписей.Добавить();
	    КНП.Пользователь	= Пользователь;
		КНП.Сервер			= Сервер;
		КНП.Параметр			= Перечисления.ПараметрыСерверов_ат.УведомлятьОКритическойЗагрузкеПроцессора;
	КонецЕсли;
	
	Если ОКритическойЗагруженностиПамяти = истина тогда
		КНМ 						= НаборЗаписей.Добавить();
	    КНМ.Пользователь	= Пользователь;
		КНМ.Сервер			= Сервер;
		КНМ.Параметр			= Перечисления.ПараметрыСерверов_ат.УведомлятьОКритическойЗагрузкеПамяти;
	КонецЕсли;
	
	Если ОКритическомЗаполненииHDD = истина тогда
		КНД 						= НаборЗаписей.Добавить();
	    КНД.Пользователь	= Пользователь;
		КНД.Сервер			= Сервер;
		КНД.Параметр			= Перечисления.ПараметрыСерверов_ат.УведомлятьОКритическомЗаполненииДискокойПодсистемы;
	КонецЕсли;
	НаборЗаписей.Записать(Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
//	СохранитьИЗакрытьНаСервере();
СписокПараметровПользователя= Новый Структура ;
СписокПараметровПользователя.Вставить("Уведомляемый", Пользователь);
СписокПараметровПользователя.Вставить("УведомлятьОбОтсутствииСвязи", ОНедоступностиСервера);
СписокПараметровПользователя.Вставить("УведомлятьОПредельнойЗагрузкеПроцессора", ОВысокойНагрузкеCPU);
СписокПараметровПользователя.Вставить("УведомлятьОПредельнойЗагрузкеПамяти", ОВысокойНагруженностиПамяти);
СписокПараметровПользователя.Вставить("УведомлятьОПороговомЗаполненииДисковойПодсистемы", ОВысокомНаполненииHDD);
СписокПараметровПользователя.Вставить("УведомлятьОКритическойЗагрузкеПроцессора", ОКритическойНагруженностиCPU);
СписокПараметровПользователя.Вставить("УведомлятьОКритическойЗагрузкеПамяти", ОКритическойЗагруженностиПамяти);
СписокПараметровПользователя.Вставить("УведомлятьОКритическомЗаполненииДискокойПодсистемы", ОКритическомЗаполненииHDD);


//Оповестить("ОбновитьСписокУведомляемых");
	Закрыть(СписокПараметровПользователя);
КонецПроцедуры
