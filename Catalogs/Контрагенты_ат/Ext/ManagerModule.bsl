
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если ВнутреннегоИспользования_КлиентСерверПовтИсп_ат.СотрудникОрганизации()
		И Не ПустаяСтрока(Данные.НаименованиеВнутреннее) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Представление = Данные.НаименованиеВнутреннее;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Наименование");
	Поля.Добавить("НаименованиеВнутреннее");
	
КонецПроцедуры
