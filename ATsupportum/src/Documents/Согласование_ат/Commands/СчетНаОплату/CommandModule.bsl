
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Документ.СчетНаОплату_ат.ФормаОбъекта", Новый Структура("Основание", ПараметрКоманды),
		ПараметрыВыполненияКоманды.Источник, Новый УникальныйИдентификатор,
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
