
#Область  ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, , , Элементы.ГруппаКоманднаяПанель);
	
	Ссылка = Параметры.Ссылка;
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Контрагенты_ат") Тогда
		
		Клиенты = Ссылка;
		Элементы.ОтборПоКлиентам.РасширеннаяПодсказка.Заголовок = "Клиент: " + Ссылка + ".";
		
	Иначе	
		
		Клиенты = Планирование_Сервер_ат.ПолучитьМассивКлиентовПоЗаявкам(Ссылка);
		
		Если ТипЗнч(Клиенты) = Тип("Массив") И Клиенты.Количество() > 0 Тогда
			
			Представление = "";
			
			Для Каждого Клиент Из Клиенты Цикл
				Представление = Представление + Клиент + "; ";
			КонецЦикла;
			
			Представление = ?(Клиенты.Количество() > 1, "Клиенты: ", "Клиент: ") + Лев(Представление, СтрДлина(Представление) - 2) + ".";
			Элементы.ОтборПоКлиентам.РасширеннаяПодсказка.Заголовок = Представление;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Клиенты", Клиенты);
	Элементы.ОтборПоКлиентам.Пометка = (Клиенты <> Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	УправляемыеФормы_Клиент_ат.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти 

#Область  ОбработчикиДействийПользователя

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора И Параметры.ЗапретВыбораДочерних Тогда
		
		Если Элемент.ТекущиеДанные.ЕстьДочерние Тогда
			
			СтандартнаяОбработка = Ложь;
			ПоказатьПредупреждение(, "Выбор Проекта имеющего дочерние запрещён!", 5);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Элементы.НадписьПроектКомментарий.Заголовок = Элементы.Список.ТекущиеДанные.Комментарий;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область  ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрытьАрхивные(Команда)

	Элементы.СкрытьАрхивные.Пометка = НЕ Элементы.СкрытьАрхивные.Пометка;
	УправляемыеФормы_КлиентСервер_ат.ИзменитьИспользованиеОтбораДинамическогоСписка(
		Список, "Скрыть архивные", Элементы.СкрытьАрхивные.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьБудущие(Команда)
	
	Элементы.СкрытьБудущие.Пометка = НЕ Элементы.СкрытьБудущие.Пометка;
	УправляемыеФормы_КлиентСервер_ат.ИзменитьИспользованиеОтбораДинамическогоСписка(
		Список, "Скрыть будущие", Элементы.СкрытьБудущие.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоКлиентам(Команда)
	
	Кнопка = Элементы.ОтборПоКлиентам;
	
	Если Кнопка.Пометка Тогда
		
		ИскомыйПараметр = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Клиенты"));
		
		Если ИскомыйПараметр <> Неопределено Тогда
			ИскомыйПараметр.Использование = Ложь;
		КонецЕсли;
		
		Кнопка.РасширеннаяПодсказка.Заголовок = "Установить отбор по клиентам";
		Кнопка.Пометка = Ложь;
		
	Иначе
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораКлиентов", ЭтаФорма);
		
		ОткрытьФорму("Справочник.Контрагенты_ат.Форма.ФормаГрупповогоВыбора",, ЭтаФорма,,,,
			Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область  СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыбораКлиентов(Результат, ПередаваемыеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат.Клиенты.Количество() > 0 Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("Клиенты", Результат.Клиенты);
		Элементы.ОтборПоКлиентам.Пометка = Истина;
		Элементы.ОтборПоКлиентам.РасширеннаяПодсказка.Заголовок = Результат.Представление;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область  УниверсальныеОбработчикиДействий

&НаКлиенте
Процедура ОбработчикУниверсальныхДействий(Команда)
	
	УправляемыеФормы_Клиент_ат.ДополнительныеДействияФормы(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Функция   ОбработчикУниверсальныхДействий_Сервер(Элемент) Экспорт
	
	Возврат УправляемыеФормы_Сервер_ат.ДополнительныеДействияФормы(ЭтаФорма, Команды[Элемент.Имя]);
	
КонецФункции

#КонецОбласти
