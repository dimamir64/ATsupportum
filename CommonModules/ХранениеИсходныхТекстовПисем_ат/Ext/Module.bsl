Процедура СохранитьИсходноеПисьмо(ПочтовоеСообщение, СсылкаНаПисьмо) Экспорт
	
	//Сообщить("сохраняем тело входящего письма");	
	СтруктураПочтовогоСообщения = ПолучитьСтруктуруТекстаИЗаголовковПочтовогоСообщения(ПочтовоеСообщение);
	
	Запись = РегистрыСведений.СодержаниеЭлектронныхПисемВходящих_ат.СоздатьМенеджерЗаписи();
	Запись.ЭПВ = СсылкаНаПисьмо;
	
	Запись.Прочитать();
	// Кладем Нашу структуру в ХЗ
	ОбъктХЗ = новый ХранилищеЗначения(СтруктураПочтовогоСообщения,Новый СжатиеДанных(9));
	Запись.ОригинальноеТелоПисьма = ОбъктХЗ;
	Попытка
		Запись.Записать(Истина);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьСтруктуруТекстаИЗаголовковПочтовогоСообщения(ПочтовоеСообщение)
	СтруктураПочтовогоСообщения = Новый Структура;
	СтруктураПочтовогоСообщения.Вставить("Заголовок", ПочтовоеСообщение.Заголовок);
	СтруктураПочтовогоСообщения.Вставить("Текст", ПочтовоеСообщение.Тексты[0].Текст);
	Возврат СтруктураПочтовогоСообщения;
КонецФункции

