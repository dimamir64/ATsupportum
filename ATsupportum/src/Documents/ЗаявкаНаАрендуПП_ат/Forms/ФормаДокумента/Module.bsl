
&НаКлиенте
Процедура ОтправитьНаСогласование(Команда)
	
	Если ЗначениеЗаполнено(Объект.Клиент) и ЗначениеЗаполнено(Объект.Действие) и ЗначениеЗаполнено(Объект.Сотрудник)
		и ЗначениеЗаполнено(Объект.АрендуемыеПП) и НЕ Модифицированность тогда
		
		статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Объект.Ссылка);
		если статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении")
			или  статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании")
			или  статус = ПредопределенноеЗначение("Перечисление.ТипыСтатусовЗаявокНаАренду_ат.НаФинансовомСогласовании")
			тогда
			ДокСогласования = Аренда_ат.СоздатьСогласование(Объект.Ссылка);
			Если НЕ ДокСогласования = Неопределено тогда
				ОткрытьЗначение(ДокСогласования);
			Иначе
				Сообщить("Не получена ссылка на документ согласования"+ Символы.ПС + 
				"возможно документ согласования уже был создан ранее кем-то другим!", СтатусСообщения.ОченьВажное);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Сообщить("Нельзя отправить на согласование не сохраненный/измененный документ!", СтатусСообщения.ОченьВажное);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьМенюДействий()
	
	Элементы.ОтправитьНаСогласование.Видимость = ложь;
	
	Статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Объект.Ссылка);
	если (статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении
		или   статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании
		или   статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаФинансовомСогласовании)
		И 	  Объект.ПометкаУдаления = ложь тогда
		
		Элементы.ОтправитьНаСогласование.Видимость = истина;
		Элементы.Оплатить.Видимость 			   = ложь;
		Элементы.Отклонить.Видимость			   = Истина;
	ИначеЕсли статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты тогда
		Элементы.ОтправитьНаСогласование.Видимость = ложь;
		Элементы.Оплатить.Видимость 			   = Истина;
		Элементы.Отклонить.Видимость			   = ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если НЕ Объект.Сотрудник.Пустая() Тогда
		
		ПодразделениеПриИзменении_Сервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзменении_Сервер()
	
	Объект.Сотрудник = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	// управляем кнопкой "Заполнить". (видна только когда отказывается от аренды)
	Если ДействиеПриИзменениеНаСервере() тогда
		
		
		Элементы.Заполнить.Видимость = Истина;
	Иначе
		Элементы.Заполнить.Видимость = ложь;
	конецЕсли;
	ОбновитьИнтерфейс();	
КонецПроцедуры

&НаСервере
Функция   ДействиеПриИзменениеНаСервере()
	Если Объект.Действие = Перечисления.ДействиеПоЗаявкеНаАрендуПП_ат.ОтказПП тогда
		Возврат Истина;
	Иначе
		возврат ложь;
	конецЕсли;
	
КонецФункции // ДействиеПриИзменениеНаСервере()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПравоНаАдминистрированиеСерверов = РольДоступна("ОрганизацияАдминистраторСерверов_ат") ИЛИ РольДоступна("ПолныеПрава");
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		Если ПравоНаАдминистрированиеСерверов Тогда
			
			Элементы.Клиент.ТолькоПросмотр = Ложь;
			
		Иначе
			
			Объект.Сотрудник = ТекущийПользователь;
			Планирование_Сервер_ат.ПервичноеЗаполнениеСотрудникКлиентПодразделение(Объект.Сотрудник, Объект.Сотрудник, Объект.Клиент, Объект.Подразделение);
			
			Если НЕ Финансы_ат.ИмеетсяДоговорОпределённогоТипа(Объект.Клиент, Перечисления.ТипыДоговоров_ат.АрендаПрограммныхПродуктов) Тогда
				
				Сообщить("Отсутствует договор на аренду ПП");
				Отказ = Истина;
				Возврат;
				
			КонецЕсли;
			
			Элементы.Клиент.ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	Иначе
		
		ДоступностьМенюДействий();
		Если ПравоНаАдминистрированиеСерверов Тогда
			
			Элементы.ПринудительнаяСменаСтатуса.Видимость = Истина;
			
		Иначе
			
			Элементы.ПринудительнаяСменаСтатуса.Видимость = ложь;
			Если ВозвратСтатусаДокумента() Тогда
				ЭтаФорма.ТолькоПросмотр = Ложь; 
			Иначе
				ЭтаФорма.ТолькоПросмотр = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если РольДоступна("ПолныеПрава")
		ИЛИ РольДоступна("ОрганизацияМенеджерПроектов_ат")
		ИЛИ РольДоступна("ОрганизацияИсполнитель_ат") Тогда
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			
			Планирование_Сервер_ат.ПервичноеЗаполнениеСотрудникКлиентПодразделение(Объект.Сотрудник, Объект.Сотрудник, Объект.Клиент, Объект.Подразделение);
			
		КонецЕсли;
		
		Элементы.Клиент.КнопкаОчистки 			= Истина;
		Элементы.Подразделение.КнопкаОчистки 	= Истина;
		Элементы.Сотрудник.КнопкаОчистки 		= Истина;
		
	КонецЕсли;
	
	Если ПравоНаАдминистрированиеСерверов Тогда
		Элементы.Дополнительно.Видимость = Истина;
	Иначе
		Элементы.Дополнительно.Видимость = Ложь;
	КонецЕсли;
	
	Статус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Объект.ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстатками(Команда)
	ЗаполнитьОстаткамиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткамиНаСервере()
	//
	Если Объект.Клиент = Справочники.Контрагенты_ат.ПустаяСсылка() тогда
		сообщение = новый СообщениеПользователю;
		сообщение.УстановитьДанные(Объект);
		Сообщение.Поле =  "Клиент";
		сообщение.Текст = "не указан клиент! ";
		сообщение.Сообщить();
		
	Иначе
		
		Клиент = Объект.Клиент;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	АрендаПП_атОстатки.ПродуктДляАренды,
		|	АрендаПП_атОстатки.РесурсОстаток
		|ИЗ
		|	РегистрНакопления.АрендаПП_ат.Остатки КАК АрендаПП_атОстатки
		|ГДЕ
		|	АрендаПП_атОстатки.Клиент = &Клиент";
		
		Запрос.УстановитьПараметр("Клиент", Клиент);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Если РезультатЗапроса.Пустой()  тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "в резерве за вами ничего не числится!";
			Сообщение.Сообщить();
		Иначе
			
			Объект.АрендуемыеПП.Очистить();
			//Новый ТаблицаЗначений;
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				НоваяСтрока = Объект.АрендуемыеПП.Добавить();
				НоваяСтрока.ПоставкаПП = ВыборкаДетальныеЗаписи.ПродуктДляАренды;
				НоваяСтрока.Количество = - ВыборкаДетальныеЗаписи.РесурсОстаток;
				
			КонецЦикла;
			
			//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
		конецЕсли;
	конецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	КлиентПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура КлиентПриИзмененииНаСервере()
	
	Объект.АрендуемыеПП.Очистить();
	Объект.Подразделение = Неопределено;
	Объект.Сотрудник = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ТЧ = Объект.АрендуемыеПП;
	МаксИндекс = ТЧ.Количество()-1;
	
	Для Индекс =0 по МаксИндекс цикл
		Если ТЧ[Индекс].Количество = 0 или ПустаяСтрока(ТЧ[Индекс].Количество) Тогда
			
			Сообщение = новый СообщениеПользователю;
			Сообщение.Текст = "Требуется указать кол-во необходимых программных продуктов";
			ячейка = "Объект.АрендуемыеПП[" + Индекс + "].Количество"; 
			Сообщение.Поле = ячейка;
			Сообщение.Сообщить();
			парам1 = Истина;
			
		КонецЕсли;			
	КонецЦикла;
	
	Если Объект.Действие.Пустая() тогда
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Требуется выбрать необходимое действие";
		Сообщение.Поле = "Объект.Действие";
		Сообщение.Сообщить();
		парам2 = Истина;
	КонецЕсли;	
	Если парам1 = Истина или парам2 = Истина тогда
		отказ = Истина;
	КонецЕсли;
	// это есть в модуле и потому работать не будет!
	//Если ВозвратСтатусаДокумента() = ложь тогда
	//Если ПроверкаРолиПолныеПрава() = истина тогда
	//	
	//	ответ = Вопрос("Заявка  заблокирована статусом! Проигнорировать предупреждение и изменить?", РежимДиалогаВопрос.ДаНет);
	//	Если ответ = КодВозвратаДиалога.нет тогда
	//		отказ = Истина;
	//	Иначе 
	//		Отказ = ложь;
	//	КонецЕсли;
	//КонецЕсли;
	//		отказ = истина;
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция   ВозвратСтатусаДокумента()
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатусыЗаявокНаАренду_атСрезПоследних.Статус
	|ИЗ
	|	РегистрСведений.СтатусыЗаявокНаАренду_ат.СрезПоследних КАК СтатусыЗаявокНаАренду_атСрезПоследних
	|ГДЕ
	|	СтатусыЗаявокНаАренду_атСрезПоследних.Заявка = &Заявка";
	
	Запрос.УстановитьПараметр("Заявка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() тогда
		Возврат Истина;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении 
			или  ВыборкаДетальныеЗаписи.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании
			или  ВыборкаДетальныеЗаписи.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаФинансовомСогласовании
			тогда
			возврат Истина;
		Иначе
			возврат ложь;
		КонецЕсли;
		
	КонецЦикла;
КонецФункции

&НаСервере
Функция   ПроверкаРолиПолныеПрава()
	Если РольДоступна("ПолныеПрава") тогда
		Возврат Истина;
	Иначе
		Возврат ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		Планирование_Сервер_ат.ПервичноеЗаполнениеСотрудникКлиентПодразделение(Объект.Сотрудник, Объект.Сотрудник, Объект.Клиент, Объект.Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринудительнаяСменаСтатуса(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Документ",Объект.Ссылка);
	ОткрытьФорму("ОбщаяФорма.ФормаСменыСтатусаЗаявкиНаАренду_ат", ПараметрыФормы,,, ВариантОткрытияОкна.ОтдельноеОкно);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ДоступностьМенюДействий();
	ОбновитьИнтерфейс();
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

