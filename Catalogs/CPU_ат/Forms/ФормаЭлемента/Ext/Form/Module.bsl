
&НаКлиенте
Процедура РазъемНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
		группа = "РазъёмCPU";
	РаботаССерверамиСлужебный_ат.ОбработкаВыбораПараметровЖелеза(Элемент, ДанныеВыбора, СтандартнаяОбработка, группа);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.Разъем) Тогда 
		Элементы.Разъем.Доступность = Ложь;
	КонецЕсли;
		
КонецПроцедуры
