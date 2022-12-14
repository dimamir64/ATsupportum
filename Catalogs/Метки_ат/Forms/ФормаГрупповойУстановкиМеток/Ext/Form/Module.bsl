
#Область РаботаСФормой

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Источники = Параметры.Источники;
	
	КоличествоИсточников = Источники.Количество();
	
	Если КоличествоИсточников = 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		Сообщить("Нет выбранных источников Меток");
		Возврат;
		
	КонецЕсли;
	
	СписокИсточников.ЗагрузитьЗначения(Источники);
	
	Элементы.ФормаИспользоватьОтборПоПроектам.Пометка = Истина;
	
	Метки_Сервер_ат.ОбновитьМетки(ЭтаФорма, СписокИсточников,, Элементы.ФормаИспользоватьОтборПоПроектам.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ОКНаСервере();
	Закрыть();
	
КонецПроцедуры

Процедура ОКНаСервере()
	
	Метки_Сервер_ат.ЗаписатьМетки(ЭтаФорма, СписокИсточников);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	_ВыбранныеМетки = ВыбранныеМетки;
	
	Для Каждого СтрокаВыбранныхМеток Из _ВыбранныеМетки Цикл
		
		СтрокаВыбранныхМеток.Использовать = 0;
		Метки_Клиент_ат.ВыполнитьВыбор(ЭтаФорма, СтрокаВыбранныхМеток.Значение, СтрокаВыбранныхМеток.Использовать, СтрокаВыбранныхМеток.Частичная, СтрокаВыбранныхМеток.Сохраненная);
		
	КонецЦикла;
	
	ОбновитьПометкиДереваМеток();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПометкиДереваМеток()
	
	Метки_Сервер_ат.ЗаполнитьПометкиДереваПоТаблицеРекурсивно(ДеревоМеток.ПолучитьЭлементы(), ВыбранныеМетки,, МаксимальноеЗначениеИспользования);
	Элементы.ДеревоМеток.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Метки_Клиент_ат.ОбновитьПринадлежностьВыбранныхМетокКПроектам(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеМеткиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Метки_Клиент_ат.УстановитьМетку(ЭтаФорма, Истина,, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеМеткиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ВыбранныеМетки.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка = Метки_Клиент_ат.ПолучитьИдентификаторСтроки(Элементы.ВыбранныеМетки.ТекущиеДанные.Значение, ДеревоМеток.ПолучитьЭлементы());
	
	Если НЕ Строка = Неопределено Тогда
		Элементы.ДеревоМеток.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМетокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Метки_Клиент_ат.УстановитьМетку(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМетокИспользоватьПриИзменении(Элемент)
	
	Метки_Клиент_ат.УстановитьМетку(ЭтаФорма, Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоПроектам(Команда)
	
	ОтключитьОтборПоПроектуНаСервере();
	Метки_Клиент_ат.ОбновитьПринадлежностьВыбранныхМетокКПроектам(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьОтборПоПроектуНаСервере()
	
	Элементы.ФормаИспользоватьОтборПоПроектам.Пометка = НЕ Элементы.ФормаИспользоватьОтборПоПроектам.Пометка;
	Метки_Сервер_ат.ОбновитьМетки(ЭтаФорма, СписокИсточников, Ложь, Элементы.ФормаИспользоватьОтборПоПроектам.Пометка);
	
КонецПроцедуры

#КонецОбласти
