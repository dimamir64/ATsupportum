////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Информация = Параметры.Информация;
	Заголовок =  Параметры.Заголовок;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Да(Команда)
	СтруктураВозврата = Новый Структура("ПрименитьКоВсем, КодВозврата", 
		ПрименитьКоВсем, КодВозвратаДиалога.Да);
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура Нет(Команда)
	СтруктураВозврата = Новый Структура("ПрименитьКоВсем, КодВозврата", 
		ПрименитьКоВсем, КодВозвратаДиалога.Нет);
	Закрыть(СтруктураВозврата);
КонецПроцедуры
