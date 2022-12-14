
//TODO: перенести в @librorum в ДинамическиеСписки_ат

////////////////////////////////////////////////////////////////////////////////
// ОТБОРЫ ДИНАМИЧЕСКОГО СПИСКА

#Область ОтборыДинамическогоСписка

// Устанавливает или изменяет значения элемента отбора.
//
// Параметры:
//	Список - ДинамическийСписок - Динамический список в котором будет установлен отбор.
//	ИмяЭлементаОтбора - Строка - Имя поля для установки отбора.
//	ВидСравнения - ВидСравненияКомпоновкиДанных - Вид сравнения элемента отбора. По умолчанию - Равно.
//	Значение - Произвольный - Правое значение элемента отбора.
//	Использование - Булево - Признак использования элемента отбора.
//	Представление - Строка - Представление элемента отбора. Если не задано приравнивается к имени элемента отбора.
//	РежимОтображения - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - Определяет видимость применённого отбора.
//		По умолчанию - Обычный.
//	ОтборДинамическогоСписка - ОтборКомпоновкиДанных (варианты:
//		Список.Отбор
//		Список.КомпоновщикНастроек.Настройки.Отбор
//		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор
//		Список.КомпоновщикНастроек.ПользовательскиеНастройки.Отбор) - Указывает вид используемого отбора.
//			По умолчанию - завсисит от режимов совместимости и видимости.
//	СпособПоиска - число 1 или 2 - при указании 1, поиск будет осуществляться по ЛевомуЗначению, 2 - по Представлению.
//		По умолчанию, если указано Представление, то по нему - 2, иначе - 1.
//
Процедура УстановитьОтборДинамическогоСписка(
	Список,
	ИмяЭлементаОтбора,
	ВидСравнения = Неопределено,
	Значение,
	Использование = Истина,
	Представление = "",
	РежимОтображения = Неопределено,
	ОтборДинамическогоСписка = Неопределено,
	СпособПоиска = Неопределено) Экспорт
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	Если ПустаяСтрока(Представление) Тогда
		ПредставлениеОтбора = ИмяЭлементаОтбора;
	Иначе
		ПредставлениеОтбора = Представление;
	КонецЕсли;
	
	Если РежимОтображения = Неопределено Тогда
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный; //Недоступный
	КонецЕсли;
	
	Если ОтборДинамическогоСписка = Неопределено Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
			
			Если РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
				ОтборДинамическогоСписка = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
			Иначе
				ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
			КонецЕсли;
			
		Иначе
			ОтборДинамическогоСписка = Список.Отбор;
		КонецЕсли;
		
	КонецЕсли;
	
	Если СпособПоиска = Неопределено Тогда
		
		Если ПустаяСтрока(Представление) Тогда
			СпособПоиска = 1;
			ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяЭлементаОтбора);
		Иначе
			СпособПоиска = 2;
			ЗначениеПоиска = ПредставлениеОтбора;
		КонецЕсли;
		
	ИначеЕсли СпособПоиска = 1 Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяЭлементаОтбора);
	ИначеЕсли СпособПоиска = 2 Тогда
		ЗначениеПоиска = ПредставлениеОтбора;
	КонецЕсли;
	
	ЭлементыОтбора = Новый Массив;
	
	ПолучитьЭлементыОтбора(ОтборДинамическогоСписка.Элементы, ЭлементыОтбора, СпособПоиска, ЗначениеПоиска);
	
	Если ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор Тогда
		
		ЭлементыПользовательскогоОтбора = Новый Массив;
		
		ПолучитьЭлементыОтбора(Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы, ЭлементыПользовательскогоОтбора,
			3, ПредставлениеОтбора);
		
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			ОтборДинамическогоСписка.Элементы.Удалить(ЭлементОтбора);
		КонецЦикла;
		
		//Для Каждого ЭлементПользовательскогоОтбора Из ЭлементыПользовательскогоОтбора Цикл
		//	Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Удалить(ЭлементПользовательскогоОтбора);
		//КонецЦикла;
		
	КонецЕсли;
	
	Если ЭлементыОтбора.Количество() = 0 Или ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор Тогда
		
		//ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ОтборДинамическогоСписка, ИмяЭлементаОтбора, ВидСравнения,
		//	Значение, ПредставлениеОтбора, Использование, РежимОтображения);
		Элемент = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяЭлементаОтбора);
		Элемент.ВидСравнения = ВидСравнения;
		Элемент.ПравоеЗначение = Значение;
		Элемент.Использование = Использование;
		Элемент.Представление = Представление;
		Элемент.РежимОтображения = РежимОтображения;
		
		Элемент.ПредставлениеПользовательскойНастройки = ПредставлениеОтбора;
		
		// Важно: установка идентификатора должна выполняться
		// в конце настройки элемента, иначе он будет скопирован
		// в пользовательские настройки частично заполненным.
		Элемент.ИдентификаторПользовательскойНастройки = ПредставлениеОтбора; //ИмяЭлементаОтбора;
		
	Иначе
		
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяЭлементаОтбора);
			ЭлементОтбора.ВидСравнения = ВидСравнения;
			ЭлементОтбора.ПравоеЗначение = Значение;
			ЭлементОтбора.Использование = Использование;
			ЭлементОтбора.Представление = ПредставлениеОтбора;
			ЭлементОтбора.РежимОтображения = РежимОтображения;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Изменяет использование элемента отбора.
//
// Параметры:
//	Список - ДинамическийСписок - Динамический список в котором будет установлен отбор.
//	ИмяИлиПредставление - Строка - Имя поля или представление элемента отбора. Обязателен, так как поиск осуществляется только по этому значению.
//	Использование - Булево - Признак использования элемента отбора.
//	СпособПоиска - число 1 или 2 - при указании 1, поиск будет осуществляться по ЛевомуЗначению, 2 - по Представлению.
//
Процедура ИзменитьИспользованиеОтбораДинамическогоСписка(Список, ИмяИлиПредставление, Использование, ОтборДинамическогоСписка = Неопределено,
	СпособПоиска = 2) Экспорт
	
	Если ПустаяСтрока(ИмяИлиПредставление) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтборДинамическогоСписка = Неопределено Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
			ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		Иначе
			ОтборДинамическогоСписка = Список.Отбор;
		КонецЕсли;
		
	КонецЕсли;
	
	ЭлементыОтбора = Новый Массив;
	
	Если СпособПоиска = 1 Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяИлиПредставление);
	ИначеЕсли СпособПоиска = 2 Тогда
		ЗначениеПоиска = ИмяИлиПредставление;
	КонецЕсли;
	
	//Если ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор Тогда
	//	
	//	Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Очистить();
	//	//ЭлементыПользовательскогоОтбора = Новый Массив;
	//	//
	//	//Для Каждого ЭлементОтбора Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
	//	//	Если ЭлементОтбора.ВидСравнения <> Неопределено Тогда
	//	//		Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Удалить(ЭлементОтбора);
	//	//	КонецЕсли;
	//	//КонецЦикла;
	//	
	//КонецЕсли;
	
	ПолучитьЭлементыОтбора(ОтборДинамическогоСписка.Элементы, ЭлементыОтбора, СпособПоиска, ЗначениеПоиска);
	
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		
		ЭлементОтбора.Использование = Использование;
		
		Если ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор Тогда
			
			Если ЭлементОтбора.ИдентификаторПользовательскойНастройки <> "" Тогда
				ЭлементыПользовательскогоОтбора = Новый Массив;
				
				ПолучитьЭлементыОтбора(Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы, ЭлементыПользовательскогоОтбора,
					3, ЭлементОтбора.ИдентификаторПользовательскойНастройки);
				
				Для Каждого ЭлементПользовательскогоОтбора Из ЭлементыПользовательскогоОтбора Цикл
					ЭлементПользовательскогоОтбора.Использование = Использование;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		//Элемент = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		//Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяЭлементаОтбора);
		//Элемент.ВидСравнения = ВидСравнения;
		//Элемент.ПравоеЗначение = Значение;
		//Элемент.Использование = Использование;
		//Элемент.Представление = Представление;
		//Элемент.РежимОтображения = РежимОтображения;
		//
		//Элемент.ПредставлениеПользовательскойНастройки = ПредставлениеОтбора;
		//
		//// Важно: установка идентификатора должна выполняться
		//// в конце настройки элемента, иначе он будет скопирован
		//// в пользовательские настройки частично заполненным.
		//Элемент.ИдентификаторПользовательскойНастройки = ПредставлениеОтбора; //ИмяЭлементаОтбора;
	КонецЦикла;
	
	//Если ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор Тогда
	//	
	//	ЭлементыПользовательскогоОтбора = Новый Массив;
	//	
	//	ПолучитьЭлементыОтбора(Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы, ЭлементыПользовательскогоОтбора,
	//		3, ИмяИлиПредставление);
	//	
	//	Для Каждого ЭлементПользовательскогоОтбора Из ЭлементыПользовательскогоОтбора Цикл
	//		ЭлементПользовательскогоОтбора.Использование = Использование;
	//	КонецЦикла;
	//	
	//КонецЕсли;
	
КонецПроцедуры 

// Осуществляет поиск элемента отбора в переданной коллекции отбора компоновки данных.
//
// Параметры:
//	КоллекцияЭлементовОтбора - КоллекцияЭлементовОтбораКомпоновкиДанных - Коллекция элементов отбора компоновки данных,
//		в котором будет осуществлен поиск элементов отбора
//	ЭлементыОтбора - Массив - _возвращаемый_ массив найденных элементов
//	СпособПоиска - число 1, 2 или 3: 1 - поиск будет осуществляться по ЛевоеЗначение, 2 - по Представление,
//		3 - по ИдентификаторПользовательскойНастройки
//	ЗначениеПоиска - Строка - Имя или Представление искомых элементов отбора
// 
Процедура ПолучитьЭлементыОтбора(КоллекцияЭлементовОтбора, ЭлементыОтбора, СпособПоиска, ЗначениеПоиска) Экспорт
	
	Для Каждого ЭлементОтбора Из КоллекцияЭлементовОтбора Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если СпособПоиска = 1 Тогда
				
				Если ЭлементОтбора.ЛевоеЗначение = ЗначениеПоиска Тогда
					ЭлементыОтбора.Добавить(ЭлементОтбора);
				КонецЕсли;
				
			ИначеЕсли СпособПоиска = 2 Тогда
				
				Если ЭлементОтбора.Представление = ЗначениеПоиска Тогда
					ЭлементыОтбора.Добавить(ЭлементОтбора);
				КонецЕсли;
				
			ИначеЕсли СпособПоиска = 3 Тогда
				
				Если ЭлементОтбора.ИдентификаторПользовательскойНастройки = ЗначениеПоиска Тогда
					ЭлементыОтбора.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			ПолучитьЭлементыОтбора(ЭлементОтбора.Элементы, ЭлементыОтбора, СпособПоиска, ЗначениеПоиска);
			
			Если СпособПоиска = 2 И ЭлементОтбора.Представление = ЗначениеПоиска Тогда
				ЭлементыОтбора.Добавить(ЭлементОтбора);
			ИначеЕсли СпособПоиска = 3 И ЭлементОтбора.ИдентификаторПользовательскойНастройки = ЗначениеПоиска Тогда
				ЭлементыОтбора.Добавить(ЭлементОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Отключает все доступные для редактирования элементы отбора.
//
// Параметры:
//	ОтборКомпоновкиДанных - ОтборКомпоновкиДанных - Отбор компановки данных в котором будет осуществлено отключение элемента отбора.
//
Процедура ОтключитьОтборыСписка(ОтборКомпоновкиДанных) Экспорт
	
	ОтключитьОтборыСпискаВЭлементах(ОтборКомпоновкиДанных.Элементы);
	
КонецПроцедуры

//TODO: сделать универсальной по поиску - см. ПолучитьЭлементыОтбора и СуществуетОтборСписка
Процедура ВосстановитьОтборСписка(Список, Настройки, ИмяЭлементаОтбора) Экспорт
	
	Отборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, ИмяЭлементаОтбора);
	
	Если Отборы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементОтбора = Отборы[0];
	ИдентификаторНастройки = ЭлементОтбора.ИдентификаторПользовательскойНастройки;
	
	Для Каждого ЭлементНастроек Из Настройки.Элементы Цикл
		
		Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементНастроек.ИдентификаторПользовательскойНастройки = ИдентификаторНастройки Тогда
			
			ЭлементНастроек.ПравоеЗначение = ЭлементОтбора.ПравоеЗначение;
			ЭлементНастроек.Использование  = ЭлементОтбора.Использование;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция   СуществуетОтборСписка(Список, ЭлементОтбораИлиЕгоИмя) Экспорт
	
	ОтборСуществует = Ложь;
	
	Для Каждого ЭлементОтбора Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если (ТипЗнч(ЭлементОтбораИлиЕгоИмя) = Тип("ЭлементОтбораКомпоновкиДанных")
				 	И ЭлементОтбора.ЛевоеЗначение = ЭлементОтбораИлиЕгоИмя)
				 Или (ТипЗнч(ЭлементОтбораИлиЕгоИмя) = Тип("Строка")
				 	И Строка(ЭлементОтбора.ЛевоеЗначение) = ЭлементОтбораИлиЕгоИмя) Тогда
				ОтборСуществует = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОтборСуществует;
	
КонецФункции

Процедура ОтключитьОтборыСпискаВЭлементах(КоллекцияЭлементовОтбора)
	
	Для Каждого ЭлементОтбора Из КоллекцияЭлементовОтбора Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если ЭлементОтбора.РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
				ЭлементОтбора.Использование = Ложь;
			КонецЕсли;
			
		Иначе
			ОтключитьОтборыСпискаВЭлементах(ЭлементОтбора.Элементы);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 
