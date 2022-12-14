
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Документы") Тогда
		
		Для Каждого Документ Из Параметры.Документы Цикл
			
			НоваяСтрока = Документы.Добавить();
			НоваяСтрока.Ссылка = Документ;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиДействийПользователя

&НаКлиенте
Процедура СтатусОтправкиПриИзменении(Элемент)
	
	Элементы.Комментарий.ОтметкаНезаполненного = КомментарийОбязателен(СтатусОтправки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка)
		ИЛИ Документы.НайтиСтроки(Новый Структура("Ссылка", Элемент.ТекущиеДанные.Ссылка)).Количество() > 1 Тогда
		
		Документы.Удалить(Элемент.ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	Если Элементы.Комментарий.ОтметкаНезаполненного И НЕ ЗначениеЗаполнено(Комментарий) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Для выбранного статуса заполнение комментария обязательно!";
		Сообщение.Поле  = "Комментарий";
		Сообщение.Сообщить(); 
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗаписатьСтатусы() Тогда
		
		Оповестить("ИзменениеСтатусаОтправки");
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция   КомментарийОбязателен(Статус)
	
	Возврат Статус.КомментарийОбязателен;
	
КонецФункции 

&НаСервере
Функция   ЗаписатьСтатусы()
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого Строка Из Документы Цикл
			Финансы_ат.ЗаписатьСтатусОтправкиФинДокумента(Строка.Ссылка, СтатусОтправки, Комментарий, ДатаСтатусаОтправки);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		Результат = Истина;
		
	Исключение
		
		ОтменитьТранзакцию();
		Сообщить(ОписаниеОшибки());
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
