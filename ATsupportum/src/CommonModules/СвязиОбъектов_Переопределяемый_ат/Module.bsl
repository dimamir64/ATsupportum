
Процедура ЗаполнениеСтрокиДерева(СтрокаДерева, Источник) Экспорт
	
	СтрокаДерева.Код = Источник.Код;
	НаименованиеКартинки = "СвязиОбъектов_ТипыСвязей_" + Источник.ТипСвязи.Наименование + "_ат";
	Если Метаданные.ОбщиеКартинки.Найти(НаименованиеКартинки) <> Неопределено Тогда
		СтрокаДерева.Картинка = БиблиотекаКартинок[НаименованиеКартинки];
	КонецЕсли;
	
КонецПроцедуры
