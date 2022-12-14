
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = Данные.Наименование
		+ ?(ПустаяСтрока(Данные.Описание), "", " - " + Данные.Описание)
		+ ?(Данные.ВРазработке, " [в разработке]", "");
	
КонецПроцедуры


Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Описание");
	Поля.Добавить("ВРазработке");
	
КонецПроцедуры

