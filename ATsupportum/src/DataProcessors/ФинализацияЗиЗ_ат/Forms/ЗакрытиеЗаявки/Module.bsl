
&НаКлиенте
Перем КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ЗакрываемыеЗаявки") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.ЗакрываемыеЗаявки.Количество() > 0 Тогда //!!!HACK
		Объект.Заявка = Параметры.ЗакрываемыеЗаявки[0];
	КонецЕсли;
	
	ЭтаФорма.Заголовок = "Закрытие Заявки по тикету #" + Объект.Заявка.Тикет;
	
	Если Объект.Заявка.Сотрудник.Пустая() ИЛИ Объект.Заявка.ТипЗаявки.Срочное Тогда
		Объект.СтатусЗакрытия = Перечисления.СтатусыЗаявок_ат.Закрыта;
	Иначе
		Объект.СтатусЗакрытия = Перечисления.СтатусыЗаявок_ат.НаПриемке;
	КонецЕсли;
	
	//Запрос = Новый Запрос(
	//	"ВЫБРАТЬ
	//	|	СвязиОбъектов_ат.Объект КАК Задание,
	//	|	СвойстваЗаданий_ат.РезультатВыполненияВHTML КАК РезультатВыполнения,
	//	|	СвойстваЗаданий_ат.ИсключатьИзРезультатаЗаявки КАК ИсключатьИзРезультатаЗаявки,
	//	|	СвязиОбъектов_ат.Объект.ЭкземплярПродукта КАК ЭкземплярПродукта,
	//	|	СвязиОбъектов_ат.Объект.ВерсияПродукта КАК ВерсияПродукта,
	//	|	СвойстваЗаданий_ат.ТребуетсяПерезапускЭкземпляраПродукта КАК ТребуетсяПерезапускЭкземпляраПродукта,
	//	|	СвойстваЗаданий_ат.Ссылка.СодержаниеРабот КАК СодержаниеРабот
	//	|ИЗ
	//	|	Документ.Заявка_ат КАК Заявка_ат
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиОбъектов_ат КАК СвязиОбъектов_ат
	//	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвойстваЗаданий_ат КАК СвойстваЗаданий_ат
	//	|			ПО СвязиОбъектов_ат.Объект = СвойстваЗаданий_ат.Ссылка
	//	|		ПО Заявка_ат.Ссылка = СвязиОбъектов_ат.Предок
	//	|ГДЕ
	//	|	Заявка_ат.Ссылка = &Заявка
	//	|	И (СвязиОбъектов_ат.Объект ССЫЛКА Документ.Задание_ат)
	//	|	И (НЕ ВЫРАЗИТЬ(СвязиОбъектов_ат.Объект КАК Документ.Задание_ат).ПометкаУдаления)
	//	|	И НЕ СвязиОбъектов_ат.Объект В
	//	|		(ВЫБРАТЬ
	//	|			ДокументФиксацияЗадания.Задание
	//	|		ИЗ
	//	|			Документ.ФиксацияРабот_ат.Задания КАК ДокументФиксацияЗадания
	//	|		ГДЕ
	//	|			ДокументФиксацияЗадания.Ссылка.Заявка = &Заявка
	//	|			И ДокументФиксацияЗадания.Ссылка.Проведен)");
	//Запрос.УстановитьПараметр("Заявка", Объект.Заявка);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	
	//	НоваяСтрокаЗадания = Объект.Задания.Добавить();
	//	ЗаполнитьЗначенияСвойств(НоваяСтрокаЗадания, Выборка);
	//	
	//КонецЦикла;
	
	Объект.СоздаватьУведомлениеОЗакрытии = Истина;
	Элементы.СоздаватьУведомлениеОЗакрытии.Видимость = (Объект.СтатусЗакрытия = Перечисления.СтатусыЗаявок_ат.Закрыта);
	
	Объект.РезультатВыполнения = Планирование_Сервер_ат.ПолучитьРезультатВыполненияЗаявки(Объект.Заявка);
	
	//Объект.РезультатВыполнения = Объект.ЗакрываемыеЗаявки[0].РезультатВыполнения;
	//Элементы.РезультатВыполнения.Документ.Body.InnerHTML = Элементы.ЗакрываемыеЗаявки.ТекущиеДанные.РезультатВыполнения;
	
	// копия из ОМ.Планирование_Сервер_ат.Процедура ПересчитатьСвойстваЗаявки {
	
	СвойстваЗаявки = Планирование_Сервер_ат.ПолучитьСвойстваЗаявки(Объект.Заявка);
	ЗаполнитьЗначенияСвойств(Объект, СвойстваЗаявки);
	
	//!!!!!+ быстро и криво, так как старый код куда-то пропал, если честно :( - переписать на фиг
	Фиксация = Документы.ФиксацияРабот_ат.СоздатьДокумент();
	Фиксация.Дата = ТекущаяДатаСеанса();
	Фиксация.Заполнить(Объект.Заявка);
	
	Для Каждого УслугаФ Из Фиксация.Услуги Цикл
		
		УслугаЗЗ = Объект.Услуги.Добавить();
		ЗаполнитьЗначенияСвойств(УслугаЗЗ, УслугаФ);
		
	КонецЦикла;
	
	ПодчиненныеЗадания = Планирование_Сервер_ат.ПолучитьДочерниеЗадания(Объект.Заявка);
	Для Каждого ЗаданиеП Из ПодчиненныеЗадания Цикл
		
		ЗаданиеЗЗ = Объект.Задания.Добавить();
		СвойстваЗадания = Планирование_Сервер_ат.ПолучитьСвойстваЗадания(ЗаданиеП);
		ЗаданиеЗЗ.Задание = ЗаданиеП;
		ЗаполнитьЗначенияСвойств(ЗаданиеЗЗ, СвойстваЗадания);
		
	КонецЦикла;
	
	// и зачем это надо?
	//Для Каждого ЗаданиеФ Из Фиксация.Задания Цикл
	//	
	//	Задания = Объект.Задания.НайтиСтроки(Новый Структура("Задание", ЗаданиеФ));
	//	
	//	Если Задания.Количество() = 1 Тогда
	//		ЗаполнитьЗначенияСвойств(Задания[0], ЗаданиеФ);
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	//!!!-
	
	Обработки.ФинализацияЗиЗ_ат.ЗаполнитьФайлы(Файлы, Объект.Заявка);
	
	ОбновитьДоступныеЭкземплярыПродуктов();
	
	РаботаСHTML_Сервер_ат.СоздатьПанелиРаботыСHTML(ЭтаФорма, Элементы.КомманднаяПанельКнопокРедактированияHTML,
		"ОбработчикКомандРаботыСHTML", Ложь, Элементы.КомментарийHTML.КонтекстноеМеню);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ Параметры.ЗавершаемоеЗадание.Пустая() Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗавершаемоеЗадание", Параметры.ЗавершаемоеЗадание);
		ПараметрыОткрытия.Вставить("СтатусЗавершенияЗадания", Параметры.СтатусЗавершенияЗадания);
		
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияЗадания", ЭтаФорма);
		
		ОткрытьФорму("Обработка.ФинализацияЗиЗ_ат.Форма.ЗавершениеЗадания", ПараметрыОткрытия, ЭтаФорма,,,, Оповещение);
		
	Иначе
		
		ЗаполнитьДанные();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьРезультата"
		И Источник = ЭтаФорма Тогда
		
		Объект.РезультатВыполнения = Параметр.ТекстРезультата;
		ОбработкаОповещенияНаСервере(Параметр.ДеревоРезультатов, Объект.Заявка);
		Элементы.РезультатВыполненияHTML.Документ.Body.InnerHTML = Объект.РезультатВыполнения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусЗакрытияПриИзменении(Элемент)
	
	Если ПустойСотрудник(Объект.Заявка)
		И Объект.СтатусЗакрытия = ПредопределенноеЗначение("Перечисление.СтатусыЗаявок_ат.НаПриемке") Тогда
		
		ПоказатьПредупреждение(, "У Заявки нет заявителя! Невозможно отправить на приемку!", 5);
		Объект.СтатусЗакрытия = ПредопределенноеЗначение("Перечисление.СтатусыЗаявок_ат.Закрыта");
		
	КонецЕсли;
	
	Элементы.СоздаватьУведомлениеОЗакрытии.Видимость =
		(Объект.СтатусЗакрытия = ПредопределенноеЗначение("Перечисление.СтатусыЗаявок_ат.Закрыта"));
	
КонецПроцедуры

&НаСервере
Функция   ПустойСотрудник(Заявка)
	
	Возврат НЕ ЗначениеЗаполнено(Заявка.Сотрудник);
	
КонецФункции

&НаКлиенте
Процедура ЭкземплярПродуктаПриИзменении(Элемент)
	
	ВерсияПродукта = ПолучитьТекущуюВерсиюЭкземпляраПродукта(Объект.ЭкземплярПродукта);
	
	ТребуетсяПерезапускЭкземпляраПродукта = Истина;
	
	УстановитьСвязиПараметровВыборяВерсииПродукта();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементаФормы_РезультатВыполнения

&НаКлиенте
Процедура РезультатВыполненияПриИзменении(Элемент)
	
	Объект.РезультатВыполнения = Элементы.РезультатВыполненияHTML.Документ.Body.InnerHTML;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ФайлыПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	Диалог.Заголовок = "Выберите файл";
	Диалог.ПолноеИмяФайла = Элементы.Файлы.ТекущиеДанные.ПутьКФайлу;
	
	Если Диалог.Выбрать() Тогда
		
		ПутьКФайлу = Диалог.ВыбранныеФайлы[0];
		
		Файл = Новый Файл(ПутьКФайлу);
		Элементы.Файлы.ТекущиеДанные.ИмяФайла = Файл.Имя;
		
		Элементы.Файлы.ТекущиеДанные.ПутьКФайлу = ПутьКФайлу;
		Элементы.Файлы.ТекущиеДанные.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу),
			УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыДобавлятьВЗаявкуПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элементы.Файлы.ТекущиеДанные.Файл) Тогда
		
		Элементы.Файлы.ТекущиеДанные.ДобавлятьВЗаявку = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьРезультат(Команда)
	
	РезультатыЗаданий = Новый СписокЗначений;
	
	Для Каждого СтрокаЗаданий Из Объект.Задания Цикл
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Задание", СтрокаЗаданий.Задание);
		
		ЭлементСтруктурыРезультатовЗаданий = Объект.СтруктураРезультатовЗаявок.НайтиСтроки(ПараметрыОтбора);
		ЗначениеПометки = ?(ЗначениеЗаполнено(ЭлементСтруктурыРезультатовЗаданий),
			ЭлементСтруктурыРезультатовЗаданий[0].Использовать,
			НЕ СтрокаЗаданий.ИсключатьИзРезультатаЗаявки);
		РезультатыЗаданий.Добавить(СтрокаЗаданий.Задание, СтрокаЗаданий.РезультатВыполнения, ЗначениеПометки);
		
	КонецЦикла;
	
	СписокРучныхТекстов = Новый СписокЗначений;
	
	Для Каждого СтрокаСтруктурыРезультатов Из Объект.СтруктураРезультатовЗаявок Цикл
		
		Если СтрокаСтруктурыРезультатов.ЭтоРучнойТекст Тогда
			
			СписокРучныхТекстов.Добавить(СтрокаСтруктурыРезультатов.СсылкаНаКод,
				СтрокаСтруктурыРезультатов.РучнойТекст, СтрокаСтруктурыРезультатов.Использовать);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Заявка", Объект.Заявка);
	ПараметрыОткрытияФормы.Вставить("РезультатыЗаданий", РезультатыЗаданий);
	ПараметрыОткрытияФормы.Вставить("СписокРучныхТекстов", СписокРучныхТекстов);
	
	ОткрытьФорму("Обработка.ФинализацияЗиЗ_ат.Форма.ФормированиеРезультата", ПараметрыОткрытияФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьРезультат(Команда)
	
	Элементы.РезультатВыполненияHTML.Документ.Body.InnerHTML = ПолучитьРезультатВыполненияЗаявки();
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	Ошибка = ПроверитьЭкземплярПродукта();
	
	Если НЕ ПустаяСтрока(Ошибка) Тогда
		
		ПоказатьПредупреждение(, Ошибка, 5);
		Возврат;
		
	КонецЕсли;
	
	Ошибка = ПроверитьОбязательныеПоля();
	
	Если НЕ ПустаяСтрока(Ошибка) Тогда
		
		ПоказатьПредупреждение(, Ошибка, 5);
		Возврат;
		
	КонецЕсли;
	
	Если Комментарий_ДокументHTMLСформирован Тогда
		Объект.Комментарий = Элементы.КомментарийHTML.Документ.documentElement.outerHTML;
	Иначе
		Объект.Комментарий = "";
	КонецЕсли;
	
	Отказ = Ложь;
	ПараметрыЗаписи = Новый Структура;
	УправляемыеФормы_Клиент_ат.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
	Результат = Применить_Сервер();
	
	УправляемыеФормы_Клиент_ат.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	Если Результат.Свойство("Ошибка") Тогда
		
		ПоказатьПредупреждение(, Результат.Ошибка, 5);
		Возврат;
		
	КонецЕсли;
	
	Если ДобавлятьВБазуЗнаний Тогда
		ДобавитьВБазуЗнаний();
	Иначе
		ПослеДобавленияВБазуЗнаний(Неопределено);
	КонецЕсли;
	
	//Для Каждого Письмо Из Результат.МассивСозданныхПисем Цикл
	//	
	//	ОткрытьЗначение(Письмо);
	//	
	//КонецЦикла;
	
	Оповестить("ЗакрытьФормуЗадания", Параметры.ЗавершаемоеЗадание, ЭтотОбъект);
	Оповестить("ОбновитьЗаявку", Объект.Заявка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеДобавленияВБазуЗнаний(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВБазуЗнаний()
	
	ОписаниеОповещенияОЗакрытииФормы = Новый ОписаниеОповещения("ПослеДобавленияВБазуЗнаний", ЭтаФорма, Новый Структура);
	ПараметрыФормы = Новый Структура("Основание", Объект.Заявка);
	ОткрытьФорму("Справочник.БазаЗнаний_ат.Форма.ФормаПомощникаВвода", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытииФормы);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьВремяДляОтображения(Строка) //!!!!! перенести в Фиксацию?
	
	Строка.ПланируемоеВремяДляОтображения =
		ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(Строка.ПланируемоеВремяВыполнения);
	Строка.ФактическоеВремяДляОтображения =
		ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(Строка.ФактическоеВремяВыполнения);
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаОповещенияНаСервере(пДеревоРезультатов, Заявка)
	
	Дерево = ДанныеФормыВЗначение(пДеревоРезультатов, Тип("ДеревоЗначений"));
	//ЗначениеВРеквизитФормы(Дерево, "ДеревоРезультатов");
	
	Объект.СтруктураРезультатовЗаявок.Очистить();
	Счетчик = 1;
	ЗаписатьВСтруктуруРезультатовЗаявокРекурсивно(Дерево.Строки, Счетчик, Заявка);
	
	//РаботаСHTML_Сервер_ат.СоздатьВременныеФайлыКартинокТекста(Заявка, "РезультатВыполненияЗаявки", ЭтаФорма, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанные()
	
	Объект.Услуги.Очистить();
	
	Объект.ОтчетнаяДатаНачала = Дата(1, 1, 1);
	Объект.ОтчетнаяДатаОкончания = Дата(2999, 1, 1);
	Объект.ОтчетнаяДлительность = 0;
	Объект.ФактическаяДатаНачала = Дата(1, 1, 1);
	Объект.ФактическаяДатаОкончания = Дата(2999, 1, 1);
	
	Для Каждого СтрокаЗадания Из Объект.Задания Цикл
		
		НайденныеСтрокиУслуг = Объект.Услуги.НайтиСтроки(Новый Структура("СодержаниеРабот", СтрокаЗадания.СодержаниеРабот));
		
		Если НайденныеСтрокиУслуг.Количество() = 0 Тогда
			
			СтрокаУслуг = Объект.Услуги.Добавить();
			СтрокаУслуг.СодержаниеРабот = СтрокаЗадания.СодержаниеРабот;
			
		Иначе
			
			СтрокаУслуг = НайденныеСтрокиУслуг[0];
			
		КонецЕсли;
		
		СтрокаУслуг.ПланируемоеВремяВыполнения = СтрокаУслуг.ПланируемоеВремяВыполнения
			+ СтрокаЗадания.ПланируемоеВремяВыполнения;
		СтрокаУслуг.ПланируемоеВремяДляОтображения = ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(
			СтрокаУслуг.ПланируемоеВремяВыполнения);
		
		СтрокаУслуг.ФактическоеВремяВыполнения = СтрокаУслуг.ФактическоеВремяВыполнения
			+ СтрокаЗадания.ФактическоеВремяВыполнения;
		СтрокаУслуг.ФактическоеВремяДляОтображения = ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(
			СтрокаУслуг.ФактическоеВремяВыполнения);
		
		Объект.ОтчетнаяДлительность = Объект.ОтчетнаяДлительность + СтрокаЗадания.ФактическаяДлительность;
		
		Если ЗначениеЗаполнено(СтрокаЗадания.ФактическаяДатаНачала)
			И СтрокаЗадания.ФактическаяДатаНачала > Объект.ОтчетнаяДатаНачала Тогда
			
			Объект.ОтчетнаяДатаНачала = СтрокаЗадания.ФактическаяДатаНачала;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаЗадания.ФактическаяДатаНачала)
			И СтрокаЗадания.ФактическаяДатаНачала > Объект.ФактическаяДатаНачала Тогда
			
			Объект.ФактическаяДатаНачала = СтрокаЗадания.ФактическаяДатаНачала;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаЗадания.ФактическаяДатаОкончания)
			И СтрокаЗадания.ФактическаяДатаОкончания < Объект.ОтчетнаяДатаОкончания Тогда
			
			Объект.ОтчетнаяДатаОкончания = СтрокаЗадания.ФактическаяДатаОкончания;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаЗадания.ФактическаяДатаОкончания)
			И СтрокаЗадания.ФактическаяДатаОкончания < Объект.ФактическаяДатаОкончания Тогда
			
			Объект.ФактическаяДатаОкончания = СтрокаЗадания.ФактическаяДатаОкончания;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СУММА(ВременаРабот_атОбороты.СогласованноеВремяОборот) КАК СогласованноеВремя,
		|	СУММА(ВременаРабот_атОбороты.ОтчетноеВремяОборот) КАК ОтчетноеВремя,
		|	ВременаРабот_атОбороты.СодержаниеРабот КАК СодержаниеРабот
		|ИЗ
		|	РегистрНакопления.ВременаРабот_ат.Обороты(,,, Заявка = &Заявка) КАК ВременаРабот_атОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременаРабот_атОбороты.СодержаниеРабот");
	Запрос.УстановитьПараметр("Заявка", Объект.Заявка);
	ВРЗ = Запрос.Выполнить().Выбрать();
	
	Пока ВРЗ.Следующий() Цикл
		
		СтрокиУслуг = Объект.Услуги.НайтиСтроки(Новый Структура("СодержаниеРабот",
			ВРЗ.СодержаниеРабот));
		
		Если СтрокиУслуг.Количество() = 1 Тогда
			
			СтрокаУслуг = СтрокиУслуг[0];
			
			СтрокаУслуг.СогласованноеВремя = ВРЗ.СогласованноеВремя;
			СтрокаУслуг.СогласованноеВремяДляОтображения = ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(
				СтрокаУслуг.СогласованноеВремя);
			
			СтрокаУслуг.РанееЗакрытоеВремя = ВРЗ.ОтчетноеВремя;
			СтрокаУслуг.РанееЗакрытоеВремяДляОтображения = ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(
				СтрокаУслуг.РанееЗакрытоеВремя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаУслуг Из Объект.Услуги Цикл
		
		Если СтрокаУслуг.СогласованноеВремя - СтрокаУслуг.РанееЗакрытоеВремя > 0 Тогда
			
			СтрокаУслуг.ОтчетноеВремя = СтрокаУслуг.СогласованноеВремя - СтрокаУслуг.РанееЗакрытоеВремя;
			СтрокаУслуг.ОтчетноеВремяДляОтображения = ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(
				СтрокаУслуг.ОтчетноеВремя);
			
		//ИначеЕсли СтрокаУслуг.ПланируемоеВремяВыполнения > СтрокаУслуг.ФактическоеВремяВыполнения Тогда
		Иначе
			
			СтрокаУслуг.ОтчетноеВремя = СтрокаУслуг.ФактическоеВремяВыполнения;
			СтрокаУслуг.ОтчетноеВремяДляОтображения = ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДляОтображения(
				СтрокаУслуг.ОтчетноеВремя);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступныеЭкземплярыПродуктов()
	
	МассивПродуктов = УчетПродуктов_ат.ПолучитьПродуктыПоЗаявкам(Объект.Заявка);
	МассивПродуктов.Добавить(Справочники.Продукты_ат.ПустаяСсылка()); //!!!HACK
	Продукты.ЗагрузитьЗначения(МассивПродуктов);
	
	Если Объект.Заявка.ТипЗаявки.НеобходимЭкземплярПродукта Тогда
		
		НеобходимЭкземплярПродукта = Истина;
		
	Иначе
		
		НеобходимЭкземплярПродукта = Ложь;
		
	КонецЕсли;
	
	НовыйМассив = Новый Массив;
	
	Если Продукты.Количество() > 0 Тогда
		
		НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.ТекущийПродукт", "Продукты");
		
		НовыйМассив.Добавить(НоваяСвязь);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Заявка.Клиент) Тогда
		
		МассивКлиентов = Новый Массив;
		МассивКлиентов.Добавить(Объект.Заявка.Клиент);
		МассивКлиентов.Добавить(Справочники.Контрагенты_ат.ПустаяСсылка()); //!!!HACK
		Клиенты.ЗагрузитьЗначения(МассивКлиентов);
		НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.Клиент", "Клиенты");
		НовыйМассив.Добавить(НоваяСвязь);
		
	КонецЕсли;
	
	НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
	
	Элементы.ЭкземплярПродукта.СвязиПараметровВыбора = НовыеСвязи;
	УстановитьСвязиПараметровВыборяВерсииПродукта();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвязиПараметровВыборяВерсииПродукта()
	
	НовыйМассив_Версии = Новый Массив;
	Если ЗначениеЗаполнено(Объект.ЭкземплярПродукта) Тогда
		
		ВерсииПродуктов.ЗагрузитьЗначения(УчетПродуктов_ат.ПолучитьВерсииЭкземпляраПродукта(Объект.ЭкземплярПродукта));
		//ТекущийПродуктЭкземпляра = ЭкземплярПродукта.ТекущийПродукт;
		НоваяСвязь_Версии = Новый СвязьПараметраВыбора("Отбор.Ссылка", "ВерсииПродуктов");
		НовыйМассив_Версии.Добавить(НоваяСвязь_Версии);
		
	КонецЕсли;
	
	НовыеСвязи_Версии = Новый ФиксированныйМассив(НовыйМассив_Версии);
	Элементы.ВерсияПродукта.СвязиПараметровВыбора = НовыеСвязи_Версии;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияЗадания(Результат, ПередаваемыеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда // данные закрытия Задания не были введены.
		
		ЭтаФорма.Закрыть();
		Возврат;
		
	КонецЕсли;
	
	Задания = Объект.Задания.НайтиСтроки(Новый Структура("Задание", Параметры.ЗавершаемоеЗадание));
	
	Если Задания.Количество() = 0 Тогда
		
		Предупреждение("Ошибка сохранения введённых данных Задания", 5);
		ЭтаФорма.Закрыть();
		Возврат;
		
	Иначе
		
		СтрокаЗадания = Задания[0];
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаЗадания, Результат);
	СтрокаЗадания.РезультатВыполнения = Результат.РезультатВыполненияВHTML;
	СтрокаЗадания.Модифицированно = Истина;

	ЗаполнитьВремяДляОтображения(СтрокаЗадания);
	
	Объект.РезультатВыполнения = ПолучитьРезультатВыполненияЗаявки();
	Элементы.РезультатВыполненияHTML.Документ.Body.InnerHTML = Объект.РезультатВыполнения;
	
	ЗаполнитьДанные();
	
КонецПроцедуры

&НаКлиенте
Функция   ПолучитьРезультатВыполненияЗаявки()
	
	Возврат ПолучитьРезультатВыполненияЗаявки_НаСервере();
	
КонецФункции

&НаСервере
Функция   ПолучитьРезультатВыполненияЗаявки_НаСервере() //!!!TODO - понять соответствие ОМ.Планирование_Сервер.ПолучитьРезультатВыполненияЗаявки
	
	ДокументHTML = Новый ДокументHTML;
	
	ЭлементТело = ДокументHTML.СоздатьЭлемент("body");
	ДокументHTML.Тело = ЭлементТело;
	
	Для Каждого Задание Из Объект.Задания Цикл
		
		Если НЕ ПустаяСтрока(Задание.РезультатВыполнения) И НЕ Задание.ИсключатьИзРезультатаЗаявки Тогда
			
			ЭлементБлок = ДокументHTML.СоздатьЭлемент("p");
			ЭлементТело.ДобавитьДочерний(ЭлементБлок);
			
			РаботаСHTML_Сервер_ат.ИмпортироватьДокументВЭлемент(ДокументHTML, ЭлементБлок,
				Взаимодействия.ПолучитьОбъектДокументHTMLИзТекстаHTML(Задание.РезультатВыполнения));
			
		КонецЕсли;
		
	КонецЦикла;
	
	НовыйРезультатВыполнения = Взаимодействия.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
	
	Возврат СокрЛП(НовыйРезультатВыполнения);
	
КонецФункции

&НаСервере
Функция   ПроверитьЭкземплярПродукта()
	
	Ошибка = "";
	
	//Если НеобходимЭкземплярПродукта И ЭкземплярНеЗаполненВЗаданиях() Тогда //!!!!!
	//	
	//	Если НЕ ЗначениеЗаполнено(Объект.ЭкземплярПродукта) Тогда
	//		Ошибка = "Не заполнен Экземпляр Продукта!";
	//	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ВерсияПродукта) Тогда
	//		Ошибка = "Не заполнена Версия Продукта!";
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

&НаСервере
Функция   ПроверитьОбязательныеПоля()
	
	Ошибка = "";
	
	Если НЕ ЗначениеЗаполнено(Объект.ОтчетнаяДатаНачала) Тогда
		Ошибка = "Не заполнена Отчётная Дата Начала!";
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ОтчетнаяДатаОкончания) Тогда
		Ошибка = "Не заполнена Отчётная Дата Окончания!";
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ОтчетнаяДлительность) Тогда
		Ошибка = "Не заполнена Отчётная Длительность!";
	ИначеЕсли ПустаяСтрока(Объект.РезультатВыполнения) Тогда
		Ошибка = "Не заполнен Результат Выполнения!";
	ИначеЕсли Объект.Услуги.Количество() > 0 Тогда
		
		Для Каждого СтрокаУслуг Из Объект.Услуги Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаУслуг.СодержаниеРабот) Тогда
				Ошибка = "Не заполнен Вид Деятельности в строке Услуг №" + СтрокаУслуг.НомерСтроки + "!";
				Прервать;
			ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаУслуг.ОтчетноеВремя) Тогда
				Ошибка = "Не заполнено Отчётное Время в строке Услуг №" + СтрокаУслуг.НомерСтроки + "!";
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

&НаСервере
Функция   ЭкземплярНеЗаполненВЗаданиях() //TODO - нет кода обеспечивающего автозаполнение ЭП и его версии из Заданий
	
	Задания = Планирование_Сервер_ат.ПолучитьДочерниеЗадания(Объект.Заявка);
	
	ЭкземплярНеЗаполнен = Истина;
	
	Для Каждого Задание Из Задания Цикл
		
		Если ЗначениеЗаполнено(Задание.ЭкземплярПродукта) Тогда
			
			ЭкземплярНеЗаполнен = Ложь;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЭкземплярНеЗаполнен;
	
КонецФункции

&НаСервере
Функция   Применить_Сервер()
	
	СтруктураРезультата = Новый Структура;
	
	НачатьТранзакцию();
	Попытка
		
		Вложения = Новый ТаблицаЗначений;
		Вложения.Колонки.Добавить("АдресВоВременномХранилище");
		Вложения.Колонки.Добавить("ИмяФайлаСРасширением");
		
		НаборЗаписейСтруктураРезультатаЗаявки = РегистрыСведений.СтруктураРезультатаЗаявки_ат.СоздатьНаборЗаписей();
		НаборЗаписейСтруктураРезультатаЗаявки.Отбор.Заявка.Установить(Объект.Заявка);
		НаборЗаписейСтруктураРезультатаЗаявки.Прочитать();
		
		НаборЗаписейСтруктураРезультатаЗаявки.Очистить();
		
		Для Каждого ЭлементСтруктурыЗаявки Из Объект.СтруктураРезультатовЗаявок Цикл;
			
			Запись = НаборЗаписейСтруктураРезультатаЗаявки.Добавить();
			Запись.Заявка = Объект.Заявка;
			Запись.Код = ЭлементСтруктурыЗаявки.Код;
			ЗаполнитьЗначенияСвойств(Запись, ЭлементСтруктурыЗаявки);
			
		КонецЦикла;
		
		НаборЗаписейСтруктураРезультатаЗаявки.Записать();
		
		//!!!!!TODO [Grig]: Сделано только для быстрого внедрения. ПЕРЕДЕЛАТЬ!!!
		НаборЗаписей = РегистрыСведений.СвойстваЗаявок_ат.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Ссылка.Установить(Объект.Заявка);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			
			Запись = НаборЗаписей.Добавить();
			Запись.Ссылка = Объект.Заявка;
			
		Иначе
			
			Запись = НаборЗаписей[0];
			
		КонецЕсли;
		
		Запись.РезультатВыполненияВHTML 			 = Объект.РезультатВыполнения;
		Запись.ЭкземплярПродукта_ИзЗакрытияЗаявки 	 = Объект.ЭкземплярПродукта; //СтрокаЗаявки.ЭкземплярПродукта_ИзЗакрытияЗаявки;
		Запись.ВерсияПродукта_ИзЗакрытияЗаявки 		 = Объект.ВерсияПродукта; //СтрокаЗаявки.ВерсияПродукта_ИзЗакрытияЗаявки;
		Запись.ТребуетсяПерезапускЭкземпляраПродукта = Объект.ТребуетсяПерезапускЭкземпляраПродукта; //СтрокаЗаявки.ТребуетсяПерезапускЭкземпляраПродукта;
		
		НаборЗаписей.Записать();
		
		СоответствиеИменФайловИдентификаторам = Новый Соответствие;
		РаботаСHTML_Сервер_ат.ЗаменитьИменаКартинокНаИдентификаторыВHTML(
			Объект.РезультатВыполнения, СоответствиеИменФайловИдентификаторам);
		РаботаСHTML_Сервер_ат.ЗаписатьПрикрепленныеФайлыКартинок(Объект.Заявка, СоответствиеИменФайловИдентификаторам);
		
		Для Каждого СтрокаФайлов Из Файлы Цикл
			
			Если СтрокаФайлов.Отправлять Тогда
				
				НоваяСтрока = Вложения.Добавить();
				
				Если ЗначениеЗаполнено(СтрокаФайлов.Файл) Тогда
					ДанныеФайла = ПрисоединенныеФайлы.ПолучитьДанныеФайла(СтрокаФайлов.Файл);
					АдресВоВременномХранилище = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
				Иначе
					АдресВоВременномХранилище = СтрокаФайлов.АдресВоВременномХранилище;
				КонецЕсли;
				
				НоваяСтрока.АдресВоВременномХранилище = АдресВоВременномХранилище;
				ИмяФайла = СтрокаФайлов.ИмяФайла;
				НоваяСтрока.ИмяФайлаСРасширением = ИмяФайла;
				
			КонецЕсли;
			
			Если СтрокаФайлов.ДобавлятьВЗаявку И НЕ ЗначениеЗаполнено(СтрокаФайлов.Файл) Тогда
				ПрисоединенныеФайлы.ДобавитьФайл(Объект.Заявка, ИмяФайла,,,, АдресВоВременномХранилище);
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.СвойстваЗаявок_ат.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Ссылка.Установить(Объект.Заявка);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			
			Запись = НаборЗаписей[0];
			Запись.ОтчетнаяДатаНачала = Объект.ОтчетнаяДатаНачала;
			Запись.ОтчетнаяДатаОкончания = Объект.ОтчетнаяДатаОкончания;
			Запись.ОтчетнаяДлительность = Объект.ОтчетнаяДлительность;
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
		//!!!!!HOTFIX {
		СтрокиЗаданий = Объект.Задания.НайтиСтроки(Новый Структура("Задание", Параметры.ЗавершаемоеЗадание));
		Если СтрокиЗаданий.Количество() > 0 Тогда
			
			СтрокаЗадания = СтрокиЗаданий[0];
			
			СвойстваЗадания = Новый Структура;
			СвойстваЗадания.Вставить("ФактическаяДатаНачала", СтрокаЗадания.ФактическаяДатаНачала);
			СвойстваЗадания.Вставить("ФактическаяДатаОкончания", СтрокаЗадания.ФактическаяДатаОкончания);
			СвойстваЗадания.Вставить("ФактическаяДлительность", СтрокаЗадания.ФактическаяДлительность);
			СвойстваЗадания.Вставить("ФактическоеВремяВыполнения", СтрокаЗадания.ФактическоеВремяВыполнения);
			СвойстваЗадания.Вставить("РезультатВыполненияВHTML", СтрокаЗадания.РезультатВыполнения);
			СвойстваЗадания.Вставить("Комментарий", СтрокаЗадания.Комментарий);
			
		Иначе
			
			СвойстваЗадания = Неопределено;
			
		КонецЕсли;
		
		//СвойстваЗадания = Новый Структура;
		//СвойстваЗадания.Вставить("ПланируемаяДатаНачала", СтрокаЗадания.ПланируемаяДатаНачала);
		//СвойстваЗадания.Вставить("ПланируемаяДатаОкончания", СтрокаЗадания.ПланируемаяДатаОкончания);
		//СвойстваЗадания.Вставить("ПланируемаяДлительность", СтрокаЗадания.ПланируемаяДлительность);
		//СвойстваЗадания.Вставить("ПланируемоеВремяВыполнения", СтрокаЗадания.ПланируемоеВремяВыполнения);
		//СвойстваЗадания.Вставить("ОтчетнаяДатаНачала", СтрокаЗадания.ОтчетнаяДатаНачала);
		//СвойстваЗадания.Вставить("ОтчетнаяДатаОкончания", СтрокаЗадания.ОтчетнаяДатаОкончания);
		//СвойстваЗадания.Вставить("ОтчетнаяДлительность", СтрокаЗадания.ОтчетнаяДлительность);
		//СвойстваЗадания.Вставить("ОтчетноеВремяВыполнения", СтрокаЗадания.ОтчетноеВремяВыполнения);
		
		//!!!!!TODO - надо всё это "счастье" привести к общему знаменателю, см. Планирование_Сервер_ат.ЗакрытьЗаявку
		
		СтруктураПодстановкиСтатуса = Новый Структура;
		СтруктураПодстановкиСтатуса.Вставить("Статус", Объект.СтатусЗакрытия);
		СтруктураПодстановкиСтатуса.Вставить("Период", Объект.ФактическаяДатаОкончания); //!!!?????  нужно,
			// что бы как-то коррелировало с Отчётной Датой Окончания. Возможно, надо при выводе клиенту
			// смотреть на совпадение по дате - если имеется, то выводим период отчёта, иначе берём из ОДО. ХЗ.
			
		Если НЕ Параметры.ЗавершаемоеЗадание.Пустая() Тогда
			Планирование_Сервер_ат.ЗавершитьЗадание(Параметры.ЗавершаемоеЗадание, Параметры.СтатусЗавершенияЗадания,
				СвойстваЗадания, СтруктураПодстановкиСтатуса, Ложь);
		КонецЕсли;
		
		Для Каждого Услуга Из Объект.Услуги Цикл
			
			Если Услуга.ОтчетноеВремя > 0 Тогда
				
				Планирование_Сервер_ат.СоздатьДокументЗакрытияЗаявки(Объект.Заявка, Объект.СоздаватьУведомлениеОЗакрытии, Вложения,
					Пользователи.ТекущийПользователь(), Объект);
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Объект.СтатусЗакрытия = Перечисления.СтатусыЗаявок_ат.НаПриемке Тогда
			
			МассивСозданныхПисем = Новый Массив;
			Письмо = Уведомления_ат.СоздатьПисьмоДляПриемкиЗаявки(Объект.Заявка, КомментарийHTML, Вложения);
			МассивСозданныхПисем.Добавить(Письмо);
			СтруктураРезультата.Вставить("МассивСозданныхПисем", МассивСозданныхПисем);
			
		Иначе
			
			Уведомления_ат.УведомитьОСменеСтатуса(Объект.Заявка, Перечисления.СтатусыЗаявок_ат.Закрыта, Вложения,
				Объект.СоздаватьУведомлениеОЗакрытии);
			
		КонецЕсли;
		
		//!!!!!HOTFIX }
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Сообщить(ОписаниеОшибки());
		СтруктураРезультата.Вставить("Ошибка", ОписаниеОшибки());
		
	КонецПопытки;
	
	Возврат СтруктураРезультата;
	
КонецФункции

&НаСервере
Процедура ЗаписатьВСтруктуруРезультатовЗаявокРекурсивно(СтрокиДерева, Счетчик, Заявка, Знач СсылкаНаКод = 0)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если СтрокаДерева.ЭтоРучнойТекст
			ИЛИ ЗначениеЗаполнено(СтрокаДерева.Ссылка) Тогда
			
			НоваяСтрока = Объект.СтруктураРезультатовЗаявок.Добавить();
			НоваяСтрока.Задание = СтрокаДерева.Ссылка;
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДерева);
			НоваяСтрока.СсылкаНаКод = СсылкаНаКод;
			НоваяСтрока.Код = ?(СтрокаДерева.Код > 0, СтрокаДерева.Код, Счетчик);
			НоваяСтрока.Порядок = Счетчик;
			Счетчик = Счетчик + 1;
			
		КонецЕсли;
		
		ЗаписатьВСтруктуруРезультатовЗаявокРекурсивно(СтрокаДерева.Строки, Счетчик, Заявка, СтрокаДерева.Код);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция   ПолучитьТекущуюВерсиюЭкземпляраПродукта(ЭкземплярПродукта)
	
	Возврат ЭкземплярПродукта.ТекущаяВерсия;
	
КонецФункции

#КонецОбласти

#Область HTML

&НаКлиенте
Процедура ОбработчикКомандРаботыСHTML(Команда, ВыбранноеЗначение)
	
	РаботаСHTML_Клиент_ат.ОбработчикКомандРаботыСHTML(ЭтаФорма, Команда, ВыбранноеЗначение,
		Элементы.КомментарийHTML, Элементы.КомманднаяПанельКнопокРедактированияHTML,
		КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийДокументСформирован(Элемент)
	
	Комментарий_ДокументHTMLСформирован = Истина;
	
	//ДобавитьОбработчик Элемент.Документ.Body.OnContextMenu, ОбработчикСобытийПоляHTML_Комментарий;
	//ДобавитьОбработчик Элемент.Документ.Body.OnPaste, ОбработчикСобытийПоляHTML_Комментарий;
	
	РаботаСHTML_Клиент_ат.УстановитьДоступностьПанелейРедактирования(Элементы.КомманднаяПанельКнопокРедактированияHTML,
		Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСобытийПоляHTML_Комментарий(Событие) Экспорт
	
	Если Событие.type = "contextmenu" Тогда
		
		ПолеМожноРедактировать = РаботаСHTML_Клиент_ат.HTMLПолеМожноРедактировать(Элементы.КомментарийHTML);
		
		Для Каждого ЭлементКонтекстногоМеню Из Элементы.КомментарийHTML.КонтекстноеМеню.ПодчиненныеЭлементы Цикл
			
			Если НЕ ЭлементКонтекстногоМеню.Имя = "Комментарий_КонтекстноеМеню_ВключитьВозможностьРедактирования"
				И НЕ ЭлементКонтекстногоМеню.Имя = "Комментарий_КонтекстноеМеню_ПроверитьОрфографию" Тогда
				
				ЭлементКонтекстногоМеню.Доступность = ПолеМожноРедактировать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПолеМожноРедактировать Тогда
			
			Если Событие.srcElement.id = "red_marker" Тогда
				
				РаботаСHTML_Клиент_ат.ОбработатьВызовКонтекстногоМеню(Событие, КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам);	
				
				ИзменитьКонтестноеМенюЗаменыСловПоляHTML(СоответствиеКомандЗаменыСловам);
				
			Иначе
				
				ИзменитьКонтестноеМенюЗаменыСловПоляHTML(Неопределено, Истина);
				
			КонецЕсли;
			
		Иначе
			
			ИзменитьКонтестноеМенюЗаменыСловПоляHTML(Неопределено, Истина);
			
		КонецЕсли;
		
	ИначеЕсли Событие.type = "paste" Тогда
		
		ИдентификаторыКартинок.ЗагрузитьЗначения(РаботаСHTML_Клиент_ат.ПолучитьИдентификаторыКартинок(Элементы.КомментарийHTML.Документ));
		ПодключитьОбработчикОжидания("УдалитьКартинкиВставленныеКопированием", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыполненияHTMLДокументСформирован(Элемент)
	
	Элементы.РезультатВыполненияHTML.Документ.Body.InnerHTML = Объект.РезультатВыполнения;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьКартинкиВставленныеКопированием() Экспорт
	
	РаботаСHTML_Клиент_ат.УдалитьКартинкиВставленныеКопированием(Элементы.КомментарийHTML.Документ,
		ИдентификаторыКартинок.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьКонтестноеМенюЗаменыСловПоляHTML(СоответствиеКомандЗаменыСловам, ТолькоОчистить = Ложь)
	
	РаботаСHTML_Сервер_ат.ИзменитьКонтестноеМенюЗаменыСловПоляHTML(ЭтаФорма,
		Элементы.КомментарийHTML.КонтекстноеМеню, СоответствиеКомандЗаменыСловам, ТолькоОчистить, "ОбработчикКомандРаботыСHTML");
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСHTML_Клиент_ат.ИзменитьПометкиКнопок(Элементы.КомманднаяПанельКнопокРедактированияHTML, Элементы.КомментарийHTML.Документ);	
	
	РаботаСHTML_Клиент_ат.ПерейтиПоСсылке(ДанныеСобытия.href);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УслугиОтчетноеВремяДляОтображенияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Услуги.ТекущиеДанные;
	
	ТекущиеДанные.ОтчетноеВремя = ПродолжительностьПроцессов_КлиентСервер_ат.ПолучитьВремяДеятельностиДляХранения(
		ТекущиеДанные.ОтчетноеВремяДляОтображения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если УправляемыеФормы_Клиент_ат.ТолькоПросмотр(Элемент) Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элементы.Задания.ТекущиеДанные.Задание);
		
	КонецЕсли;

КонецПроцедуры
