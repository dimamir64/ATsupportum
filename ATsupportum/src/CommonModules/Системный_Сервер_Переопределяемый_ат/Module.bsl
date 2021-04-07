
// Обёртки для кода зависящего от платформы, конфигурации-назначении, наличия в окружении БСП.


Функция   ТекущийПользователь() Экспорт
	
	Попытка
		Возврат Вычислить("Пользователи.АвторизованныйПользователь()");
	Исключение
		Попытка
			Возврат Вычислить("Пользователи.ТекущийПользователь()");
		Исключение
			Возврат Неопределено;
		КонецПопытки;
	КонецПопытки;
	
КонецФункции

// Важно:
// Изменение способа получения хеш-суммы допустимо только при начальном
// внедрении, т.к. разные способы вернут разные значения.
Функция   ПолучитьЧислокод(ИсходныеДанные) Экспорт
	
	//+ Использовать для версий платформы начиная с 8.3
	Хеш = Новый ХешированиеДанных(ХешФункция.CRC32);
	Хеш.Добавить(ИсходныеДанные);
	Возврат Хеш.ХешСумма;
	//- Использовать для версий платформы начиная с 8.3
	
	////+ Использовать для версий платформы ниже 8.3
	//Возврат Числа_КлиентСервер_ат.ПолучитьХешСумму(ИсходныеДанные);
	////- Использовать для версий платформы ниже 8.3

КонецФункции

Функция   ПолучитьЧислокодКоллекции(Коллекция) Экспорт
	
	ЧислокодКоллекции = 0;
	
	Для Каждого Элемент Из Коллекция Цикл
		
		Если Метаданные.Перечисления.Содержит(Элемент.Метаданные()) Тогда
			
			Перечисление = Элемент.Метаданные();
			СтрокаДляХеширования = Перечисление.ЗначенияПеречисления.Найти(Элемент).ПолноеИмя();
			
		Иначе
			
			СтрокаДляХеширования = Строка(Элемент.УникальныйИдентификатор());
			
		КонецЕсли;
		
		ЧислокодКоллекции = ЧислокодКоллекции + ПолучитьЧислокод(СтрокаДляХеширования);
		
	КонецЦикла;

	Возврат ЧислокодКоллекции;
	
КонецФункции
