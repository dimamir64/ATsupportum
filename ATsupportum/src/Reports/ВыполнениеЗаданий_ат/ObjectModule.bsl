
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Если НЕ КомпоновщикНастроек.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти("ВыводитьОтбор").Значение Тогда
		
		КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор").Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
		КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор").Использование = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
