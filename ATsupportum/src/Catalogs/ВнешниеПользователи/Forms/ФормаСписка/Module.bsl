////////////////////////////////////////////////////////////////////////////////
//                          ИСПОЛЬЗОВАНИЕ ФОРМЫ                               //
//
// Дополнительные параметры открытия формы подбора:
//
// РасширенныйПодбор - Булево - если Истина - открывается расширенная форма
//  подбора пользователей. Используется вместе с параметром
//  ПараметрыРасширеннойФормыПодбора.
// ПараметрыРасширеннойФормыПодбора - Строка - ссылка на структуру,
//  содержащую параметры расширенной формы подбора во
//  временном хранилище.
//  Параметры структуры:
//    ЗаголовокФормыПодбора - Строка - заголовок формы подбора.
//    ВыбранныеПользователи - Массив - массив уже выбранных пользователей.
//

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Начальное значение настройки до загрузки данных из настроек.
	ВыбиратьИерархически = Истина;
	
	ЗаполнитьХранимыеПараметры();
	ЗаполнитьПараметрыДинамическихСписков();
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	// Скрытие пользователей с пустым идентификатором, если значение параметра Истина.
	Если Параметры.ДоступКИнформационнойБазеРазрешен Тогда
		
		Если Параметры.ДоступКИнформационнойБазеРазрешен = Ложь Тогда
			ВидСравненияКД = ВидСравненияКомпоновкиДанных.Равно;
		Иначе
			ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеРавно;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ВнешниеПользователиСписок,
			"ИдентификаторПользователяИБ",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКД);
		
	КонецЕсли;
	
	// Скрытие переданного пользователя из формы выбора пользователей.
	Если ТипЗнч(Параметры.СкрываемыеПользователи) = Тип("СписокЗначений") Тогда
		
		ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСписке;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ВнешниеПользователиСписок,
			"Ссылка",
			Параметры.СкрываемыеПользователи,
			ВидСравненияКД);
	КонецЕсли;
	
	НастроитьПорядокГруппыВсеВнешниеПользователи(ГруппыВнешнихПользователей);
	ОформитьИСкрытьНедействительныхВнешнихПользователей();
	
	ХранимыеПараметры.Вставить("РасширенныйПодбор", Параметры.РасширенныйПодбор);
	Элементы.ВыбранныеПользователиИГруппы.Видимость = ХранимыеПараметры.РасширенныйПодбор;
	ХранимыеПараметры.Вставить(
		"ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Элементы.СоздатьВнешнегоПользователя.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		
		// Отбор не помеченных на удаление.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ВнешниеПользователиСписок, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
		Элементы.ВнешниеПользователиСписок.РежимВыбора = Истина;
		Элементы.ГруппыВнешнихПользователей.РежимВыбора =
			ХранимыеПараметры.ВыборГруппВнешнихПользователей;
		
		// Отключение перетаскивания пользователя в формах выбора и подбора пользователей.
		Элементы.ВнешниеПользователиСписок.РазрешитьНачалоПеретаскивания = Ложь;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.ВнешниеПользователиСписок.МножественныйВыбор = Истина;
			
			Если ХранимыеПараметры.РасширенныйПодбор Тогда
				ЭтаФорма.КлючСохраненияПоложенияОкна = "РасширенныйПодборВнешнихПользователей";
				ИзменитьПараметрыРасширеннойФормыПодбора();
			Иначе
				ЭтаФорма.КлючСохраненияПоложенияОкна = "РежимПодбораВнешнихПользователей";
			КонецЕсли;
			
			Если ХранимыеПараметры.ВыборГруппВнешнихПользователей Тогда
				Элементы.ГруппыВнешнихПользователей.МножественныйВыбор = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ВыбратьВнешнегоПользователя.Видимость       = Ложь;
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	
	ХранимыеПараметры.Вставить("ГруппаВсеПользователи", Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи);
	ХранимыеПараметры.Вставить("ТекущаяСтрока", Параметры.ТекущаяСтрока);
	НастроитьФормуПоИспользованиюГруппПользователей();
	ХранимыеПараметры.Удалить("ТекущаяСтрока");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыВнешнихПользователей")
	   И Источник = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока Тогда
		
		Элементы.ГруппыВнешнихПользователей.Обновить();
		Элементы.ВнешниеПользователиСписок.Обновить();
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_ИспользоватьГруппыПользователей") Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененииИспользованияГруппПользователей", 0.1, Истина);
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("РазмещениеПользователейВГруппах") Тогда
		
		Элементы.ВнешниеПользователиСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ТипЗнч(Настройки["ВыбиратьИерархически"]) = Тип("Булево") Тогда
		ВыбиратьИерархически = Настройки["ВыбиратьИерархически"];
	КонецЕсли;
	
	Если НЕ ВыбиратьИерархически Тогда
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор
		Или Не СписокВыбранныхПользователейИзменен Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Список выбранных пользователей был изменен. Сохранить изменения?'");
	КнопкиВопроса = Новый СписокЗначений;
	КнопкиВопроса.Добавить(НСтр("ru='Да'"));
	КнопкиВопроса.Добавить(НСтр("ru='Нет'"));
	КнопкиВопроса.Добавить(НСтр("ru='Отмена'"));
	Ответ = Вопрос(ТекстВопроса, КнопкиВопроса,, КнопкиВопроса[0].Значение);
	
	Если Ответ = КнопкиВопроса[0].Значение Тогда
		МассивПользователей = РезультатВыбора();
		ОповеститьОВыборе(МассивПользователей);
	ИначеЕсли Ответ = КнопкиВопроса[2].Значение Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГруппыВнешнихПользователей

&НаКлиенте
Процедура ГруппыВнешнихПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			
			ПараметрыФормы.Вставить(
				"ЗначенияЗаполнения",
				Новый Структура("Родитель", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
		КонецЕсли;
		
		ОткрытьФорму(
			"Справочник.ГруппыВнешнихПользователей.ФормаОбъекта",
			ПараметрыФормы,
			Элементы.ГруппыВнешнихПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбиратьИерархически Тогда
		Предупреждение(НСтр("ru = 'Для перетаскивания пользователя в группы необходимо отключить
			|флажок ""Показывать пользователей дочерних групп"".'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = Строка
		Или Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
		Перемещение = Истина;
	Иначе
		Перемещение = Ложь;
	КонецЕсли;
	
	ТекущаяСтрокаГруппы = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока;
	ГруппаСТипомВсеОбъектыАвторизации = 
		Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(ТекущаяСтрокаГруппы).ВсеОбъектыАвторизации;
	
	Если Строка = ХранимыеПараметры.ГруппаВсеПользователи
		И ГруппаСТипомВсеОбъектыАвторизации Тогда
		СообщениеПользователю = Новый Структура("Сообщение, ЕстьОшибки, Пользователи",
			НСтр("ru = 'Из групп с типом участников ""Все пользователи заданного типа"" исключение пользователей невозможно.'"),
			Истина,
			Неопределено);
	Иначе
		ГруппаПомеченаНаУдаление = Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(Строка).ПометкаУдаления;
		
		КоличествоПользователей = ПараметрыПеретаскивания.Значение.Количество();
		
		ДействиеИсключитьПользователя = (ХранимыеПараметры.ГруппаВсеПользователи = Строка);
		
		ДействиеСПользователем = 
			?((ХранимыеПараметры.ГруппаВсеПользователи = ТекущаяСтрокаГруппы) ИЛИ ГруппаСТипомВсеОбъектыАвторизации,
			НСтр("ru = 'Включить'"),
			?(Перемещение, НСтр("ru = 'Переместить'"), НСтр("ru = 'Скопировать'")));
		
		Если ГруппаПомеченаНаУдаление Тогда
			ШаблонДействия = ?(Перемещение, НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"), 
				НСтр("ru = 'Группа ""%1"" помечена на удаление. %2'"));
			ДействиеСПользователем = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонДействия, Строка(Строка), ДействиеСПользователем);
		КонецЕсли;
		
		Если КоличествоПользователей = 1 Тогда
			
			Если ДействиеИсключитьПользователя Тогда
				ШаблонВопроса = НСтр("ru = 'Исключить пользователя ""%2"" из группы ""%4""?'");
			ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
				ШаблонВопроса = НСтр("ru = '%1 пользователя ""%2"" в группу ""%3""?'");
			Иначе
				ШаблонВопроса = НСтр("ru = '%1 пользователя ""%2"" в эту группу?'");
			КонецЕсли;
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонВопроса, ДействиеСПользователем, Строка(ПараметрыПеретаскивания.Значение[0]),
				Строка(Строка), Строка(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
			
		Иначе
			
			Если ДействиеИсключитьПользователя Тогда
				ШаблонВопроса = НСтр("ru = 'Исключить пользователей (%2) из группы ""%4""?'");
			ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
				ШаблонВопроса = НСтр("ru = '%1 пользователей (%2) в группу ""%3""?'");
			Иначе
				ШаблонВопроса = НСтр("ru = '%1 пользователей (%2) в эту группу?'");
			КонецЕсли;
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонВопроса, ДействиеСПользователем, КоличествоПользователей,
				Строка(Строка), Строка(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
			
		КонецЕсли;
		
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		СообщениеПользователю = ПеремещениеПользователяВНовуюГруппу(
			ПараметрыПеретаскивания.Значение, Строка, Перемещение);
	КонецЕсли;
	
	Если СообщениеПользователю.Сообщение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ГруппыВнешнихПользователей");
	
	Если СообщениеПользователю.ЕстьОшибки = Ложь Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю.Сообщение, БиблиотекаКартинок.Информация32);
	Иначе
		
		Если СообщениеПользователю.Пользователи <> Неопределено Тогда
			Отчет = Новый ТекстовыйДокумент;
			Отчет.ДобавитьСтроку(НСтр("ru = 'Следующие пользователи не были включены в выбранную группу:'"));
			Отчет.ДобавитьСтроку(Символы.ПС);
			Отчет.ДобавитьСтроку(СообщениеПользователю.Пользователи);
			
			ТекстВопроса = СообщениеПользователю.Сообщение;
			КнопкиВопроса = Новый СписокЗначений;
			КнопкиВопроса.Добавить(НСтр("ru='ОК'"));
			КнопкиВопроса.Добавить(НСтр("ru='Показать отчет'"));
			Ответ = Вопрос(ТекстВопроса, КнопкиВопроса,, КнопкиВопроса[0].Значение);
			
			Если Ответ = КнопкиВопроса[0].Значение Тогда
				Возврат;
			Иначе
				Отчет.Показать(НСтр("ru = 'Пользователи, не включенные в группы'"));
				Возврат;
			КонецЕсли;
		Иначе
			Предупреждение(СообщениеПользователю.Сообщение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ВнешниеПользователи

&НаКлиенте
Процедура ВнешниеПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура(
		"ГруппаНовогоВнешнегоПользователя", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(ХранимыеПараметры.ОтборОбъектАвторизации) Тогда
		
		ПараметрыФормы.Вставить(
			"ОбъектАвторизацииНовогоВнешнегоПользователя",
			ХранимыеПараметры.ОтборОбъектАвторизации);
	КонецЕсли;
	
	Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ВнешниеПользователи.ФормаОбъекта",
		ПараметрыФормы,
		Элементы.ВнешниеПользователиСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокВыбранныхПользователейИГрупп

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	УдалитьИзСпискаВыбранных();
	СписокВыбранныхПользователейИзменен = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьГруппуВнешнихПользователей(Команда)
	
	Элементы.ГруппыВнешнихПользователей.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	Элементы.ПоказыватьНедействительныхПользователей.Пометка =
		НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ВнешниеПользователиСписок, "Недействителен", Ложь, , ,
		НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьГруппы(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователи", Элементы.ВнешниеПользователиСписок.ВыделенныеСтроки);
	ПараметрыФормы.Вставить("ВнешниеПользователи", Истина);
	
	ОткрытьФорму("ОбщаяФорма.ГруппыПользователей", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьИЗакрыть(Команда)
	
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		МассивПользователей = РезультатВыбора();
		ОповеститьОВыборе(МассивПользователей);
		СписокВыбранныхПользователейИзменен = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователяКоманда(Команда)
	
	МассивПользователей = Элементы.ВнешниеПользователиСписок.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборПользователяИлиГруппы(Команда)
	
		УдалитьИзСпискаВыбранных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокВыбранныхПользователейИГрупп(Команда)
	
	УдалитьИзСпискаВыбранных(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппу(Команда)
	
	МассивГрупп = Элементы.ГруппыВнешнихПользователей.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивГрупп);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьХранимыеПараметры()
	
	ХранимыеПараметры = Новый Структура;
	ХранимыеПараметры.Вставить("ВыборГруппВнешнихПользователей", Параметры.ВыборГруппВнешнихПользователей);
	
	Если Параметры.Отбор.Свойство("ОбъектАвторизации") Тогда
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Параметры.Отбор.ОбъектАвторизации);
	Иначе
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Неопределено);
	КонецЕсли;
	
	// Подготовка представлений типов объектов авторизации.
	ХранимыеПараметры.Вставить("ПредставлениеТиповОбъектовАвторизации", Новый СписокЗначений);
	ТипыОбъектовАвторизации = Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектАвторизации.Тип.Типы();
	
	Для каждого ТекущийТипОбъектовАвторизации Из ТипыОбъектовАвторизации Цикл
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТекущийТипОбъектовАвторизации);
		ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
		
		ХранимыеПараметры.ПредставлениеТиповОбъектовАвторизации.Добавить(
			ОписаниеТипа.ПривестиЗначение(Неопределено),
			Метаданные.НайтиПоТипу(ТекущийТипОбъектовАвторизации).Синоним);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыДинамическихСписков()
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ПустойУникальныйИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	ТипОбъектовАвторизации = Неопределено;
	Параметры.Свойство("ТипОбъектовАвторизации", ТипОбъектовАвторизации);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ГруппыВнешнихПользователей,
		"ЛюбойТипОбъектовАвторизации",
		ТипОбъектовАвторизации = Неопределено);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ГруппыВнешнихПользователей,
		"ТипОбъектовАвторизации",
		ТипЗнч(ТипОбъектовАвторизации));
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ЛюбойТипОбъектовАвторизации",
		ТипОбъектовАвторизации = Неопределено);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ТипОбъектовАвторизации",
		ТипЗнч(ТипОбъектовАвторизации));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПорядокГруппыВсеВнешниеПользователи(Список)
	
	Перем Порядок;
	
	// Порядок.
	Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
		Порядок = Список.КомпоновщикНастроек.Настройки.Порядок;
		Порядок.ИдентификаторПользовательскойНастройки = "ОсновнойПорядок";
	Иначе
		Порядок = Список.Порядок;
	КонецЕсли;
	
	Порядок.Элементы.Очистить();
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
	ЭлементПорядка = Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьИСкрытьНедействительныхВнешнихПользователей()
	
	// Оформление.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.НедоступныеДанныеЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВнешниеПользователиСписок.Недействителен");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ВнешниеПользователиСписок");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Скрытие.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ВнешниеПользователиСписок, "Недействителен", Ложь, , , Истина);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьИзСпискаВыбранных(УдалитьВсех = Ложь)
	
	Если УдалитьВсех Тогда
		ВыбранныеПользователиИГруппы.Очистить();
		ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
		Возврат;
	КонецЕсли;
	
	МассивЭлементовСписка = Элементы.СписокВыбранныхПользователейИГрупп.ВыделенныеСтроки;
	Для Каждого ЭлементСписка Из МассивЭлементовСписка Цикл
		ВыбранныеПользователиИГруппы.Удалить(ВыбранныеПользователиИГруппы.НайтиПоИдентификатору(ЭлементСписка));
	КонецЦикла;
	
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивВыбранныхЭлементов)
	
	ВыбранныеЭлементыИКартинки = Новый Массив;
	Для Каждого ВыбранныйЭлемент Из МассивВыбранныхЭлементов Цикл
		
		Если ТипЗнч(ВыбранныйЭлемент) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			НомерКартинки = Элементы.ВнешниеПользователиСписок.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		Иначе
			НомерКартинки = Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		КонецЕсли;
		
		ВыбранныеЭлементыИКартинки.Добавить(
			Новый Структура("ВыбранныйЭлемент, НомерКартинки", ВыбранныйЭлемент, НомерКартинки));
	КонецЦикла;
	
	ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки);
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	
	ВыбранныеПользователиТаблицаЗначений = ВыбранныеПользователиИГруппы.Выгрузить( , "Пользователь");
	МассивПользователей = ВыбранныеПользователиТаблицаЗначений.ВыгрузитьКолонку("Пользователь");
	Возврат МассивПользователей;
	
КонецФункции

&НаСервере
Процедура ИзменитьПараметрыРасширеннойФормыПодбора()
	
	// Загрузка списка выбранных пользователей
	ПараметрыРасширеннойФормыПодбора = ПолучитьИзВременногоХранилища(Параметры.ПараметрыРасширеннойФормыПодбора);
	ВыбранныеПользователиИГруппы.Загрузить(ПараметрыРасширеннойФормыПодбора.ВыбранныеПользователи);
	ХранимыеПараметры.Вставить("ЗаголовокФормыПодбора", ПараметрыРасширеннойФормыПодбора.ЗаголовокФормыПодбора);
	Пользователи.ЗаполнитьНомераКартинокПользователей(ВыбранныеПользователиИГруппы, "Пользователь", "НомерКартинки");
	// Установка параметров расширенной формы подбора.
	Элементы.ЗавершитьИЗакрыть.Видимость                      = Истина;
	Элементы.ГруппаВыбратьПользователя.Видимость              = Истина;
	// Включение видимости списка выбранных пользователей.
	Элементы.ВыбранныеПользователиИГруппы.Видимость           = Истина;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") Тогда
		Элементы.ГруппыИПользователи.Группировка                 = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ГруппыИПользователи.ШиринаПодчиненныхЭлементов  = ШиринаПодчиненныхЭлементовФормы.Одинаковая;
		ЭтаФорма.Высота                                          = 25;
		Элементы.ГруппаВыбратьГруппу.Видимость                   = Истина;
		// Включение отображения заголовков списков ПользователиСписок и ГруппыПользователей.
		Элементы.ГруппыВнешнихПользователей.ПоложениеЗаголовка   = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ВнешниеПользователиСписок.ПоложениеЗаголовка    = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ВнешниеПользователиСписок.Заголовок             = НСтр("ru = 'Пользователи в группе'");
		Если ПараметрыРасширеннойФормыПодбора.Свойство("ПодборГруппНевозможен") Тогда
			Элементы.ВыбратьГруппу.Видимость                     = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтменитьВыборПользователя.Видимость             = Истина;
		Элементы.ОчиститьСписокВыбранных.Видимость               = Истина;
	КонецЕсли;
	
	// Добавление количества выбранных пользователей в заголовке выбранных пользователей и групп.
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп()
	
	Если ХранимыеПараметры.ИспользоватьГруппы Тогда
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи и группы (%1)'");
	Иначе
		ЗаголовокВыбранныеПользователиИГруппы = НСтр("ru = 'Выбранные пользователи (%1)'");
	КонецЕсли;
	
	КоличествоПользователей = ВыбранныеПользователиИГруппы.Количество();
	Если КоличествоПользователей <> 0 Тогда
		Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокВыбранныеПользователиИГруппы, КоличествоПользователей);
	Иначе
		
		Если ХранимыеПараметры.ИспользоватьГруппы Тогда
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи и группы'");
		Иначе
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = НСтр("ru = 'Выбранные пользователи'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки)
	
	Для Каждого СтрокаМассива Из ВыбранныеЭлементыИКартинки Цикл
		
		ВыбранныйПользовательИлиГруппа = СтрокаМассива.ВыбранныйЭлемент;
		НомерКартинки = СтрокаМассива.НомерКартинки;
		
		ПараметрыОтбора = Новый Структура("Пользователь", ВыбранныйПользовательИлиГруппа);
		Найденный = ВыбранныеПользователиИГруппы.НайтиСтроки(ПараметрыОтбора);
		Если Найденный.Количество() = 0 Тогда
			
			СтрокаВыбранныеПользователи = ВыбранныеПользователиИГруппы.Добавить();
			СтрокаВыбранныеПользователи.Пользователь = ВыбранныйПользовательИлиГруппа;
			СтрокаВыбранныеПользователи.НомерКартинки = НомерКартинки;
			СписокВыбранныхПользователейИзменен = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВыбранныеПользователиИГруппы.Сортировать("Пользователь Возр");
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияГруппПользователей()
	
	НастроитьФормуПоИспользованиюГруппПользователей();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоИспользованиюГруппПользователей()
	
	Если ХранимыеПараметры.Свойство("ТекущаяСтрока") Тогда
		
		Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			
			Если ХранимыеПараметры.ИспользоватьГруппы Тогда
				Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ХранимыеПараметры.ТекущаяСтрока;
			Иначе
				Параметры.ТекущаяСтрока = Неопределено;
			КонецЕсли;
		Иначе
			ТекущийЭлемент = Элементы.ВнешниеПользователиСписок;
			
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока =
				Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		КонецЕсли;
	Иначе
		Если НЕ ХранимыеПараметры.ИспользоватьГруппы
		   И Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока
		     <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока =
				Справочники.ГруппыПользователей.ВсеПользователи;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.Видимость =
		ХранимыеПараметры.ИспользоватьГруппы;
	
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		Элементы.НазначитьГруппы.Видимость = Ложь;
	Иначе
		Элементы.НазначитьГруппы.Видимость = ХранимыеПараметры.ИспользоватьГруппы;
	КонецЕсли;
	
	Элементы.СоздатьГруппуВнешнихПользователей.Видимость =
		ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыВнешнихПользователей)
		И ХранимыеПараметры.ИспользоватьГруппы;
	
	ВыборГруппВнешнихПользователей = ХранимыеПараметры.ВыборГруппВнешнихПользователей
	                               И ХранимыеПараметры.ИспользоватьГруппы
	                               И Параметры.РежимВыбора;
	
	Если Параметры.РежимВыбора Тогда
		
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость   = 
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, ВыборГруппВнешнихПользователей);
		Элементы.ВыбратьВнешнегоПользователя.КнопкаПоУмолчанию =
			?(ХранимыеПараметры.РасширенныйПодбор, Ложь, Не ВыборГруппВнешнихПользователей);
		Элементы.ВыбратьВнешнегоПользователя.Видимость         = Не ХранимыеПараметры.РасширенныйПодбор;
		
		АвтоЗаголовок = Ложь;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			
			Если ВыборГруппВнешнихПользователей Тогда
				
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор внешних пользователей и групп'");
				КонецЕсли;
				
				Элементы.ВыбратьВнешнегоПользователя.Заголовок =
					НСтр("ru = 'Выбрать внешних пользователей'");
				
				Элементы.ВыбратьГруппуВнешнихПользователей.Заголовок =
					НСтр("ru = 'Выбрать группы'");
				
			Иначе
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = НСтр("ru = 'Подбор внешних пользователей'");
				КонецЕсли;
			КонецЕсли;
		Иначе
			// Режим выбора.
			Если ВыборГруппВнешнихПользователей Тогда
				Заголовок = НСтр("ru = 'Выбор внешнего пользователя или группы'");
				
				Элементы.ВыбратьВнешнегоПользователя.Заголовок = НСтр("ru = 'Выбрать внешнего пользователя'");
			Иначе
				Заголовок = НСтр("ru = 'Выбор внешнего пользователя'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВНовуюГруппу(МассивПользователей, НоваяГруппаВладелец, Перемещение)
	
	Если НоваяГруппаВладелец = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекущаяГруппаВладелец = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока;
	СообщениеПользователю = ПользователиСлужебный.ПеремещениеПользователяВНовуюГруппу(
		МассивПользователей, ТекущаяГруппаВладелец, НоваяГруппаВладелец, Перемещение);
	
	Элементы.ВнешниеПользователиСписок.Обновить();
	Элементы.ГруппыВнешнихПользователей.Обновить();
	
	Возврат СообщениеПользователю;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы(Форма)
	
	Элементы = Форма.Элементы;
	
	Если НЕ Форма.ХранимыеПараметры.ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ПредопределенноеЗначение(
	         "Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи") Тогда
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок,
			"ГруппаВнешнихПользователей",
			ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи"));
	Иначе
	#Если Сервер Тогда
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			ТекущиеДанные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока, "ВсеОбъектыАвторизации");
		Иначе
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	#Иначе
		ТекущиеДанные = Элементы.ГруппыВнешнихПользователей.ТекущиеДанные;
	#КонецЕсли
		
		Если ТекущиеДанные <> Неопределено
		   И ТекущиеДанные.ВсеОбъектыАвторизации Тогда
			
			ЭлементПредставленияТипаОбъектаАвторизации =
				Форма.ХранимыеПараметры.ПредставлениеТиповОбъектовАвторизации.НайтиПоЗначению(
					ТекущиеДанные.ТипОбъектовАвторизации);
				
			ОбновитьЗначениеПараметраКомпоновкиДанных(
				Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		Иначе
			ОбновитьЗначениеПараметраКомпоновкиДанных(
				Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Форма.ВыбиратьИерархически);
		КонецЕсли;
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок,
			"ГруппаВнешнихПользователей",
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров,
                                                    Знач ИмяПараметра,
                                                    Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			
			Если Параметр.Использование
			   И Параметр.Значение = ЗначениеПараметра Тогда
				
				Возврат;
			КонецЕсли;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры
