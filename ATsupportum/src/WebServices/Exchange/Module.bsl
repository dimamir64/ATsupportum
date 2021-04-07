////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики операций

// Соответствует операции Upload
Функция ВыполнитьВыгрузку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	УстановитьПривилегированныйРежим(Истина);
	
	СообщениеОбмена = "";
	
	ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыЧерезСтроку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, СообщениеОбмена);
	
	ХранилищеСообщенияОбмена = Новый ХранилищеЗначения(СообщениеОбмена, Новый СжатиеДанных(9));
	
КонецФункции

// Соответствует операции Download
Функция ВыполнитьЗагрузку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыЧерезСтроку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена.Получить());
	
КонецФункции

// Соответствует операции UploadData
Функция ВыполнитьВыгрузкуДанных(ИмяПланаОбмена,
								КодУзлаИнформационнойБазы,
								ИдентификаторФайлаСтрокой,
								ДлительнаяОперация,
								ИдентификаторОперации,
								ДлительнаяОперацияРазрешена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	ИдентификаторФайлаСтрокой = Строка(ИдентификаторФайла);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыВСервисПередачиФайлов(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла);
		
	Иначе
		
		ВыполнитьВыгрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла, ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);
		
	КонецЕсли;
	
КонецФункции

// Соответствует операции DownloadData
Функция ВыполнитьЗагрузкуДанных(ИмяПланаОбмена,
								КодУзлаИнформационнойБазы,
								ИдентификаторФайлаСтрокой,
								ДлительнаяОперация,
								ИдентификаторОперации,
								ДлительнаяОперацияРазрешена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ИдентификаторФайла = Новый УникальныйИдентификатор(ИдентификаторФайлаСтрокой);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		ОбменДаннымиСервер.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыИзСервисаПередачиФайлов(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла);
		
	Иначе
		
		ВыполнитьЗагрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла, ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);
		
	КонецЕсли;
	
КонецФункции

// Соответствует операции GetIBParameters
Функция ПолучитьПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке)
	
	Возврат ОбменДаннымиСервер.ПолучитьПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке);
	
КонецФункции

// Соответствует операции GetIBData
Функция ПолучитьДанныеИнформационнойБазы(ПолноеИмяТаблицы)
	
	Результат = Новый Структура("СвойстваОбъектаМетаданных, ТаблицаБазыКорреспондента");
	
	Результат.СвойстваОбъектаМетаданных = ЗначениеВСтрокуВнутр(ОбменДаннымиСервер.СвойстваОбъектаМетаданных(ПолноеИмяТаблицы));
	Результат.ТаблицаБазыКорреспондента = ЗначениеВСтрокуВнутр(ОбменДаннымиСервер.ПолучитьОбъектыТаблицы(ПолноеИмяТаблицы));
	
	Возврат ЗначениеВСтрокуВнутр(Результат);
КонецФункции

// Соответствует операции GetCommonNodsData
Функция ПолучитьОбщиеДанныеУзлов(ИмяПланаОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ЗначениеВСтрокуВнутр(ОбменДаннымиСервер.ДанныеДляТабличныхЧастейУзловЭтойИнформационнойБазы(ИмяПланаОбмена));
	
КонецФункции

// Соответствует операции CreateExchange
Функция СоздатьОбменДанными(ИмяПланаОбмена, СтрокаПараметров, НастройкаОтборовСтрокой, ЗначенияПоУмолчаниюСтрокой)
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получаем обработку помощника настройки обмена во второй базе
	ПомощникСозданияОбменаДанными = Обработки.ПомощникСозданияОбменаДанными.Создать();
	ПомощникСозданияОбменаДанными.ИмяПланаОбмена = ИмяПланаОбмена;
	
	Отказ = Ложь;
	
	// Загружаем параметры помощника из строки в обработку помощника
	ПомощникСозданияОбменаДанными.ВыполнитьЗагрузкуПараметровМастера(Отказ, СтрокаПараметров);
	
	Если Отказ Тогда
		Сообщение = НСтр("ru = 'При создании настройки обмена во второй информационной базе возникли ошибки: %1'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение, ПомощникСозданияОбменаДанными.СтрокаСообщенияОбОшибке());
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	ПомощникСозданияОбменаДанными.ВариантРаботыМастера = "ПродолжитьНастройкуОбменаДанными";
	ПомощникСозданияОбменаДанными.ЭтоНастройкаРаспределеннойИнформационнойБазы = Ложь;
	ПомощникСозданияОбменаДанными.ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS;
	ПомощникСозданияОбменаДанными.ПрефиксИнформационнойБазыИсточникаУстановлен = ЗначениеЗаполнено(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы"));
	
	// Выполняем создание настройки обмена
	ПомощникСозданияОбменаДанными.ВебСервисВыполнитьДействияПоНастройкеНовогоОбменаДанными(
											Отказ,
											ЗначениеИзСтрокиВнутр(НастройкаОтборовСтрокой),
											ЗначениеИзСтрокиВнутр(ЗначенияПоУмолчаниюСтрокой));
	
	Если Отказ Тогда
		Сообщение = НСтр("ru = 'При создании настройки обмена во второй информационной базе возникли ошибки: %1'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение, ПомощникСозданияОбменаДанными.СтрокаСообщенияОбОшибке());
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
КонецФункции

// Соответствует операции UpdateExchange
Функция ОбновитьНастройкиОбменаДанными(ИмяПланаОбмена, КодУзла, ЗначенияПоУмолчаниюСтрокой)
	
	ОбменДаннымиСервер.ВнешнееСоединениеОбновитьНастройкиОбменаДанными(ИмяПланаОбмена, КодУзла, ЗначенияПоУмолчаниюСтрокой);
	
КонецФункции

// Соответствует операции RegisterOnlyCatalogData
Функция ЗарегистрироватьИзмененияТолькоСправочников(ИмяПланаОбмена, КодУзла, ДлительнаяОперация, ИдентификаторОперации)
	
	ЗарегистрироватьДанныеДляНачальнойВыгрузки(ИмяПланаОбмена, КодУзла, ДлительнаяОперация, ИдентификаторОперации, Истина);
	
КонецФункции

// Соответствует операции RegisterAllDataExceptCatalogs
Функция ЗарегистрироватьИзмененияВсехДанныхКромеСправочников(ИмяПланаОбмена, КодУзла, ДлительнаяОперация, ИдентификаторОперации)
	
	ЗарегистрироватьДанныеДляНачальнойВыгрузки(ИмяПланаОбмена, КодУзла, ДлительнаяОперация, ИдентификаторОперации, Ложь);
	
КонецФункции

// Соответствует операции GetContinuousOperationStatus
Функция ПолучитьСостояниеДлительнойОперации(ИдентификаторОперации, СтрокаСообщенияОбОшибке)
	
	СостоянияФоновогоЗадания = Новый Соответствие;
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Активно,           "Active");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Завершено,         "Completed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.ЗавершеноАварийно, "Failed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Отменено,          "Canceled");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторОперации));
	
	Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
		
		СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
		
	КонецЕсли;
	
	Возврат СостоянияФоновогоЗадания.Получить(ФоновоеЗадание.Состояние);
КонецФункции

// Соответствует операции GetFunctionalOption
Функция ПолучитьЗначениеФункциональнойОпции(Имя)
	
	Возврат ПолучитьФункциональнуюОпцию(Имя);
	
КонецФункции

// Соответствует операции PrepareGetFile
Функция PrepareGetFile(FileId, BlockSize, TransferId, PartQuantity)
	
	УстановитьПривилегированныйРежим(Истина);
	
	TransferId = Новый УникальныйИдентификатор;
	
	ИмяИсходногоФайла = ОбменДаннымиСервер.ПолучитьФайлИзХранилища(FileId);
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(TransferId);
	
	Файл = Новый Файл(ИмяИсходногоФайла);
	
	ИмяИсходногоФайлаВоВременномКаталоге = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, Файл.Имя);
	ИмяНеразделенногоФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, "data.zip");
	
	СоздатьКаталог(ВременныйКаталог);
	
	ПереместитьФайл(ИмяИсходногоФайла, ИмяИсходногоФайлаВоВременномКаталоге);
	
	Архиватор = Новый ЗаписьZipФайла(ИмяНеразделенногоФайла,,,, УровеньСжатияZIP.Максимальный);
	Архиватор.Добавить(ИмяИсходногоФайлаВоВременномКаталоге);
	Архиватор.Записать();
	
	Если BlockSize <> 0 Тогда
		// Разделение файла на части
		ИменаФайлов = РазделитьФайл(ИмяНеразделенногоФайла, BlockSize * 1024);
		PartQuantity = ИменаФайлов.Количество();
	Иначе
		PartQuantity = 1;
		ПереместитьФайл(ИмяНеразделенногоФайла, ИмяНеразделенногоФайла + ".1");
	КонецЕсли;
	
КонецФункции

// Соответствует операции GetFilePart
Функция GetFilePart(TransferId, PartNumber, PartData)
	
	ИмяФайла = "data.zip.[n]";
	ИмяФайла = СтрЗаменить(ИмяФайла, "[n]", Формат(PartNumber, "ЧГ=0"));
	
	ИменаФайлов = НайтиФайлы(ВременныйКаталогВыгрузки(TransferId), ИмяФайла);
	Если ИменаФайлов.Количество() = 0 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Не найден фрагмент %1 сессии передачи с идентификатором %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(PartNumber), Строка(TransferId));
		ВызватьИсключение(ТекстСообщения);
		
	ИначеЕсли ИменаФайлов.Количество() > 1 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Найдено несколько фрагментов %1 сессии передачи с идентификатором %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(PartNumber), Строка(TransferId));
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ИмяФайлаЧасти = ИменаФайлов[0].ПолноеИмя;
	PartData = Новый ДвоичныеДанные(ИмяФайлаЧасти);
	
КонецФункции

// Соответствует операции ReleaseFile
Функция ReleaseFile(TransferId)
	
	Попытка
		УдалитьФайлы(ВременныйКаталогВыгрузки(TransferId));
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецФункции

// Соответствует операции PutFilePart
Функция PutFilePart(TransferId, PartNumber, PartData)
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(TransferId);
	
	Если PartNumber = 1 Тогда
		
		СоздатьКаталог(ВременныйКаталог);
		
	КонецЕсли;
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, ПолучитьИмяФайлаЧасти(PartNumber));
	
	PartData.Записать(ИмяФайла);
	
КонецФункции

// Соответствует операции SaveFileFromParts
Функция SaveFileFromParts(TransferId, PartQuantity, FileId)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(TransferId);
	
	ФайлыЧастейДляОбъединения = Новый Массив;
	
	Для НомерЧасти = 1 По PartQuantity Цикл
		
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, ПолучитьИмяФайлаЧасти(НомерЧасти));
		
		Если НайтиФайлы(ИмяФайла).Количество() = 0 Тогда
			ШаблонСообщения = НСтр("ru = 'Не найден фрагмент %1 сессии передачи с идентификатором %2.
					|Необходимо убедиться, что в настройках программы заданы параметры
					|""Каталог временных файлов для Linux"" и ""Каталог временных файлов для Windows"".'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(НомерЧасти), Строка(TransferId));
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		ФайлыЧастейДляОбъединения.Добавить(ИмяФайла);
		
	КонецЦикла;
	
	ИмяАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, "data.zip");
	
	ОбъединитьФайлы(ФайлыЧастейДляОбъединения, ИмяАрхива);
	
	Разархиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Если Разархиватор.Элементы.Количество() = 0 Тогда
		Попытка
			УдалитьФайлы(ВременныйКаталог);
		Исключение
			ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
				УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		ВызватьИсключение(НСтр("ru = 'Файл архива не содержит данных.'"));
	КонецЕсли;
	
	КаталогВыгрузки = ОбщегоНазначенияПовтИсп.КаталогВременногоХранилищаФайлов();
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВыгрузки, Разархиватор.Элементы[0].Имя);
	
	Разархиватор.Извлечь(Разархиватор.Элементы[0], КаталогВыгрузки);
	Разархиватор.Закрыть();
	
	FileId = ОбменДаннымиСервер.ПоместитьФайлВХранилище(ИмяФайла);
	
	Попытка
		УдалитьФайлы(ВременныйКаталог);
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецФункции

// Соответствует операции PutFileIntoStorage
Функция PutFileIntoStorage(FileName, FileId)
	
	УстановитьПривилегированныйРежим(Истина);
	
	FileId = ОбменДаннымиСервер.ПоместитьФайлВХранилище(FileName);
	
КонецФункции

// Соответствует операции GetFileFromStorage
Функция GetFileFromStorage(FileId)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяИсходногоФайла = ОбменДаннымиСервер.ПолучитьФайлИзХранилища(FileId);
	
	Файл = Новый Файл(ИмяИсходногоФайла);
	
	Возврат Файл.Имя;
КонецФункции

// Соответствует операции FileExists
Функция FileExists(FileName)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПолноеИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ОбщегоНазначенияПовтИсп.КаталогВременногоХранилищаФайлов(), FileName);
	
	Файл = Новый Файл(ПолноеИмяВременногоФайла);
	
	Возврат Файл.Существует();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

Процедура ПроверитьБлокировкуИнформационнойБазыДляОбновления()
	
	ИнформационнаяБазаЗаблокированаДляОбновления =
		ОбновлениеИнформационнойБазы.ИнформационнаяБазаЗаблокированаДляОбновления()
	;
	Если ЗначениеЗаполнено(ИнформационнаяБазаЗаблокированаДляОбновления) Тогда
		ВызватьИсключение ИнформационнаяБазаЗаблокированаДляОбновления;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьВыгрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена,
														КодУзлаИнформационнойБазы,
														ИдентификаторФайла,
														ДлительнаяОперация,
														ИдентификаторОперации,
														ДлительнаяОперацияРазрешена)
	
	Параметры = Новый Массив;
	Параметры.Добавить(ИмяПланаОбмена);
	Параметры.Добавить(КодУзлаИнформационнойБазы);
	Параметры.Добавить(ИдентификаторФайла);
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыВСервисПередачиФайлов",
										Параметры,
										КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ИмяПланаОбмена, КодУзлаИнформационнойБазы),
										НСтр("ru = 'Выполнение обмена данными через веб-сервис.'"));
	
	Попытка
		Таймаут = ?(ДлительнаяОперацияРазрешена, 5, Неопределено);
		
		ФоновоеЗадание.ОжидатьЗавершения(Таймаут);
	Исключение
		
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗадание.УникальныйИдентификатор);
		
		Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			
			ИдентификаторОперации = Строка(ФоновоеЗадание.УникальныйИдентификатор);
			ДлительнаяОперация = Истина;
			Возврат;
			
		Иначе
			
			Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
				ВызватьИсключение ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
			КонецЕсли;
			
			ВызватьИсключение;
		КонецЕсли;
		
	КонецПопытки;
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗадание.УникальныйИдентификатор);
	
	Если ФоновоеЗадание.Состояние <> СостояниеФоновогоЗадания.Завершено Тогда
		
		Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
			ВызватьИсключение ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
		КонецЕсли;
		
		ВызватьИсключение НСтр("ru = 'Ошибка при выгрузке данных через веб-сервис.'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьЗагрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена,
													КодУзлаИнформационнойБазы,
													ИдентификаторФайла,
													ДлительнаяОперация,
													ИдентификаторОперации,
													ДлительнаяОперацияРазрешена)
	
	Параметры = Новый Массив;
	Параметры.Добавить(ИмяПланаОбмена);
	Параметры.Добавить(КодУзлаИнформационнойБазы);
	Параметры.Добавить(ИдентификаторФайла);
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОбменДаннымиСервер.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыИзСервисаПередачиФайлов",
										Параметры,
										КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ИмяПланаОбмена, КодУзлаИнформационнойБазы),
										НСтр("ru = 'Выполнение обмена данными через веб-сервис.'"));
	
	Попытка
		Таймаут = ?(ДлительнаяОперацияРазрешена, 5, Неопределено);
		
		ФоновоеЗадание.ОжидатьЗавершения(Таймаут);
	Исключение
		
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗадание.УникальныйИдентификатор);
		
		Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			
			ИдентификаторОперации = Строка(ФоновоеЗадание.УникальныйИдентификатор);
			ДлительнаяОперация = Истина;
			Возврат;
			
		Иначе
			
			Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
				ВызватьИсключение ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
			КонецЕсли;
			ВызватьИсключение;
		КонецЕсли;
		
	КонецПопытки;
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗадание.УникальныйИдентификатор);
	
	Если ФоновоеЗадание.Состояние <> СостояниеФоновогоЗадания.Завершено Тогда
		
		Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
			ВызватьИсключение ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
		КонецЕсли;
		
		ВызватьИсключение НСтр("ru = 'Ошибка при загрузке данных через веб-сервис.'");
	КонецЕсли;
	
КонецПроцедуры

Функция КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ПланОбмена, КодУзла)
	
	Ключ = "ПланОбмена:[ПланОбмена] КодУзла:[КодУзла]";
	Ключ = СтрЗаменить(Ключ, "[ПланОбмена]", ПланОбмена);
	Ключ = СтрЗаменить(Ключ, "[КодУзла]", КодУзла);
	
	Возврат Ключ;
КонецФункции

Функция ЗарегистрироватьДанныеДляНачальнойВыгрузки(Знач ИмяПланаОбмена, Знач КодУзла, ДлительнаяОперация, ИдентификаторОперации, ТолькоСправочники)
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелИнформационнойБазы = ПланыОбмена[ИмяПланаОбмена].НайтиПоКоду(КодУзла);
	
	Если Не ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		Сообщение = НСтр("ru = 'Не найден узел плана обмена; имя плана обмена %1; код узла %2'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение, ИмяПланаОбмена, КодУзла);
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Если ТолькоСправочники Тогда
			
			ОбменДаннымиСервер.ЗарегистрироватьТолькоСправочникиДляНачальнойВыгрузки(УзелИнформационнойБазы);
			
		Иначе
			
			ОбменДаннымиСервер.ЗарегистрироватьВсеДанныеКромеСправочниковДляНачальнойВыгрузки(УзелИнформационнойБазы);
			
		КонецЕсли;
		
	Иначе
		
		Если ТолькоСправочники Тогда
			ИмяМетода = "ОбменДаннымиСервер.ЗарегистрироватьТолькоСправочникиДляНачальнойВыгрузки";
		Иначе
			ИмяМетода = "ОбменДаннымиСервер.ЗарегистрироватьВсеДанныеКромеСправочниковДляНачальнойВыгрузки";
		КонецЕсли;
		
		Параметры = Новый Массив;
		Параметры.Добавить(УзелИнформационнойБазы);
		
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМетода, Параметры,, НСтр("ru = 'Создание обмена данными.'"));
		
		Попытка
			ФоновоеЗадание.ОжидатьЗавершения(5);
		Исключение
			
			ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗадание.УникальныйИдентификатор);
			
			Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
				
				ИдентификаторОперации = Строка(ФоновоеЗадание.УникальныйИдентификатор);
				ДлительнаяОперация = Истина;
				
			Иначе
				Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
					ВызватьИсключение ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
				КонецЕсли;
				
				ВызватьИсключение;
			КонецЕсли;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьИмяФайлаЧасти(PartNumber)
	
	Результат = "data.zip.[n]";
	
	Возврат СтрЗаменить(Результат, "[n]", Формат(PartNumber, "ЧГ=0"));
КонецФункции

Функция ВременныйКаталогВыгрузки(Знач ИдентификаторСессии)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВременныйКаталог = "{ИдентификаторСессии}";
	ВременныйКаталог = СтрЗаменить(ВременныйКаталог, "ИдентификаторСессии", Строка(ИдентификаторСессии));
	
	Результат = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ОбщегоНазначенияПовтИсп.КаталогВременногоХранилищаФайлов(), ВременныйКаталог);
	
	Возврат Результат;
КонецФункции

