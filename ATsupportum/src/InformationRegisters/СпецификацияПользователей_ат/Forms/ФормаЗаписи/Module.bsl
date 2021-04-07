
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьНеобходимостьЗадаватьВопрос();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗадаватьВопрос И Запись.Основной И СуществуетОсновнаяЗаписьДляПользователя() Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОбУстановкиПризнакаОсновной", ЭтаФорма, Новый Структура);
		ПоказатьВопрос(ОписаниеОповещения, "Для пользователя уже существует основная запись.
											|Сделать основной текущую?", РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	УстановитьНеобходимостьЗадаватьВопрос();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьНеобходимостьЗадаватьВопрос();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	УстановитьНеобходимостьЗадаватьВопрос();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнойПриИзменении(Элемент)
	
	УстановитьНеобходимостьЗадаватьВопрос();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОбУстановкиПризнакаОсновной(Результат, ДополнительныеПараметры) Экспорт
	
	ЗадаватьВопрос = Ложь;
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		СнятьПризнакОсновнаяУЗаписей();
		Записать();
		
	Иначе
		
		Запись.Основной = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СнятьПризнакОсновнаяУЗаписей()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацияПользователей_ат.Пользователь,
	|	СпецификацияПользователей_ат.Контрагент,
	|	СпецификацияПользователей_ат.Подразделение
	|ИЗ
	|	РегистрСведений.СпецификацияПользователей_ат КАК СпецификацияПользователей_ат
	|ГДЕ
	|	СпецификацияПользователей_ат.Пользователь = &Пользователь
	|	И СпецификацияПользователей_ат.Основной
	|	И НЕ(СпецификацияПользователей_ат.Контрагент = &Контрагент
	|				И СпецификацияПользователей_ат.Подразделение = &Подразделение)";
	
	Запрос.УстановитьПараметр("Пользователь",	Запись.Пользователь);
	Запрос.УстановитьПараметр("Контрагент",		Запись.Контрагент);
	Запрос.УстановитьПараметр("Подразделение",	Запись.Подразделение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.СпецификацияПользователей_ат.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Пользователь.Установить(Выборка.Пользователь);
		НаборЗаписей.Отбор.Контрагент.Установить(Выборка.Контрагент);
		НаборЗаписей.Отбор.Подразделение.Установить(Выборка.Подразделение);
		
		НаборЗаписей.Прочитать();
		
		Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
			
			ЗаписьНабора.Основной = Ложь;
			
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СуществуетОсновнаяЗаписьДляПользователя()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК Индикатор
	|ИЗ
	|	РегистрСведений.СпецификацияПользователей_ат КАК СпецификацияПользователей_ат
	|ГДЕ
	|	СпецификацияПользователей_ат.Пользователь = &Пользователь
	|	И СпецификацияПользователей_ат.Основной
	|	И НЕ(СпецификацияПользователей_ат.Контрагент = &Контрагент
	|				И СпецификацияПользователей_ат.Подразделение = &Подразделение)";
	
	Запрос.УстановитьПараметр("Пользователь",	Запись.Пользователь);
	Запрос.УстановитьПараметр("Контрагент",		Запись.Контрагент);
	Запрос.УстановитьПараметр("Подразделение",	Запись.Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

&НаСервере
Процедура УстановитьНеобходимостьЗадаватьВопрос()
	
	Если Запись.Основной Тогда
		ЗадаватьВопрос = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	а= 1;
КонецПроцедуры
