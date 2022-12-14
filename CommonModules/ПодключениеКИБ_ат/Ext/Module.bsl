
////////////////////////////////////////////////////////////////////////////////
// Подключение к внешним ИБ
 
// Устанавливает соединение с базой данных в соответствии с переданными параметрами.
//
// Параметры:
//	ПараметрыПодключения - СправочникСсылка.БазыДанных_ат, Структура - Данные для кстановки соединения.
//	ПроверятьАктивность - Булево - признак проверки активности БД в случае если первым параметром передана ссылка на справочник БазыДанных_ат.
//
// Возвращаемое значение:
//  COMОбъект в случае удачного соединения, иначе - строка.
//
Функция   УстановитьПодключение(ПараметрыПодключения, ПроверятьАктивность = Истина) Экспорт
	
	Если ТипЗнч(ПараметрыПодключения) = Тип("Структура") Тогда
		
		СтруктураПодключения = ПараметрыПодключения;
		
	ИначеЕсли ТипЗнч(ПараметрыПодключения) = Тип("СправочникСсылка.БазыДанных_ат") Тогда
		
		Если ПараметрыПодключения.ПометкаУдаления
			ИЛИ (ПроверятьАктивность И НЕ ПараметрыПодключения.Активность) Тогда
			
			Возврат "Переданная ссылка на справочник ""Базы данных"" не активна!";
			
		КонецЕсли;
		
		СтруктураПодключения = Новый Структура();
		
		СтруктураПодключения.Вставить("Наименование", 		ПараметрыПодключения.Наименование);
		СтруктураПодключения.Вставить("ФайловыйРежим", 		ПараметрыПодключения.ТипИнформационнойБазыДляПодключения);
		СтруктураПодключения.Вставить("КаталогИБ", 			ПараметрыПодключения.КаталогИнформационнойБазыДляПодключения);
		СтруктураПодключения.Вставить("ИмяСервера", 		ПараметрыПодключения.ИмяСервераИнформационнойБазыДляПодключения);
		СтруктураПодключения.Вставить("ИмяИБНаСервере", 	ПараметрыПодключения.ИмяИнформационнойБазыНаСервереДляПодключения);
		СтруктураПодключения.Вставить("Пользователь", 		ПараметрыПодключения.ПользовательИнформационнойБазыДляПодключения);
		СтруктураПодключения.Вставить("Пароль", 			ПараметрыПодключения.ПарольИнформационнойБазыДляПодключения);
		СтруктураПодключения.Вставить("ВерсияПлатформы",	ПараметрыПодключения.ВерсияПлатформыИнформационнойБазыДляПодключения);
		
	Иначе
		
		Возврат "Переданны неверные параметры подключения!";
		
	КонецЕсли;
	
	АдресХранилищаПодключений = ПодключениеКИБ_ПовтИсп_ат.ПолучитьАдресХранилищаПодключений();
	Ключ = ПолучитьКлюч(СтруктураПодключения.ИмяСервера + "_" + СтруктураПодключения.ИмяИБНаСервере +
		"_" + СтруктураПодключения.КаталогИБ);
	  
	Подключения = ПолучитьИзВременногоХранилища(АдресХранилищаПодключений);
	
	Если НЕ Подключения.Свойство(Ключ) ИЛИ Подключения[Ключ] = Неопределено Тогда
		
		РезультатПодключения = ПодключитьсяКИнформационнойБазе(СтруктураПодключения);
		
		Если ТипЗнч(РезультатПодключения) = Тип("Строка") Тогда
			Возврат РезультатПодключения;
		КонецЕсли;
		
		Подключения.Вставить(Ключ, РезультатПодключения);
		ПоместитьВоВременноеХранилище(Подключения, АдресХранилищаПодключений);
		
	Иначе
		
		РезультатПодключения = Подключения[Ключ];
		
	КонецЕсли;
	
	Возврат РезультатПодключения;
	
КонецФункции

Функция   ПодключитьсяКИнформационнойБазе(СтруктураПодключения) Экспорт
	
	Перем СтрокаПодключения, СтрокаСообщенияОбОшибке;
	
	Если НЕ ПараметровДляПодключенияДостаточно(СтруктураПодключения, СтрокаПодключения, СтрокаСообщенияОбОшибке) Тогда
		Возврат СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтруктураПодключения.Пользователь) Тогда
		СтрокаПодключения = СтрокаПодключения + ";Usr = """ + СтруктураПодключения.Пользователь + """";
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтруктураПодключения.Пароль) Тогда
		СтрокаПодключения = СтрокаПодключения + ";Pwd = """ + СтруктураПодключения.Пароль + """";
	КонецЕсли;
	
	ВерисяПлатформы = СтрЗаменить(СтруктураПодключения.ВерсияПлатформы, ".", "");
	Если Найти(ВРег(ВерисяПлатформы), "V") = 0 Тогда
		ВерисяПлатформы = "V" + ВерисяПлатформы;
	КонецЕсли;
	
	СтрокаПодключения = СтрокаПодключения + ";";
	
	Попытка
		
		ОбъектПодключения = ВерисяПлатформы +".COMConnector";
		ТекCOMПодключение = Новый COMОбъект(ОбъектПодключения);
		ТекCOMОбъект = ТекCOMПодключение.Connect(СтрокаПодключения);
		
	Исключение
		
		СтрокаСообщенияОбОшибке = "При попытке соедиения с COM-сервером внешней ИБ ("
			+ СтрокаПодключения
			+ ") произошла следующая ошибка:" + Символы.ПС + ОписаниеОшибки();
		Возврат СтрокаСообщенияОбОшибке;
		
	КонецПопытки;
	
	Возврат ТекCOMОбъект;
	
КонецФункции

Функция   СоздатьВременноеХранилище() Экспорт
	
	ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Новый Структура, Новый УникальныйИдентификатор());
	
	НаборЗаписей = РегистрыСведений.АдресаВременныхХранилищ_ат.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УникальныйИдентификаторПользователяИБ.Установить(ТекущийПользовательИБ.УникальныйИдентификатор);
	
	Запись = НаборЗаписей.Добавить();
	
	Запись.УникальныйИдентификаторПользователяИБ 	= ТекущийПользовательИБ.УникальныйИдентификатор;
	Запись.Имя 										= ТекущийПользовательИБ.Имя;
	Запись.АдресВременногоХранилища 				= АдресВременногоХранилища;
	
	НаборЗаписей.Записать();
	
	Возврат АдресВременногоХранилища;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Работа с внешними ИБ
 
Функция   ПолучитьGUIDВнешнейСсылки(Подключение, Ссылка) Экспорт
	
	Возврат Подключение.String(Ссылка.УникальныйИдентификатор());
	
КонецФункции 

Функция   ПолучитьВнешнююСсылку(Подключение, КлассОбъекта, ИмяОбъекта, УИд) Экспорт
	
	Попытка
		Ссылка = Подключение[КлассОбъекта][ИмяОбъекта].ПолучитьСсылку(Подключение.NewObject("УникальныйИдентификатор", УИд));
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Запрос = Подключение.NewObject("Запрос");
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Объект.Ссылка
		|ИЗ
		|	" + Ссылка.Метаданные().ПолноеИмя() + " КАК Объект
		|ГДЕ
		|	Объект.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат Ссылка;
	КонецЕсли;
	
КонецФункции

Функция   ПолучитьВнешнююСсылкуПоНавигационнойСсылке(Подключение, НавигационнаяСсылка) Экспорт
	
	Результат = Неопределено;
	
	УИд = Строки_КлиентСервер_ат.ПолучитьСтрУИдПоНавСсылке(НавигационнаяСсылка);
	Если УИд = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПозицияНачалаИдентификатора = Найти(НавигационнаяСсылка, "?ref=");
	ПозицияНачалаПути = Найти(НавигационнаяСсылка, "e1cib/data/") + 11;
	Если ПозицияНачалаИдентификатора <> 0 И ПозицияНачалаПути <> 11 Тогда
		
		ПутьКМетаданному = Сред(НавигационнаяСсылка, ПозицияНачалаПути, ПозицияНачалаИдентификатора - ПозицияНачалаПути);
		ЧастиПути = Системный_КлиентСервер_Переопределяемый_ат.РазложитьСтрокуВМассивПодстрок(ПутьКМетаданному, ".");
		Если ЧастиПути.Количество() = 2 Тогда
			
			ИмяКласса = ОбщегоНазначения_КлиентСервер_ат.ИмяКлассаИзИмениТипаОбъектаМетаданных(ЧастиПути[0]);
			Результат = ПолучитьВнешнююСсылку(Подключение, ИмяКласса, ЧастиПути[1], УИд);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Внутренние процедуры
 
Функция   ПолучитьКлюч(Строка)
	
	Строка = "Ключ_" + СокрЛП(Строка);
	Строка = СтрЗаменить(Строка, "-", "_");
	Строка = СтрЗаменить(Строка, "/", "_");
	Строка = СтрЗаменить(Строка, "\", "_");
	Строка = СтрЗаменить(Строка, ".", "_");
	Строка = СтрЗаменить(Строка, ",", "");
	Строка = СтрЗаменить(Строка, "+", "");
	Строка = СтрЗаменить(Строка, "!", "");
	Строка = СтрЗаменить(Строка, "@", "");
	Строка = СтрЗаменить(Строка, "#", "");
	Строка = СтрЗаменить(Строка, "$", "");
	Строка = СтрЗаменить(Строка, "%", "");
	Строка = СтрЗаменить(Строка, "^", "");
	Строка = СтрЗаменить(Строка, "&", "");
	Строка = СтрЗаменить(Строка, "*", "");
	Строка = СтрЗаменить(Строка, "(", "");
	Строка = СтрЗаменить(Строка, ")", "");
	Строка = СтрЗаменить(Строка, "№", "");
	Строка = СтрЗаменить(Строка, ";", "");
	Строка = СтрЗаменить(Строка, ":", "");
	Строка = СтрЗаменить(Строка, "?", "");
	
	Возврат Строка;
	
КонецФункции

Функция   ПараметровДляПодключенияДостаточно(СтруктураПодключения, СтрокаПодключения = "", СтрокаСообщенияОбОшибке = "")
	
	НаличиеОшибок = Ложь;
	
	Если СтруктураПодключения.ФайловыйРежим  Тогда
		
		Если ПустаяСтрока(СтруктураПодключения.КаталогИБ) Тогда
			СтрокаСообщенияОбОшибке = "ИБ <" + СтруктураПодключения.Наименование + ">
				|Не задан каталог информационной базы!";
				
			НаличиеОшибок = Истина;
		КонецЕсли;
		
		СтрокаПодключения = "File=""" + СтруктураПодключения.КаталогИБ + """";
		
	Иначе
		
		Если ПустаяСтрока(СтруктураПодключения.ИмяСервера) Тогда
			СтрокаСообщенияОбОшибке = "ИБ <" + СтруктураПодключения.Наименование + ">
				|Не задано имя Сервера 1С:Предприятия информационной базы!";
				
			НаличиеОшибок = Истина;
		КонецЕсли;
		
		Если ПустаяСтрока(СтруктураПодключения.ИмяИБНаСервере) Тогда
			СтрокаСообщенияОбОшибке = "ИБ <" + СтруктураПодключения.Наименование + ">
			|Не задано имя информационной базы на Сервере 1С:Предприятия!";
			
			НаличиеОшибок = Истина;
		КонецЕсли;
		
		СтрокаПодключения = "Srvr = """ + СтруктураПодключения.ИмяСервера + """; Ref = """ + СтруктураПодключения.ИмяИБНаСервере + """";
		
	КонецЕсли;
	
	Возврат НЕ НаличиеОшибок;
	
КонецФункции
