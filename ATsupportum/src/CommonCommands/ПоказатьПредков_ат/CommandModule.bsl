
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Параметры = Новый Структура("ОтображаемыеСвязи, Ссылка", "Предки", ПараметрКоманды);
	
	ОткрытьФорму("ОбщаяФорма.СвязанныеОбъекты_ат", Параметры, ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
