// Форма ожидает обязательные параметры:
//
// ОбъектДляСопоставления   - Строка - описание объекта в текущей программе
// Программа1               - Строка - название программы - корреспондента
// Программа2               - Строка - название текущей программы
//
// СписокИспользуемыхПолей - СписокЗначений - поля, по которым происходит сопоставление
//     Значение      - Строка - имя поля, 
//     Представление - Строка - описани (заголовок) поля
//     Пометка       - Булево - флаг того, что поле сейчас используется
//
// МаксимальноеКоличествоПользовательскихПолей - Число - ограничение на количество полей сопоставления.
//
// НомерПоПорядкуСтрокиНачала - Число - ключ текущей строки во входной таблице
//
// АдресВременногоХранилища - Строка - адрес входной таблицы сопоставления. В таблице используются колонки:
//     ИндексКартинки   - Число
//     НомерПоПорядку   - Число, уникальный ключ строки
//     ПолеСортировки1  - Строка, значение реквизита 1 из списка используемых полей
//     ...
//     ПолеСортировкиNN - Строка, значение реквизита NN из списка используемых полей
//
// После открытия формы данные с адресом АдресВременногоХранилища будут удалены из временного хранилища
//

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбъектДляСопоставления = Параметры.ОбъектДляСопоставления;
	
	Элементы.ОбъектДляСопоставления.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Объект в ""%1""'"), Параметры.Программа1);
		
	Элементы.Шапка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Объект в ""%1""'"), Параметры.Программа2);
		
	
	// Построим и подготовим на форме таблицу выбора
	ПостроитьТаблицуВыбора(Параметры.МаксимальноеКоличествоПользовательскихПолей, Параметры.СписокИспользуемыхПолей, 
		Параметры.АдресВременногоХранилища);
		
	УстановитьКурсорТаблицыВыбора(Параметры.НомерПоПорядкуСтрокиНачала);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ТаблицаВыбора

&НаКлиенте
Процедура ТаблицаВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПроизвестиВыбор(ВыбраннаяСтрока);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	ПроизвестиВыбор(Элементы.ТаблицаВыбора.ТекущаяСтрока);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПроизвестиВыбор(Знач ИдентификаторСтрокиВыбора)
	Если ИдентификаторСтрокиВыбора=Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ДанныеВыбора = ТаблицаВыбора.НайтиПоИдентификатору(ИдентификаторСтрокиВыбора);
	Если ДанныеВыбора<>Неопределено Тогда
		ОповеститьОВыборе(ДанныеВыбора.НомерПоПорядку);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьТаблицуВыбора(Знач ВсегоПолей, Знач ИспользуемыеПоля, Знач АдресДанных)
	
	// Добавляем реквизиты-колонки
	Добавляемые = Новый Массив;
	ТипСтрока   = Новый ОписаниеТипов("Строка");
	Для НомерПоля=1 По ВсегоПолей Цикл
		Добавляемые.Добавить(Новый РеквизитФормы("ПолеСортировки" + Формат(НомерПоля, "ЧН=; ЧГ="), ТипСтрока, "ТаблицаВыбора"));
	КонецЦикла;
	ИзменитьРеквизиты(Добавляемые);
	
	// Достраиваем на форме
	ГруппаКолонок = Элементы.ГруппировкаПолей;
	ТипЭлемента   = Тип("ПолеФормы");
	РазмерСписка  = ИспользуемыеПоля.Количество() - 1;
	
	Для НомерПоля=0 По ВсегоПолей-1 Цикл
		Реквизит = Добавляемые[НомерПоля];
		
		НоваяКолонка = Элементы.Добавить("ТаблицаВыбора" + Реквизит.Имя, ТипЭлемента, ГруппаКолонок);
		НоваяКолонка.ПутьКДанным = Реквизит.Путь + "." + Реквизит.Имя;
		Если НомерПоля<=РазмерСписка Тогда
			Поле = ИспользуемыеПоля[НомерПоля];
			НоваяКолонка.Видимость = Поле.Пометка;
			НоваяКолонка.Заголовок = Поле.Представление;
		Иначе
			НоваяКолонка.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	// Заполняем значениями и очищаем источник
	Если Не ПустаяСтрока(АдресДанных) Тогда
		ТаблицаВыбора.Загрузить( ПолучитьИзВременногоХранилища(АдресДанных) );
		УдалитьИзВременногоХранилища(АдресДанных);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьКурсорТаблицыВыбора(Знач НомерПоПорядкуСтрокиНачала)
	
	Для Каждого Строка Из ТаблицаВыбора Цикл
		Если Строка.НомерПоПорядку=НомерПоПорядкуСтрокиНачала Тогда
			Элементы.ТаблицаВыбора.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Прервать;
			
		ИначеЕсли Строка.НомерПоПорядку>НомерПоПорядкуСтрокиНачала Тогда
			ИндексПредыдущей = ТаблицаВыбора.Индекс(Строка) - 1;
			Если ИндексПредыдущей>0 Тогда
				Элементы.ТаблицаВыбора.ТекущаяСтрока = ТаблицаВыбора[ИндексПредыдущей].ПолучитьИдентификатор();
			КонецЕсли;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
