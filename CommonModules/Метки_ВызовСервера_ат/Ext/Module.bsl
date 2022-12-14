
Функция   ПолучитьСписокКлючейДляОтбора(ИмяОбъектаМетаданных, СписокЗначенийОтбора, СписокАктивныхОтборов) Экспорт
	
	Возврат Метки_Сервер_ат.ПолучитьСписокКлючейДляОтбора(ИмяОбъектаМетаданных, СписокЗначенийОтбора, СписокАктивныхОтборов);
	
КонецФункции

Функция   ПолучитьСписокОбъектовОтбора(ТипЗначенияОбъекта, ТипЗначенияМеток, МассивЗначенийИ,
									МассивЗначенийИЛИ, МассивЗначенийНЕ, ДобавлятьНулевоеЗначение, ОтборыВключены) Экспорт
		
	Если НЕ ТипЗнч(ТипЗначенияОбъекта) = Тип("Массив") Тогда
		
		ЭлементМассива = ТипЗначенияОбъекта;
		ТипЗначенияОбъекта = Новый Массив;
		ТипЗначенияОбъекта.Добавить(ЭлементМассива);
		
	КонецЕсли;
	
	ТекстЗапроса = "";
	ЭтоПервый = Истина;
	
	Для Каждого ЭлементМассива Из ТипЗначенияОбъекта Цикл
		
		ИмяРегистра = Метки_КлиентСервер_Переопределяемый.ПолучитьИмяРегистраМеток(ЭлементМассива, ТипЗначенияМеток);
		
		Если ПустаяСтрока(ИмяРегистра) Тогда
			Возврат Новый Массив;
		КонецЕсли;
		
		Если НЕ ЭтоПервый Тогда
			ТекстЗапроса = ТекстЗапроса + " Объединить все ";
		КонецЕсли;
		
		ИмяМетаданныхОбъекта = Метаданные.НайтиПоТипу(ЭлементМассива).ПолноеИмя();
		
		Запрос = Новый Запрос;
		
		СтрокаУсловияИЛИ			 = "";
		СтрокаУсловияНЕ				 = "";
		СтрокаУсловиеПоНезаполненным = "";
		
		Если МассивЗначенийИ.Количество() = 0 Тогда
			
			ТекстЗапроса = ТекстЗапроса +
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Объекты.Ссылка КАК Объект
			|ИЗ
			|	&ИмяМетаданныхОбъекта КАК Объекты
			|		ЛЕВОЕ СОЕДИНЕНИЕ &ИмяРегистра КАК ЗначенияМеток
			|		ПО Объекты.Ссылка = ЗначенияМеток.Объект 
			|ГДЕ
			|	&УсловиеПоНезаполненным
			|	ИЛИ
			|	(&УсловиеИЛИ
			|	И &УсловиеНЕ)";
			
		Иначе
			
			ТекстЗапроса = ТекстЗапроса +
			"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
			|	Объекты.Ссылка КАК Объект
			|ИЗ
			|	&ИмяМетаданныхОбъекта КАК Объекты
			|		ЛЕВОЕ СОЕДИНЕНИЕ &ИмяРегистра КАК ЗначенияМеток
			|		
			|			ЛЕВОЕ СОЕДИНЕНИЕ
			|		(ВЫБРАТЬ
			|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КоличествоМеток.ЗначениеМетки) КАК Количество,
			|			КоличествоМеток.Объект КАК Объект
			|		ИЗ
			|			&ИмяРегистра КАК КоличествоМеток
			|		ГДЕ
			|			КоличествоМеток.ЗначениеМетки В(&МассивИ)
			|	
			|			СГРУППИРОВАТЬ ПО
			|				КоличествоМеток.Объект) КАК ВложенныйЗапрос
			|			ПО (ЗначенияМеток.Объект = ВложенныйЗапрос.Объект)
			|		ПО Объекты.Ссылка = ЗначенияМеток.Объект
			|ГДЕ
			|	&УсловиеПоНезаполненным
			|	ИЛИ 
			|	((ВложенныйЗапрос.Количество = &КоличествоЗначенийИ ИЛИ &УсловиеИЛИ)
			|	И &УсловиеНЕ)";
			
			Запрос.УстановитьПараметр("МассивИ", МассивЗначенийИ);
			Запрос.УстановитьПараметр("КоличествоЗначенийИ", МассивЗначенийИ.Количество());
			
			ОтборыВключены = Истина;
			
		КонецЕсли;
		
		Если МассивЗначенийИЛИ.Количество() = 0 Тогда
			
			СтрокаУсловияИЛИ = "Ложь";
			
		Иначе
			
			СтрокаУсловияИЛИ = "ЗначенияМеток.ЗначениеМетки В(&МассивИЛИ)";
			Запрос.УстановитьПараметр("МассивИЛИ",	МассивЗначенийИЛИ);
			
			ОтборыВключены = Истина;
			
		КонецЕсли;
		
		Если МассивЗначенийНЕ.Количество() = 0 Тогда
			
			СтрокаУсловияНЕ = "Истина";
			
		Иначе
			
			ЗапросНЕ = Новый Запрос;
			ЗапросНЕ.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЗначенияМеток.Объект КАК Объект
			|ИЗ
			|	&ИмяРегистра КАК ЗначенияМеток
			|ГДЕ
			|	ЗначенияМеток.ЗначениеМетки В(&МассивНЕ)";
			
			ЗапросНЕ.Текст = СтрЗаменить(ЗапросНЕ.Текст, "&ИмяРегистра", "РегистрСведений." + ИмяРегистра);
			
			СтрокаУсловияНЕ = "НЕ ЗначенияМеток.Объект В(&МассивОбъектовНЕ)";
			ЗапросНЕ.УстановитьПараметр("МассивНЕ",	МассивЗначенийНЕ);
			
			Запрос.УстановитьПараметр("МассивОбъектовНЕ", ЗапросНЕ.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект"));
			
			ОтборыВключены = Истина;
			
		КонецЕсли;
		
		Если НЕ ОтборыВключены И НЕ ДобавлятьНулевоеЗначение Тогда
			Возврат Новый Массив;
		КонецЕсли;
		
		СтрокаУсловиеПоНезаполненным = ?(ДобавлятьНулевоеЗначение, "ЗначенияМеток.Объект Есть NULL", "Ложь");
			
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяМетаданныхОбъекта",	ИмяМетаданныхОбъекта);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяРегистра",			"РегистрСведений." + ИмяРегистра);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеПоНезаполненным", СтрокаУсловиеПоНезаполненным);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеИЛИ",				СтрокаУсловияИЛИ);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеНЕ",				СтрокаУсловияНЕ);
		
		ЭтоПервый = Ложь;
		
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект");	
	
КонецФункции

Функция   СформироватьПредставлениеОтбора(Дерево, ДобавлятьНулевоеЗначение = Ложь) Экспорт
	
	ПредставлениеОтбора = "";
	ПредставлениеОтбораИ = "";
	ПредставлениеОтбораИЛИ = "";
	ПредставлениеОтбораНЕ = "";
		
	ИспользованиеМеток = ПолучитьСтруктуруВыбранныхМеток(Дерево);
	
	Если ИспользованиеМеток.ИспользоватьИ Тогда
		
		СформироватьПредставлениеОтбораПоВидуОтбора(Дерево, ПредставлениеОтбораИ, "ИспользоватьИ");
		
		Если НЕ ПустаяСтрока(ПредставлениеОтбораИ) Тогда
			
			ПредставлениеОтбора = "И: " + Лев(ПредставлениеОтбораИ, СтрДлина(ПредставлениеОтбораИ) - 2);
			
		КонецЕсли;
		
	Иначе
		
		ПредставлениеОтбораИ = "* ";
		ПредставлениеОтбора = "И: " + ПредставлениеОтбораИ;
		
	КонецЕсли;
	
	Если ИспользованиеМеток.ИспользоватьИЛИ Тогда
	
		СформироватьПредставлениеОтбораПоВидуОтбора(Дерево, ПредставлениеОтбораИЛИ, "ИспользоватьИЛИ");
		
		Если НЕ ПустаяСтрока(ПредставлениеОтбораИЛИ) Тогда
			
			ПредставлениеОтбора = ПредставлениеОтбора + ?(ПустаяСтрока(ПредставлениеОтбораИ), "", Символы.ПС)
				+ "ИЛИ: " + Лев(ПредставлениеОтбораИЛИ, СтрДлина(ПредставлениеОтбораИЛИ) - 2);
			
		КонецЕсли;
	
	Иначе
		
		ПредставлениеОтбораИЛИ = "* ";
		ПредставлениеОтбора = ПредставлениеОтбора + ?(ПустаяСтрока(ПредставлениеОтбораИ), "", Символы.ПС)
			+ "ИЛИ: " + ПредставлениеОтбораИЛИ;
		
	КонецЕсли;
	
	Если ИспользованиеМеток.ИспользоватьНЕ Тогда
	
		СформироватьПредставлениеОтбораПоВидуОтбора(Дерево, ПредставлениеОтбораНЕ, "ИспользоватьНЕ");
		
		Если НЕ ПустаяСтрока(ПредставлениеОтбораНЕ) Тогда
			
			ПредставлениеОтбора = ПредставлениеОтбора + ?(ПустаяСтрока(ПредставлениеОтбораИ) И ПустаяСтрока(ПредставлениеОтбораИЛИ), "", Символы.ПС)
				+ "НЕ: " + Лев(ПредставлениеОтбораНЕ, СтрДлина(ПредставлениеОтбораНЕ) - 2);
			
		КонецЕсли;
		
	Иначе
		
		ПредставлениеОтбораНЕ = "* ";
		ПредставлениеОтбора = ПредставлениеОтбора + ?(ПустаяСтрока(ПредставлениеОтбораИ) И ПустаяСтрока(ПредставлениеОтбораИЛИ), "", Символы.ПС)
			+ "НЕ: " + ПредставлениеОтбораНЕ;
		
	КонецЕсли;
	
	Если ДобавлятьНулевоеЗначение Тогда
		
		Если ПустаяСтрока(ПредставлениеОтбора) Тогда
			ПредставлениеОтбора = "Только незаполненные";
		Иначе
			ПредставлениеОтбора = ПредставлениеОтбора + Символы.ПС + "Включая незаполненные";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ПредставлениеОтбора) Тогда
		ПредставлениеОтбора = "Нет отбора";
	Иначе
		ПредставлениеОтбора = "Установлен отбор:" + Символы.ПС + ПредставлениеОтбора;
	КонецЕсли;
	
	Возврат ПредставлениеОтбора;
	
КонецФункции

Функция   СформироватьПредставлениеОтбораИзСпискаАктивныхМеток(СписокЗначенийМеток, ВключаяНезаполненные = Ложь) Экспорт
	
	Дерево = Метки_Сервер_ат.ПолучитьТаблицуСсылокНаИсточникиЗначенийВыбора("Справочник.Метки_ат",, Истина);
	
	Для Каждого ЭлементСпискаЗначенийМеток Из СписокЗначенийМеток Цикл
		
		СтрокаДерева = Дерево.Строки.Найти(ЭлементСпискаЗначенийМеток.Значение,, Истина);
		Если НЕ СтрокаДерева = Неопределено Тогда
			
			СтрокаДерева.ИспользоватьИ = ЭлементСпискаЗначенийМеток.Пометка;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СформироватьПредставлениеОтбора(ДобавитьКонревойЭлементДерева(Дерево), ВключаяНезаполненные = Ложь);
	
КонецФункции

Функция   СформироватьПредставлениеОтбораИзТаблицы(ТаблицаЗначенийМеток, ВключаяНезаполненные) Экспорт
	
	Дерево = Метки_Сервер_ат.ПолучитьТаблицуСсылокНаИсточникиЗначенийВыбора("Справочник.Метки_ат",, Истина);
	
	Для Каждого СтрокаТаблицыЗначенийМеток Из ТаблицаЗначенийМеток Цикл
		
		СтрокаДерева = Дерево.Строки.Найти(СтрокаТаблицыЗначенийМеток.Значение,, Истина);
		Если НЕ СтрокаДерева = Неопределено Тогда
			
			СтрокаДерева.ИспользоватьИ		= СтрокаТаблицыЗначенийМеток.ИспользоватьИ;
			СтрокаДерева.ИспользоватьИЛИ	= СтрокаТаблицыЗначенийМеток.ИспользоватьИЛИ;
			СтрокаДерева.ИспользоватьНЕ		= СтрокаТаблицыЗначенийМеток.ИспользоватьНЕ;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СформироватьПредставлениеОтбора(ДобавитьКонревойЭлементДерева(Дерево), ВключаяНезаполненные);
	
КонецФункции

Функция   ДобавитьКонревойЭлементДерева(ИсходноеДерево)
	
	НовоеДерево = Новый ДеревоЗначений;
	
	Для Каждого Колонка Из ИсходноеДерево.Колонки Цикл
		
		НовоеДерево.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения ,"ВСЕ");
		
	КонецЦикла;
	
	НоваяСтрока = НовоеДерево.Строки.Добавить();
	
	ПереместитьСтрокиДереваРекурсивно(НоваяСтрока, ИсходноеДерево.Строки);
	
	Возврат НовоеДерево;
	
КонецФункции

Процедура ПереместитьСтрокиДереваРекурсивно(Родитель, СтрокиИсходногоДерева)
	
	Для Каждого СтрокаИсходногоДерева Из СтрокиИсходногоДерева Цикл
		
		НоваяСтрока = Родитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсходногоДерева,, "Родитель");
		ПереместитьСтрокиДереваРекурсивно(НоваяСтрока, СтрокаИсходногоДерева.Строки)
		
	КонецЦикла;
	
КонецПроцедуры

Функция   ПолучитьСтруктуруВыбранныхМеток(Дерево)
	
	СтруктураВыбранныхМеток = Новый Структура;
	КоличествоИ = 0;
	КоличествоИЛИ = 0;
	КоличествоНЕ = 0;
	КоличествоИспользуемых = 0;
	ОбщееКоличество = 0;
	
	ПосчитатьКоличествоМетокРекурсивно(Дерево.Строки, КоличествоИ, КоличествоИЛИ, КоличествоНЕ, КоличествоИспользуемых, ОбщееКоличество);
	
	Если КоличествоИспользуемых = ОбщееКоличество Тогда
		
		МаксимальноеКоличество = Макс(КоличествоИ, КоличествоИЛИ, КоличествоНЕ);
		
		Если КоличествоИ = МаксимальноеКоличество Тогда
			
			СтруктураВыбранныхМеток.Вставить("ИспользоватьИ", Ложь);
			СтруктураВыбранныхМеток.Вставить("ИспользоватьИЛИ", Истина);
			СтруктураВыбранныхМеток.Вставить("ИспользоватьНЕ", Истина);
			
		ИначеЕсли КоличествоИЛИ = МаксимальноеКоличество Тогда
			
			СтруктураВыбранныхМеток.Вставить("ИспользоватьИ", Истина);
			СтруктураВыбранныхМеток.Вставить("ИспользоватьИЛИ", Ложь);
			СтруктураВыбранныхМеток.Вставить("ИспользоватьНЕ", Истина);
			
		ИначеЕсли КоличествоНЕ = МаксимальноеКоличество Тогда
			
			СтруктураВыбранныхМеток.Вставить("ИспользоватьИ", Истина);
			СтруктураВыбранныхМеток.Вставить("ИспользоватьИЛИ", Истина);
			СтруктураВыбранныхМеток.Вставить("ИспользоватьНЕ", Ложь);
			
		КонецЕсли;
		
		
	Иначе
		
		СтруктураВыбранныхМеток.Вставить("ИспользоватьИ", Истина);
		СтруктураВыбранныхМеток.Вставить("ИспользоватьИЛИ", Истина);
		СтруктураВыбранныхМеток.Вставить("ИспользоватьНЕ", Истина);
		
	КонецЕсли;
	
	
	Возврат СтруктураВыбранныхМеток;
	
КонецФункции

Процедура ПосчитатьКоличествоМетокРекурсивно(Строки, КоличествоИ, КоличествоИЛИ, КоличествоНЕ, КоличествоИспользуемых, ОбщееКоличество)
	
	Для Каждого Строка Из Строки Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение) И НЕ Строка.Значение.ЭтоГруппа Тогда
			
			Если Строка.ИспользоватьИ Тогда
				
				КоличествоИ = КоличествоИ + 1;
				КоличествоИспользуемых = КоличествоИспользуемых + 1;
				
			ИначеЕсли Строка.ИспользоватьИЛИ Тогда
				
				КоличествоИЛИ = КоличествоИЛИ + 1;
				КоличествоИспользуемых = КоличествоИспользуемых + 1;
				
			ИначеЕсли Строка.ИспользоватьНЕ Тогда
				
				КоличествоНЕ = КоличествоНЕ + 1;
				КоличествоИспользуемых = КоличествоИспользуемых + 1;
				
			КонецЕсли;
			
			ОбщееКоличество = ОбщееКоличество + 1;
			
		КонецЕсли;
		
		ПосчитатьКоличествоМетокРекурсивно(Строка.Строки, КоличествоИ, КоличествоИЛИ, КоличествоНЕ, КоличествоИспользуемых, ОбщееКоличество)
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьПредставлениеОтбораПоВидуОтбора(Дерево, ПредставлениеОтбора, ИмяТекущейПометки)
	
	Строки = Дерево.Строки.НайтиСтроки(Новый Структура(ИмяТекущейПометки, Истина), Истина);
	Если Строки.Количество() > 0 Тогда
		
		МассивГруппИ = Новый Массив;
		
		Для Каждого Строка Из Строки Цикл
			
			Если ЗначениеЗаполнено(Строка.Значение) И НЕ Строка.Значение.ЭтоГруппа Тогда
				
				Если ВыбраныВсеЭлементыГруппы(Строка, ИмяТекущейПометки) Тогда
					
					Если МассивГруппИ.Найти(Строка.Родитель.Значение) = Неопределено Тогда // Исключаем повторы.
						
						ПредставлениеОтбора = ПредставлениеОтбора + Строка.Родитель.Значение + "*, ";
						МассивГруппИ.Добавить(Строка.Родитель.Значение);
						
					КонецЕсли;
					
				Иначе
					
					ПредставлениеОтбора = ПредставлениеОтбора + ?(ЗначениеЗаполнено(Строка.Родитель.Значение), Строка(Строка.Родитель.Значение) + "/", "")
						+ Строка.Значение + ", ";
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция   ВыбраныВсеЭлементыГруппы(ТекущийЭлемент, ИмяТекущейПометки)
	
	Родитель = ТекущийЭлемент.Родитель;
	
	ВыбраныВсе = Истина;
	
	ПроверитьПодчиненныеЭлементыРекурсивно(Родитель.Строки, ВыбраныВсе, ИмяТекущейПометки);
	
	Возврат ВыбраныВсе;
	
КонецФункции

Процедура ПроверитьПодчиненныеЭлементыРекурсивно(Строки, ВыбраныВсе, ИмяТекущейПометки)
	
	Для Каждого Строка Из Строки Цикл
		
		Если Строка.Значение.ЭтоГруппа Тогда
			ПроверитьПодчиненныеЭлементыРекурсивно(Строка.Строки, ВыбраныВсе, ИмяТекущейПометки)
		Иначе
			ВыбраныВсе = Строка[ИмяТекущейПометки];
		КонецЕсли;
		
		Если НЕ ВыбраныВсе Тогда
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция   ПолучитьСтруктуруНастройки(Настройка) Экспорт
	
	СтруктураНастройки = Новый Структура;
	МассивВыбранныхМеток = Новый Массив;
	Для Каждого СтрокаВыбранныхМеток Из Настройка.ВыбранныеМетки Цикл
		
		СтруктураМетки = Новый Структура;
		СтруктураМетки.Вставить("Значение",			СтрокаВыбранныхМеток.Значение);
		СтруктураМетки.Вставить("ИспользоватьИ",	СтрокаВыбранныхМеток.ИспользоватьИ);
		СтруктураМетки.Вставить("ИспользоватьИЛИ",	СтрокаВыбранныхМеток.ИспользоватьИЛИ);
		СтруктураМетки.Вставить("ИспользоватьНЕ",	СтрокаВыбранныхМеток.ИспользоватьНЕ);
		
		МассивВыбранныхМеток.Добавить(СтруктураМетки);
		
	КонецЦикла;
	
	СтруктураНастройки.Вставить("ВыбранныеМетки", МассивВыбранныхМеток);
	СтруктураНастройки.Вставить("ВключаяНезаполненные", Настройка.ВключаяНезаполненные);
	
	Возврат СтруктураНастройки;
	
КонецФункции

Функция   ЭтоГруппа(Ссылка) Экспорт
	
	Возврат Ссылка.ЭтоГруппа;
	
КонецФункции

Функция   ПолучитьПредставлениеМеткиРекурсивно(Метка) Экспорт
	
	Представление = "";
	
	Если ЗначениеЗаполнено(Метка.Родитель) Тогда
		
		Представление = Представление + ПолучитьПредставлениеМеткиРекурсивно(Метка.Родитель);
		
	КонецЕсли;
	
	Представление = Представление + ?(ПустаяСтрока(Представление), "", "/") + Строка(Метка);
	
	Возврат Представление;
	
КонецФункции
