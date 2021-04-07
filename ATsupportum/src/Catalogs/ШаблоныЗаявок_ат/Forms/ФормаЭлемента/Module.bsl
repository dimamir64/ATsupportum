
#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		Планирование_Сервер_ат.ПервичноеЗаполнениеСотрудникКлиентПодразделение(Объект.Сотрудник, Объект.Сотрудник, Объект.Клиент, Объект.Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиДействийПользователя

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)

	КлиентПриИзменении_Сервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)

	Если НЕ Объект.Сотрудник.Пустая() Тогда
		ПодразделениеПриИзменении_Сервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		Планирование_Сервер_ат.ПервичноеЗаполнениеСотрудникКлиентПодразделение(Объект.Сотрудник, Объект.Сотрудник, Объект.Клиент, Объект.Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура КлиентПриИзменении_Сервер()
	
	Объект.Сотрудник	 = Неопределено;
	Объект.Подразделение = Неопределено;
	
	Если НЕ Объект.Проект.Пустая() Тогда
		
		Если Объект.Проект.Клиент <> Объект.Клиент И НЕ Объект.Проект.Клиент.Пустая() Тогда
			Объект.Проект = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Процедура ПодразделениеПриИзменении_Сервер()

	Если ПолучитьИзВременногоХранилища(Хранилище).НайтиСтроки(Новый Структура("Контрагент, Подразделение",
		Объект.Клиент, Объект.Подразделение)).Количество() = 0 Тогда
		
		Объект.Сотрудник = Неопределено;
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти
 
