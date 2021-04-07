////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контроль динамического обновления конфигурации"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Проверить, что информационная база была обновлена динамически.
//
Функция КонфигурацияБДБылаИзмененаДинамически() Экспорт
	
	Возврат КонфигурацияБазыДанныхИзмененаДинамически();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриНачалеРаботыСистемы"].Добавить(
			"КонтрольДинамическогоОбновленияКонфигурацииКлиент");
	
КонецПроцедуры
