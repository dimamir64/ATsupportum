#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Предотвращает изменение разделов дат запрета изменения,
// которые должны изменятся только в режиме конфигурирования.
//
Процедура ПередЗаписью(Отказ)
	
	Если Предопределенный И ОбменДанными.Загрузка Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ТипЗначения, Наименование"));
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение(НСтр("ru = 'Изменение разделов дат запрета изменения
	                             |выполняется только через конфигуратор.
	                             |
	                             |Удаление допустимо.'"));
	
КонецПроцедуры

#КонецЕсли