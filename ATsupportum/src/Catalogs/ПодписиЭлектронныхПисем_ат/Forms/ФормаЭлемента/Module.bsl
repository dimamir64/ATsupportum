/// Дописать
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекстHTML ="";
	СтруктураВложений = Новый Структура;
	
	ПолеHTMLподписи.ПолучитьHTML(ТекстHTML, СтруктураВложений);
	// Получим документ html его легче обрабатывать
	
	ДокументHTML = Взаимодействия.ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML);
	ТаблицаКартинок = Новый Соответствие();
	Для каждого Картинка из ДокументHTML.Картинки Цикл
		
		АтрибутИсточникКартинки = Картинка.Атрибуты.ПолучитьИменованныйЭлемент("src");
		НайденнаяСтрока = АтрибутИсточникКартинки.ТекстовоеСодержимое;//ТаблицаСоответствий.Найти(АтрибутИсточникКартинки.ТекстовоеСодержимое,"ИмяФайла");	
		
		Если НайденнаяСтрока <> Неопределено Тогда
			
			НовыйАтрибутКартинки = АтрибутИсточникКартинки.КлонироватьУзел(Ложь);
			НовыйАтрибутКартинки.ТекстовоеСодержимое = Строка("att"+АтрибутИсточникКартинки.ТекстовоеСодержимое);
			НовыйАтрибутКартинки.Значение  =  Строка("att"+АтрибутИсточникКартинки.ТекстовоеСодержимое);
			НовыйАтрибутКартинки.ЗначениеУзла  =  Строка("att"+АтрибутИсточникКартинки.ТекстовоеСодержимое);

			Картинка.Атрибуты.УстановитьИменованныйЭлемент(НовыйАтрибутКартинки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Вложение из СтруктураВложений Цикл
		КлючВложения = Вложение.Ключ;
		ЗначениеВложения = Вложение.Значение; 
		СтруктураВложений.Вставить("att"+КлючВложения,ЗначениеВложения);
		СтруктураВложений.Удалить(КлючВложения);
	КонецЦикла;
	
	  ТекстПослеЗаменыИменФайлов = Взаимодействия.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
	ПолеHTMLподписи.УстановитьHTML(ТекстПослеЗаменыИменФайлов,СтруктураВложений);
	
	//
	//НачПозИмяФайла = Найти(ТекстHTML, "<img src='");
	//КонПозИмяФайла = Найти(ТекстHTML, "<img src='");
	//
	
	ТекущийОбъект.ПодписьHTML = Новый ХранилищеЗначения(ПолеHTMLподписи, новый СжатиеДанных(9));

	Попытка
		ТекущийОбъект.Записать();
	Исключение
		Сообщить("Не удалось записать подпись в формате HTML");	
	КонецПопытки;	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РеквизитыФормы = РеквизитФормыВЗначение("Объект");
	ОбъектПодпись = РеквизитыФормы.ПодписьHTML; 
	ПолеHTMLподписи = ОбъектПодпись.получить();	
КонецПроцедуры
