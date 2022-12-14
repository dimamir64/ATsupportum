
///////////////////////////////////////////////////////////////////////////////////////////////////
//ПЕРЕМЕННЫЕ МОДУЛЯ
///////////////////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Перем КоординатыЗаменяемогоСлова;

&НаКлиенте
Перем СоответствиеКомандЗаменыСловам;

///////////////////////////////////////////////////////////////////////////////////////////////////
//ОСНОВНЫЕ ПРОЦЕДУРЫ ФОРМЫ
///////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Объект.Ссылка.Пустая() Тогда // Новый.
		
		Вопрос = Параметры.Владелец;
		Если ЗначениеЗаполнено(Параметры.Владелец) Тогда
			Объект.Владелец = Вопрос;
		КонецЕсли;
		
		Объект.Состояние = Перечисления.СостоянияРешений_ат.Предварительное ;
		
		Объект.Приоритет = 1;
		
		Модифицированность = Ложь;
		
	КонецЕсли;
	
	РаботаСHTML_Сервер_ат.СоздатьВременныеФайлыКартинокТекста(Объект, "Содержание", ЭтаФорма,, Истина);
	Содержание = Объект.Содержание;
	//// Избавляемся от потери данных когда форма не отрисовывает поля HTML
	
	РаботаСHTML_Сервер_ат.СоздатьПанелиРаботыСHTML(ЭтаФорма, Элементы.КомманднаяПанельКнопокРедактированияHTML,
		"ОбработчикКомандРаботыСHTML", Истина, Элементы.СодержаниеКонтекстноеМеню);
		
	СотрудникОрганизации = ВнутреннегоИспользования_КлиентСерверПовтИсп_ат.СотрудникОрганизации();
	Элементы.КомманднаяПанельКнопокРедактированияHTML.Видимость = СотрудникОрганизации;
	Элементы.СодержаниеКонтекстноеМеню.Доступность = СотрудникОрганизации;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	УправляемыеФормы_Клиент_ат.ПриПовторномОткрытии(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Клиент_ат.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	УправляемыеФормы_Клиент_ат.ПриЗакрытии(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	УправляемыеФормы_Клиент_ат.ОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	УправляемыеФормы_Клиент_ат.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАктивизации(АктивныйОбъект, Источник)
	
	УправляемыеФормы_Клиент_ат.ОбработкаАктивизации(ЭтаФорма, АктивныйОбъект, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	УправляемыеФормы_Клиент_ат.ОбработкаЗаписиНового(ЭтаФорма, НовыйОбъект, Источник, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправляемыеФормы_Сервер_ат.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
	РаботаСHTML_Клиент_ат.ОбработатьHTMLПередЗаписью(Элементы.Содержание);
	Элементы.Содержание.Документ.body.InnerHTML = ПроверкаОрфографии_Клиент_ат.УдалитьИзТекстаHTMLТэгиВыделения(Элементы.Содержание.Документ.body.InnerHTML);
	Объект.Содержание = Элементы.Содержание.Документ.documentElement.outerHTML;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправляемыеФормы_Сервер_ат.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправляемыеФормы_Сервер_ат.ПриЗаписиНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УправляемыеФормы_Сервер_ат.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	Оповестить("ЗаписьРешения", Объект.Ссылка, ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправляемыеФормы_Сервер_ат.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПРоверяемыеРеквизиты);
	
КонецПроцедуры

#Область HTML

&НаКлиенте
Процедура ОбработчикКомандРаботыСHTML(Команда, ВыбранноеЗначение)
	
	РаботаСHTML_Клиент_ат.ОбработчикКомандРаботыСHTML(ЭтаФорма, Команда, ВыбранноеЗначение,
		Элементы.Содержание, Элементы.КомманднаяПанельКнопокРедактированияHTML,
		КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам);
	
КонецПроцедуры

&НаКлиенте
Процедура СодержаниеДокументСформирован(Элемент)
	
	//ДобавитьОбработчик Элемент.Документ.Body.oncontextmenu, ОбработчикСобытийПоляHTML;
	
	РаботаСHTML_Клиент_ат.УстановитьДоступностьПанелейРедактирования(Элементы.КомманднаяПанельКнопокРедактированияHTML,
		Элемент, Ложь);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОбработчикСобытийПоляHTML(Событие) Экспорт
	
	Если Событие.type = "contextmenu" Тогда	
		
		ПолеМожноРедактировать = РаботаСHTML_Клиент_ат.HTMLПолеМожноРедактировать(Элементы.Содержание);
		
		Для Каждого ЭлементКонтекстногоМеню Из Элементы.ПредставлениеТекстаЗаявкиВHTML.КонтекстноеМеню.ПодчиненныеЭлементы Цикл
			
			Если НЕ ЭлементКонтекстногоМеню.Имя = "Содержание_КонтекстноеМеню_ВключитьВозможностьРедактирования"
			   И НЕ ЭлементКонтекстногоМеню.Имя = "Содержание_КонтекстноеМеню_ПроверитьОрфографию" Тогда
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
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьКонтестноеМенюЗаменыСловПоляHTML(СоответствиеКомандЗаменыСловам, ТолькоОчистить = Ложь)
	
	РаботаСHTML_Сервер_ат.ИзменитьКонтестноеМенюЗаменыСловПоляHTML(ЭтаФорма,
		Элементы.Содержание.КонтекстноеМеню, СоответствиеКомандЗаменыСловам, ТолькоОчистить, "ОбработчикКомандРаботыСHTML");
	
КонецПроцедуры

&НаКлиенте
Процедура СодержаниеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСHTML_Клиент_ат.ИзменитьПометкиКнопок(Элементы.КомманднаяПанельКнопокРедактированияHTML, Элементы.Содержание.Документ);	
	
	РаботаСHTML_Клиент_ат.ПерейтиПоСсылке(ДанныеСобытия.href);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаПросмотр(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ФормаРедактораHTML_ат", Новый Структура("ТекстHTML,ФормаОткрытаДляПросмотра", Элементы.Содержание.Документ.documentElement.OuterHTML, Истина), ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти 

