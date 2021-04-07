&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске
	
	// СтандартныеПодсистемы.РегламентныеЗадания
	Элементы.ГруппаОбработкаРегламентныеИФоновыеЗадания.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.РегламентныеЗадания
	
	// СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами
	Элементы.ГруппаОбработкаУправлениеИтогамиИАгрегатамиОткрыть.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.УправлениеИтогамиИАгрегатами
	
	// СтандартныеПодсистемы.ПолнотекстовыйПоиск
	Элементы.ГруппаУправлениеПолнотекстовымПоискомИИзвлечениемТекстов.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ПолнотекстовыйПоиск
	
	// СтандартныеПодсистемы.РезервноеКопированиеИБ
	ПоддержкаРезервногоКопированияВМоделиСервиса = Истина;
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	ПоддержкаРезервногоКопированияВМоделиСервиса = РезервноеКопированиеОбластейДанных.РезервноеКопированиеИспользуется();
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость        = ((РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы) 
		ИЛИ (РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторПрограммы И ПоддержкаРезервногоКопированияВМоделиСервиса);
	ОбновитьНастройкиРезервногоКопирования();
	Элементы.ГруппаВосстановлениеРезервнойКопии.Видимость               = (РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы;
	Элементы.ГруппаВосстановлениеРезервнойКопииВМоделиСервиса.Видимость = РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторПрограммы 
		И ПоддержкаРезервногоКопированияВМоделиСервиса;
	// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Элементы.ГруппаОценкаПроизводительности.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	Элементы.ГруппаКлассификаторы.Видимость = РежимРаботы.Локальный Или РежимРаботы.Автономный;
	
	// СтандартныеПодсистемы.АдресныйКлассификатор
	Элементы.ГруппаРегистрСведенийАдресныйКлассификатор.Видимость = РежимРаботы.Локальный Или РежимРаботы.Автономный;
	// Конец СтандартныеПодсистемы.АдресныйКлассификатор
	
	// СтандартныеПодсистемы.Валюты
	Элементы.ГруппаОбработкаЗагрузкаКурсовВалют.Видимость = РежимРаботы.Локальный;
	// Конец СтандартныеПодсистемы.Валюты
	
	// СтандартныеПодсистемы.Банки
	Элементы.ГруппаЗагрузитьКлассификаторБанков.Видимость = РежимРаботы.Локальный И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.Банки
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	Элементы.ГруппаОткрытьНастройкиРегистрацииСобытийДоступаКПерсональнымДанным.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
	// СтандартныеПодсистемы.ОбновлениеКонфигурации
	Элементы.ГруппаОбработкаОбновлениеКонфигурации.Видимость = РежимРаботы.Локальный И РежимРаботы.ЭтоАдминистраторСистемы И Не РежимРаботы.ЭтоLinuxКлиент;
	// Конец СтандартныеПодсистемы.ОбновлениеКонфигурации
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	Элементы.ГруппаДетализироватьОбновлениеИБВЖурналеРегистрации.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

// СтандартныеПодсистемы.РезервноеКопированиеИБ
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	
	Если ИмяСобытия = "ЗакрытаФормаНастройкиРезервногоКопирования" Тогда
		ОбновитьНастройкиРезервногоКопирования();
	КонецЕсли;
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// СтандартныеПодсистемы.РезервноеКопированиеИБ
&НаКлиенте
Процедура РезервноеКопированиеПрограммыНажатие(Элемент)
	
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	Если РежимРаботы.МодельСервиса Тогда
		ОткрытьФорму("ОбщаяФорма.СозданиеРезервнойКопии", , ЭтаФорма);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРезервногоКопированияНажатие(Элемент)
	
	// СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	Если РежимРаботы.МодельСервиса Тогда
		ОткрытьФорму("Обработка.НастройкаРезервногоКопированияПриложения.Форма", , ЭтаФорма);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных
	
	ОткрытьФорму("Обработка.НастройкаРезервногоКопированияИБ.Форма", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановлениеИзРезервнойКопииНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма.ВосстановлениеДанныхИнформационнойБазыИзРезервнойКопии", , ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Процедура ВыполнятьЗамерыПроизводительностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ДетализироватьОбновлениеИБВЖурналеРегистрацииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.Валюты
&НаКлиенте
Процедура ОбработкаЗагрузкаКурсовВалют(Команда)
	
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Валюты

// СтандартныеПодсистемы.Банки
&НаКлиенте
Процедура ЗагрузитьКлассификаторБанков(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Банки

// СтандартныеПодсистемы.АдресныйКлассификатор
&НаКлиенте
Процедура ОткрытьАдресныйКлассификатор(Команда)
	
	ОткрытьФорму("РегистрСведений.АдресныйКлассификатор.Форма.АдресныйКлассификатор");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.АдресныйКлассификатор

// СтандартныеПодсистемы.ПолнотекстовыйПоиск
&НаКлиенте
Процедура ОбработкаУправлениеПолнотекстовымПоиском(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.УправлениеПолнотекстовымПоискомИИзвлечениемТекстов", , ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПолнотекстовыйПоиск

// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ОтложеннаяОбработкаДанных(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзПанелиАдминистрирования", Истина);
	ОткрытьФорму("Обработка.ОбновлениеИнформационнойБазы.Форма.ИндикацияХодаОтложенногоОбновленияИБ", ПараметрыФормы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		// СтандартныеПодсистемы.ВариантыОтчетов
		ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		// Конец СтандартныеПодсистемы.ВариантыОтчетов
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		
		// СтандартныеПодсистемы.ОценкаПроизводительности
		Если РеквизитПутьКДанным = "НаборКонстант.ВыполнятьЗамерыПроизводительности" ИЛИ РеквизитПутьКДанным = "" Тогда
			Элементы.ОбработкаОценкаПроизводительности.Доступность = НаборКонстант.ВыполнятьЗамерыПроизводительности;
		КонецЕсли;
		// Конец СтандартныеПодсистемы.ОценкаПроизводительности
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиРезервногоКопирования()
	
	// СтандартныеПодсистемы.РезервноеКопированиеИБ
	Если (РежимРаботы.Локальный Или РежимРаботы.Автономный) И РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Элементы.ПояснениеНастройкаРезервногоКопирования.Заголовок = РезервноеКопированиеИБСервер.ТекущаяНастройкаРезервногоКопирования();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ
	
КонецПроцедуры
