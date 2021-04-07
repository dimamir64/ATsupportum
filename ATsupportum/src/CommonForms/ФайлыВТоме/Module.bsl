////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Том = Параметры.Том;
	
	// Определение доступных хранилищ файлов.
	ЗаполнитьИменаХранилищФайлов();
	
	Если ИменаХранилищФайлов.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не найдены хранилища файлов.'");
		
	ИначеЕсли ИменаХранилищФайлов.Количество() = 1 Тогда
		Элементы.ПредставлениеХранилищаФайлов.Видимость = Ложь;
	КонецЕсли;
	
	ИмяХранилищаФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщаяФорма.ФайлыВТоме.ОтборПоХранилищам", 
		Строка(Том.УникальныйИдентификатор()) );
	
	Если ИмяХранилищаФайлов = ""
	 ИЛИ ИменаХранилищФайлов.НайтиПоЗначению(ИмяХранилищаФайлов) = Неопределено Тогда
	
		ЭлементВерсииФайлов = ИменаХранилищФайлов.НайтиПоЗначению("ВерсииФайлов");
		
		Если ЭлементВерсииФайлов = Неопределено Тогда
			ИмяХранилищаФайлов = ИменаХранилищФайлов[0].Значение;
			ПредставлениеХранилищаФайлов = ИменаХранилищФайлов[0].Представление;
		Иначе
			ИмяХранилищаФайлов = ЭлементВерсииФайлов.Значение;
			ПредставлениеХранилищаФайлов = ЭлементВерсииФайлов.Представление;
		КонецЕсли;
	Иначе
		ПредставлениеХранилищаФайлов = ИменаХранилищФайлов.НайтиПоЗначению(ИмяХранилищаФайлов).Представление;
	КонецЕсли;
	
	НастроитьДинамическийСписок(ИмяХранилищаФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если СохранитьНастройкиОтбораХранилищ Тогда
		СохранитьНастройкиОтбора(Том, ИмяХранилищаФайлов);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПредставлениеХранилищаФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущееХранилище = ВыбратьИзСписка(ИменаХранилищФайлов,
	                                   Элементы.ПредставлениеХранилищаФайлов,
	                                   ИменаХранилищФайлов.НайтиПоЗначению(ИмяХранилищаФайлов));
	
	Если ТипЗнч(ТекущееХранилище) = Тип("ЭлементСпискаЗначений") Тогда
		
		ИмяХранилищаФайлов = ТекущееХранилище.Значение;
		ПредставлениеХранилищаФайлов = ТекущееХранилище.Представление;
		НастроитьДинамическийСписок(ИмяХранилищаФайлов);
		СохранитьНастройкиОтбораХранилищ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ФайлыВТомах

&НаКлиенте
Процедура ФайлыВТомахВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьКарточкуФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыВТомахПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуФайла();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура НастроитьДинамическийСписок(Знач ИмяХранилища)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ХранилищеФайлов.Ссылка КАК Ссылка,
	|	ХранилищеФайлов.ИндексКартинки КАК ИндексКартинки,
	|	ХранилищеФайлов.ПутьКФайлу КАК ПутьКФайлу,
	|	ХранилищеФайлов.Размер КАК Размер,
	|	ХранилищеФайлов.Автор КАК Автор,
	|	&ЭтоПрисоединенныеФайлы КАК ЭтоПрисоединенныеФайлы
	|ИЗ
	|	&ИмяСправочника КАК ХранилищеФайлов
	|ГДЕ
	|	ХранилищеФайлов.Том = &Том";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", "Справочник." + ИмяХранилища);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ЭтоПрисоединенныеФайлы", ?(
		ВРег(ИмяХранилища) = ВРег("ВерсииФайлов"), "ЛОЖЬ", "ИСТИНА"));
	
	ФайлыВТомах.ТекстЗапроса = ТекстЗапроса;
	ФайлыВТомах.Параметры.УстановитьЗначениеПараметра("Том", Том);
	ФайлыВТомах.ОсновнаяТаблица = "Справочник." + ИмяХранилища;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИменаХранилищФайлов()
	
	Для каждого Справочник Из Метаданные.Справочники Цикл
		
		Если Справочник.Имя = "ВерсииФайлов"
		 ИЛИ Прав(Справочник.Имя, 19) = "ПрисоединенныеФайлы" Тогда
			
			ИменаХранилищФайлов.Добавить(Справочник.Имя, Справочник.Синоним);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиОтбора(Том, ТекущиеНастройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ОбщаяФорма.ФайлыВТоме.ОтборПоХранилищам",
		Строка(Том.УникальныйИдентификатор()),
		ТекущиеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуФайла()
	
	ТекущиеДанные = Элементы.ФайлыВТомах.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоПрисоединенныеФайлы Тогда
		ПрисоединенныеФайлыКлиент.ОткрытьФормуПрисоединенногоФайла(ТекущиеДанные.Ссылка);
	Иначе
		ОткрытьЗначение(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры


