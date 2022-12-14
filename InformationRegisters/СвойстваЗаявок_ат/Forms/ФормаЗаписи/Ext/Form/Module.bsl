
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ РольДоступна("ПолныеПрава") Тогда
		
		ОткрыватьФормуЗаявки = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОткрыватьФормуЗаявки Тогда
		
		Отказ = Истина;
		
		ОткрытьЗначение(Запись.Ссылка);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
