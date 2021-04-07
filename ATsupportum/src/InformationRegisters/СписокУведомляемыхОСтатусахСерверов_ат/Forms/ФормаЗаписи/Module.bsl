
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Сервер") И ЗначениеЗаполнено(Параметры.Сервер) Тогда
		
		Запись.Сервер = Параметры.Сервер;
		Элементы.Сервер.Доступность = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

//&НаКлиенте
//Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
//	
//	Если НЕ ЗаданВопрос Тогда 
//		
//		Отказ = Истина;	
//		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("РезультатВопроса", ЭтаФорма);
//		ТектсВопроса = "У пользователя не указан e-mail, вы ДЕЙСТВИТЕЛЬНО! хотите указать ПОЛЬЗОВАТЕЛЯ БЕЗ E-MAIL?";
//		ПоказатьВопрос(ОписаниеОповещенияОЗакрытии, ТектсВопроса, РежимДиалогаВопрос.ДаНет,,,"Внимание! данные не заполнены!!",);
//		
//	Иначе
//		
//		Если РазрешениеЗакрытия тогда 
//			Закрыть();
//		КонецЕсли;

//		
//	КонецЕсли;

//КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	Проверка = ПроверкаНаличияУПользователяЭлектроннойПочты(Запись.Пользователь);

	Если Проверка= Ложь Тогда
		//ЗапретЗакрытия = Истина;
		СБЩ = Новый СообщениеПользователю;
		СБЩ.Текст = "У данного пользователя не заполнено поле контактной информации " +  Символ(34)+"Email  для уведомлений" + Символ(34);
	//     СБЩ.Поле = Элементы.Пользователь;
		СБЩ.Сообщить();
	Иначе
	КонецЕсли;

КонецПроцедуры

//&НаКлиенте
//Процедура РезультатВопроса(Результат, ДополнительныеПараметры = Неопределено) Экспорт
//	
//	Если НЕ  Результат = Неопределено Тогда
//	
//		Если Результат = КодВозвратаДиалога.Да Тогда 
//			ЗаданВопрос = Истина;
//			ЗаписатьИЗакрыть(Неопределено);
//			//ЗапретЗакрытия = ложь;
//		Иначе
//			РазрешениеЗакрытия = Ложь;

//		КонецЕсли;
//		
//	КонецЕсли;
//	

//		
//КонецПроцедуры

&НаСервере
Функция ПроверкаНаличияУПользователяЭлектроннойПочты(Пользователь)
	
	 	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПользователиКонтактнаяИнформация.АдресЭП КАК Адрес,
		|	ПользователиКонтактнаяИнформация.Представление
		|ИЗ
		|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
		|ГДЕ
		|	ПользователиКонтактнаяИнформация.Ссылка = &Пользователь
		|	И ПользователиКонтактнаяИнформация.Вид = &Вид";
	
//	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.EmailПользователяДляУведомлений);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() тогда
		Возврат ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//  
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//КонецЦикла;
	//
	//Возврат    Неопределено;
	////}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
КонецФункции

//&НаСервере
//Процедура ЗаписатьИЗакрытьНаСервере()
//	
//	ЗаписатьНаСервере();
//КонецПроцедуры

//&НаКлиенте
//Процедура ЗаписатьИЗакрыть(Команда)
//	РазрешениеЗакрытия = истина;
//	Записать();
//КонецПроцедуры

//&НаСервере
//Процедура ЗаписатьНаСервере()
//	
//	//МенеджерЗаписи = РегистрыСведений.СписокУведомляемыхОСтатусахСерверов_ат.СоздатьМенеджерЗаписи();
//	//МенеджерЗаписи.Период 		= ТекущаяДата();
//	//МенеджерЗаписи.Сервер 		= Запись.Сервер;
//	//МенеджерЗаписи.Пользователь	= Запись.Пользователь;
//	//МенеджерЗаписи.Параметр		= Запись.Параметр;	
//	//МенеджерЗаписи.Записать();
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ЗаписатьИзменения(Команда)
//	ЗаписатьНаСервере();
//КонецПроцедуры

