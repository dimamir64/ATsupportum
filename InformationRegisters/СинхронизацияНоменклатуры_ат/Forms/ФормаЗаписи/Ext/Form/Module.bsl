
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИБ = Константы.БухгалтерияДляСинхронизации_ат.Получить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НавигационнаяСсылкаПриИзменении(Элемент)
	
	Запись.Идентификатор = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Синхронизировать(Команда)
	
	Если НЕ ОбязательныеРеквизитыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Запись.НавигационнаяСсылка) Тогда
		
		ПоказатьПредупреждение(, "Навигационная ссылка не заполнена!", 5);
		
	Иначе
		
		Оповещение = Новый ОписаниеОповещения("ПослеВопроса", ЭтаФорма);
		ПоказатьВопрос(Оповещение, "Номенклатура в выбранной ИБ Бухгалтерии Предприятия <" + ИБ + "> будет изменена. Продолжить?", РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовую(Команда)
	
	Если НЕ ОбязательныеРеквизитыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПослеВопроса", ЭтаФорма, "");
	
	ПоказатьВопрос(Оповещение, "В выбранной ИБ Бухгалтерии Предприятия <" + ИБ + "> будет создана новая Номенклатура. Продолжить?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция   ОбязательныереквизитыЗаполнены()
	
	ТекстПредупреждения = "";
	
	Если Запись.Ссылка.Пустая() Тогда
		ТекстПредупреждения = "Номенклатура должна быть выбрана!";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, СокрЛ(ТекстПредупреждения), 5);
	КонецЕсли;
	
	Возврат ТекстПредупреждения = "";
	
КонецФункции

&НаКлиенте
Процедура ПослеВопроса(Результат, Идентификатор) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждения = СинхронизироватьНоменклатуру(Идентификатор);
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, СокрЛП(ТекстПредупреждения), 5);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция   СинхронизироватьНоменклатуру(Идентификатор)
	
	ТекстПредупреждения = "";
	
	Если Идентификатор = Неопределено Тогда
		
		Подключение = ПодключениеКИБ_ат.УстановитьПодключение(ИБ);
		Если ТипЗнч(Подключение) = Тип("Строка") Тогда
			Возврат Подключение;
		КонецЕсли;
		
		СинхронизированнаяНоменклатура = ПодключениеКИБ_ат.ПолучитьВнешнююСсылкуПоНавигационнойСсылке(Подключение, Запись.НавигационнаяСсылка);
		Если СинхронизированнаяНоменклатура = Неопределено Тогда
			Возврат "Введённая навигационная ссылка не корректна для выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!";
		КонецЕсли;
		
		Идентификатор = Строки_КлиентСервер_ат.ПолучитьСтрУИдПоНавСсылке(Запись.НавигационнаяСсылка);
		
	КонецЕсли;
	
	РезультатСинхронизации = СинхронизацияСБП_ат.СинхронизироватьНоменклатуру(Запись.Ссылка, ИБ, Идентификатор);
	Если РезультатСинхронизации.Ошибки.Количество() > 0 Тогда
		
		Для каждого Ошибка Из РезультатСинхронизации.Ошибки Цикл
			ТекстПредупреждения = ТекстПредупреждения + Символы.ПС + Ошибка;
		КонецЦикла;
		
	Иначе
		
		Запись.НавигационнаяСсылка 	= РезультатСинхронизации.НавигационнаяСсылка;
		Запись.Идентификатор 		= РезультатСинхронизации.Идентификатор;
		
		Попытка
			
			Записать();
			
			ТекстПредупреждения = "Синхронизация прошла успешно";
			
		Исключение
			
			ТекстПредупреждения = ОписаниеОшибки();
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

#КонецОбласти
