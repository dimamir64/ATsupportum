////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокФайловВФорме();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокФайлов

&НаКлиенте
Процедура СписокФайловПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьКарточкуВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УдалитьИзЛокальногоКэшаФайловВыполнить();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайлов(Команда)
	УдалитьИзЛокальногоКэшаФайловВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Неопределено, Ссылка);
		РаботаСФайламиКлиент.ЗакончитьРедактирование(ДанныеФайла.Ссылка, УникальныйИдентификатор);
		ЗаполнитьСписокФайлов();
		ЗаполнитьСписокФайловВФорме();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	ОткрытьКарточкуВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВыполнить()
	МассивСсылок = Новый Массив;
	Для Каждого Элемент Из Элементы.СписокФайлов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокФайлов.ДанныеСтроки(Элемент);
		Ссылка = ДанныеСтроки.Версия;
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	Для Каждого Ссылка Из МассивСсылок Цикл
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Неопределено, Ссылка);
		
		// Проверяем возможность освобождения
		СтрокаОшибки = "";
		Если Не РаботаСФайламиСлужебныйКлиент.ВозможностьОсвободитьФайл(
					ДанныеФайла.Ссылка,
					ДанныеФайла.РедактируетТекущийПользователь,
					ДанныеФайла.Редактирует,
					СтрокаОшибки) Тогда
			
			Предупреждение(СтрокаОшибки);
			Продолжить;
		КонецЕсли;
		
		РаботаСФайламиСлужебныйКлиент.ОсвободитьФайл(ДанныеФайла.Ссылка);
	КонецЦикла;
	
	ЗаполнитьСписокФайлов();
	ЗаполнитьСписокФайловВФорме();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайлаВыполнить()
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Неопределено, Ссылка);
		РаботаСФайламиСлужебныйКлиент.КаталогФайла(ДанныеФайла);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаполнитьСписокФайловВФорме()
	
	РабочийКаталогПользователя = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	СписокФайлов.Очистить();
	
	Для Каждого Строка Из СписокЗначенийФайловВРегистре Цикл
		
		ПолныйПуть = РабочийКаталогПользователя + Строка.Значение.ЧастичныйПуть;
		Файл = Новый Файл(ПолныйПуть);
		Если Файл.Существует() Тогда
			НоваяСтрока = СписокФайлов.Добавить();
			НоваяСтрока.ДатаИзмененияФайла = МестноеВремя(Строка.Значение.ДатаМодификацииУниверсальная);
			НоваяСтрока.ИмяФайла           = Строка.Значение.ПолноеНаименование;
			НоваяСтрока.ИндексКартинки     = Строка.Значение.ИндексКартинки;
			НоваяСтрока.Размер             = Формат(Строка.Значение.Размер / 1024, "ЧЦ=10; ЧН=0"); // в КБ
			НоваяСтрока.Версия             = Строка.Значение.Ссылка;
			НоваяСтрока.Редактирует        = Строка.Значение.Редактирует;
			НоваяСтрока.НаРедактирование   = НЕ Строка.Значение.НаЧтение;
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПоСсылке(СсылкаДляУдаления)
	КоличествоЭлементов = СписокФайлов.Количество();
	
	Для Номер = 0 По КоличествоЭлементов - 1 Цикл
		Строка = СписокФайлов[Номер];
		Ссылка = Строка.Версия;
		Если Ссылка = СсылкаДляУдаления Тогда
			СписокФайлов.Удалить(Номер);
			Возврат;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокФайлов()
	
	СписокФайловВРегистре = РаботаСФайламиСлужебныйВызовСервера.СписокФайловВРегистре();
	СписокЗначенийФайловВРегистре.Очистить();
	
	Для Каждого Строка Из СписокФайловВРегистре Цикл
		СписокЗначенийФайловВРегистре.Добавить(Строка);
	КонецЦикла;	

КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайловВыполнить()
	
	Текст = НСтр("ru = 'Удалить выбранные файлы из основного рабочего каталога ?'");
	Ответ = Вопрос(Текст, РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;	
	
	МассивСсылок = Новый Массив;
	Для Каждого НомерЦикла Из Элементы.СписокФайлов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокФайлов.ДанныеСтроки(НомерЦикла);
		Ссылка = ДанныеСтроки.Версия;
		Если ДанныеСтроки.НаРедактирование = Ложь Тогда // Если не занят текущим пользователем
			МассивСсылок.Добавить(Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСсылок.Количество() = 0 Тогда
		Предупреждение(НСтр("ru = 'Нельзя удалять из основного рабочего каталога файлы,
		                          |занятые для редактирования.'"));
	КонецЕсли;	
	
	Для Каждого Ссылка Из МассивСсылок Цикл
		РаботаСФайламиСлужебныйКлиент.УдалитьФайлИзРабочегоКаталога(Ссылка);
		УдалитьПоСсылке(Ссылка);
	КонецЦикла;
	
	Элементы.СписокФайлов.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуВыполнить()
	
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Неопределено, Ссылка);
		ОткрытьЗначение(ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры
