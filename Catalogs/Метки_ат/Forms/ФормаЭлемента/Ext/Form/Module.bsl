
#Область ЛокальныеПеременные

#Область Комментарии

&НаКлиенте
Перем КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам;

#КонецОбласти

#КонецОбласти

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправляемыеФормы_Сервер_ат.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	#Область Комментарии
	
	ЗагрузитьКомментарии(Ложь);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	#Область Комментарии
	
	ЗагрузитьКомментарии(Истина);
	
	#КонецОбласти
	
	ЭтаФорма.ТолькоПросмотр = НЕ Объект.Ссылка.Пустая() И НЕ Метки_Сервер_ат.ПроверитьДоступностьМетки(Объект.Ссылка, Истина);
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
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
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
	#Область Комментарии
	
	Если КомментарийВнутреннийСформирован Тогда
		
		Элементы.КомментарийВнутренний.Документ.body.innerHTML =
			ПроверкаОрфографии_Клиент_ат.УдалитьИзТекстаHTMLТэгиВыделения(Элементы.КомментарийВнутренний.Документ.body.innerHTML);
		
		КомментарийВнутренний = Элементы.КомментарийВнутренний.Документ.documentElement.outerHTML;
		
		РаботаСHTML_Клиент_ат.ВключитьВозможностьРедактирования(ЭтаФорма,
			Элементы.КомментарийВнутренний, Элементы.КомментарийВнутренний_КоманднаяПанель, Истина);
		
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправляемыеФормы_Сервер_ат.ПриЗаписиНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	#Область Комментарии
	
	Комментарии_ат.СохранитьКомментарий(ЭтаФорма, ТекущийОбъект.Ссылка);
	Комментарии_ат.СохранитьКомментарийВнутренний(ЭтаФорма, ТекущийОбъект.Ссылка);
	Комментарии_ат.СохранитьКомментарийКлиента(ЭтаФорма, ТекущийОбъект.Ссылка);
	
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	Оповестить("ОбновленСписокМеток");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщаяПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ЛичнаяПриИзменении(Элемент)
	
	УстановитьВидимость();
	Если Объект.Личная Тогда
		Объект.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		Объект.Пользователь = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#Область УниверсальныеОбработчикиДействий
	
&НаКлиенте
Процедура ОбработчикУниверсальныхДействий(Команда)
	
	УправляемыеФормы_Клиент_ат.ДополнительныеДействияФормы(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Функция   ОбработчикУниверсальныхДействий_Сервер(Элемент) Экспорт
	
	Возврат УправляемыеФормы_Сервер_ат.ДополнительныеДействияФормы(ЭтаФорма, Команды[Элемент.Имя]);
	
КонецФункции
	
#КонецОбласти 

#Область Комментарии

&НаСервере
Процедура ЗагрузитьКомментарии(СозданиеФормы)
	
	Если НЕ СозданиеФормы Тогда
		
		Комментарии_ат.ЗагрузитьКомментарий(ЭтаФорма, Объект.Ссылка);
		Комментарии_ат.ЗагрузитьКомментарийКлиента(ЭтаФорма, Объект.Ссылка);
		
	КонецЕсли;
	
	Если НЕ СозданиеФормы ИЛИ Объект.Ссылка.Пустая() Тогда
		
		Комментарии_ат.ЗагрузитьКомментарийВнутренний(ЭтаФорма, Объект.Ссылка);
		
	КонецЕсли;
	
	Если СозданиеФормы И Элементы.КомментарийВнутренний.Видимость И НЕ Элементы.КомментарийВнутренний.ТолькоПросмотр Тогда
		
		РаботаСHTML_Сервер_ат.СоздатьПанелиРаботыСHTML(ЭтаФорма, Элементы.КомментарийВнутренний_КоманднаяПанель,
			"КомментарийВнутренний_ОбработчикКоманд", , Элементы.КомментарийВнутренний.КонтекстноеМеню);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийВнутреннийДокументСформирован(Элемент)
	
	КомментарийВнутреннийСформирован = Истина;
	
	//ДобавитьОбработчик Элемент.Документ.Body.oncontextmenu, ОбработчикСобытийВнутреннегоКомментария;
	
	РаботаСHTML_Клиент_ат.УстановитьДоступностьПанелейРедактирования(Элементы.КомментарийВнутренний_КоманднаяПанель,
		Элементы.КомментарийВнутренний, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийВнутреннийПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСHTML_Клиент_ат.ИзменитьПометкиКнопок(Элементы.КомментарийВнутренний_КоманднаяПанель,
		Элементы.КомментарийВнутренний.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСобытийВнутреннегоКомментария(Событие)
	
	Если Событие.type = "contextmenu" Тогда
		
		ПолеМожноРедактировать = РаботаСHTML_Клиент_ат.HTMLПолеМожноРедактировать(Элементы.КомментарийВнутренний);
		
		Для каждого ЭлементКонтекстногоМеню Из Элементы.КомментарийВнутренний.ПодчиненныеЭлементы Цикл
			
			Если НЕ ЭлементКонтекстногоМеню.Имя = "КомментарийВнутренний_КонтекстноеМеню_ВключитьВозможностьРедактирования"
				И НЕ ЭлементКонтекстногоМеню.Имя = "КомментарийВнутренний_КонтекстноеМеню_ПроверитьОрфографию" Тогда
				
				ЭлементКонтекстногоМеню.Доступность = ПолеМожноРедактировать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПолеМожноРедактировать Тогда
			
			Если Событие.srcElement.id = "red_marker" Тогда
				
				РаботаСHTML_Клиент_ат.ОбработатьВызовКонтекстногоМеню(Событие, КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам);	
				
				ИзменитьКонтестноеМенюЗаменыСловВнутреннегоКомментария(СоответствиеКомандЗаменыСловам);
				
			Иначе
				
				ИзменитьКонтестноеМенюЗаменыСловВнутреннегоКомментария(Неопределено, Истина);
				
			КонецЕсли;
			
		Иначе
			
			ИзменитьКонтестноеМенюЗаменыСловВнутреннегоКомментария(Неопределено, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьКонтестноеМенюЗаменыСловВнутреннегоКомментария(СоответствиеКомандЗаменыСловам, ТолькоОчистить = Ложь)
	
	РаботаСHTML_Сервер_ат.ИзменитьКонтестноеМенюЗаменыСловПоляHTML(ЭтаФорма,
		Элементы.КомментарийВнутренний.КонтекстноеМеню, СоответствиеКомандЗаменыСловам,
		ТолькоОчистить, "КомментарийВнутренний_ОбработчикКоманд");
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийВнутренний_ОбработчикКоманд(Команда, ВыбранноеЗначение)
	
	РаботаСHTML_Клиент_ат.ОбработчикКомандРаботыСHTML(ЭтаФорма, Команда, ВыбранноеЗначение,
		Элементы.КомментарийВнутренний, Элементы.КомментарийВнутренний_КоманднаяПанель,
		КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьВидимость()
	
	СотрудникОрганизации = ВнутреннегоИспользования_КлиентСерверПовтИсп_ат.СотрудникОрганизации();
	
	Если НЕ СотрудникОрганизации Тогда
		
		Элементы.Общая.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.Личная.ТолькоПросмотр = Объект.Общая;
	
КонецПроцедуры

