////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	Если НЕ ЗначениеЗаполнено(ТекущийОбъект.ОсновнойОбъектАдресации) Тогда
		ТекущийОбъект.ОсновнойОбъектАдресации = Неопределено;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекущийОбъект.ДополнительныйОбъектАдресации) Тогда
		ТекущийОбъект.ДополнительныйОбъектАдресации = Неопределено;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте                
Процедура РольИсполнителяПриИзменении(Элемент)
	
	Запись.ОсновнойОбъектАдресации = Неопределено;
	Запись.ДополнительныйОбъектАдресации = Неопределено;
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьСостояниеЭлементов()

	ТипыОсновногоОбъектаАдресации = Запись.РольИсполнителя.ТипыОсновногоОбъектаАдресации.ТипЗначения;
	ТипыДополнительногоОбъектаАдресации = Запись.РольИсполнителя.ТипыДополнительногоОбъектаАдресации.ТипЗначения;
	ИспользуетсяСОбъектамиАдресации = Запись.РольИсполнителя.ИспользуетсяСОбъектамиАдресации;
	ИспользуетсяБезОбъектовАдресации = Запись.РольИсполнителя.ИспользуетсяБезОбъектовАдресации;
	
	ЗаданаРоль = НЕ Запись.РольИсполнителя.Пустая();
	ЗаголовокОсновногоОбъектаАдресации = ?(ЗаданаРоль, Строка(Запись.РольИсполнителя.ТипыОсновногоОбъектаАдресации), "");
	ЗаголовокДополнительногоОбъектаАдресации = ?(ЗаданаРоль, Строка(Запись.РольИсполнителя.ТипыДополнительногоОбъектаАдресации), "");
	
	ЗаданыТипыОсновногоОбъектаАдресации = ЗаданаРоль И ИспользуетсяСОбъектамиАдресации
		И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ЗаданаРоль И ИспользуетсяСОбъектамиАдресации 
		И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
	Элементы.ОсновнойОбъектАдресации.Доступность = ЗаданыТипыОсновногоОбъектаАдресации;
	Элементы.ДополнительныйОбъектАдресации.Доступность = ЗаданыТипыДополнительногоОбъектаАдресации;
	
	Элементы.ОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыОсновногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Если ТипыОсновногоОбъектаАдресации <> Неопределено Тогда
		Элементы.ОсновнойОбъектАдресации.ОграничениеТипа = ТипыОсновногоОбъектаАдресации;
	КонецЕсли;
	Элементы.ОсновнойОбъектАдресации.Заголовок = ЗаголовокОсновногоОбъектаАдресации;
	
	Элементы.ДополнительныйОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыДополнительногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Если ТипыДополнительногоОбъектаАдресации <> Неопределено Тогда
		Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	КонецЕсли;
	Элементы.ДополнительныйОбъектАдресации.Заголовок = ЗаголовокДополнительногоОбъектаАдресации;
	
КонецПроцедуры

