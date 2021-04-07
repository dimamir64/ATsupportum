
#Область  ЛокальныеПеременные

#Область  Комментарии

&НаКлиенте
Перем КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам;
//&НаКлиенте
//Перем ПоследняяСтраница; //v1 работы с буфером обмена

#КонецОбласти

#КонецОбласти

#Область  ОбработчикиСобытийФормы

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
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
	//v2 работы с буфером обмена
	Элементы.Страница_Скрытая.Видимость = Ложь;
	//v1 работы с буфером обмена
	//ПоследняяСтраница = Элементы.Страница_Комментарий;
	
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

#Область  ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ПарольОткрытие(Элемент, СтандартнаяОбработка)
	
	//v2
	ВременныйCOMHTML = Новый COMОбъект("htmlfile"); 
	ВременныйCOMHTML.ParentWindow.ClipboardData.Setdata("Text", Объект.Пароль);
	//v1 работы с буфером обмена
	//Окно_HTMLdoc4Cpy2Clpbrd = Элементы.ПолеHTMLДокументаДляКопированияПароляВБуферОбмена.Документ.ParentWindow;
	//Окно_HTMLdoc4Cpy2Clpbrd.ClipboardData.SetData("Text", Объект.Пароль);
	
	Предупреждение("Пароль скопирован в буфер обмена", 3);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область  Комментарии

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

&НаКлиенте
Процедура СтраницыКомментариевПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	//v1 работы с буфером обмена
	//Если ТекущаяСтраница = Элементы.Страница_Скрытая Тогда
	//	Элементы.СтраницыКомментариев.ТекущаяСтраница = ПоследняяСтраница;
	//Иначе
	//	ПоследняяСтраница = ТекущаяСтраница;
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
