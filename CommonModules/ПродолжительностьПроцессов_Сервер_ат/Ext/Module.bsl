
Функция   ПолучитьРабочийДень(Дата, ПолучатьПредшествующие = Ложь) Экспорт
	
	НачальныеДаты = Новый Массив;
	НачальныеДаты.Добавить(НачалоДня(Дата));
	
	РабочийДень = КалендарныеГрафики.ПолучитьДатыРабочихДней(Константы.ОсновнойКалендарь_ат.Получить(),
		НачальныеДаты, ПолучатьПредшествующие).Получить(НачалоДня(Дата));
	
	Возврат РабочийДень;
	
КонецФункции

Функция   ПолучитьДлительность(ДатаНачала, ДатаОкончания) Экспорт
	
	Если НачалоДня(ДатаНачала) = НачалоДня(ДатаОкончания) Тогда Возврат 1 КонецЕсли;
	
	Возврат КалендарныеГрафики.ПолучитьРазностьДатПоКалендарю(Константы.ОсновнойКалендарь_ат.Получить(), ДатаНачала, ДатаОкончания);
	
КонецФункции

Функция   ПолучитьРазностьДат(ДатаНачала, ДатаОкончания) Экспорт
	
	РазностьВДнях = КалендарныеГрафики.ПолучитьРазностьДатПоКалендарю(Константы.ОсновнойКалендарь_ат.Получить(), ДатаНачала, ДатаОкончания);
	
	РазностьВДнях = РазностьВДнях - 1;
	Если НачалоДня(ДатаНачала) > НачалоДня(ДатаОкончания) Тогда
		РазностьВДнях = РазностьВДнях * -1;
	КонецЕсли;
	
	Возврат РазностьВДнях;
	
КонецФункции

Функция   ПолучитьДату(ДатаНачала, Длительность) Экспорт
	
	//ДлительностьДляРасчета = Длительность - 1;
	Возврат КалендарныеГрафики.ПолучитьДатуПоКалендарю(Константы.ОсновнойКалендарь_ат.Получить(), ДатаНачала, Длительность - 1);
	
КонецФункции

Функция   ПолучитьПорогиВыполнения(ДатаНачала, Длительность) Экспорт
	
	ДнейДоПорога1 = Цел(Длительность / 2);
	ДнейДоПорога2 = Окр(Длительность * 0.85);
	
	Если ДнейДоПорога1 = 0 Тогда
		Порог1 = ДатаНачала;
	Иначе	
		Порог1 = ПолучитьДату(ДатаНачала, ДнейДоПорога1);
	КонецЕсли;
	
	Порог2 = ПолучитьДату(ДатаНачала, ДнейДоПорога2);
	
	Возврат Новый Структура("Порог1, Порог2", Порог1, Порог2);
	
КонецФункции 

Функция   ПолучитьМинимальныйИнтервалВремени() Экспорт
	
	Возврат Константы.МинимальныйИнтервалВремени_ат.Получить();
	
КонецФункции

Функция   ПолучитьМинимальныйИнтервалДеятельности() Экспорт
	
	Возврат Константы.МинимальныйИнтервалДеятельности_ат.Получить();
	
КонецФункции

Функция   ВСпринте(ДатаНачала, ДатаОкончания) Экспорт
	
	Спринт = Константы.ДлительностьСпринта_ат.Получить();
	
	Если Спринт = Перечисления.ДлительностьСпринта_ат.ПустаяСсылка() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Спринт = Перечисления.ДлительностьСпринта_ат.Неделя Тогда
		ВСпринте = НачалоНедели(ДатаНачала) = НачалоНедели(ДатаОкончания);
	ИначеЕсли Спринт = Перечисления.ДлительностьСпринта_ат.ДвеНедели Тогда
		ВСпринте = НачалоНедели(ДатаНачала) = НачалоНедели(ДатаОкончания)
												ИЛИ НачалоНедели(ДатаНачала) = НачалоНедели(НачалоНедели(ДатаОкончания) - 1);
	ИначеЕсли Спринт = Перечисления.ДлительностьСпринта_ат.Месяц Тогда
		ВСпринте = НачалоМесяца(ДатаНачала) = НачалоМесяца(ДатаОкончания);
	КонецЕсли; 
	
	Возврат ВСпринте;
	
КонецФункции
