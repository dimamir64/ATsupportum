
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтбираемыеРоли") Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("ОтбираемыеРоли", Параметры.ОтбираемыеРоли);
		
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагенты") Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("Контрагенты", Параметры.Контрагенты);
		
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделения")
		И (ЗначениеЗаполнено(Параметры.Подразделения)
			ИЛИ (НЕ ЗначениеЗаполнено(Параметры.Подразделения) И НЕ Параметры.НеОтбиратьПоПустомуПодразделению)) Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("Подразделения", Параметры.Подразделения);
		
	КонецЕсли;
	
КонецПроцедуры
