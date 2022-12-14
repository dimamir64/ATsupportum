
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ЗаявкаПомеченаНаУдаление(ПараметрКоманды) Тогда
		
		ПоказатьПредупреждение(, "Родительская Заявка не должна быть помечена на удаление!", 5);
		
		Возврат;
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.Заявка_ат.ФормаОбъекта", Новый Структура("Шаблон", ПараметрКоманды));
	
КонецПроцедуры

&НаСервере
Функция   ЗаявкаПомеченаНаУдаление(Заявка)
	
	Возврат Заявка.ПометкаУдаления;
	
КонецФункции 