&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.Владелец) Тогда 
		Элементы.Владелец.Доступность = Ложь;
	КонецЕсли;
	
	ОбновитьСписокIP();
	
	ПроверкаОтображения();
	
КонецПроцедуры

&НаКлиенте
Процедура DoNoAssignIPПриИзменении(Элемент)
	
	ПроверкаОтображения();
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаОтображения()
	
	//Элементы.IPAdressesManuale.Видимость = Истина;
	Элементы.AssignmentMethodIP.Видимость = Истина;
	Элементы.IPaddress.Видимость = Истина;
	Элементы.IPaddress.Доступность = ложь;
	
	Если Объект.НеУстанавливатьIP тогда 
		
		//Элементы.IPAdressesManuale.Видимость = ложь;
		Элементы.AssignmentMethodIP.Видимость = ложь;
		Элементы.IPaddress.Видимость = ложь;
		
	КонецЕсли;
	
	Если Объект.МетодНазначенияIP = 2 тогда
		Элементы.IPaddress.Доступность = Истина;
		Элементы.IPaddress.Видимость = Истина;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
//	Оповестить("СозданиеСетевогоИнтерфейсаПриОбработкиЗаполненияОсновногоIP", Объект.Ссылка, ВладелецФормы);
	ОбновитьСписокIP();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокIP()
	
	УправляемыеФормы_КлиентСервер_ат.УстановитьОтборДинамическогоСписка(IPaddress, "Владелец",, Объект.Ссылка, Истина,,, IPaddress.Отбор);
	
КонецПроцедуры

&НаКлиенте
Процедура AssignmentMethodIPПриИзменении(Элемент)
	
	ПроверкаОтображения();
	
КонецПроцедуры

&НаКлиенте
Процедура IPaddressПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Модифицированность Тогда 
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Перед добавлением интерфейсов и адресов необходимо сохранить изменения!";
		Сообщение.Сообщить();
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
