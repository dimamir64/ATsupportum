
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контроль данных"
// 
// Первый автор - Вячеслав 'Mechanist' А. Павлов (с) с 2009 г.
//
//////////////////////////////////////////////////////////////////////////////// 

#Область ПрограммныйИнтерфейс

Функция   ИсточникИсключение(Источник, ПараметрКонтроля) Экспорт
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.Заявка_ат")
	 //ИЛИ ТипЗнч(Источник) = Тип("ДокументОбъект.Задание_ат") Тогда // Grig 08.12.2015 Закомментировал т.к. исключение противоречит Заявки 35-84-02-59
		Тогда	 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция   РеквизитИсточникаИсключение(Источник, ИзменяемыйРеквизит) Экспорт
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗаполнениеОбщихОбязательныхПолей(Источник) Экспорт
	
	ТекПользователь = Системный_Сервер_Переопределяемый_ат.ТекущийПользователь();
	
	Если ТекПользователь <> Неопределено
		И Метаданные_ат.СуществуетРеквизит(Источник, "Автор_ат")
		И НЕ ЗначениеЗаполнено(Источник.Автор)
		И НЕ РеквизитИсточникаИсключение(Источник, "Автор_ат") Тогда
		
		Источник.Автор_ат = ТекПользователь;
		
	КонецЕсли;
	
	Если ТекПользователь <> Неопределено
		И Метаданные_ат.СуществуетРеквизит(Источник, "Ответственный_ат")
		И НЕ РольДоступна("ПолныеПрава") Тогда
		
		Если (Источник.Ссылка.Пустая() И Источник.Ответственный_ат.Пустая()) // - устанавливаем для новых объектов
			 ИЛИ (НЕ Источник.Ссылка.Пустая() И НЕ Источник.Ссылка.Ответственный_ат = ТекПользователь) // - и для существующих, с учетом возможности снять ответственность с себя
             И НЕ РеквизитИсточникаИсключение(Источник, "Ответственный_ат") Тогда
			 
			 ОбщегоНазначения_КлиентСервер_ат.ПрисвоитьНеравное(Источник.Ответственный_ат, ТекПользователь);
			
		КонецЕсли;
		
	ИначеЕсли ТекПользователь <> Неопределено
		И Метаданные_ат.СуществуетРеквизит(Источник, "АвторИзменений_ат")
		И НЕ РольДоступна("ПолныеПрава") Тогда
		
		Если (Источник.Ссылка.Пустая() И Источник.АвторИзменений_ат.Пустая()) // - устанавливаем для новых объектов
			 ИЛИ (НЕ Источник.Ссылка.Пустая() И НЕ Источник.Ссылка.АвторИзменений_ат = ТекПользователь) // - и для существующих, с учетом возможности снять ответственность с себя
             И НЕ РеквизитИсточникаИсключение(Источник, "АвторИзменений_ат") Тогда
			 
			 ОбщегоНазначения_КлиентСервер_ат.ПрисвоитьНеравное(Источник.АвторИзменений_ат, ТекПользователь);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Метаданные_ат.СуществуетРеквизит(Источник, "ДатаИзменений_ат")
		И НЕ ЗначениеЗаполнено(Источник.ДатаИзменений_ат)
		И НЕ РеквизитИсточникаИсключение(Источник, "ДатаИзменений_ат")
		И НЕ РольДоступна("ПолныеПрава") Тогда
		
		Источник.ДатаИзменений_ат = ТекущаяДата();
		
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ФиксацияРабот_ат") Тогда
		
		Источник.Ответственный = Пользователи.ТекущийПользователь();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СправочникиПередЗаписью(Источник, Отказ) Экспорт

	Если ТипЗнч(Источник) = Тип("СправочникОбъект.Пользователи") Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.EmailПользователя);
		СтрокиКонтактнойИнформации = Источник.КонтактнаяИнформация.НайтиСтроки(ПараметрыОтбора);
		
		ЭлектроннаяПочтаУказана = Ложь;
		
		Для Каждого СтрокаКонтактнойИнформации Из СтрокиКонтактнойИнформации Цикл
			
			Если НЕ ПустаяСтрока(СтрокаКонтактнойИнформации.Представление) Тогда
				
				ЭлектроннаяПочтаУказана = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если НЕ ЭлектроннаяПочтаУказана Тогда
			
			Отказ = Истина;
			Сообщить("Запрещено создавать пользователей без указания адреса электронной почты");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если РольДоступна("ПолныеПрава") Тогда
		
		Отказ = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДокументыПередЗаписью(Источник, Отказ) Экспорт

	Если РольДоступна("ПолныеПрава") Тогда
		
		Отказ = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура БизнесПроцессыИЗадачиПередЗаписью(Источник, Отказ) Экспорт

	Если РольДоступна("ПолныеПрава") Тогда
		
		Отказ = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
