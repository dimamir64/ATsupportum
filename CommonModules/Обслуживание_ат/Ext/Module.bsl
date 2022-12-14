
Процедура РаспаковкаОтчетовОбОшибках_ат() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	*
		|ИЗ
		|	РегистрСведений.РегистрацияОшибок_ат
		|ГДЕ
		|	(НЕ Распакован)";
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		РезультатВыборки = РезультатЗапроса.Выбрать();
		Пока РезультатВыборки.Следующий() Цикл
			
			Попытка
				ОбработатьОтчетОбОшибке(РезультатВыборки);
			Исключение
				ЗаписатьОшибкуРаспаковкиОтчетаОбОшибке(РезультатВыборки.ИдентификаторОшибки, ОписаниеОшибки());
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОтчетОбОшибке(РезультатВыборкиОшибки)
	
	Попытка
		
		ВременныйКаталог = Новый Массив;
		ВременныйКаталог.Добавить(КаталогВременныхФайлов());
		ВременныйКаталог.Добавить("ОбработкаОтчетовОбОшибках");
		ВременныйКаталог.Добавить(РезультатВыборкиОшибки.ИдентификаторОшибки);
		ВременныйКаталог = СтрСоединить(ВременныйКаталог, "\");
		
		ДанныеОтчета = РезультатВыборкиОшибки.ПолученныеДанные.Получить();
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".zip");
		ДанныеОтчета.Записать(ИмяВременногоФайла);
		
		Попытка
			
			Архиватор = Новый ЧтениеZipФайла(ИмяВременногоФайла);
			Архиватор.ИзвлечьВсе(ВременныйКаталог);
			Архиватор.Закрыть();
			
			//TESTУдалитьФайлы(ИмяВременногоФайла);
			
		Исключение
			
			Попытка
				
				//TESTУдалитьФайлы(ИмяВременногоФайла);
				//TESTУдалитьФайлы(ВременныйКаталог);
				
			Исключение
			КонецПопытки;
			
			ВызватьИсключение;
			
		КонецПопытки;
		
		Попытка
			
			ИмяОсновногоФайла = СтрШаблон("%1\%2", ВременныйКаталог, "report.json");
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ИмяОсновногоФайла, КодировкаТекста.UTF8);
			
			ТекстОсновногоФайла = ТекстовыйДокумент.ПолучитьТекст();
			
			//TESTУдалитьФайлы(ВременныйКаталог);
			
		Исключение
			
			//TESTУдалитьФайлы(ВременныйКаталог);
			ВызватьИсключение;
			
		КонецПопытки;
		
		//СсылкаНаОтчет = Документы.ОтчетыОбОшибках.ПолучитьСсылку(РезультатВыборкиОшибки.Идентификатор);
		//ОтчетОбОшибке = СсылкаНаОтчет.ПолучитьОбъект();
		//
		//Если ОтчетОбОшибке = Неопределено Тогда
		//	ОтчетОбОшибке = Документы.ОтчетыОбОшибках.СоздатьДокумент();
		//	ОтчетОбОшибке.УстановитьСсылкуНового(СсылкаНаОтчет);
		//КонецЕсли;
		ОтчетОбОшибке = Документы.АвтоотчетОбОшибке_ат.СоздатьДокумент();
		ОтчетОбОшибке.Дата = РезультатВыборкиОшибки.ДатаВремяПолучения;
		//ОтчетОбОшибке.АвторКлиента = ф;
		ОтчетОбОшибке.ИдентификаторОшибки = РезультатВыборкиОшибки.ИдентификаторОшибки;
		//ОтчетОбОшибке.ИмяПользователя = ф;
		//ОтчетОбОшибке.ИнформационнаяБаза = ф;
		//ОтчетОбОшибке.СведенияОбОкружении = ф;
		ОтчетОбОшибке.ТекстОтчета = ТекстОсновногоФайла;
		ОтчетОбОшибке.Записать();
		
		ЗаписьРегистрации = РегистрыСведений.РегистрацияОшибок_ат.СоздатьМенеджерЗаписи();
		ЗаписьРегистрации.ИдентификаторОшибки = РезультатВыборкиОшибки.ИдентификаторОшибки;
		
		Если ЗаписьРегистрации.Выбран() Тогда
			
			ЗаписьРегистрации.Распакован = Истина;
			ЗаписьРегистрации.Записать();
			
		КонецЕсли;
		
	Исключение
		
		ЗаписатьОшибкуРаспаковкиОтчетаОбОшибке(РезультатВыборкиОшибки.ИдентификаторОшибки, ОписаниеОшибки());
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗаписатьОшибкуРаспаковкиОтчетаОбОшибке(ИдентификаторОшибки, ОписаниеОшибки)
	
	ЗаписьРегистрации = РегистрыСведений.РегистрацияОшибок_ат.СоздатьМенеджерЗаписи();
	ЗаписьРегистрации.ИдентификаторОшибки = ИдентификаторОшибки;
	
	Если ЗаписьРегистрации.Выбран() Тогда
		
		ЗаписьРегистрации.Распакован = Истина;
		ЗаписьРегистрации.ОшибкаРаспаковки = ОписаниеОшибки;
		ЗаписьРегистрации.Записать();
		
	КонецЕсли;
	
КонецПроцедуры
