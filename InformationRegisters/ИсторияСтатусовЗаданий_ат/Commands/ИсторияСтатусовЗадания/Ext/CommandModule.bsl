
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыОткрытия = Новый Структура("Отбор", Новый Структура("Ссылка", ПараметрКоманды));
	ОткрытьФорму("РегистрСведений.ИсторияСтатусовЗаданий_ат.ФормаСписка", ПараметрыОткрытия,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
