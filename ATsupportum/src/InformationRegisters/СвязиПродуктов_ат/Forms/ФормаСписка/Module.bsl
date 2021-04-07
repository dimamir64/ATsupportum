
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Продукт) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Продукт", Параметры.Продукт);
	КонецЕсли; 
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт( , , Истина));
	ЭлементУсловия = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодчиненныйПродукт");
	ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементУсловия.ПравоеЗначение = Параметры.Продукт;
	ЭлементУсловногоОформления.Использование = Истина;
	
КонецПроцедуры
