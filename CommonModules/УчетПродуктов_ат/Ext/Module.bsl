
Функция   ПолучитьВерсиюЧислом(Знач ВерсияСтрокой) Экспорт
	
	Множетель = 1000000000000000000000;
	ВерсияЧислом = 0;
	ВерсияСтрокой = ВерсияСтрокой + ".";
	ПозицияРазделителя = Найти(ВерсияСтрокой, ".");
	
	Пока ПозицияРазделителя <> 0 Цикл
		
		ВерсияЧислом = ВерсияЧислом + Лев(ВерсияСтрокой, ПозицияРазделителя - 1) * Множетель;
		ВерсияСтрокой = Прав(ВерсияСтрокой, СтрДлина(ВерсияСтрокой) - ПозицияРазделителя);
		Множетель = Множетель / 100000;
		ПозицияРазделителя = Найти(ВерсияСтрокой, ".");
		
	КонецЦикла;
	
	Возврат ВерсияЧислом;
	
КонецФункции 

#Область  ПолучениеАктуальныхНомеровРелизовССайта1С

Процедура ПолучитьТекущиеРелизы1С() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Продукты_ат.Ссылка КАК Продукт,
		|	Продукты_ат.НаименованиеУПоставщика,
		|	ВерсииПродуктов_ат.Наименование КАК Версия
		|ИЗ
		|	Справочник.Продукты_ат КАК Продукты_ат
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ВерсииПродуктов_ат.Владелец КАК Владелец,
		|			МАКСИМУМ(ВерсииПродуктов_ат.ВерсияЧислом) КАК ВерсияЧислом
		|		ИЗ
		|			Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ВерсииПродуктов_ат.Владелец) КАК ВложенныйЗапрос
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
		|			ПО ВложенныйЗапрос.ВерсияЧислом = ВерсииПродуктов_ат.ВерсияЧислом
		|		ПО ВложенныйЗапрос.Владелец = Продукты_ат.Ссылка
		|ГДЕ
		|	Продукты_ат.Поставщик = ЗНАЧЕНИЕ(Справочник.Контрагенты_ат.ОдинЭс)
		|	И Продукты_ат.ПроверятьОбновления";
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Продукты_ат.Ссылка КАК Продукт,
		|	Продукты_ат.НаименованиеУПоставщика,
		|	ВерсииПродуктов_ат.Наименование КАК Версия
		|ИЗ
		|	Справочник.Продукты_ат КАК Продукты_ат
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ВерсииПродуктов_ат.Владелец КАК Владелец,
		|			МАКСИМУМ(ВерсииПродуктов_ат.ВерсияЧислом) КАК ВерсияЧислом
		|		ИЗ
		|			Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ВерсииПродуктов_ат.Владелец) КАК ВложенныйЗапрос
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
		|			ПО ВложенныйЗапрос.ВерсияЧислом = ВерсииПродуктов_ат.ВерсияЧислом
		|		ПО ВложенныйЗапрос.Владелец = Продукты_ат.Ссылка
		|ГДЕ
		|	Продукты_ат.Поставщик = ЗНАЧЕНИЕ(Справочник.Контрагенты_ат.ОдинЭс)
		|	И Продукты_ат.ПроверятьОбновления";
	
	ТаблицаПроверяемыхПродуктов = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаПроверяемыхПродуктов.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	HTTPСоединение = Новый HTTPСоединение("downloads.1c.ru", , , , , 30);
	
	МассивИдентификаторовКатегорий = ПолучитьМассивИдентификаторовКатегорий(HTTPСоединение);
	
	Если МассивИдентификаторовКатегорий = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТаблицаАктуальныхВерсий = ПолучитьТаблицуАктуальныхВерсий(HTTPСоединение, МассивИдентификаторовКатегорий);
	
	Если ТаблицаАктуальныхВерсий = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Строка Из ТаблицаПроверяемыхПродуктов Цикл
		
		СтрокаСАктуальнойВерсией = ТаблицаАктуальныхВерсий.Найти(ВРег(Строка.НаименованиеУПоставщика), "Продукт");
		
		Если СтрокаСАктуальнойВерсией = Неопределено Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не удалось получить актуальную версию для " + Строка.Продукт + ". Проверьте наличие обновлений вручную.";
			Сообщение.Сообщить(); 
			
			Продолжить;
			
		КонецЕсли;
		
		Если Строка.Версия <> СтрокаСАктуальнойВерсией.АктуальнаяВерсия Тогда
		    // Что бы не дублировать записи проверим ещё раз
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ВерсииПродуктов_ат.Наименование
				|ИЗ
				|	Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
				|ГДЕ
				|	ВерсииПродуктов_ат.Владелец = &Продукт
				|	И ВерсииПродуктов_ат.ВерсияЧислом = &ВерсияЧислом";

			Запрос.УстановитьПараметр("Продукт", Строка.Продукт);
			Запрос.УстановитьПараметр("ВерсияЧислом", УчетПродуктов_ат.ПолучитьВерсиюЧислом(СтрокаСАктуальнойВерсией.АктуальнаяВерсия));

			Если НЕ Запрос.Выполнить().Выбрать().Следующий() Тогда
				
				НоваяВерсия = Справочники.ВерсииПродуктов_ат.СоздатьЭлемент();
				НоваяВерсия.Владелец = Строка.Продукт;
				НоваяВерсия.Наименование = СтрокаСАктуальнойВерсией.АктуальнаяВерсия;
				НоваяВерсия.ДатаВыхода = СтрокаСАктуальнойВерсией.ДатаВыхода;
				НоваяВерсия.Записать();
				
				//TODO - всё нижеследующее сделать через отдельную процедуру
				
				Запрос = Новый Запрос(
					"ВЫБРАТЬ
					|	ЭкземплярыПродуктов_ат.Ссылка КАК Ссылка,
					|	ЭкземплярыПродуктов_ат.Владелец.КонтрагентВладелец КАК ВладелецКонтрагентВладелец,
					|	ЭкземплярыПродуктов_ат.Представление КАК Представление,
					|	ЭкземплярыПродуктов_ат.ТекущаяВерсия КАК ТекущаяВерсия
					|ИЗ
					|	Справочник.ЭкземплярыПродуктов_ат КАК ЭкземплярыПродуктов_ат
					|ГДЕ
					|	НЕ ЭкземплярыПродуктов_ат.ПометкаУдаления
					|	И ЭкземплярыПродуктов_ат.ТекущийПродукт = &ТекущийПродукт");
				
				Запрос.УстановитьПараметр("ТекущийПродукт", Строка.Продукт);
				
				РЗ = Запрос.Выполнить();
				
				Если НЕ РЗ.Пустой() Тогда
					
					ВРЗ = РЗ.Выбрать();
					
					//СписокПолучателей = ВнутреннегоИспользования_ВызовСервера_ат.ПолучитьСписокПользователейПоРоли("ОрганизацияМенеджерПродуктов_ат");
					//
					//Если СписокПолучателей.Количество() > 0 Тогда
					//	
					//	ТаблицаАдресов = ОбработчикиСобытийДляПочтовыхДокументов_ат.ПолучитьТаблицуАдресовДляУведомленийПользователей(СписокПолучателей);
					ТаблицаАдресов = Новый ТаблицаЗначений;
					ТаблицаАдресов.Колонки.Добавить("Контакт",
						Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
					ТаблицаАдресов.Колонки.Добавить("Адрес", Новый ОписаниеТипов("Строка",,
						Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
					ТаблицаАдресов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка",,
						Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
					
					СтрокаАдреса = ТаблицаАдресов.Добавить();
					СтрокаАдреса.Адрес = "1ces@at.com.ru";
					СтрокаАдреса.Представление = "1ces";
						
						Если ТаблицаАдресов.Количество() > 0 Тогда
							
							//ДокументHTML = СоздатьДокументСОписаниемУведомленияОСозданииФинансовогоДокумента(Документ, Источник, Ошибки, СоздаватьФинДокументНеНужно);
							ДокументHTML = Новый ДокументHTML;
							
							ЭлементТело = ДокументHTML.СоздатьЭлемент("body");
							ДокументHTML.Тело = ЭлементТело;
							
							ЭлементБлок = ДокументHTML.СоздатьЭлемент("p");
							ЭлементТело.ДобавитьДочерний(ЭлементБлок);
							
							Тема = "Зарегистрирована новая версия продукта '" + Строка(Строка.Продукт) + "' - "
								+ СтрокаСАктуальнойВерсией.АктуальнаяВерсия + " (выпущена " + СтрокаСАктуальнойВерсией.ДатаВыхода + ")!";
							
							Взаимодействия.ДобавитьТекстовыйУзел(ЭлементБлок, "Данные о экземплярах (наличии) такого продукта:", Истина, Истина);
							
							Пока ВРЗ.Следующий() Цикл
								
								Взаимодействия.ДобавитьТекстовыйУзел(ЭлементБлок, "> "
									+ ВРЗ.Представление + " | владелец: " + ВРЗ.ВладелецКонтрагентВладелец,, Истина);
								
							КонецЦикла;
							
							Уведомления_ат.СоздатьПисьмо(ДокументHTML, Неопределено, Тема, ТаблицаАдресов,,,,,
								Перечисления.ТипыУведомлений_ат.ВнутреннееТехническое);
							
						КонецЕсли;
						
					//КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция   ПолучитьМассивИдентификаторовКатегорий(HTTPСоединение)
	
	Попытка
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("jsp");
		HTTPСоединение.Получить("release_info/categ_js.jsp", ИмяВременногоФайла);
		
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить(); 
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяВременногоФайла);
	ТекстСпискаКатегорий = ТекстовыйДокумент.ПолучитьТекст();
	УдалитьФайлы(ИмяВременногоФайла);
	
	МассивИдентификаторовКатегорий = Новый Массив;
	Позиция = Найти(ТекстСпискаКатегорий, "GroupID=");
	
	Пока Позиция <> 0 Цикл
		
		ТекстСпискаКатегорий = Прав(ТекстСпискаКатегорий, СтрДлина(ТекстСпискаКатегорий) - Позиция - 7);
		ИдентификаторовКатегорий = СтрЗаменить(Лев(ТекстСпискаКатегорий, 3), """", "");
		
		Если МассивИдентификаторовКатегорий.Найти(ИдентификаторовКатегорий) = Неопределено Тогда 
			
			МассивИдентификаторовКатегорий.Добавить(ИдентификаторовКатегорий);
			
		КонецЕсли;	
		
		Позиция = Найти(ТекстСпискаКатегорий, "GroupID=");
		
	КонецЦикла;

	Возврат МассивИдентификаторовКатегорий;
	
КонецФункции 

Функция   ПолучитьТаблицуАктуальныхВерсий(HTTPСоединение, МассивИдентификаторовКатегорий)
	
	ТаблицаАктуальныхВерсий = Новый ТаблицаЗначений;
	ТаблицаАктуальныхВерсий.Колонки.Добавить("Продукт");
	ТаблицаАктуальныхВерсий.Колонки.Добавить("АктуальнаяВерсия");
	ТаблицаАктуальныхВерсий.Колонки.Добавить("ДатаВыхода");
	
	Для Каждого ИдентификаторовКатегорий Из МассивИдентификаторовКатегорий Цикл
		
		Попытка
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("jsp");
			HTTPСоединение.Получить("release_info/categ_js.jsp?GroupID=" + ИдентификаторовКатегорий, ИмяВременногоФайла);
			
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить(); 
			
			Возврат Неопределено;
			
		КонецПопытки;
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяВременногоФайла);
		ТекстСпискаПродуктов = ВРег(ТекстовыйДокумент.ПолучитьТекст());
		УдалитьФайлы(ИмяВременногоФайла);
		
		Позиция = ОпределитьБлижайшуюПозициюОбрезки(ТекстСпискаПродуктов);
		Сч = 1;
		
		Пока Позиция <> 0 Цикл
			
			ТекстСпискаПродуктов = Прав(ТекстСпискаПродуктов, СтрДлина(ТекстСпискаПродуктов) - Позиция);
			Значение = СокрЛП(Лев(ТекстСпискаПродуктов, Найти(ТекстСпискаПродуктов, "<") - 1));
			
			Если Сч = 1 Тогда
				
				НоваяСтрокаТаблицы = ТаблицаАктуальныхВерсий.Добавить();
				НоваяСтрокаТаблицы.ДатаВыхода = Дата(Сред(Значение, 7, 4) + Сред(Значение, 4, 2) + Лев(Значение, 2)); 
				Сч = 2;
				
			ИначеЕсли Сч = 2 Тогда 
				
				Если Найти(Значение, "ТЕХНОЛОГИЧЕСКАЯ ПЛАТФОРМА") <> 0 Тогда
					
					Продукт = Значение;
					
				Иначе	
					
					НоваяСтрокаТаблицы.Продукт = Значение;
					
				КонецЕсли;
				
				Сч = 3;
				
			ИначеЕсли Сч = 3 Тогда 	
				
				Если Продукт <> Неопределено Тогда
					
					НоваяСтрокаТаблицы.Продукт = Продукт + " " + Лев(Значение, 3);
					Продукт = Неопределено;
					
				КонецЕсли;				
				
				НоваяСтрокаТаблицы.АктуальнаяВерсия = Значение;
				Сч = 1;
				
			КонецЕсли;
			
			Позиция = ОпределитьБлижайшуюПозициюОбрезки(ТекстСпискаПродуктов);
			
		КонецЦикла;
		
	КонецЦикла;

	Возврат ТаблицаАктуальныхВерсий;
	
КонецФункции

Функция   ОпределитьБлижайшуюПозициюОбрезки(ТекстСпискаПродуктов)
	
	Позиция1 = Найти(ТекстСпискаПродуктов, "PROD");
	Позиция2 = Найти(ТекстСпискаПродуктов, "NEW");
	
	Если Позиция1 = 0 ИЛИ Позиция2 = 0 Тогда
		Если Позиция1 = 0 И Позиция2 = 0 Тогда
			Возврат 0;
		ИначеЕсли Позиция1 = 0 Тогда 
			Возврат Позиция2 + 4;
		Иначе 
			Возврат Позиция1 + 5;
		КонецЕсли;
	Иначе	
		Если Позиция1 < Позиция2 Тогда
			Возврат Позиция1 + 5;
		Иначе
			Возврат Позиция2 + 4;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции 

#КонецОбласти 

#Область  ЭкземплярыПродуктов

// ЭП, у которых есть количество
Функция   ДоступнаМножественностьЭкземпляров(ТипПродукта) Экспорт
	
	Возврат ТипПродукта = Перечисления.ТипыПродуктов_ат.КлиентскаяЛицензия1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.КлиентскаяЛицензияПП1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.КлиентскийДоступMSSQLServer
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.КлючUSB1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.КлючUSBКонфигурации1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.УдаленныйДоступMSServer;
		
КонецФункции 

Функция   ОпределитьДоступноеКоличествоЭкземпляров(Поставка, Экземпляр = Неопределено) Экспорт
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("КоличествоОграничено", Ложь);
	ВозвращаемаяСтруктура.Вставить("ДоступноеКоличество", 0);
	
	ТипПродукта = Поставка.Продукт.ТипПродукта;
	
	Если НЕ ЗначениеЗаполнено(ТипПродукта) // ЭП, которые могут размещаться любое кол-во раз от одной поставки
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.Конфигурация1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.Платформа1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.ПрочийПП
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.ПрочийППMS
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.Сервер_nix
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверMSWindows
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверВеб Тогда
		
		Возврат ВозвращаемаяСтруктура;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ЭкземплярыПродуктов_ат.Количество) КАК ИспользованноеКоличество
		|ИЗ
		|	Справочник.ЭкземплярыПродуктов_ат КАК ЭкземплярыПродуктов_ат
		|ГДЕ
		|	ЭкземплярыПродуктов_ат.Владелец = &Владелец
		|	И НЕ ЭкземплярыПродуктов_ат.ПометкаУдаления";
		
	Если ЗначениеЗаполнено(Экземпляр) Тогда
		
		Запрос.Текст = Запрос.Текст + " И НЕ ЭкземплярыПродуктов_ат.Ссылка = &Экземпляр";
		
		Запрос.УстановитьПараметр("Экземпляр", Экземпляр);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Владелец", Поставка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ВозвращаемаяСтруктура.КоличествоОграничено = Истина;
		
		ВозвращаемаяСтруктура.ДоступноеКоличество =
			Поставка.Продукт.Количество - ?(ЗначениеЗаполнено(Выборка.ИспользованноеКоличество),
				Выборка.ИспользованноеКоличество, 0);
		
	КонецЕсли;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции 

Процедура ЗаполнитьСписокПоследнихВерсийПродукта(Продукт, СписокВерсий) Экспорт
	
	СписокВерсий.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 5
	|	ВложенныйЗапрос.Ссылка,
	|	ВложенныйЗапрос.ВерсияЧислом
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВерсииПродуктов_ат.Ссылка КАК Ссылка,
	|		ВерсииПродуктов_ат.ВерсияЧислом КАК ВерсияЧислом
	|	ИЗ
	|		Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПродуктов_ат КАК ГруппыПродуктов_ат
	|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПродуктов_ат.Продукты КАК ГруппыПродуктов_атПродукты
	|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Продукты_ат КАК Продукты_ат
	|					ПО ГруппыПродуктов_атПродукты.Продукт = Продукты_ат.Ссылка
	|				ПО ГруппыПродуктов_ат.Ссылка = ГруппыПродуктов_атПродукты.Ссылка
	|			ПО ВерсииПродуктов_ат.Владелец = ГруппыПродуктов_ат.Ссылка
	|	ГДЕ
	|		Продукты_ат.Ссылка = &Продукт
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВерсииПродуктов_ат.Ссылка,
	|		ВерсииПродуктов_ат.ВерсияЧислом
	|	ИЗ
	|		Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Продукты_ат КАК Продукты_ат
	|			ПО ВерсииПродуктов_ат.Владелец = Продукты_ат.Ссылка
	|	ГДЕ
	|		Продукты_ат.Ссылка = &Продукт) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.ВерсияЧислом УБЫВ";
	
	Запрос.УстановитьПараметр("Продукт", Продукт);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СписокВерсий.Добавить(Выборка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область  ПоддержкаСпецификацийЭкземпляровПродуктов

Функция   ПолучитьИмяРегистраСпецификацииЭкземпляраПродукта(ТипПродукта) Экспорт
	
	Если ТипПродукта = Перечисления.ТипыПродуктов_ат.Документация
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.ДокументацияПП1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.Книга Тогда
		
		ИмяРегистра = "СпецификацияЭП_Документация_ат";
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.КлиентскаяЛицензия1С Тогда
		
		ИмяРегистра = "СпецификацияЭП_КлиентскаяЛицензия1С_ат";
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.КлиентскийДоступMSSQLServer Тогда
		
		ИмяРегистра = "СпецификацияЭП_КлиентскийДоступMSSQLServer_ат";
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.КлючUSB1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.КлючUSBКонфигурации1С Тогда
		
		ИмяРегистра = "СпецификацияЭП_КлючUSB1С_ат";
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.Конфигурация1С Тогда
		
		ИмяРегистра = "СпецификацияЭП_Конфигурация1С_ат";
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.Сервер1С Тогда
		
		ИмяРегистра = "СпецификацияЭП_Сервер1С_ат";
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверMSSQL Тогда
		
		ИмяРегистра = "СпецификацияЭП_СерверMSSQL_ат";
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверВеб Тогда
		
		ИмяРегистра = "СпецификацияЭП_СерверВеб_ат";
		
	Иначе
		
		ИмяРегистра = Неопределено;
		
	КонецЕсли;
	
	Возврат ИмяРегистра;
	
КонецФункции

Процедура ОтобразитьСпецификациюЭкземпляраНаФорме(Форма, ЗначениеКопированияСсылка) Экспорт
	
	УдалитьРеквизитыИЭлементыФормы(Форма, Форма.СписокДобавленныхРеквизитов);
	
	Элементы = Форма.Элементы;
	ТипПродукта = Форма.ТипПродукта;
	ИмяРегистра = ПолучитьИмяРегистраСпецификацииЭкземпляраПродукта(ТипПродукта);
	
	Если ИмяРегистра = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДобавляемыеРеквизиты = Новый Массив;
	МассивИмен = Новый Массив;
	
	Для Каждого Ресурс Из Метаданные.РегистрыСведений[ИмяРегистра].Ресурсы Цикл 
		
		Реквизит = Новый РеквизитФормы(Ресурс.Имя, Ресурс.Тип,, Ресурс.Синоним, Истина);
		ДобавляемыеРеквизиты.Добавить(Реквизит);
		МассивИмен.Добавить(Ресурс.Имя);
		
	КонецЦикла;
	
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	Форма.СписокДобавленныхРеквизитов.ЗагрузитьЗначения(МассивИмен);
	
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЭкземплярПродукта.Установить(?(ЗначениеЗаполнено(ЗначениеКопированияСсылка), ЗначениеКопированияСсылка, Форма.Объект.Ссылка));
	НаборЗаписей.Прочитать();

	Если НаборЗаписей.Количество() = 0 Тогда
		
		ЗаписьРегистра = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
		
	Иначе 
		
		ЗаписьРегистра = НаборЗаписей[0];
		
	КонецЕсли;
	
	Для Каждого Реквизит Из ДобавляемыеРеквизиты Цикл
		
		Имя = Реквизит.Имя;
		Элемент = Элементы.Добавить(Имя, Тип("ПолеФормы"), Элементы.Спецификация);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = Имя;
		
		Ресурс = Метаданные.РегистрыСведений[ИмяРегистра].Ресурсы[Имя];
		
		Если ТипЗнч(Форма[Имя]) = Тип("Число") Тогда
			
			Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
			
		КонецЕсли;
		
		Элемент.ФорматРедактирования = Ресурс.ФорматРедактирования;
		Элемент.СвязиПараметровВыбора = Ресурс.СвязиПараметровВыбора;
		Элемент.ПараметрыВыбора = Ресурс.ПараметрыВыбора;
		
		Форма[Имя] = ЗаписьРегистра[Имя];
		
	КонецЦикла;
	
	Если ТипПродукта = Перечисления.ТипыПродуктов_ат.Конфигурация1С Тогда
		
		//+ ХАК до создания аренды. Показывать и наши серваки
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ДополнительныеРеквизитыОрганизаций_ат.Контрагент
			|ИЗ
			|	РегистрСведений.ДополнительныеРеквизитыОрганизаций_ат КАК ДополнительныеРеквизитыОрганизаций_ат
			|ГДЕ
			|	НЕ ДополнительныеРеквизитыОрганизаций_ат.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты_ат.ПустаяСсылка)";
		
		МассивКлиентов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Контрагент");
		МассивКлиентов.Добавить(Форма.Объект.Владелец.КонтрагентВладелец);
		//- ХАК до создания аренды. Показывать и наши серваки
		
		МассивПараметровВыбора = Новый Массив;
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Клиент", МассивКлиентов)); // должен быть только контрагент владелец!!!
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("ТипРолиСервера", Перечисления.ТипыРолейСерверов_ат.Сервер1С));
		
		Элементы.Сервер1С.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
		
		МассивСвязейПараметровВыбора = Новый Массив;
		МассивСвязейПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.СерверРазмещения", "Объект.СерверРазмещения",
			РежимИзмененияСвязанногоЗначения.Очищать));
		
		Элементы.Сервер1С.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязейПараметровВыбора);
		
		МассивПараметровВыбора = Новый Массив;
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Клиент", МассивКлиентов));
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("ТипРолиСервера", Перечисления.ТипыРолейСерверов_ат.СерверБД));
		
		Элементы.СерверБД.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
		
		ИзменитьВидимостьЭлементовСпецификацииКонфигурации1С(Форма);
		
		ДобавитьСведенияОбОбъемеИБ(Форма);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.КлиентскаяЛицензия1С Тогда	
		
		Элементы.ТипЛицензии.УстановитьДействие("ПриИзменении", "ТипЛицензииПриИзменении");
		Элементы.Размещение.УстановитьДействие("ПриИзменении", "РазмещениеПриИзменении");
		Элементы.ВебСервер.Вид = ВидПоляФормы.ПолеФлажка;
		
		ИзменитьВидимостьЭлементовСпецификацииЛицензии(Форма);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.Сервер1С Тогда
		
		МассивСвязейПараметровВыбора = Новый Массив;
		МассивСвязейПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.СерверРазмещения", "Объект.СерверРазмещения",
		РежимИзмененияСвязанногоЗначения.Очищать));
		
		Элементы.Платформа.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСвязейПараметровВыбора); 
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСведенияОбОбъемеИБ(Форма)
	
	ОбъемИБ = ПолучитьОбъемИБ(Форма.Объект.Ссылка);
	
	Если ОбъемИБ <> Неопределено Тогда
		
		ДобавляемыеРеквизиты = Новый Массив;
		
		ИмяРеквизита = "ОбъемИБ";
		Реквизит = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("Число"), , "Объём ИБ (MB)", Истина);
		ДобавляемыеРеквизиты.Добавить(Реквизит);
		
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		Форма.СписокДобавленныхРеквизитов.Добавить(ИмяРеквизита);

		Элементы = Форма.Элементы;
		
		Элемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Элементы.Спецификация);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = ИмяРеквизита;
		Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
		Элемент.ТолькоПросмотр = Истина;
		
		Форма[ИмяРеквизита] = ОбъемИБ;
		
	КонецЕсли;
	
КонецПроцедуры 

Процедура УдалитьРеквизитыИЭлементыФормы(Форма, СписокРеквизитов)
	
	Форма.ИзменитьРеквизиты(, СписокРеквизитов.ВыгрузитьЗначения());
	
	Для Каждого Реквизит Из СписокРеквизитов Цикл
		
		Форма.Элементы.Удалить(Форма.Элементы[Реквизит.Значение]);
		
	КонецЦикла;
	
	СписокРеквизитов.Очистить();
	
КонецПроцедуры 

Процедура ИзменитьВидимостьЭлементовСпецификацииЛицензии(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если Форма.ТипЛицензии Тогда // Истина - однопользовательская, ложь - многопользовательская
		
		Элементы.Размещение.Видимость = Ложь;
		Элементы.Сервер1С.Видимость = Ложь;
		Элементы.Компьютер.Видимость = Истина;
		Элементы.ВебСервер.Видимость = Истина;
		
	Иначе 
		
		Элементы.Размещение.Видимость = Истина;                                                    
		Элементы.Сервер1С.Видимость = Не Форма.Размещение;                                         
		Элементы.ВебСервер.Видимость = Форма.Размещение;
		Элементы.Компьютер.Видимость = Форма.Размещение;
		
	КонецЕсли;
	
КонецПроцедуры 

Процедура ИзменитьВидимостьЭлементовСпецификацииКонфигурации1С(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	КлиентСервернаяБаза = (Форма.Объект.РольСервераРазмещения.ВидРолиСервера.ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.Сервер1С);
	
	Элементы.Сервер1С.Видимость = КлиентСервернаяБаза;
	Элементы.СерверБД.Видимость = КлиентСервернаяБаза;
	Элементы.ФайловыйКаталог.Видимость = Не КлиентСервернаяБаза;
	Элементы.ДоступКСерверуБД.Видимость = КлиентСервернаяБаза;
	Элементы.ИмяИБНа1С.Видимость = КлиентСервернаяБаза;
	Элементы.ИмяИБНаSQL.Видимость = КлиентСервернаяБаза;
	
КонецПроцедуры

#КонецОбласти

#Область  ИнформацияНаОснованииТипаПродуктов

// Возвращает массив типов продуктов соответствующих переданному типу роли сервера.
//
// Параметры:
//	ТипРолиСервера - ПеречислениеСсылка.ТипыРолейСерверов_ат - Тип роли сервера для которой будут возвращены соответствующие типы продуктов.
//
// Возвращаемое значение:
//	Массив
// 
Функция   ПолучитьТипыПродуктовПоТипуРолиСервера(ТипРолиСервера) Экспорт
	
	ВозвращаемыйМассив = Новый Массив;
	                             
	Если ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.СерверТерминалов Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.УдаленныйДоступMSServer);
		
	ИначеЕсли ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.Сервер1С Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.Сервер1С);
		
	ИначеЕсли ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.СерверБД Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.СерверMSSQL);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.СерверOracle);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.СерверIBMDB2);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.СерверPostgreSQL);
		
	ИначеЕсли ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.СерверФайловый
		ИЛИ ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.СерверFTP Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.ПрочийПП);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.СерверMSWindows);
		
	ИначеЕсли ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.СерверВеб Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.СерверВеб);
		
	ИначеЕсли ТипРолиСервера = Перечисления.ТипыРолейСерверов_ат.СерверПрочий Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыПродуктов_ат.ПрочийПП);
		
	КонецЕсли;
	
	Возврат ВозвращаемыйМассив;
	
КонецФункции

// Возвращает массив типов ролей серверов соответствующих переданному типу продукта.
//
// Параметры:
//	ТипПродукта - ПеречислениеСсылка.ТипыПродуктов_ат - Тип продукта для которой будут возвращены соответствующие типы ролей серверов.
//
// Возвращаемое значение:
//	Массив
// 
Функция   ПолучитьТипыРолейСерверовПоТипуПродукта(ТипПродукта) Экспорт
	
	ВозвращаемыйМассив = Новый Массив;
	                             
	Если ТипПродукта = Перечисления.ТипыПродуктов_ат.УдаленныйДоступMSServer Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверТерминалов);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.Сервер1С Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.Сервер1С);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверMSSQL
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверOracle
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверIBMDB2
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверPostgreSQL Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверБД);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверMSWindows Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверФайловый);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверFTP);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверВеб);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверПрочий);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.СерверВеб Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверВеб);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.ПрочийПП Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверФайловый);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверFTP);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверВеб);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверПрочий);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.Конфигурация1С Тогда
		
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.Сервер1С);
		ВозвращаемыйМассив.Добавить(Перечисления.ТипыРолейСерверов_ат.СерверФайловый);
		
	ИначеЕсли ТипПродукта = Перечисления.ТипыПродуктов_ат.Документация
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.ДокументацияПП1С
		ИЛИ ТипПродукта = Перечисления.ТипыПродуктов_ат.Книга Тогда
		
		// Оставим массив пустым.
		
	Иначе
		
		Для Каждого ТипРолиСервера Из Перечисления.ТипыРолейСерверов_ат Цикл
			
			ВозвращаемыйМассив.Добавить(ТипРолиСервера);
			
		КонецЦикла;
		
	КонецЕсли;

	Возврат ВозвращаемыйМассив;
	
КонецФункции

Функция   ЕстьПродуктЭтогоТипаНаСервере(Сервер, ТипПродукта) Экспорт //oldname - ПроверкаТипаПродукта
	
	Запрос = Новый Запрос;
	Запрос.Текст =  
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.ЭкземплярыПродуктов_ат КАК ЭкземплярыПродуктов_ат
	|ГДЕ
	|	ЭкземплярыПродуктов_ат.РольСервераРазмещения.Владелец = &Сервер
	|	И ЭкземплярыПродуктов_ат.ТекущийПродукт.ТипПродукта = &ТипПродукта";
	Запрос.УстановитьПараметр("Сервер", Сервер);
	Запрос.УстановитьПараметр("ТипПродукта", ТипПродукта);
	
	РЗ = Запрос.Выполнить();
	
	Если РЗ.Пустой() тогда
		Возврат 0;
	Иначе
		Возврат РЗ.Выбрать().Следующий();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

Функция   ПолучитьПродуктыПоЗаявкам(Заявки) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Проекты_атПродукты.Продукт КАК Продукт
		|ПОМЕСТИТЬ ПродуктыГруппыПродуктов
		|ИЗ
		|	Справочник.Проекты_ат.Продукты КАК Проекты_атПродукты
		|ГДЕ
		|	НЕ Проекты_атПродукты.Ссылка.ПометкаУдаления
		|	И НЕ Проекты_атПродукты.Продукт.ПометкаУдаления
		|	И Проекты_атПродукты.Ссылка В
		|			(ВЫБРАТЬ
		|				Заявка.Проект
		|			ИЗ
		|				Документ.Заявка_ат КАК Заявка
		|			ГДЕ
		|				Заявка.Ссылка В (&Заявки))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Продукты_ат.Ссылка КАК Ссылка
		|ИЗ
		|	ПродуктыГруппыПродуктов КАК ПродуктыГруппыПродуктов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Продукты_ат КАК Продукты_ат
		|		ПО ПродуктыГруппыПродуктов.Продукт = Продукты_ат.Ссылка
		|			И (ПродуктыГруппыПродуктов.Продукт ССЫЛКА Справочник.Продукты_ат)
		|ГДЕ
		|	НЕ Продукты_ат.Ссылка ЕСТЬ NULL 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Продукты_ат.Ссылка
		|ИЗ
		|	ПродуктыГруппыПродуктов КАК ПродуктыГруппыПродуктов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПродуктов_ат КАК ГруппыПродуктов_ат
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПродуктов_ат.Продукты КАК ГруппыПродуктов_атПродукты
		|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Продукты_ат КАК Продукты_ат
		|				ПО ГруппыПродуктов_атПродукты.Продукт = Продукты_ат.Ссылка
		|			ПО ГруппыПродуктов_ат.Ссылка = ГруппыПродуктов_атПродукты.Ссылка
		|		ПО ПродуктыГруппыПродуктов.Продукт = ГруппыПродуктов_ат.Ссылка
		|			И (ПродуктыГруппыПродуктов.Продукт ССЫЛКА Справочник.ГруппыПродуктов_ат)
		|ГДЕ
		|	НЕ Продукты_ат.Ссылка ЕСТЬ NULL
		|");
	Запрос.УстановитьПараметр("Заявки", Заявки);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция   ПолучитьВерсииЭкземпляраПродукта(ЭкземплярПродукта) Экспорт
	
	Версии = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВерсииПродуктов_ат.Ссылка КАК Версия
	|ИЗ
	|	Справочник.ЭкземплярыПродуктов_ат КАК ЭкземплярыПродуктов_ат
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Продукты_ат КАК Продукты_ат
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
	|			ПО Продукты_ат.Ссылка = ВерсииПродуктов_ат.Владелец
	|		ПО ЭкземплярыПродуктов_ат.ТекущийПродукт = Продукты_ат.Ссылка
	|ГДЕ
	|	ЭкземплярыПродуктов_ат.Ссылка = &ЭкземплярПродукта
	|	И НЕ ВерсииПродуктов_ат.Ссылка ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВерсииПродуктов_ат.Ссылка
	|ИЗ
	|	Справочник.ЭкземплярыПродуктов_ат КАК ЭкземплярыПродуктов_ат
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Продукты_ат КАК Продукты_ат
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПродуктов_ат.Продукты КАК ГруппыПродуктов_атПродукты
	|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПродуктов_ат КАК ГруппыПродуктов_ат
	|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВерсииПродуктов_ат КАК ВерсииПродуктов_ат
	|					ПО ГруппыПродуктов_ат.Ссылка = ВерсииПродуктов_ат.Владелец
	|				ПО ГруппыПродуктов_атПродукты.Ссылка = ГруппыПродуктов_ат.Ссылка
	|			ПО Продукты_ат.Ссылка = ГруппыПродуктов_атПродукты.Продукт
	|		ПО ЭкземплярыПродуктов_ат.ТекущийПродукт = Продукты_ат.Ссылка
	|ГДЕ
	|	ЭкземплярыПродуктов_ат.Ссылка = &ЭкземплярПродукта
	|	И НЕ ВерсииПродуктов_ат.Ссылка ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("ЭкземплярПродукта", ЭкземплярПродукта);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Версия");
	
КонецФункции

Функция   ПолучитьОбъемИБ(ЭкземплярПродукта) Экспорт
	
	НаборЗаписей = РегистрыСведений.ОбъёмИБ_ат.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЭкземплярПродукта.Установить(ЭкземплярПродукта);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		
		Возврат Неопределено
		
	Иначе 
		
		Возврат НаборЗаписей[0].Объём;
		
	КонецЕсли;
	
КонецФункции
