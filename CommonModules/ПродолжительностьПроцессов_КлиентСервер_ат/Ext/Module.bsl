
Функция   ПолучитьВремяДляХранения(Значение) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Число") Тогда
		Возврат 0;
	КонецЕсли;
	
	Часы = Цел(Значение);
	Минуты = (Значение - Часы) * 100;
	
	База = ПродолжительностьПроцессов_Сервер_ат.ПолучитьМинимальныйИнтервалВремени();
	
	Если Часы = 0 И Минуты <> 0 И Минуты < База Тогда
		Минуты = База;
	КонецЕсли;
	
	Возврат Числа_КлиентСервер_ат.ПривестиЧислоКБазе(Часы * 60 + Минуты, База);
	
КонецФункции

Функция   ПолучитьВремяДеятельностиДляХранения(Значение) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Число") Тогда
		Возврат 0;
	КонецЕсли;
	
	Часы = Цел(Значение);
	Минуты = (Значение - Часы) * 100;
	
	База = ПродолжительностьПроцессов_Сервер_ат.ПолучитьМинимальныйИнтервалДеятельности();
	
	Если Часы = 0 И Минуты <> 0 И Минуты < База Тогда
		Минуты = База;
	КонецЕсли;
	
	Возврат Числа_КлиентСервер_ат.ПривестиЧислоКБазе(Часы * 60 + Минуты, База);
	
КонецФункции

Функция   ПолучитьВремяДляОтображения(Значение) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Число") Тогда
		Возврат 0;
	КонецЕсли;
	
	Часы = Цел(Значение / 60);
	Минуты = (Значение - Часы * 60) / 100;
	
	Возврат Часы + Минуты;
	
КонецФункции

Функция   ПеревестиВремяДляХраненияВДесятичнуюСистему(Значение) Экспорт
	
	Если ТипЗнч(Значение) <> Тип("Число") Тогда
		Возврат 0;
	КонецЕсли;
	
	Часы = Цел(Значение / 60);
	Минуты = (Значение - Часы * 60) / 100;
	
	Возврат Часы + Минуты / 0.6;
	
КонецФункции
