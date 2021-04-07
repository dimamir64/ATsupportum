////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ФорматСохранения Из УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента() Цикл
		ВыбранныеФорматыСохранения.Добавить(ФорматСохранения.ТипФайлаТабличногоДокумента, Строка(ФорматСохранения.Ссылка), Ложь, ФорматСохранения.Картинка);
	КонецЦикла;
	
	СписокПолучателей = Параметры.Получатели;
	Если ТипЗнч(СписокПолучателей) = Тип("Строка") Тогда
		ЗаполнитьТаблицуПолучателейИзСтроки(СписокПолучателей);
	ИначеЕсли ТипЗнч(СписокПолучателей) = Тип("СписокЗначений") Тогда
		ЗаполнитьТаблицуПолучателейИзСпискаЗначений(СписокПолучателей);
	ИначеЕсли ТипЗнч(СписокПолучателей) = Тип("Массив") Тогда
		ЗаполнитьТаблицуПолучателейИзМассиваСтруктур(СписокПолучателей);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ФорматыСохраненияИзНастроек = Настройки["ВыбранныеФорматыСохранения"];
	Если ФорматыСохраненияИзНастроек <> Неопределено Тогда
		Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл 
			ФорматИзНастроек = ФорматыСохраненияИзНастроек.НайтиПоЗначению(ВыбранныйФормат.Значение);
			Если ФорматИзНастроек <> Неопределено Тогда
				ВыбранныйФормат.Пометка = ФорматИзНастроек.Пометка;
			КонецЕсли;
		КонецЦикла;
		Настройки.Удалить("ВыбранныеФорматыСохранения");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВыборФормата();
	СформироватьПредставлениеВыбранныхФорматов();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборФорматаВложений") Тогда
		
		Если ВыбранноеЗначение <> КодВозвратаДиалога.Отмена И ВыбранноеЗначение <> Неопределено Тогда
			УстановитьВыборФормата(ВыбранноеЗначение.ФорматыСохранения);
			УпаковатьВАрхив = ВыбранноеЗначение.УпаковатьВАрхив;
			СформироватьПредставлениеВыбранныхФорматов();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	РезультатВыбора = ВыбранныеНастройкиФормата();
	ОповеститьОВыборе(РезультатВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсехПолучателей(Команда)
	УстановитьВыборДляВсехПолучателей(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборДляВсех(Команда)
	УстановитьВыборДляВсехПолучателей(Ложь);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ФорматВложенийНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("НастройкиФормата", ВыбранныеНастройкиФормата());
	ОткрытьФорму("ОбщаяФорма.ВыборФорматаВложений", ПараметрыОткрытия, ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Получатели

&НаКлиенте
Процедура ПолучателиПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Выбран = Не Элементы.Получатели.ТекущиеДанные.Выбран;
	Для Каждого ВыделеннаяСтрока Из Элементы.Получатели.ВыделенныеСтроки Цикл
		Получатель = Получатели.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Получатель.Выбран = Выбран;
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьТаблицуПолучателейИзСтроки(Знач СписокПолучателей)
	
	СписокПолучателей = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(СписокПолучателей);
	
	Для Каждого Получатель Из СписокПолучателей Цикл
		НовыйПолучатель = Получатели.Добавить();
		НовыйПолучатель.Адрес = Получатель.Адрес;
		НовыйПолучатель.Представление = Получатель.Псевдоним;
		НовыйПолучатель.ПредставлениеАдреса = НовыйПолучатель.Адрес;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПолучателейИзСпискаЗначений(СписокПолучателей)
	
	Для Каждого Получатель Из СписокПолучателей Цикл
		НовыйПолучатель = Получатели.Добавить();
		НовыйПолучатель.Адрес = Получатель.Значение;
		НовыйПолучатель.Представление = Получатель.Представление;
		НовыйПолучатель.ПредставлениеАдреса = НовыйПолучатель.Адрес;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПолучателейИзМассиваСтруктур(СписокПолучателей)
	
	Для Каждого Получатель Из СписокПолучателей Цикл
		НовыйПолучатель = Получатели.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйПолучатель, Получатель);
		НовыйПолучатель.ПредставлениеАдреса = НовыйПолучатель.Адрес;
		Если Не ПустаяСтрока(Получатель.ВидПочтовогоАдреса) Тогда
			НовыйПолучатель.ПредставлениеАдреса = НовыйПолучатель.ПредставлениеАдреса + " (" + Получатель.ВидПочтовогоАдреса + ")";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыборФормата(Знач ФорматыСохранения = Неопределено)
	
	ЕстьВыбранныйФормат = Ложь;
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ФорматыСохранения <> Неопределено Тогда
			ВыбранныйФормат.Пометка = ФорматыСохранения.Найти(ВыбранныйФормат.Значение) <> Неопределено;
		КонецЕсли;
			
		Если ВыбранныйФормат.Пометка Тогда
			ЕстьВыбранныйФормат = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьВыбранныйФормат Тогда
		ВыбранныеФорматыСохранения[0].Пометка = Истина; // выбор по умолчанию - первый в списке
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеВыбранныхФорматов()
	
	ФорматВложений = "";
	КоличествоФорматов = 0;
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			Если Не ПустаяСтрока(ФорматВложений) Тогда
				ФорматВложений = ФорматВложений + ", ";
			КонецЕсли;
			ФорматВложений = ФорматВложений + ВыбранныйФормат.Представление;
			КоличествоФорматов = КоличествоФорматов + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеНастройкиФормата()
	
	ФорматыСохранения = Новый Массив;
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;	
	
	Результат = Новый Структура;
	Результат.Вставить("УпаковатьВАрхив", УпаковатьВАрхив);
	Результат.Вставить("ФорматыСохранения", ФорматыСохранения);
	Результат.Вставить("Получатели", ВыбранныеПолучатели());
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВыбранныеПолучатели()
	Результат = Новый Массив;
	Для Каждого ВыбранныйПолучатель Из Получатели Цикл
		Если ВыбранныйПолучатель.Выбран Тогда
			СтруктураПолучателя = Новый Структура("Адрес,Представление,ИсточникКонтактнойИнформации,ВидПочтовогоАдреса");
			ЗаполнитьЗначенияСвойств(СтруктураПолучателя, ВыбранныйПолучатель);
			Результат.Добавить(СтруктураПолучателя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция УстановитьВыборДляВсехПолучателей(Выбор)
	Для Каждого Получатель Из Получатели Цикл
		Получатель.Выбран = Выбор;
	КонецЦикла;
КонецФункции


