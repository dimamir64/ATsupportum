
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И Ссылка.Услуга <> Услуга Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Номенклатура_ат.Ссылка
			|ИЗ
			|	Справочник.Номенклатура_ат КАК Номенклатура_ат
			|ГДЕ
			|	Номенклатура_ат.ВидНоменклатуры = &ВидНоменклатуры";
		
		Запрос.УстановитьПараметр("ВидНоменклатуры", Ссылка);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя изменять признак ""Услуга"" если есть номенклатурыне позиции данного вида.";
			Сообщение.Сообщить();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
