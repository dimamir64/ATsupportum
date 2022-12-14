
//&НаСервере
//Процедура ПроверкаГотовностиНаСервере()
//	// Вставить содержимое обработчика.
//	СерверныеКоманды_ат.ОбработкаЗаданийVZ();

//КонецПроцедуры

//&НаКлиенте
//Процедура ПроверкаГотовности(Команда)
//	ПроверкаГотовностиНаСервере();
//	ОбновитьИнтерфейс();
//КонецПроцедуры

//&НаСервере
//Процедура СоздатьСогласованиеНаСервере()
//	УчетУслуг_ат.СоздатьСогласование(Элементы.Список.ТекущаяСтрока);
//КонецПроцедуры

&НаКлиенте
Процедура СоздатьСогласование(Команда)
	статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Элементы.Список.ТекущиеДанные.ссылка);
	Если статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении") 
		или  статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании") 
		или  статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаФинансовомСогласовании")
		тогда
		ДокументСогласования = Аренда_ат.СоздатьСогласование(Элементы.Список.ТекущаяСтрока);
		Если НЕ ДокументСогласования = Неопределено тогда
			ОткрытьЗначение(ДокументСогласования);
		Иначе
			Сообщить("Не получена ссылка на документ согласования"+ Символы.ПС + 
			"возможно документ согласования уже был создан ранее кем-то другим!", СтатусСообщения.ОченьВажное);
		КонецЕсли;
	Иначе Сообщить("статус изменен!, обновите список!");
		Элементы.Список.ТекущаяСтрока = неопределено;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	//Если (Элементы.Список.ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении") 
	//	или	  Элементы.Список.ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании")) 
	//	И 	  Элементы.Список.ТекущиеДанные.ПометкаУдаления = ложь тогда	
	//	СписокСоздатьСогласованиеНаСервере();
	//Иначе
	//	Элементы.СоздатьСогласование.Видимость = ложь;
	//конецЕсли;
	ТД =  Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено тогда
		Элементы.СоздатьСогласование.Доступность = ложь;
		Элементы.СоздатьВыполнениеЗаявки.Доступность = ложь;
		
	Иначе
		статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Элементы.Список.ТекущиеДанные.ссылка);
		Если (статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении")
			или   статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании"))
			И 	  Элементы.Список.ТекущиеДанные.ПометкаУдаления = ложь тогда	
			СписокСоздатьСогласованиеНаСервере();
		Иначе
			Элементы.СоздатьСогласование.Доступность = ложь;
		конецЕсли;
		
		//Если Элементы.Список.ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты")
		Если Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты")
			тогда СписокСоздатьВыполнениеЗаявкиНаСервере();
		Иначе Элементы.СоздатьВыполнениеЗаявки.Видимость = ложь;
		КонецЕсли;
		//Элементы.Список.ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
процедура СписокСоздатьСогласованиеНаСервере()
	//		 
	Если НЕ (РольДоступна("ПолныеПрава") или РольДоступна("ОрганизацияАдминистраторСерверов_ат")) или Элементы.Список.ТекущиеДанные	 = НЕОПРЕДЕЛЕНО
		тогда
		Элементы.СоздатьСогласование.Доступность 	= ложь;
	Иначе Элементы.СоздатьСогласование.Доступность 	= Истина;
	конецЕсли;
	
КонецПроцедуры

&НаСервере
процедура СписокСоздатьВыполнениеЗаявкиНаСервере()
	//		 
	Если НЕ (РольДоступна("ПолныеПрава") или РольДоступна("ОрганизацияАдминистраторСерверов_ат")) тогда
		Элементы.СоздатьВыполнениеЗаявки.Доступность = ложь;
	Иначе 	Элементы.СоздатьВыполнениеЗаявки.Доступность = истина;
		
	конецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаявку(Команда)
	
	статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Элементы.Список.ТекущиеДанные.ссылка);
	Если статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты") тогда
		ДокументВыполнение = Аренда_ат.СоздатьВыполнениеЗаявки(Элементы.Список.ТекущаяСтрока);
		Если НЕ ДокументВыполнение = Неопределено тогда
			ОткрытьЗначение(ДокументВыполнение);
		Иначе
			Сообщить("Не получена ссылка на документ ВыполнениеЗаявки"+ Символы.ПС + 
			"возможно документ уже был создан ранее кем-то другим!", СтатусСообщения.ОченьВажное);
		КонецЕсли;
	Иначе Сообщить("статус изменен!, обновите список!");
		Элементы.Список.ТекущаяСтрока = неопределено;
	КонецЕсли;
КонецПроцедуры

//&НаКлиенте
//Процедура СоздатьСогласование(Команда)
//	
//	если СерверныеКоманды_ат.ПроверкаПометкиУдаления(Элементы.Список.ТекущаяСтрока) тогда 
//		// HARDCODED!!!!
//		СБ = Новый СообщениеПользователю;
//		Сб.Текст = "Этот документ помечен на удаление! нельзя создавать документ согласования";
//		СБ.Поле = "Элементы.Список.ТекущаяСтрока";
//		СБ.Сообщить();
//	Иначе
//		статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Элементы.Список.ТекущиеДанные.ссылка);
//		Если статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.ВОбработке") 
//			или  статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании") 
//			или  статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаФинансовомСогласовании")
//			тогда
//			
//			ДокСогласования = Аренда_ат.ПолучаемАктивныйДокументСогласования(Элементы.Список.ТекущаяСтрока);
//			Если ДокСогласования = Неопределено тогда
//				
//				ДокументСогласования = Аренда_ат.СоздатьСогласование(Элементы.Список.ТекущаяСтрока);
//				ФормаНового	= ПолучитьФорму("Документ.Согласование_ат.Форма.ФормаДокумента"); 
//     				ДанныеФормы 	= ФормаНового.Объект;
//	    			СоздатьСогласованиеЗаявкиНаСервере(ДанныеФормы); 
//	  				копироватьДанныеФормы(ДанныеФормы, ФормаНового.Объект); 
//     			ФормаНового.Открыть();
//				
//				//Если НЕ ДокументСогласования = Неопределено тогда
//				//	ОткрытьЗначение(ДокументСогласования);
//				//	
//				//Иначе
//				//	Сообщить("ошибка: Не получена ссылка на документ согласования"+ Символы.ПС + 
//				//	"возможно документ согласования уже был создан ранее кем-то другим!", СтатусСообщения.ОченьВажное);
//				//КонецЕсли;
//				
//			Иначе 
//				//ответ = Вопрос("У документа уже имеется активный документ согласования! открыть его?", РежимДиалогаВопрос.ДаНет);
//				//Сообщить("статус изменен!, обновите список!");
//				значения = Новый СписокЗначений;
//				значения.Добавить("СоздатьНовый",	"Создать новый?");
//				значения.Добавить("Открыть",		"Открыть согласование?");
//				значения.Добавить("отмена",			"Отмена");
//				
//			///	ДокументСогласования = УчетУслуг_ат.СоздатьСогласование(Элементы.Список.ТекущаяСтрока);
//				ответ = Вопрос("У документа уже имеется активный документ согласования!", Значения);
//				Если ответ = "СоздатьНовый" тогда
//					
//				//	ДокументСогласования = УчетУслуг_ат.СоздатьСогласование(Элементы.Список.ТекущаяСтрока);
//					ФормаНового	= ПолучитьФорму("Документ.Согласование_ат.Форма.ФормаДокумента"); 
//	     				ДанныеФормы 	= ФормаНового.Объект;
//		    			СоздатьСогласованиеЗаявкиНаСервере(ДанныеФормы); 
//		  				копироватьДанныеФормы(ДанныеФормы, ФормаНового.Объект); 
//	     			ФормаНового.Открыть();

//					//ДокументСогласования = УчетУслуг_ат.СоздатьСогласование(Элементы.Список.ТекущаяСтрока);
//					//Если НЕ ДокументСогласования = Неопределено тогда
//					//	ОткрытьЗначение(ДокументСогласования);
//					//	
//					//Иначе
//					//	Сообщить("ошибка: Не получена ссылка на документ согласования"+ Символы.ПС + 
//					//	"возможно документ согласования уже был создан ранее кем-то другим!", СтатусСообщения.ОченьВажное);
//					//КонецЕсли;
//					
//				ИначеЕсли ответ = "Открыть" тогда
//					ОткрытьЗначение(ДокСогласования);		
//				Иначе 
//					
//				КонецЕсли;
//				
//				
//			КонецЕсли;
//			
//		ИначеЕсли статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.Отклонена") тогда
//			Сообщить("Этот документ ОТКЛОНЕН!!!, Для него нельзя создать догласование",СтатусСообщения.ОченьВажное);
//		ИначеЕсли статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении") тогда
//			Сообщить("Этот документ не находится в обработке" + Символы.ПС + "Необходимо создать документ Выполение Заявки...");
//		Иначе
//			Сообщить("Этот документ прошел все стадии согласования, сейчас его статус " + статус ,СтатусСообщения.ОченьВажное);
//			
//			
//		КонецЕсли;
//	КонецЕсли;
//	
////Элементы.Список.ТекущаяСтрока = неопределено;
////Элементы.Список.ВыделенныеСтроки = Неопределено;
//КонецПроцедуры

//&НаКлиенте
//Процедура СоздатьВыполнениеЗаявки(Команда)
//	док = Элементы.Список.ТекущаяСтрока;
//    если СерверныеКоманды_ат.ПроверкаПометкиУдаления(док) тогда 
//		СБ = Новый СообщениеПользователю;
//		Сб.Текст = "Этот документ помечен на удаление! нельзя создавать документ выполнения";
//		СБ.Поле = "Элементы.Список.ТекущаяСтрока";
//		СБ.Сообщить();
//	Иначе 
//	ДокументВыполнениеЗаявки = Аренда_ат.ПолучаемАктивныйДокументВыполненияЗаявки(Элементы.Список.ТекущаяСтрока);
//	Если ДокументВыполнениеЗаявки = Неопределено тогда
//		ФормаНового   = ПолучитьФорму("Документ.ВыполнениеЗаявкиНаАрендуПП_ат.Форма.ФормаДокумента"); 
//     	ДанныеФормы = ФормаНового.Объект;
//	    СоздатьВыполнениеЗаявкиНаСервере(ДанныеФормы); 
//	  	копироватьДанныеФормы(ДанныеФормы, ФормаНового.Объект); 
//     	ФормаНового.Открыть();

//	 Иначе
//	 	ответ = Вопрос("У документа уже есть подчиненный документ " + ДокументВыполнениеЗаявки + Символы.ПС + 
//	 	" открыть его для просмотра?",РежимДиалогаВопрос.ДаНет);
//		Если ответ = КодВозвратаДиалога.Да тогда
//			ОткрытьЗначение(ДокументВыполнениеЗаявки);			
//		КонецЕсли;
//	КонецЕсли;
//	КонецЕсли;

//КонецПроцедуры

//&НаСервере
//Функция   СоздатьВыполнениеЗаявкиНаСервере(ДанныеФормы)
//		документ = Документы.ВыполнениеЗаявкиНаАрендуПП_ат.СоздатьДокумент();
//		документ.Заполнить(Элементы.Список.ТекущаяСтрока);
//		
//      	ЗначениеВДанныеФормы(документ, ДанныеФормы); 
//		
//КонецФункции

//&НаСервере
//Функция   СоздатьСогласованиеЗаявкиНаСервере(ДанныеФормы)
//	
//		документ = Документы.Согласование_ат.СоздатьДокумент();
//		документ.Заполнить(Элементы.Список.ТекущаяСтрока);
//		ЗначениеВДанныеФормы(документ, ДанныеФормы); 
//		
//КонецФункции

//&НаКлиенте
//Процедура ИзменитьСтатусВручную(Команда)
//    ПараметрыФормы = Новый Структура;
//	ПараметрыФормы.Вставить("Документ",Элементы.Список.ТекущиеДанные.ссылка);
//	//ПараметрыФормы.Вставить("ОкноКлиентскогоПриложения", ВариантОткрытияОкна.ОтдельноеОкно);
//	ОткрытьФорму("ОбщаяФорма.ФормаСменыСтатусаЗаявки_ат",ПараметрыФормы,,,ВариантОткрытияОкна.ОтдельноеОкно);

//	//ИзменитьСтатусВручнуюНаСервере()
//КонецПроцедуры

//&НаСервере
//Процедура ИзменитьСтатусВручнуюНаСервере()
//	//Параметры = Новый Структура;
//	//Параметры.Вставить("Документ",Элементы.Список.ТекущиеДанные.ссылка);
//	//ОткрытьФорму("ОбщаяФорма.ФормаСменыСтатусаЗаявки_ат",Параметры);
//КонецПроцедуры

//&НаСервере
//процедура СписокСоздатьСогласованиеНаСервере()
//	//		 
//	Если НЕ (РольДоступна("ПолныеПрава") или РольДоступна("ОрганизацияАдминистраторСерверов_ат")) тогда
//		Элементы.СоздатьСогласование.Видимость 	= ложь;
//	Иначе Элементы.СоздатьСогласование.Видимость 	= Истина;
//	конецЕсли;
//	
//КонецПроцедуры


////&НаСервере
////процедура СписокСоздатьВыполнениеЗаявкиНаСервере()
////	//		 
////	Если НЕ (РольДоступна("ПолныеПрава") или РольДоступна("ОрганизацияАдминистраторСерверов_ат")) тогда
////			Элементы.СоздатьВыполнениеЗаявки.Видимость = ложь;
////	Иначе 	Элементы.СоздатьВыполнениеЗаявки.Видимость = истина;
////		
////	конецЕсли;
////	
////КонецПроцедуры


//статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Элементы.Список.ТекущиеДанные.ссылка);
//Если статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты") тогда
//	ДокументВыполнение = УчетУслуг_ат.СоздатьВыполнениеЗаявки(Элементы.Список.ТекущаяСтрока);
//	Если НЕ ДокументВыполнение = Неопределено тогда
//		ОткрытьЗначение(ДокументВыполнение);
//	Иначе
//		Сообщить("Не получена ссылка на документ ВыполнениеЗаявки"+ Символы.ПС + 
//		"возможно документ уже был создан ранее кем-то другим!", СтатусСообщения.ОченьВажное);
//	КонецЕсли;
//Иначе Сообщить("статус изменен!, обновите список!");
//	Элементы.Список.ТекущаяСтрока = неопределено;
//КонецЕсли;

//&НаКлиенте
//Процедура СписокПриАктивизацииСтроки(Элемент)
////Если (Элементы.Список.ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении") 
////или	  Элементы.Список.ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании")) 
//статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Элементы.Список.ТекущиеДанные.ссылка);
//Если (статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении")
//или   статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании"))
//И 	 Элементы.Список.ТекущиеДанные.ПометкаУдаления = ложь тогда	
//		//СписокСоздатьСогласованиеНаСервере();
//		Элементы.СоздатьСогласование.Видимость = СерверныеКоманды_ат.ПроверкаРолиСменыСтатусов();
//Иначе
//		Элементы.СоздатьСогласование.Видимость = ложь;
//конецЕсли;
//	
//		//Если Элементы.Список.ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты")
//Если Статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты")
//тогда 
//	//СписокСоздатьВыполнениеЗаявкиНаСервере();
//	Элементы.СоздатьВыполнениеЗаявки.Видимость = СерверныеКоманды_ат.ПроверкаРолиСменыСтатусов();
//Иначе Элементы.СоздатьВыполнениеЗаявки.Видимость = ложь;
//КонецЕсли;
////Элементы.Список.ТекущаяСтрока = Неопределено;

//	Элементы.ИзменитьСтатусВручную.Видимость = СерверныеКоманды_ат.ПроверкаРолиСменыСтатусов();	

//
//Если Элементы.Список.ТекущиеДанные.ПометкаУдаления тогда
//	 Элементы.СоздатьНаОсновании.Доступность = ложь;
//Иначе
//	 Элементы.СоздатьНаОсновании.Доступность = Истина;
//	 
//	 Если статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении") тогда
//		 Элементы.СоздатьВыполнение.Доступность = Истина;
//	 Иначе
//		 Элементы.СоздатьВыполнение.Доступность = Ложь;
//	 КонецЕсли;
// КонецЕсли;
//
//КонецПроцедуры
