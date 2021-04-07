////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Настройка подсистемы в разделенном режиме не поддерживается.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ОбновитьСписокСостоянияУзлов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Элементы.СписокСостоянияУзловВключитьОтключитьРасписаниеОтправкиИПолученияСообщенийСистемы.Пометка =
		РегламентныеЗаданияСервер.ПолучитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.ОтправкаИПолучениеСообщенийСистемы);;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если    ИмяСобытия = ОбменСообщениямиКлиент.ИмяСобытияВыполненаОтправкаИПолучениеСообщений()
		ИЛИ ИмяСобытия = ОбменСообщениямиКлиент.ИмяСобытияЗакрытаФормаКонечнойТочки()
		ИЛИ ИмяСобытия = ОбменСообщениямиКлиент.ИмяСобытияДобавленаКонечнаяТочка()
		ИЛИ ИмяСобытия = ОбменСообщениямиКлиент.ИмяСобытияУстановленаВедущаяКонечнаяТочка()
		Тогда
		
		ОбновитьДанныеМонитора();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СписокСостоянияУзловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИзменитьКонечнуюТочку(Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодключитьКонечнуюТочку(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПодключениеКонечнойТочки",, ЭтаФорма, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодписки(Команда)
	
	ОткрытьФорму("РегистрСведений.ПодпискиПолучателей.Форма.НастройкаПодписокЭтойКонечнойТочки",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьИПолучитьСообщения(Команда)
	
	ОбменСообщениямиКлиент.ОтправитьИПолучитьСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКонечнуюТочку(Команда)
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьЗначение(ТекущиеДанные.УзелИнформационнойБазы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийВыгрузкиДанных(Команда)
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(ТекущиеДанные.УзелИнформационнойБазы, ЭтаФорма, "ВыгрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийЗагрузкиДанных(Команда)
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(ТекущиеДанные.УзелИнформационнойБазы, ЭтаФорма, "ЗагрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеОтправкиИПолученияСообщенийСистемы(Команда)
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписание());
	
	Если Диалог.ОткрытьМодально() Тогда
		
		УстановитьРасписание(Диалог.Расписание);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьРасписаниеОтправкиИПолученияСообщенийСистемы(Команда)
	
	ВключитьОтключитьРасписаниеОтправкиИПолученияСообщенийСистемыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьМонитор(Команда)
	
	ОбновитьДанныеМонитора();
	
КонецПроцедуры

&НаКлиенте
Процедура Подробно(Команда)
	
	ПодробноНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ВключитьОтключитьРасписаниеОтправкиИПолученияСообщенийСистемыНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Элементы.СписокСостоянияУзловВключитьОтключитьРасписаниеОтправкиИПолученияСообщенийСистемы.Пометка =
		НЕ РегламентныеЗаданияСервер.ПолучитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.ОтправкаИПолучениеСообщенийСистемы);
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ОтправкаИПолучениеСообщенийСистемы,
		Элементы.СписокСостоянияУзловВключитьОтключитьРасписаниеОтправкиИПолученияСообщенийСистемы.Пометка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРасписание()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегламентныеЗаданияСервер.ПолучитьРасписаниеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ОтправкаИПолучениеСообщенийСистемы);
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьРасписание(Знач Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ОтправкаИПолучениеСообщенийСистемы,
		Расписание);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСостоянияУзлов()
	
	СписокСостоянияУзлов.Очистить();
	
	Массив = Новый Массив;
	Массив.Добавить("ОбменСообщениями");
	
	МонитораОбменаДанными = ОбменДаннымиСервер.ТаблицаМонитораОбменаДанными(Массив, "Ведущая,Заблокирована");
	
	// обновляем данные в списке состояния узлов
	Для Каждого Настройка Из МонитораОбменаДанными Цикл
		
		Если Настройка.Заблокирована Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СписокСостоянияУзлов.Добавить(), Настройка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеМонитора()
	
	ИндексСтрокиСписокСостоянияУзлов = ПолучитьТекущийИндексСтроки("СписокСостоянияУзлов");
	
	// выполняем обновление таблиц монитора на сервере
	ОбновитьСписокСостоянияУзлов();
	
	// выполняем позиционирование курсора
	ВыполнитьПозиционированиеКурсора("СписокСостоянияУзлов", ИндексСтрокиСписокСостоянияУзлов);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущийИндексСтроки(ИмяТаблицы)
	
	// возвращаемое значение функции
	ИндексСтроки = Неопределено;
	
	// при обновлении монитора выполняем позиционирование курсора
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ИндексСтроки = ЭтаФорма[ИмяТаблицы].Индекс(ТекущиеДанные);
		
	КонецЕсли;
	
	Возврат ИндексСтроки;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПозиционированиеКурсора(ИмяТаблицы, ИндексСтроки)
	
	Если ИндексСтроки <> Неопределено Тогда
		
		// выполняем проверки позиционирования курсора после получения новых данных
		Если ЭтаФорма[ИмяТаблицы].Количество() <> 0 Тогда
			
			Если ИндексСтроки > ЭтаФорма[ИмяТаблицы].Количество() - 1 Тогда
				
				ИндексСтроки = ЭтаФорма[ИмяТаблицы].Количество() - 1;
				
			КонецЕсли;
			
			// позиционируем курсор
			Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтаФорма[ИмяТаблицы][ИндексСтроки].ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодробноНаСервере()
	
	Элементы.СписокСостоянияУзловПодробно.Пометка = Не Элементы.СписокСостоянияУзловПодробно.Пометка;
	
	Элементы.СписокСостоянияУзловДатаПоследнейЗагрузки.Видимость = Элементы.СписокСостоянияУзловПодробно.Пометка;
	Элементы.СписокСостоянияУзловДатаПоследнейВыгрузки.Видимость = Элементы.СписокСостоянияУзловПодробно.Пометка;
	
КонецПроцедуры
