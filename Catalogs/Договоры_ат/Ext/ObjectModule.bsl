
Перем СтруктураНовогоНомера Экспорт;


#Область  ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Если Ссылка.Пустая() Тогда
	//	
	//	Если НЕ ЗначениеЗаполнено(НомерДоговора) Тогда
	//		
	//		Если ЗначениеЗаполнено(Родитель) Тогда
	//			
	//			НомерДоговора = Справочники.Договоры_ат.ПолучитьНомерПодчиненногоДоговора(Родитель);
	//			
	//		Иначе
	//			
	//			НомерИПостфикс = Нумераторы_ат.ПолучитьНомерОбъекта(ЭтотОбъект, ДатаДоговора,,, Ложь);
	//			
	//			Если Тип(НомерИПостфикс) = ТипЗнч("Структура") И НомерИПостфикс.Свойство("Номер") Тогда
	//				
	//				НомерДоговора  = НомерИПостфикс.Номер;
	//				
	//			Иначе
	//				
	//				Сообщить("Ошибка определение нового номера договора!", СтатусСообщения.Внимание);
	//				Отказ = Истина;
	//				Возврат;
	//				
	//			КонецЕсли;
	//			
	//		КонецЕсли;
	//		
	//	КонецЕсли;
	//	
	//КонецЕсли;
	//
	//Справочники.Договоры_ат.ЗаполнитьНаименованиеДоговора(ЭтотОбъект);
	//
	//Если Ссылка.Пустая() Тогда
	//	
	//	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Наименование")); // У нового договора генерируется при записи
	//	
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Родитель.Родитель.Пустая() Тогда
		
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Нельзя сделать Дополнительное Соглашение к Дополнительному Соглашению (только непосредственно к основному Договору)!";
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	ПроверитьКлючевыеРеквизиты(Отказ);
	
	Если СтруктураНовогоНомера <> Неопределено И Родитель.Пустая() Тогда
		
		СтруктураНомера = Нумераторы_ат.ЗаписатьНомерОбъекта(СтруктураНовогоНомера, Истина);
		Если ТипЗнч(СтруктураНомера) <> Тип("Структура") Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Ошибка сохранения номера договора!";
			Сообщение.Сообщить();
			Отказ = Истина;
			
		ИначеЕсли НомерДоговора <> СтруктураНомера.Номер Тогда
			
			НомерДоговора = СтруктураНомера.Номер;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "При записи договора обнаружна коллизия номеров! Присвоен новый номер (и пересозданы наименования) - №" + НомерДоговора;
			Сообщение.Сообщить();
			
		КонецЕсли;
		
		СтруктураНовогоНомера = Неопределено;
		
	КонецЕсли;
	
	Справочники.Договоры_ат.ЗаполнитьНаименованияДоговора(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Удаляем данные при смене ТипаДоговора
	Если Ссылка.ВидДоговора.ТипДоговора <> ВидДоговора.ТипДоговора Тогда
		
		ИмяРегистра = Справочники.Договоры_ат.ПолучитьИмяРегистраСпецификацииДляТипаДоговора(Ссылка.ВидДоговора.ТипДоговора);
		Если ИмяРегистра <> Неопределено Тогда
			
			Попытка
				
				НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Договор.Установить(Ссылка);
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать();
				
			Исключение
				
				Отказ = Истина;
				Сообщить(ОписаниеОшибки());
				Возврат;
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Удаляем данные при смене Родителя (Основного договора)
	Если Ссылка.Родитель <> Родитель Тогда
		
		НаборЗаписей = РегистрыСведений.ДанныеДоговоров_ат.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.РодительскийДоговор.Установить(?(Ссылка.Родитель.Пустая(), Ссылка, Ссылка.Родитель));
		НаборЗаписей.Прочитать();
		
		ЗаписьДоговора = ЗаписьДанныхДоговора(НаборЗаписей);
		
		Если ЗаписьДоговора <> Неопределено Тогда
			
			НаборЗаписей.Удалить(ЗаписьДоговора);
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
	//
	
	РодительскийДоговор = ?(Родитель.Пустая(), Ссылка, Родитель);
	
	НаборЗаписей = РегистрыСведений.ДанныеДоговоров_ат.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.РодительскийДоговор.Установить(РодительскийДоговор);
	НаборЗаписей.Прочитать();
	
	ЗаписьДоговора = ЗаписьДанныхДоговора(НаборЗаписей);
	
	Если ЗначениеЗаполнено(ДатаНачала) Тогда
		
		Если ЗаписьДоговора = Неопределено Тогда
			ЗаписьДоговора = НаборЗаписей.Добавить();
		КонецЕсли;
		
		ЗаписьДоговора.Договор 				= Ссылка;
		ЗаписьДоговора.Период 				= ДатаНачала;
		ЗаписьДоговора.ДатаОкончания 		= ДатаОкончания(); //!!!TODO - если допик не с автопролонгацией, то надо делать запись с предыдущим
		ЗаписьДоговора.РодительскийДоговор 	= РодительскийДоговор; // актуальным договором (вычислять) на дату следующую за ДатаОкончания
		ЗаписьДоговора.ПометкаУдаления 		= ПометкаУдаления; //!!! зачем запись? почему не просто удалять?
		
	ИначеЕсли ЗаписьДоговора <> Неопределено Тогда
		
		НаборЗаписей.Удалить(ЗаписьДоговора);
		
	КонецЕсли;
	
	Попытка
		
		НаборЗаписей.Записать();
		
	Исключение
		
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить(); 
		
		Возврат;
		
	КонецПопытки;
	
	//
	
	БазаДанных = Константы.БухгалтерияДляСинхронизации_ат.Получить();
	
	Если БазаДанных.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	РезультатСинхронизации = СинхронизацияСБП_ат.СинхронизироватьДоговорСКонтрагентом(Ссылка, БазаДанных,, Ложь);
	
	Если РезультатСинхронизации.Ошибки.Количество() > 0 Тогда
		
		Отказ = Истина;
		
		Для Каждого Ошибка Из РезультатСинхронизации.Ошибки Цикл
			Сообщить(Ошибка);
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область  СлужебныеПроцедурыИФункции

Процедура ПроверитьКлючевыеРеквизиты(Отказ)
	
	Если НЕ Родитель.Пустая() Тогда
		
		Если Родитель.Организация <> Организация Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Организация в доп. соглашении не может отличаться от указанной в основном догворе!";
			Сообщение.Сообщить();
			
		КонецЕсли;
		
		Если Родитель.Владелец <> Владелец Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Контрагент в доп. соглашении не может отличаться от указанного в основном догворе!";
			Сообщение.Сообщить();
			
		КонецЕсли;
		
		Если Родитель.ВидДоговора <> ВидДоговора Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Вид договора в доп. соглашении не может отличаться от указанного в основном догворе!";
			Сообщение.Сообщить();
			
		КонецЕсли;
		
		Если Родитель.РодДоговора <> РодДоговора Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Вид договора контрагента в доп. соглашении не может отличаться от указанного в основном догворе!";
			Сообщение.Сообщить();
			
		КонецЕсли;
		
	КонецЕсли;
		
	Если Отказ ИЛИ ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;

	Если Организация <> Ссылка.Организация
		ИЛИ Владелец <> Ссылка.Владелец
		ИЛИ ВидДоговора <> Ссылка.ВидДоговора
		ИЛИ РодДоговора <> Ссылка.РодДоговора
		Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Договоры_ат.Ссылка) КАК Количество,
			|	ИСТИНА КАК Договоры,
			|	ЛОЖЬ КАК Счета,
			|	ЛОЖЬ КАК Реализации,
			|	ЛОЖЬ КАК Спецификации
			|ИЗ
			|	Справочник.Договоры_ат КАК Договоры_ат
			|ГДЕ
			|	Договоры_ат.Родитель = &Договор
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СчетНаОплату_ат.Ссылка),
			|	ЛОЖЬ,
			|	ИСТИНА,
			|	ЛОЖЬ,
			|	ЛОЖЬ
			|ИЗ
			|	Документ.СчетНаОплату_ат КАК СчетНаОплату_ат
			|ГДЕ
			|	СчетНаОплату_ат.Договор = &Договор
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Реализация_ат.Ссылка),
			|	ЛОЖЬ,
			|	ЛОЖЬ,
			|	ИСТИНА,
			|	ЛОЖЬ
			|ИЗ
			|	Документ.Реализация_ат КАК Реализация_ат
			|ГДЕ
			|	Реализация_ат.Договор = &Договор
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СпецификацияДоговоров_Обслуживание_ат.Договор.Ссылка),
			|	ЛОЖЬ,
			|	ЛОЖЬ,
			|	ЛОЖЬ,
			|	ИСТИНА
			|ИЗ
			|	РегистрСведений.СпецификацияДоговоров_Обслуживание_ат КАК СпецификацияДоговоров_Обслуживание_ат
			|ГДЕ
			|	СпецификацияДоговоров_Обслуживание_ат.ВключаетИТС.Ссылка = &Договор";
		
		Запрос.УстановитьПараметр("Договор", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ПрисоединяемыйТекстПричины = "";
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Договоры И Выборка.Количество > 0 Тогда
				
				ПрисоединяемыйТекстПричины = ПрисоединяемыйТекстПричины + "," +
					?(Выборка.Количество = 1, " Доп. соглашение", " Доп. соглашения");
				
			ИначеЕсли Выборка.Счета И Выборка.Количество > 0 Тогда
				
				ПрисоединяемыйТекстПричины = ПрисоединяемыйТекстПричины + "," +
					?(Выборка.Количество = 1, " Счёт созданный по договору", " Счета созданные по договору"); 
				
			ИначеЕсли Выборка.Реализации И Выборка.Количество > 0 Тогда
				
				ПрисоединяемыйТекстПричины = ПрисоединяемыйТекстПричины + "," +
					?(Выборка.Количество = 1, " Реализация созданная по договору", " Реализации созданные по договору");
				
			ИначеЕсли Выборка.Спецификации И Выборка.Количество > 0 Тогда		
				
				ПрисоединяемыйТекстПричины = ПрисоединяемыйТекстПричины + "," +
					?(Выборка.Количество = 1, " ссылка на Договор в спецификации Договора", " ссылки на Договор в спецификации Договоров");
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ПрисоединяемыйТекстПричины) Тогда
			
			Отказ = Истина;
			
			Сообщить("Изменение ключевых реквизитов Договора не допустимо т.к. есть" +
				Прав(ПрисоединяемыйТекстПричины, СтрДлина(ПрисоединяемыйТекстПричины) - 1) + ".");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция   ДатаОкончания()
	
	ДатаОкончания = Дата(1, 1, 1);
	
	Если ЗначениеЗаполнено(ДатаРасторжения) И ЗначениеЗаполнено(СрокДоговора) Тогда
		
		Если Автопролонгация ИЛИ ДатаРасторжения <= СрокДоговора Тогда
			ДатаОкончания = ДатаРасторжения;
		Иначе
			ДатаОкончания = СрокДоговора;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ДатаРасторжения) Тогда
		
		ДатаОкончания = ДатаРасторжения;
		
	ИначеЕсли НЕ Автопролонгация Тогда 
		
		ДатаОкончания = СрокДоговора;
		
	КонецЕсли;
	
	Возврат ДатаОкончания;
	
КонецФункции 

Функция   ЗаписьДанныхДоговора(НаборЗаписей)
	
	ЗаписьДоговора = Неопределено;
	
	Для Каждого Запись Из НаборЗаписей Цикл
		
		Если Запись.Договор = Ссылка Тогда
			
			ЗаписьДоговора = Запись;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЗаписьДоговора;
	
КонецФункции

#КонецОбласти


СтруктураНовогоНомера = Неопределено;
