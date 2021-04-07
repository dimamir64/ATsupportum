
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Параметры.Отбор) Тогда
		
		Элементы.КомпоновщикНастроекПользовательскиеНастройки.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	// Необходимо для предотвращения конфликтов при программном формировании отчёта с переданными параметрами
	Для Каждого Элемент Из Настройки.Элементы Цикл
		
		Элемент.ПравоеЗначение = Неопределено;
		Элемент.Использование = Ложь;
		
	КонецЦикла;
	
КонецПроцедуры
