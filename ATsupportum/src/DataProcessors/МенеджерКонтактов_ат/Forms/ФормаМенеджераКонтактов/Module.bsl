
&НаКлиенте
Процедура ДоставитьПочту(Команда)
	ДоставитьПочтуНаСервере();
	Этаформа.Элементы.СписокПисемДляОтображения.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура  ДоставитьПочтуНаСервере()
		 
	УправлениеЭлектроннойПочтой.ПолучениеИОтправкаЭлектронныхПисем() ;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокПисемДляОтображения.Параметры.УстановитьЗначениеПараметра("Пользователь",ПараметрыСеанса.ТекущийПользователь.Ссылка); 
	//ГруппировкаПоГруппе = СписокПисемДляОтображения.Группировка;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПочту(Команда)
	ОбработатьПочтуНаСервере();
	ЭтаФорма.Элементы.СписокПисемДляОтображения.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбработатьПочтуНаСервере()
	ОбработчикиСобытийДляПочтовыхДокументов_ат.НазначитьГруппыВсемПисьмам();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьФормуОбработки();
ФормаОбр = ПолучитьФорму("Обработка.ОбработкаВосстановленияПисемИзФайла_ат.Форма");
ФормаОбр.Открыть();


КонецПроцедуры


&НаКлиенте
Процедура ВосстановитьПисьмоИзФайла(Команда)
	Форма = ПолучитьФорму("Обработка.ОбработкаВосстановленияПисемИзФайла_ат.Форма");
	Форма.Открыть()
КонецПроцедуры

&НаКлиенте
Процедура ТестоваяКнопкаНажатие(Команда)
	ОтослатьУведомление()	
КонецПроцедуры

&НаСервере
Процедура ОтослатьУведомление()
	Пользователь = Справочники.Пользователи.НайтиПоНаименованию("Пользователь номер один");
	Получатель = ОбработчикиСобытийДляПочтовыхДокументов_ат.ПолучитьАдресЭлектроннойПочтыПользователяДляУведомлений(Пользователь);
	Тема = "тестовое письмо";
	ТекстПисьма = "это просто тест "+ Строка(ТекущаяДата());
	СписокФайлов = Неопределено;
	Подпись = "Письмо сформировано автоматически, не отвечайте на него.";
	ОбработчикиСобытийДляПочтовыхДокументов_ат.ОтправитьСистемноеЭлПисьмоОдномуАдресату(Получатель, Тема, ТекстПисьма, СписокФайлов,Истина, Подпись);
КонецПроцедуры

&НаКлиенте
Процедура НаписатьПисьмоКоманда(Команда)
	
	НаписатьПисьмоКомандаНаСервере();
КонецПроцедуры

&НаСервере
Процедура НаписатьПисьмоКомандаНаСервере()
	ОбработчикиСобытийДляПочтовыхДокументов_ат.ПолучитьДоступныеУчетныеЗаписиПользователя(ПараметрыСеанса.ТекущийПользователь.Ссылка);
КонецПроцедуры




	