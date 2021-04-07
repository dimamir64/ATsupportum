
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Свойства = ДатыЗапретаИзмененияПовтИсп.СвойстваРазделов();
	
	// Установка варианта отчета.
	Если Параметры.ПоРазделамОбъектам = Истина Тогда
		
		Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
			УстановитьТекущийВариант("ДатыЗапретаИзмененияПоРазделамОбъектамДляПользователей");
			
		ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
			УстановитьТекущийВариант("ДатыЗапретаИзмененияПоРазделамДляПользователей");
		Иначе
			УстановитьТекущийВариант("ДатыЗапретаИзмененияПоОбъектамДляПользователей");
		КонецЕсли;
	Иначе
		Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
			УстановитьТекущийВариант("ДатыЗапретаИзмененияПоПользователям");
			
		ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
			УстановитьТекущийВариант("ДатыЗапретаИзмененияПоПользователямБезОбъектов");
		Иначе
			УстановитьТекущийВариант("ДатыЗапретаИзмененияПоПользователямБезРазделов");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

