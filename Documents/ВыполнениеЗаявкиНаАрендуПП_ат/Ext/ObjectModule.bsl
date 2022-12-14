
	//Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	//// Данный фрагмент построен конструктором.
	//// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	//Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаАрендуПП_ат") Тогда
	//	// Заполнение шапки
	//	Действие = ДанныеЗаполнения.Действие;
	//	Клиент = ДанныеЗаполнения.Клиент;
	//	ДокументОснование = ДанныеЗаполнения.Ссылка;
	//	Для Каждого ТекСтрокаАрендуемыеПП Из ДанныеЗаполнения.АрендуемыеПП Цикл
	//		НоваяСтрока = Поставки.Добавить();
	//		НоваяСтрока.Количество = ТекСтрокаАрендуемыеПП.Количество;
	//		НоваяСтрока.ПродуктДляАренды = ТекСтрокаАрендуемыеПП.ПоставкаПП;
	//	КонецЦикла;
	//КонецЕсли;
	////}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	//КонецПроцедуры

	Процедура ОбработкаПроведения(Отказ, Режим)
		Если Действие = Перечисления.ДействиеПоЗаявкеНаАрендуПП_ат.ЗаказПП тогда
			
			Движения.АрендаПП_ат.Записывать = Истина;
			Для Каждого ТекСтрокаПоставки Из Поставки Цикл
				Движение = Движения.АрендаПП_ат.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.ПоставкаПродукта = ТекСтрокаПоставки.Поставка;
				Движение.Клиент = ДокументОснование.Ссылка.Клиент;
				Движение.ПродуктДляАренды = ТекСтрокаПоставки.ПродуктДляАренды;
				Движение.Организация = Организация;
				Движение.Договор = Договор;
				Движение.Ресурс = ТекСтрокаПоставки.Количество;
			КонецЦикла;
			
		// создаем допик договора:
				
		//Если УчетУслуг_ат.ФормированиеДопДоговора(Договор,ДокументОснование) = истина тогда
			//иначе отказ = Истина;
		//КонецЕсли;
		
	
			
		ИначеЕсли Действие = Перечисления.ДействиеПоЗаявкеНаАрендуПП_ат.ОтказПП тогда
			
			Движения.АрендаПП_ат.Записывать = Истина;
			Для Каждого ТекСтрокаПоставки Из Поставки Цикл
				Движение = Движения.АрендаПП_ат.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.ПоставкаПродукта = ТекСтрокаПоставки.Поставка;
				Движение.Клиент = ДокументОснование.Ссылка.Клиент;
				Движение.Организация = Организация;
				Движение.Договор = Договор;
				Движение.ПродуктДляАренды = ТекСтрокаПоставки.ПродуктДляАренды;
				Движение.Ресурс = ТекСтрокаПоставки.Количество;
			КонецЦикла;
		КонецЕсли;
	
	КонецПроцедуры
	
	&НаСервере
	Процедура ПриЗаписи(Отказ)

	ЗаписьСтатуса = РегистрыСведений.СтатусыЗаявокНаАренду_ат.СоздатьНаборЗаписей();
	ЗаписьСтатуса.Отбор.Заявка.Установить(ЭтотОбъект.ДокументОснование);
	
	НаборСведений = ЗаписьСтатуса.Добавить();
	НаборСведений.Заявка = ЭтотОбъект.ДокументОснование;
	НаборСведений.Период = ТекущаяДата();
	
	Если ЭтотОбъект.Проведен = ложь и ЭтотОбъект.ПометкаУдаления = ложь тогда
		НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ВОбработке;
	ИначеЕсли ЭтотОбъект.ПометкаУдаления = Истина тогда
		НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.Отклонена;
	ИначеЕсли ЭтотОбъект.Проведен = Истина тогда 
		НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты;
	КонецЕсли;
	
	НаборСведений.Пользователь = Пользователи.ТекущийПользователь();
	НаборСведений.Регистратор = ЭтотОбъект;
	ЗаписьСтатуса.Записать(Истина);

		
	КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	если РежимЗаписи = РежимЗаписиДокумента.Запись тогда		
		//если документ записан 	
		ЗаписьСтатуса = РегистрыСведений.СтатусыЗаявокНаАренду_ат.СоздатьНаборЗаписей();
		ЗаписьСтатуса.Отбор.Заявка.Установить(ЭтотОбъект.ДокументОснование);
		НаборСведений = ЗаписьСтатуса.Добавить();
		НаборСведений.Заявка = ЭтотОбъект.ДокументОснование;
		НаборСведений.Период = ТекущаяДата();
		НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении;
		НаборСведений.Пользователь = Пользователи.ТекущийПользователь();
		НаборСведений.Регистратор = ЭтотОбъект;
		ЗаписьСтатуса.Записать(Истина);
		
	Иначеесли РежимЗаписи = РежимЗаписиДокумента.Проведение тогда
		ЗаписьСтатуса = РегистрыСведений.СтатусыЗаявокНаАренду_ат.СоздатьНаборЗаписей();
		ЗаписьСтатуса.Отбор.Заявка.Установить(ЭтотОбъект.ДокументОснование);
		НаборСведений = ЗаписьСтатуса.Добавить();
		НаборСведений.Заявка = ЭтотОбъект.ДокументОснование;
		НаборСведений.Период = ТекущаяДата();
		НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты;
		НаборСведений.Пользователь = Пользователи.ТекущийПользователь();
		НаборСведений.Регистратор = ЭтотОбъект;
		ЗаписьСтатуса.Записать(Истина);
		
		
	Иначеесли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения тогда
		ЗаписьСтатуса = РегистрыСведений.СтатусыЗаявокНаАренду_ат.СоздатьНаборЗаписей();
		ЗаписьСтатуса.Отбор.Заявка.Установить(ЭтотОбъект.ДокументОснование);
		НаборСведений = ЗаписьСтатуса.Добавить();
		НаборСведений.Заявка = ЭтотОбъект.ДокументОснование;
		НаборСведений.Период = ТекущаяДата();
		НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.Отклонена;
		НаборСведений.Пользователь = Пользователи.ТекущийПользователь();
		НаборСведений.Регистратор = ЭтотОбъект;
		ЗаписьСтатуса.Записать(Истина);
	КонецЕсли
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	ПометкаУдаления = ложь;
	Основание = ДокументОснование;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры_ат.Ссылка
		|ИЗ
		|	Справочник.Договоры_ат КАК Договоры_ат
		|ГДЕ
		|	Договоры_ат.ПометкаУдаления = &ПометкаУдаления
		|	И Договоры_ат.Основание = &Основание";
	
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Дог = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		дог.ПометкаУдаления = Истина;
		Дог.Записать();
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;      // только это почему-то не работает...
	
	ДокументВыполнениеЗаявки = Аренда_ат.ПолучаемАктивныйДокументВыполненияЗаявки(ДанныеЗаполнения);
	Если  ДокументВыполнениеЗаявки = Неопределено тогда

	Аренда_ат.СоздатьВыполнениеЗаявки(ДанныеЗаполнения, ЭтотОбъект);	

		
	Иначе
		сообщение = "У данной завки уже есть документ-выполнение!  => "+ Символы.ПС  +ДокументВыполнениеЗаявки + Символы.ПС + 
		"Новый документ создан не будет!";
		ВызватьИсключение сообщение;
	КонецЕсли;	
КонецПроцедуры



//		Действие 			= ДанныеЗаполнения.Действие;
//		Клиент 				= ДанныеЗаполнения.Клиент;
//		ДокументОснование 	= ДанныеЗаполнения.Ссылка;
//		Тикет 				= ДанныеЗаполнения.Тикет;
//		Для Каждого ТекСтрокаАрендуемыеПП Из ДанныеЗаполнения.АрендуемыеПП Цикл
//			НоваяСтрока = Поставки.Добавить();
//			НоваяСтрока.Количество = ТекСтрокаАрендуемыеПП.Количество;
//			НоваяСтрока.ПродуктДляАренды = ТекСтрокаАрендуемыеПП.ПоставкаПП;
//		КонецЦикла;
//		Дата 				= ТекущаяДата();
//		



//Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
//	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаАрендуПП_ат") Тогда
//		// Заполнение шапки
//		Действие = ДанныеЗаполнения.Действие;
//		Клиент = ДанныеЗаполнения.Клиент;
//		ДокументОснование = ДанныеЗаполнения.Ссылка;
//		Тикет = ДанныеЗаполнения.Тикет;
//		Для Каждого ТекСтрокаАрендуемыеПП Из ДанныеЗаполнения.АрендуемыеПП Цикл
//			НоваяСтрока = Поставки.Добавить();
//			НоваяСтрока.Количество = ТекСтрокаАрендуемыеПП.Количество;
//			НоваяСтрока.ПродуктДляАренды = ТекСтрокаАрендуемыеПП.ПоставкаПП;
//		КонецЦикла;
//	КонецЕсли;

//КонецПроцедуры
