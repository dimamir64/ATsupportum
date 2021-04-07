////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов.
	//@comm
	//ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
		ЗапретРедактированияРеквизитовОбъектовКлиент.ЗаблокироватьРеквизиты(ЭтаФорма);
	КонецЕсли;
	
	ТекущийНаборСвойств = Параметры.ТекущийНаборСвойств;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ЭтоДополнительноеСведение.Доступность = Ложь;
		ПоказатьУточнениеНабора = Параметры.ПоказатьУточнениеНабора;
	Иначе
		Если ЗначениеЗаполнено(ТекущийНаборСвойств) Тогда
			Объект.НаборСвойств = ТекущийНаборСвойств;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ВладелецДополнительныхЗначений) Тогда
			Объект.ВладелецДополнительныхЗначений = Параметры.ВладелецДополнительныхЗначений;
		КонецЕсли;
		
		Если Параметры.ЭтоДополнительноеСведение <> Неопределено Тогда
			Объект.ЭтоДополнительноеСведение = Параметры.ЭтоДополнительноеСведение;
			
		ИначеЕсли НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Элементы.ЭтоДополнительноеСведение.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ЭтоДополнительноеСведение = ?(Объект.ЭтоДополнительноеСведение, 1, 0);
	
	ОбновитьСоставЭлементовФормы();
	
	Если Объект.МногострочноеПолеВвода > 0 Тогда
		МногострочноеПолеВвода = Истина;
		МногострочноеПолеВводаЧисло = Объект.МногострочноеПолеВвода;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы)
	   = ВРег("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.РазблокированиеРеквизитов") Тогда
		
		//@comm
		Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			ЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
		Иначе
			Возврат;
		КонецЕсли;
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(
			ЭтаФорма, ВыбранноеЗначение);
	
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
		Закрыть();
		
		// Открытие формы свойства.
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ВыбранноеЗначение);
		ПараметрыФормы.Вставить("ТекущийНаборСвойств", ТекущийНаборСвойств);
		
		ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта",
			ПараметрыФормы, ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	// Заполнение наименования по набору свойств
	// и проверка есть ли свойство с тем же наименованием.
	ТекстВопроса = НаименованиеУжеИспользуется(
		Объект.Заголовок, Объект.Ссылка, Объект.НаборСвойств, Объект.Наименование);
	
	Если ЗначениеЗаполнено(ТекстВопроса) Тогда
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ПродолжитьЗапись",            НСтр("ru = 'Продолжить запись'"));
		Кнопки.Добавить("ВернутьсяКВводуНаименования", НСтр("ru = 'Вернуться к вводу наименования'"));
		
		Ответ = Вопрос(ТекстВопроса, Кнопки, , "ВернутьсяКВводуНаименования");
		Если Ответ <> "ПродолжитьЗапись" Тогда
			Отказ = Истина;
			ТекущийЭлемент = Элементы.Заголовок;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(Объект.ТипЗначения) Тогда
		ТекущийОбъект.ДополнительныеЗначенияИспользуются = Истина;
	Иначе
		ТекущийОбъект.ДополнительныеЗначенияИспользуются = Ложь;
		ТекущийОбъект.ЗаголовокФормыЗначения = "";
		ТекущийОбъект.ЗаголовокФормыВыбораЗначения = "";
	КонецЕсли;
	
	Если Объект.ЭтоДополнительноеСведение
	 ИЛИ НЕ (    Объект.ТипЗначения.СодержитТип(Тип("Число" ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Дата"  ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Булево")) )Тогда
		
		ТекущийОбъект.ФорматСвойства = "";
	КонецЕсли;
	
	ТекущийОбъект.МногострочноеПолеВвода = 0;
	
	Если НЕ Объект.ЭтоДополнительноеСведение
	   И Объект.ТипЗначения.Типы().Количество() = 1
	   И Объект.ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		
		Если МногострочноеПолеВвода Тогда
			ТекущийОбъект.МногострочноеПолеВвода = МногострочноеПолеВводаЧисло;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущийОбъект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"))
	 ИЛИ ТекущийОбъект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
		
		ТекущийОбъект.ДополнительныеЗначенияИспользуются = Истина;
	Иначе
		ТекущийОбъект.ДополнительныеЗначенияИспользуются = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.НаборСвойств) Тогда
		ДобавитьВНабор = ТекущийОбъект.НаборСвойств;
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.НаборыДополнительныхРеквизитовИСведений");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ДобавитьВНабор);
		Блокировка.Заблокировать();
		ЗаблокироватьДанныеДляРедактирования(ДобавитьВНабор);
		
		ОбъектНаборСвойств = ДобавитьВНабор.ПолучитьОбъект();
		Если ТекущийОбъект.ЭтоДополнительноеСведение Тогда
			ТабличнаяЧасть = ОбъектНаборСвойств.ДополнительныеСведения;
		Иначе
			ТабличнаяЧасть = ОбъектНаборСвойств.ДополнительныеРеквизиты;
		КонецЕсли;
		НайденнаяСтрока = ТабличнаяЧасть.Найти(ТекущийОбъект.Ссылка, "Свойство");
		Если НайденнаяСтрока = Неопределено Тогда
			НоваяСтрока = ТабличнаяЧасть.Добавить();
			НоваяСтрока.Свойство = ТекущийОбъект.Ссылка;
			ОбъектНаборСвойств.Записать();
			ТекущийОбъект.ДополнительныеСвойства.Вставить("ИзмененныйНабор", ДобавитьВНабор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов.
	//@comm
	//ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
		ЗапретРедактированияРеквизитовОбъектовКлиент.ЗаблокироватьРеквизиты(ЭтаФорма);
	КонецЕсли;
	
	ОбновитьСоставЭлементовФормы();
	
	Если ТекущийОбъект.ДополнительныеСвойства.Свойство("ИзмененныйНабор") Тогда
		ПараметрыЗаписи.Вставить("ИзмененныйНабор", ТекущийОбъект.ДополнительныеСвойства.ИзмененныйНабор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ДополнительныеРеквизитыИСведения",
		Новый Структура("Ссылка", Объект.Ссылка), Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ИзмененныйНабор") Тогда
		
		Оповестить("Запись_НаборыДополнительныхРеквизитовИСведений",
			Новый Структура("Ссылка", ПараметрыЗаписи.ИзмененныйНабор), ПараметрыЗаписи.ИзмененныйНабор);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ЭтоДополнительноеСведениеПриИзменении(Элемент)
	
	Объект.ЭтоДополнительноеСведение = ЭтоДополнительноеСведение;
	
	ОбновитьСоставЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УточнениеСпискаЗначенийКомментарийНажатие(Элемент)
	
	Если ЗаписатьОбъект("ПереходКСпискуЗначений") Тогда
		Закрыть();
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПоказатьУточнениеНабора", Истина);
		ПараметрыФормы.Вставить("Ключ", Объект.ВладелецДополнительныхЗначений);
		ПараметрыФормы.Вставить("ТекущийНаборСвойств", ТекущийНаборСвойств);
		
		ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта",
			ПараметрыФормы, ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УточнениеНаборовКомментарийНажатие(Элемент)
	
	Если НЕ ЗаписатьОбъект("ПереходКСпискуЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныйНабор = Неопределено;
	
	Если СписокНаборов.Количество() > 1 Тогда
		ВыбранныйЭлемент = ВыбратьИзСписка(СписокНаборов, Элементы.УточнениеНаборовКомментарий);
		Если ВыбранныйЭлемент <> Неопределено Тогда
			ВыбранныйНабор = ВыбранныйЭлемент.Значение;
		КонецЕсли;
	Иначе
		ВыбранныйНабор = СписокНаборов[0].Значение;
	КонецЕсли;
	
	Если ВыбранныйНабор <> Неопределено Тогда
		Закрыть();
		
		ЗначениеВыбора = Новый Структура;
		ЗначениеВыбора.Вставить("Набор", ВыбранныйНабор);
		ЗначениеВыбора.Вставить("Свойство", Объект.Ссылка);
		ЗначениеВыбора.Вставить("ЭтоДополнительноеСведение", Объект.ЭтоДополнительноеСведение);
		ОповеститьОВыборе(ЗначениеВыбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	ТекстПредупреждения = "";
	ОбновитьСоставЭлементовФормы(ТекстПредупреждения);
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		Предупреждение(ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеЗначенияСВесомПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
	   И НЕ Объект.ДополнительныеЗначенияСВесом Тогда
		
		ТекстВопроса =
			НСтр("ru = 'Очистить введенные весовые коэффициенты?
			           |
			           |Данные будут записаны.'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("ОчиститьИЗаписать", НСтр("ru = 'Очистить и записать'"));
		Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
		Ответ = Вопрос(ТекстВопроса, Кнопки, , "ОчиститьИЗаписать");
		Если Ответ <> "ОчиститьИЗаписать" Тогда
			Объект.ДополнительныеЗначенияСВесом = Истина;
			Возврат;
		КонецЕсли;
		Попытка
			ОчиститьВведенныеВесовыеКоэффициенты();
		Исключение
			Объект.ДополнительныеЗначенияСВесом = Истина;
			ВызватьИсключение;
		КонецПопытки;
	Иначе
		Попытка
			Успех = ЗаписатьОбъект("ИзменениеИспользованияВеса");
		Исключение
			Объект.ДополнительныеЗначенияСВесом = Ложь;
			ВызватьИсключение;
		КонецПопытки;
		Если Не Успех Тогда
			Объект.ДополнительныеЗначенияСВесом = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Оповестить(
			"Изменение_ЗначениеХарактеризуетсяВесовымКоэффициентом",
			Объект.ДополнительныеЗначенияСВесом,
			Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МногострочноеПолеВводаЧислоПриИзменении(Элемент)
	
	МногострочноеПолеВвода = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		Объект.Комментарий,
		Модифицированность);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Значения

&НаКлиенте
Процедура ЗначенияПриИзменении(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		ИмяСобытия = "Запись_ЗначенияСвойствОбъектов";
	Иначе
		ИмяСобытия = "Запись_ЗначенияСвойствОбъектовИерархия";
	КонецЕсли;
	
	Оповестить(ИмяСобытия,
		Новый Структура("Ссылка", Элемент.ТекущиеДанные.Ссылка),
		Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если НЕ ЗаписатьОбъект("ПереходКСпискуЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		ИмяТаблицыЗначений = "Справочник.ЗначенияСвойствОбъектов";
	Иначе
		ИмяТаблицыЗначений = "Справочник.ЗначенияСвойствОбъектовИерархия";
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Родитель", Родитель);
	ЗначенияЗаполнения.Вставить("Владелец", Объект.Ссылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СкрытьВладельца", Истина);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если Группа Тогда
		ПараметрыФормы.Вставить("ЭтоГруппа", Истина);
		
		ОткрытьФорму(ИмяТаблицыЗначений + ".ФормаГруппы", ПараметрыФормы, Элементы.Значения);
	Иначе
		ПараметрыФормы.Вставить("ПоказатьВес", Объект.ДополнительныеЗначенияСВесом);
		
		Если Копирование Тогда
			ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Значения.ТекущаяСтрока);
		КонецЕсли;
		
		ОткрытьФорму(ИмяТаблицыЗначений + ".ФормаОбъекта", ПараметрыФормы, Элементы.Значения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элементы.ДополнительныеЗначения.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаписатьОбъект("ПереходКСпискуЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		ИмяТаблицыЗначений = "Справочник.ЗначенияСвойствОбъектов";
	Иначе
		ИмяТаблицыЗначений = "Справочник.ЗначенияСвойствОбъектовИерархия";
	КонецЕсли;
	
	Если Элементы.Значения.ТекущаяСтрока <> Неопределено Тогда
		// Открытие формы значения или группы значений.
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СкрытьВладельца", Истина);
		ПараметрыФормы.Вставить("ПоказатьВес", Объект.ДополнительныеЗначенияСВесом);
		ПараметрыФормы.Вставить("Ключ", Элементы.Значения.ТекущаяСтрока);
		
		ОткрытьФорму(ИмяТаблицыЗначений + ".ФормаОбъекта", ПараметрыФормы, Элементы.Значения);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура РедактироватьФорматЗначения(Команда)
	
	Конструктор = Новый КонструкторФорматнойСтроки(Объект.ФорматСвойства);
	
	Конструктор.ДоступныеТипы = Объект.ТипЗначения;
	
	Если Конструктор.ОткрытьМодально() Тогда
		Объект.ФорматСвойства = Конструктор.Текст;
		УстановитьЗаголовокКнопкиФормата(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УточнениеСпискаЗначенийИзменить(Команда)
	
	Если НЕ ЗаписатьОбъект("ИзменениеВидаРеквизита") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", ТекущийНаборСвойств);
	ПараметрыФормы.Вставить("НаборСвойств", Объект.НаборСвойств);
	ПараметрыФормы.Вставить("Свойство", Объект.Ссылка);
	ПараметрыФормы.Вставить("ВладелецДополнительныхЗначений", Объект.ВладелецДополнительныхЗначений);
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Объект.ЭтоДополнительноеСведение);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.ИзменениеНастройкиСвойства",
		ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УточнениеНаборовИзменить(Команда)
	
	Если НЕ ЗаписатьОбъект("ИзменениеВидаРеквизита") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", ТекущийНаборСвойств);
	ПараметрыФормы.Вставить("Свойство", Объект.Ссылка);
	ПараметрыФормы.Вставить("НаборСвойств", Объект.НаборСвойств);
	ПараметрыФормы.Вставить("ВладелецДополнительныхЗначений", Объект.ВладелецДополнительныхЗначений);
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Объект.ЭтоДополнительноеСведение);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.ИзменениеНастройкиСвойства",
		ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	//@comm
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
	Иначе
		Возврат;
	КонецЕсли;
	
	ЗаблокированныеРеквизиты = ЗапретРедактированияРеквизитовОбъектовКлиент.РеквизитыКромеНевидимых(ЭтаФорма);
	
	Если ЗаблокированныеРеквизиты.Количество() > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ссылка", Объект.Ссылка);
		ПараметрыФормы.Вставить("ЭтоДополнительныйРеквизит", Объект.ЭтоДополнительноеСведение);
		
		ОткрытьФорму(
			"ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.РазблокированиеРеквизитов",
			ПараметрыФормы,
			ЭтаФорма);
	Иначе
		ЗапретРедактированияРеквизитовОбъектовКлиент.ПредупреждениеВсеВидимыеРеквизитыРазблокированы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ЗаписатьОбъект(ВариантТекстаВопроса)
	
	Если НЕ Модифицированность Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ВариантТекстаВопроса = "ПереходКСпискуЗначений" Тогда
			ТекстВопроса =
				НСтр("ru = 'Переход к работе со списком значений
				           |возможен только после записи данных.
				           |
				           |Данные будут записаны.'");
		Иначе
			ТекстВопроса =
				НСтр("ru = 'Данные будут записаны.'")
		КонецЕсли;
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Записать", НСтр("ru = 'Записать'"));
		Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
		Ответ = Вопрос(ТекстВопроса, Кнопки, , "Записать");
		Если Ответ <> "Записать" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Записать();
	
КонецФункции

&НаСервере
Процедура ОбновитьСоставЭлементовФормы(ТекстПредупреждения = "")
	
	Заголовок = ПолучитьЗаголовок(Объект);
	
	Если НЕ Объект.ТипЗначения.СодержитТип(Тип("Число"))
	   И НЕ Объект.ТипЗначения.СодержитТип(Тип("Дата"))
	   И НЕ Объект.ТипЗначения.СодержитТип(Тип("Булево")) Тогда
		
		Объект.ФорматСвойства = "";
	КонецЕсли;
	
	УстановитьЗаголовокКнопкиФормата(ЭтаФорма);
	
	Если Объект.ЭтоДополнительноеСведение
	 ИЛИ НЕ (    Объект.ТипЗначения.СодержитТип(Тип("Число" ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Дата"  ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Булево")) )Тогда
		
		Элементы.РедактироватьФорматЗначения.Видимость = Ложь;
	Иначе
		Элементы.РедактироватьФорматЗначения.Видимость = Истина;
	КонецЕсли;
	
	Если НЕ Объект.ЭтоДополнительноеСведение
	   И Объект.ТипЗначения.Типы().Количество() = 1
	   И Объект.ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		
		Элементы.ГруппаМногострочность.Видимость = Истина;
	Иначе
		Элементы.ГруппаМногострочность.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ЭтоДополнительноеСведение Тогда
		Объект.ЗаполнятьОбязательно = Ложь;
		Элементы.ЗаполнятьОбязательно.Видимость = Ложь;
	Иначе
		Элементы.ЗаполнятьОбязательно.Видимость = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СтарыйТипЗначения = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Ссылка, "ТипЗначения");
	Иначе
		СтарыйТипЗначения = Новый ОписаниеТипов;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ВладелецДополнительныхЗначений) Тогда
		
		СвойстваВладельца = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
			Объект.ВладелецДополнительныхЗначений, "ТипЗначения, ДополнительныеЗначенияСВесом");
		
		Если СвойстваВладельца.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
			Объект.ТипЗначения = Новый ОписаниеТипов(
				Объект.ТипЗначения,
				"СправочникСсылка.ЗначенияСвойствОбъектовИерархия",
				"СправочникСсылка.ЗначенияСвойствОбъектов");
		Иначе
			Объект.ТипЗначения = Новый ОписаниеТипов(
				Объект.ТипЗначения,
				"СправочникСсылка.ЗначенияСвойствОбъектов",
				"СправочникСсылка.ЗначенияСвойствОбъектовИерархия");
		КонецЕсли;
		
		ВладелецЗначений = Объект.ВладелецДополнительныхЗначений;
		ЗначенияСВесом   = СвойстваВладельца.ДополнительныеЗначенияСВесом;
	Иначе
		// Проверка возможности удаления типа дополнительных значений.
		Если УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(СтарыйТипЗначения) Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Владелец", Объект.Ссылка);
			
			Если СтарыйТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
				Запрос.Текст =
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ИСТИНА КАК ЗначениеИстина
				|ИЗ
				|	Справочник.ЗначенияСвойствОбъектовИерархия КАК ЗначенияСвойствОбъектовИерархия
				|ГДЕ
				|	ЗначенияСвойствОбъектовИерархия.Владелец = &Владелец";
			Иначе
				Запрос.Текст =
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ИСТИНА КАК ЗначениеИстина
				|ИЗ
				|	Справочник.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
				|ГДЕ
				|	ЗначенияСвойствОбъектов.Владелец = &Владелец";
			КонецЕсли;
			
			Если НЕ Запрос.Выполнить().Пустой() Тогда
				
				Если СтарыйТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия"))
				   И НЕ Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
					
					ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Недопустимо удалять тип ""%1"",
						           |так как дополнительные значения уже введены.
						           |Сначала нужно удалить введенные дополнительные значения.
						           |
						           |Удаленный тип восстановлен.'"),
						Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) );
					
					Объект.ТипЗначения = Новый ОписаниеТипов(
						Объект.ТипЗначения,
						"СправочникСсылка.ЗначенияСвойствОбъектовИерархия",
						"СправочникСсылка.ЗначенияСвойствОбъектов");
				
				ИначеЕсли СтарыйТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"))
				        И НЕ Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
					
					ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Недопустимо удалять тип ""%1"",
						           |так как дополнительные значения уже введены.
						           |Сначала нужно удалить введенные дополнительные значения.
						           |
						           |Удаленный тип восстановлен.'"),
						Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) );
					
					Объект.ТипЗначения = Новый ОписаниеТипов(
						Объект.ТипЗначения,
						"СправочникСсылка.ЗначенияСвойствОбъектов",
						"СправочникСсылка.ЗначенияСвойствОбъектовИерархия");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		// Проверка, что установлено не более одного типа дополнительных значений.
		Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия"))
		   И Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
			
			Если НЕ СтарыйТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
				
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Недопустимо одновременно использовать типы значения
					           |""%1"" и
					           |""%2"".
					           |
					           |Второй тип удален.'"),
					Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")),
					Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) );
				
				// Удаление второго типа.
				Объект.ТипЗначения = Новый ОписаниеТипов(
					Объект.ТипЗначения,
					,
					"СправочникСсылка.ЗначенияСвойствОбъектовИерархия");
			Иначе
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Недопустимо одновременно использовать типы значения
					           |""%1"" и
					           |""%2"".
					           |
					           |Первый тип удален.'"),
					Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")),
					Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) );
				
				// Удаление первого типа.
				Объект.ТипЗначения = Новый ОписаниеТипов(
					Объект.ТипЗначения,
					,
					"СправочникСсылка.ЗначенияСвойствОбъектов");
			КонецЕсли;
		КонецЕсли;
		
		ВладелецЗначений = Объект.Ссылка;
		ЗначенияСВесом   = Объект.ДополнительныеЗначенияСВесом;
	КонецЕсли;
	
	Если УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(Объект.ТипЗначения) Тогда
		Элементы.ГруппаЗаголовкиФормЗначений.Видимость = Истина;
		Элементы.ДополнительныеЗначенияСВесом.Видимость = Истина;
		Элементы.ДополнительныеЗначения.Видимость = Истина;
	Иначе
		Элементы.ГруппаЗаголовкиФормЗначений.Видимость = Ложь;
		Элементы.ДополнительныеЗначенияСВесом.Видимость = Ложь;
		Элементы.ДополнительныеЗначения.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Значения.Шапка        = ЗначенияСВесом;
	Элементы.ЗначенияВес.Видимость = ЗначенияСВесом;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Значения, "Владелец", ВладелецЗначений, , , Истина);
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		Значения.ОсновнаяТаблица = "Справочник.ЗначенияСвойствОбъектов";
	Иначе
		Значения.ОсновнаяТаблица = "Справочник.ЗначенияСвойствОбъектовИерархия";
	КонецЕсли;
	
	// Отображение уточнений.
	
	Если НЕ ЗначениеЗаполнено(Объект.ВладелецДополнительныхЗначений) Тогда
		Элементы.УточнениеСпискаЗначений.Видимость = Ложь;
		Элементы.ДополнительныеЗначения.ТолькоПросмотр = Ложь;
		Элементы.ЗначенияКоманднаяПанельРедактирования.Видимость = Истина;
		Элементы.ЗначенияКонтекстноеМенюРедактирования.Видимость = Истина;
		Элементы.ДополнительныеЗначенияСВесом.Видимость = Истина;
	Иначе
		Элементы.УточнениеСпискаЗначений.Видимость = Истина;
		Элементы.ДополнительныеЗначения.ТолькоПросмотр = Истина;
		Элементы.ЗначенияКоманднаяПанельРедактирования.Видимость = Ложь;
		Элементы.ЗначенияКонтекстноеМенюРедактирования.Видимость = Ложь;
		Элементы.ДополнительныеЗначенияСВесом.Видимость = Ложь;
		
		Элементы.УточнениеСпискаЗначенийКомментарий.Гиперссылка = ЗначениеЗаполнено(Объект.Ссылка);
		Элементы.УточнениеСпискаЗначенийИзменить.Доступность    = ЗначениеЗаполнено(Объект.Ссылка);
		
		СвойстваВладельца = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
			Объект.ВладелецДополнительныхЗначений, "НаборСвойств, Заголовок, ЭтоДополнительноеСведение");
		
		Если СвойстваВладельца.ЭтоДополнительноеСведение <> Истина Тогда
			ШаблонУточнения = НСтр("ru = 'Список значений общий с реквизитом ""%1"" набора ""%2""'");
		Иначе
			ШаблонУточнения = НСтр("ru = 'Список значений общий со сведением ""%1"" набора ""%2""'");
		КонецЕсли;
		
		Элементы.УточнениеСпискаЗначенийКомментарий.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонУточнения, СвойстваВладельца.Заголовок, Строка(СвойстваВладельца.НаборСвойств)) + "  ";
	КонецЕсли;
	
	ОбновитьСписокНаборов();
	
	Если НЕ ПоказатьУточнениеНабора
	   И ЗначениеЗаполнено(Объект.НаборСвойств)
	   И СписокНаборов.Количество() < 2 Тогда
		
		Элементы.УточнениеНаборов.Видимость = Ложь;
	Иначе
		Элементы.УточнениеНаборов.Видимость = Истина;
		Элементы.УточнениеНаборовКомментарий.Гиперссылка =
			ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(ТекущийНаборСвойств);
		
		Элементы.УточнениеНаборовИзменить.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
		
		Если ЗначениеЗаполнено(Объект.НаборСвойств)
		   И СписокНаборов.Количество() < 2 Тогда
			
			Элементы.УточнениеНаборовИзменить.Видимость = Ложь;
		
		ИначеЕсли ЗначениеЗаполнено(ТекущийНаборСвойств) Тогда
			Элементы.УточнениеНаборовИзменить.Видимость = Истина;
		Иначе
			Элементы.УточнениеНаборовИзменить.Видимость = Ложь;
		КонецЕсли;
		
		Если СписокНаборов.Количество() > 0 Тогда
		
			Если ЗначениеЗаполнено(Объект.НаборСвойств)
			   И СписокНаборов.Количество() < 2 Тогда
				
				Если Объект.ЭтоДополнительноеСведение Тогда
					ШаблонУточнения = НСтр("ru = 'Сведение входит в набор: %1'");
				Иначе
					ШаблонУточнения = НСтр("ru = 'Реквизит входит в набор: %1'");
				КонецЕсли;
				ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонУточнения, СокрЛП(СписокНаборов[0].Представление));
			Иначе
				Если СписокНаборов.Количество() > 1 Тогда
					Если Объект.ЭтоДополнительноеСведение Тогда
						ШаблонУточнения = НСтр("ru = 'Общее сведение входит в %1 %2'");
					Иначе
						ШаблонУточнения = НСтр("ru = 'Общий реквизит входит в %1 %2'");
					КонецЕсли;
					
					СтрокаНаборы = СокрЛП(ЧислоПрописью(
						СписокНаборов.Количество(), "НД=Ложь", "набор,набора,наборов,м,,,,,0"));
					
					Пока Истина Цикл
						Позиция = Найти(СтрокаНаборы, " ");
						Если Позиция = 0 Тогда
							Прервать;
						КонецЕсли;
						СтрокаНаборы = СокрЛП(Сред(СтрокаНаборы, Позиция + 1));
					КонецЦикла;
					
					ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ШаблонУточнения, Формат(СписокНаборов.Количество(), "ЧГ="), СтрокаНаборы);
				Иначе
					Если Объект.ЭтоДополнительноеСведение Тогда
						ШаблонУточнения = НСтр("ru = 'Общее сведение входит в набор: %1'");
					Иначе
						ШаблонУточнения = НСтр("ru = 'Общий реквизит входит в набор: %1'");
					КонецЕсли;
					
					ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ШаблонУточнения, СокрЛП(СписокНаборов[0].Представление));
				КонецЕсли;
			КонецЕсли;
		Иначе
			Элементы.УточнениеНаборовКомментарий.Гиперссылка = Ложь;
			Элементы.УточнениеНаборовИзменить.Видимость = Ложь;
			
			Если ЗначениеЗаполнено(Объект.НаборСвойств) Тогда
				Если Объект.ЭтоДополнительноеСведение Тогда
					ТекстКомментария = НСтр("ru = 'Сведение не входит в набор'");
				Иначе
					ТекстКомментария = НСтр("ru = 'Реквизит не входит в набор'");
				КонецЕсли;
			Иначе
				Если Объект.ЭтоДополнительноеСведение Тогда
					ТекстКомментария = НСтр("ru = 'Общее сведение не входит в наборы'");
				Иначе
					ТекстКомментария = НСтр("ru = 'Общий реквизит не входит в наборы'");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.УточнениеНаборовКомментарий.Заголовок = ТекстКомментария + " ";
		
		Если Элементы.УточнениеНаборовКомментарий.Гиперссылка Тогда
			Элементы.УточнениеНаборовКомментарий.Подсказка = НСтр("ru = 'Переход к набору'");
		Иначе
			Элементы.УточнениеНаборовКомментарий.Подсказка = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьВведенныеВесовыеКоэффициенты()
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		ИмяТаблицыЗначений = "Справочник.ЗначенияСвойствОбъектов";
	Иначе
		ИмяТаблицыЗначений = "Справочник.ЗначенияСвойствОбъектовИерархия";
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицыЗначений);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТекущаяТаблица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗначенияСвойствОбъектов КАК ТекущаяТаблица
		|ГДЕ
		|	ТекущаяТаблица.Вес <> 0";
		Запрос.Текст = СтрЗаменить(Запрос.Текст , "Справочник.ЗначенияСвойствОбъектов", ИмяТаблицыЗначений);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗначениеОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗначениеОбъект.Вес = 0;
			ЗначениеОбъект.Записать();
		КонецЦикла;
		
		Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьСписокНаборов()
	
	СписокНаборов.Очистить();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДополнительныеРеквизиты.Ссылка КАК Набор,
		|	ДополнительныеРеквизиты.Ссылка.Наименование
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Свойство = &Свойство
		|	И НЕ ДополнительныеРеквизиты.Ссылка.ЭтоГруппа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДополнительныеСведения.Ссылка,
		|	ДополнительныеСведения.Ссылка.Наименование
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
		|ГДЕ
		|	ДополнительныеСведения.Свойство = &Свойство
		|	И НЕ ДополнительныеСведения.Ссылка.ЭтоГруппа");
		
		Запрос.УстановитьПараметр("Свойство", Объект.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				СписокНаборов.Добавить(Выборка.Набор, Выборка.Наименование + "         ");
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеУжеИспользуется(Знач Заголовок, Знач ТекущееСвойство, Знач НаборСвойств, НовоеНаименование)
	
	Если ЗначениеЗаполнено(НаборСвойств) Тогда
		НаименованиеНабора = ОбщегоНазначения.ПолучитьЗначениеРеквизита(НаборСвойств, "Наименование");
		НовоеНаименование = Заголовок + " (" + НаименованиеНабора + ")";
	Иначе
		НовоеНаименование = Заголовок;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Свойства.ЭтоДополнительноеСведение,
	|	Свойства.НаборСвойств
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК Свойства
	|ГДЕ
	|	Свойства.Наименование = &Наименование
	|	И Свойства.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",       ТекущееСвойство);
	Запрос.УстановитьПараметр("Наименование", НовоеНаименование);
	
	НачатьТранзакцию();
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.НаборСвойств) Тогда
		Если Выборка.ЭтоДополнительноеСведение Тогда
			ТекстВопроса = НСтр("ru = 'Существует дополнительное сведение с наименованием
			                          |""%1"".'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Существует дополнительный реквизит с наименованием
			                          |""%1"".'");
		КонецЕсли;
	Иначе
		Если Выборка.ЭтоДополнительноеСведение Тогда
			ТекстВопроса = НСтр("ru = 'Существует общее дополнительное сведение с наименованием
			                          |""%1"".'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Существует общий дополнительный реквизит с наименованием
			                          |""%1"".'");
		КонецЕсли;
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстВопроса + НСтр("ru ='
		                         |
		                         |Рекомендуется использовать другое наименование,
		                         |иначе программа может работать некорректно.'"),
		НовоеНаименование);
	
	Возврат ТекстВопроса;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЗаголовок(Объект)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если ЗначениеЗаполнено(Объект.НаборСвойств) Тогда
			Если Объект.ЭтоДополнительноеСведение Тогда
				Заголовок = Строка(Объект.Заголовок) + " " + НСтр("ru = '(Дополнительное сведение)'");
			Иначе
				Заголовок = Строка(Объект.Заголовок) + " " + НСтр("ru = '(Дополнительный реквизит)'");
			КонецЕсли;
		Иначе
			Если Объект.ЭтоДополнительноеСведение Тогда
				Заголовок = Строка(Объект.Заголовок) + " " + НСтр("ru = '(Общее дополнительное сведение)'");
			Иначе
				Заголовок = Строка(Объект.Заголовок) + " " + НСтр("ru = '(Общий дополнительный реквизит)'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(Объект.НаборСвойств) Тогда
			Если Объект.ЭтоДополнительноеСведение Тогда
				Заголовок = НСтр("ru = 'Дополнительное сведение (создание)'");
			Иначе
				Заголовок = НСтр("ru = 'Дополнительный реквизит (создание)'");
			КонецЕсли;
		Иначе
			Если Объект.ЭтоДополнительноеСведение Тогда
				Заголовок = НСтр("ru = 'Общее дополнительное сведение (создание)'");
			Иначе
				Заголовок = НСтр("ru = 'Общий дополнительный реквизит (создание)'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокКнопкиФормата(Форма)
	
	Если ПустаяСтрока(Форма.Объект.ФорматСвойства) Тогда
		ТекстЗаголовка = НСтр("ru = 'Формат по умолчанию'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Формат установлен'");
	КонецЕсли;
	
	Форма.Элементы.РедактироватьФорматЗначения.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры
