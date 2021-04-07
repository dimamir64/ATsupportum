
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отчеты_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииВариантаНаСервере(Настройки)
	
	Отчеты_ат.ПриСохраненииВариантаНаСервере(ЭтаФорма, Настройки);	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Отчеты_ат.ПриЗагрузкеВариантаНаСервере(ЭтаФорма, Настройки);	
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасширеныеНастройкиПриИзменении(Элемент)

	РасширеныеНастройкиПриИзмененииНаСервере();
	
	УправлениеФормой(ЭтаФорма); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Отбор

&НаКлиенте
Процедура ОтборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Отчеты_Клиент_ат.ОтборПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПередНачаломИзменения(Элемент, Отказ)

	Отчеты_Клиент_ат.ОтборПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Выбор

&НаКлиенте
Процедура ВыборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отчеты_Клиент_ат.ВыборПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПередНачаломИзменения(Элемент, Отказ)

	Отчеты_Клиент_ат.ВыборПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры
	
#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Сортировка
	
&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Отчеты_Клиент_ат.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	Отчеты_Клиент_ат.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры
	
#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Группировка

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)
	
	ВариантМодифицирован = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отчеты_Клиент_ат.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	Отчеты_Клиент_ат.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	
КонецПроцедуры
	
#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
		
	СкомпоноватьРезультат();
		
	СкрытьНастройки("");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.СтраницыОтчета.ТекущаяСтраница = Элементы.СтраницаНастройкиОтчета;
	
	Элементы.Сформировать_СтраницаНастроек.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки(Команда)
	
	Элементы.СтраницыОтчета.ТекущаяСтраница = Элементы.СтраницаОтчет;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если Форма.Отчет.РасширеныеНастройки Тогда
		Форма.Элементы.СтраницыНастроек.ТекущаяСтраница = Форма.Элементы.СтраницаРасширеныхНастроек;
	Иначе
		Форма.Элементы.СтраницыНастроек.ТекущаяСтраница = Форма.Элементы.СтраницаБыстрыхНастроек;
	КонецЕсли;	
	
КонецПроцедуры 

&НаСервере
Процедура РасширеныеНастройкиПриИзмененииНаСервере()
	
	Если Отчет.РасширеныеНастройки Тогда
		Отчеты_ат.ЗаполнитьНастройкиИзГруппировок(Отчет);
	Иначе
		Отчеты_ат.ЗаполнитьГруппировокиИзКомпановщика(Отчет);
	КонецЕсли;
	
КонецПроцедуры  

#КонецОбласти
