#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Возврат Взаимодействия.ПолучитьУчастниковПоТаблице(Ссылка);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Взаимодействия.ОбработкаПолученияДанныхВыбора(
		ДанныеВыбора,
		Параметры,
		СтандартнаяОбработка, 
		"ЗапланированноеВзаимодействие");
	
КонецПроцедуры



#КонецЕсли