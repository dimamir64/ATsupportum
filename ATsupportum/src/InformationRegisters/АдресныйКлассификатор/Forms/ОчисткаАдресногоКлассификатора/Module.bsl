////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события "при создании на сервере" формы
// Заполняет таблицу по макету
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуПоМакетуАдресныхОбъектов();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Обработчик события "выбор" элемента формы АдресныеОбъекты
// Инвертирует флаг выбора адресного объекта
//
&НаКлиенте
Процедура АдресныеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Элемент.ТекущиеДанные.Пометка = НЕ Элемент.ТекущиеДанные.Пометка;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Обработчик события нажатия на кнопку командной панели
// элемента управления АдресныеОбъекты.
// Устанавливает флаг выбора всем адресным объектам в списке
//
&НаКлиенте
Процедура ВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		ЭлементАдресныйОбъект.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик события нажатия на кнопку командной панели
// элемента управления АдресныеОбъекты.
// Снимает флаг выбора у всех адресных объектов в списке
//
&НаКлиенте
Процедура ОтменитьВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		ЭлементАдресныйОбъект.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик события нажатия на кнопку "Очистить"
// Проверяет корректность данных и вызывает диалог подтверждения
// очистки адресных сведений.
//
&НаКлиенте
Процедура ОчиститьВыполнить()
	
	ОчиститьСообщения();
	
	Если КоличествоВыделенныхАдресныхОбъектов() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Необходимо выбрать как минимум один адресный объект.'"), ,
					"АдресныеОбъекты");
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Адресные сведения по выбранным объектам будут удалены. Удалить адресные сведения?'");
	КодВозврата = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	
	Если КодВозврата = КодВозвратаДиалога.ОК Тогда
		ОчиститьАдресныеСведения();
		Предупреждение(НСтр("ru = 'Адресные сведения успешно удалены.'"),,
		               НСтр("ru = 'Удаление адресных сведений.'"));
		Оповестить("Запись_АдресныйКлассификатор", Новый Структура("Событие", "Очистить"));
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет переданную таблицу значений по значениям таблицы адресных объектов.
// Выбирается код, наименование и сокращение типа объекта.
//
&НаСервере
Процедура ЗаполнитьТаблицуПоМакетуАдресныхОбъектов()
	
	АдресныеОбъекты.Очистить();
	
	КлассификаторАдресныхОбъектовXML =
	   РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	
	Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
		
		Наименование = Лев(АдресныйОбъект.Code, 2)
		             + " - "
		             + АдресныйОбъект.Name
		             + " "
		             + АдресныйОбъект.Socr;
		
		НоваяСтрока = АдресныеОбъекты.Добавить();
		НоваяСтрока.Пометка             = Ложь;
		НоваяСтрока.НаименованиеАдресногоОбъекта = Наименование;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает количество помеченных адресных объектов
//
&НаКлиенте
Функция КоличествоВыделенныхАдресныхОбъектов()
	
	КоличествоВыделенныхАдресныхОбъектов = 0;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			КоличествоВыделенныхАдресныхОбъектов = КоличествоВыделенныхАдресныхОбъектов + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КоличествоВыделенныхАдресныхОбъектов;
	
КонецФункции

// Удаляет адресные сведения по выбранным адресным объектам
//
&НаСервере
Процедура ОчиститьАдресныеСведения()
	
	// формируем список адресных объектов, для очистки адресных сведений
	
	ВыбранныеАО = Новый Массив;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъекты Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			ВыбранныеАО.Добавить(Лев(ЭлементАдресныйОбъект.НаименованиеАдресногоОбъекта, 2));
		КонецЕсли;
	КонецЦикла;
	
	АдресныйКлассификатор.УдалитьАдресныеСведения(ВыбранныеАО);
	АдресныйКлассификатор.ЗагрузитьАдресныеОбъектыПервогоУровня();
	
КонецПроцедуры
