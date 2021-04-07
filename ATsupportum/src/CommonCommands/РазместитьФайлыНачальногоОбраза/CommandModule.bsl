&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ЕстьФайлыВТомах() Тогда
		Предупреждение(НСтр("ru = 'Файлы в томах отсутствуют.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ВыборПутиКАрхивуФайловТомов", , ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

&НаСервере
Функция ЕстьФайлыВТомах()
	
	Возврат ФайловыеФункцииСлужебный.ЕстьФайлыВТомах();
	
КонецФункции
