////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Объект.Родитель = Справочники.РассылкиОтчетов.ЛичныеРассылки Тогда
			Объект.Родитель = Справочники.РассылкиОтчетов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
