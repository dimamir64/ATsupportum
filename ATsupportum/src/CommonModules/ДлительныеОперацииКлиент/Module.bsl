////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Поддержка работы длительных серверных операций в веб-клиенте.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет структуру параметров значениями по умолчанию.
// 
// Параметры:
//  ПараметрыОбработчикаОжидания - Структура - заполняется значениями по умолчанию. 
//
// 
Процедура ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания = Новый Структура(
		"МинимальныйИнтервал,МаксимальныйИнтервал,ТекущийИнтервал,КоэффициентУвеличенияИнтервала", 1, 15, 1, 1.4);
	
КонецПроцедуры

// Заполняет структуру параметров новыми расчетными значениями.
// 
// Параметры:
//  ПараметрыОбработчикаОжидания - Структура - заполняется расчетными значениями. 
//
// 
Процедура ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
	Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
		ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с формой длительной операции
//

// Открывает форму-индикатор длительной операции.
// 
// Параметры:
//  ВладелецФормы        - УправляемаяФорма - форма, из которой производится открытие. 
//  ИдентификаторЗадания - УникальныйИдентификатор - Идентификатор фонового задания.
//
// Возвращаемое значение:
//  УправляемаяФорма     - ссылка на открытую форму.
// 
Функция ОткрытьФормуДлительнойОперации(Знач ВладелецФормы, Знач ИдентификаторЗадания) Экспорт
	
	ФормаДлительнойОперации = ДлительныеОперацииКлиентПовтИсп.ФормаДлительнойОперации();
	Если ФормаДлительнойОперации.Открыта() Тогда
		ФормаДлительнойОперации = ОткрытьФорму(
			"ОбщаяФорма.ДлительнаяОперация",
			Новый Структура("ИдентификаторЗадания", ИдентификаторЗадания), 
			ВладелецФормы);
	Иначе
		ФормаДлительнойОперации.ВладелецФормы        = ВладелецФормы;
		ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания;
		ФормаДлительнойОперации.Открыть();
	КонецЕсли;
	
	Возврат ФормаДлительнойОперации;
	
КонецФункции

// Закрывает форму-индикатор длительной операции.
// 
// Параметры:
//  СсылкаНаФорму - УправляемаяФорма - ссылка на форму-индикатор длительной операции. 
//
Процедура ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации) Экспорт
	
	Если ТипЗнч(ФормаДлительнойОперации) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если ФормаДлительнойОперации.Открыта() Тогда
			ФормаДлительнойОперации.Закрыть();
		КонецЕсли;
	КонецЕсли;
	ФормаДлительнойОперации = Неопределено;
	
КонецПроцедуры