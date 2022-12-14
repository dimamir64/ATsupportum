
Функция   ПустоеСодержаниеHTML(ТекстHTML) Экспорт
	
	Если ПустаяСтрока(ТекстHTML) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	ДокументHTML = РаботаСHTML_КлиентСервер_ат.ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML);
	
	Возврат ПустаяСтрока(ДокументHTML.Тело.ТекстовоеСодержимое) И ДокументHTML.Картинки.Количество() = 0;
	
КонецФункции

Функция   ТекстЯвляетсяТекстомHTML(Текст) Экспорт
	
	ТекстЯвляетсяТекстомHTML = СтрНайти(НРег(Текст), "<html") > 0;
	
	Если НЕ ТекстЯвляетсяТекстомHTML Тогда
		
		Если СтрНайти(НРег(Текст), "<div") > 0 ИЛИ СтрНайти(НРег(Текст), "<p>") Тогда
			
			// Недохтмл!
			ТекстHTML = РаботаСHTML_КлиентСервер_ат.ПреобразоватьОбычныйТекстВHTML(РаботаСHTML_КлиентСервер_ат.ПолучитьОбычныйТекстИзHTML(ТекстHTML));
			
			ТекстЯвляетсяТекстомHTML = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТекстЯвляетсяТекстомHTML
	
КонецФункции

Функция   ОбъединитьТекстыHTML(ТекстHTML1, ТекстHTML2) Экспорт
	
	ДокументHTML1 = ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML1);
	ДокументHTML2 = ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML2);
	
	ОбъединитьДокументыHTML(ДокументHTML1, ДокументHTML2);
	
	Возврат ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML1);
	
КонецФункции

Функция   ОбъединитьДокументыHTML(ДокументHTML1, ДокументHTML2) Экспорт
	
	Для Каждого Элемент Из ДокументHTML2.Тело.ДочерниеУзлы Цикл
		
		НовыйЭлемент = ДокументHTML1.ИмпортироватьУзел(Элемент, Истина);
		ДокументHTML1.Тело.ДобавитьДочерний(НовыйЭлемент);
		
	КонецЦикла;
	
	Возврат ДокументHTML1;
	
КонецФункции

// Получает объект ДокументHTML из обычного текста (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  Текст  - Строка - текст из которого будет создан документ HTML
//
// Возвращаемое значение:
//   ДокументHTML   - созданный документ HTML
Функция   ПолучитьДокументHTMLИзОбычногоТекста(Текст) Экспорт
	
	ДокументHTML = Новый ДокументHTML;
	
	ЭлементТело = ДокументHTML.СоздатьЭлемент("body");
	ДокументHTML.Тело = ЭлементТело;
	
	ЭлементБлок = ДокументHTML.СоздатьЭлемент("p");
	ЭлементТело.ДобавитьДочерний(ЭлементБлок);
	
	КоличествоСтрок = СтрЧислоСтрок(Текст);
	Для Инд = 1 По КоличествоСтрок Цикл
		ДобавитьТекстовыйУзел(ЭлементБлок, СтрПолучитьСтроку(Текст, Инд), Ложь, ?(Инд = КоличествоСтрок, Ложь, Истина));
	КонецЦикла;
	
	Возврат ДокументHTML;
	
КонецФункции

// Получает текст HTML из объекта ДокументHTML (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  ДокументHTML  - ДокументHTML - документ, из которого будет извлекаться текст
//
// Возвращаемое значение:
//   Строка   - текст HTML
//
Функция   ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML) Экспорт
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML,ЗаписьHTML);
	Возврат ЗаписьHTML.Закрыть();
	
КонецФункции

// Получает обычный текст из текста HTML (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  ТекстHTML  - Строка - текст HTML
//
// Возвращаемое значение:
//   Строка   - обычный текст
//
Функция   ПолучитьОбычныйТекстИзHTML(ТекстHTML) Экспорт
	
	ФорматированныйДокумент = Новый ФорматированныйДокумент;
	ФорматированныйДокумент.УстановитьHTML(ТекстHTML, Новый Структура);
	Возврат ФорматированныйДокумент.ПолучитьТекст();
	
КонецФункции

// Получает объект ДокументHTML из текста HTML (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  ТекстHTML  - Строка - 
//
// Возвращаемое значение:
//   ДокументHTML   - созданный документ HTML
Функция   ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML,Кодировка = Неопределено) Экспорт
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	
	НовыйТекстHTML = ТекстHTML;
	ПозицияОткрытиеXML = Найти(НовыйТекстHTML,"<?xml");
	
	Если ПозицияОткрытиеXML > 0 Тогда
		
		ПозицияЗакрытиеXML = Найти(НовыйТекстHTML,"?>");
		Если ПозицияЗакрытиеXML > 0 Тогда
			
			НовыйТекстHTML = ЛЕВ(НовыйТекстHTML,ПозицияОткрытиеXML - 1) + ПРАВ(НовыйТекстHTML,СтрДлина(НовыйТекстHTML) - ПозицияЗакрытиеXML -1);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Кодировка = Неопределено Тогда
		ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	Иначе
		ЧтениеHTML.УстановитьСтроку(ТекстHTML, Кодировка);
	КонецЕсли;
	Возврат Построитель.Прочитать(ЧтениеHTML);
	
КонецФункции

// Добавляет текстовый узел в ДокументHTML (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  ЭлементРодитель  - ЭлементHTML - элемент,к которому будет добавлен дочерний элемент
//  Текст  - Строка - содержимое текстового узла
//  Атрибуты  - Соответствие - ключ содержит имя атрибута, значение текстовое содержимое
//
// Возвращаемое значение:
//   ЭлементHTML   - добавленный элемент
//
Процедура ДобавитьТекстовыйУзел(ЭлементРодитель, Текст, ВыделятьЖирным = Ложь, ДобавлятьПереносСтроки = Ложь) Экспорт
	
	ДокументВладелец = ЭлементРодитель.ДокументВладелец;
	
	ТекстовыйУзел = ДокументВладелец.СоздатьТекстовыйУзел(Текст);
	
	Если ВыделятьЖирным Тогда
		ЭлементЖирный = ДокументВладелец.СоздатьЭлемент("b");
		ЭлементЖирный.ДобавитьДочерний(ТекстовыйУзел);
		ЭлементРодитель.ДобавитьДочерний(ЭлементЖирный);
	Иначе
		
		ЭлементРодитель.ДобавитьДочерний(ТекстовыйУзел);
		
	КонецЕсли;
	
	Если ДобавлятьПереносСтроки Тогда
		ЭлементРодитель.ДобавитьДочерний(ДокументВладелец.СоздатьЭлемент("br"));
	КонецЕсли;
	
КонецПроцедуры

// Вставляет элемент HTML перед первым дочерним узлом элемента родителя (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  ЭлементРодитель  - ЭлементHTML - элемент,к которому будет добавлен дочерний элемент
//  ВставляемыйЭлемент  - ЭлементHTML - вставляемый элемент HTML
//  МассивДочернихЭлементовРодителя  - Массив - массив дочерних элементов родительского элемента
//
Процедура ВставитьЭлементHTMLПервымДочернимЭлементом(ЭлементРодитель,
		ВставляемыйЭлемент,
		МассивДочернихЭлементовРодителя) Экспорт
	
	Если МассивДочернихЭлементовРодителя.Количество() > 0 Тогда
		ЭлементРодитель.ВставитьПеред(ВставляемыйЭлемент, МассивДочернихЭлементовРодителя[0]);
	Иначе
		ЭлементРодитель.ДобавитьДочерний(ВставляемыйЭлемент);
	КонецЕсли;
	
КонецПроцедуры

// Получает массив дочерних узлов элемента HTML, содержащих HTML (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  Элемент  - ЭлементHTML
//
// Возвращаемое значение:
//   Массив   - массив дочерних узлов содержащих HTML
//
Функция   ПолучитьМассивДочернихУзловСодержащихHTML(Элемент) Экспорт
	
	МассивДочернихУзлов = Новый Массив;
	
	Для каждого ДочернийУзел Из Элемент.ДочерниеУзлы Цикл
		
		Если ТипЗнч(ДочернийУзел) = Тип("ЭлементБлокHTML") ИЛИ ТипЗнч(ДочернийУзел) = Тип("ЭлементHTML") Тогда
			
			МассивДочернихУзлов.Добавить(ДочернийУзел);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивДочернихУзлов;
	
КонецФункции

Функция   ПреобразоватьОбычныйТекстВHTML(Текст) Экспорт
	
	ДокументHTML = ПолучитьДокументHTMLИзОбычногоТекста(Текст);
	
	Возврат ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
	
КонецФункции // ПреобразоватьОбычныйТекстВHTML()

// Функция возвращает структуру из различных элементов строки URI
//
// Параметры:
//	НавигационнаяСсылка	- Строка, URI, который необходимо разобрать
//
// Возвращаемое значение:
//	Структура
//		Ссылка 		- Относительные ссылки ИБ дополняются до полных. Ссылки на файлы дополняются префиксом file:///
//						Для остальных типов - копия переданного параметра. 
//		Протокол 	- Строка, значение схемы URI (http, ftp, mailto и т.д.; e1c для ссылок ИБ не веб-клиента).
//						пустая строка в случае некорректного URI.
//		Тип			- Строка, ТОЛЬКО Для ссылок ИБ - следующий элемент пути после элемента "e1cib", идентифицирующего ссылку как ссылку ИБ.
//						Может быть "data" для ссылок на данные, "tmpstore" для ссылок временного хранилища и т.д. Не локализуется.
//						Для остальных ссылок - пустая строка.
//		Путь		- Строка, Для ссылок ИБ - Путь метаданных. Для остальных - содержимое URI между схемой и параметрами.
//		Параметры	- Структура - список переданных параметров, где ключ - имя параметра, а значение - его значение(строка)
//						ПустаяСтрока если параметров нет.
//		ЭтоСсылкаИБ - Булево, Истина если ссылка является ссылкой на объект ИБ.
Функция   СтруктураНавигационнойСсылки(Знач НавигационнаяСсылка) Экспорт
	
	Если ТипЗнч(НавигационнаяСсылка) <> Тип("Строка") Тогда Возврат Неопределено; КонецЕсли;
		
	Результат = Новый Структура("Ссылка, Протокол, Тип, Путь, Параметры, ЭтоСсылкаИБ", НавигационнаяСсылка,"", "", "", "", Ложь);
	
	ПодстрокиСсылки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(НавигационнаяСсылка, ":", Истина);
	
	Если ПодстрокиСсылки.Количество() > 1 Тогда
		Длина = СтрДлина(ПодстрокиСсылки[0]);
		Если Длина > 1  И Длина < 8 Тогда //Самый длинный - mailto, если больше, то это не протокол :)
			Результат.Протокол = НРег(ПодстрокиСсылки[0]);
			НавигационнаяСсылка = Сред(НавигационнаяСсылка,Длина+2);
			Пока СтрДлина(НавигационнаяСсылка) И Лев(НавигационнаяСсылка, 1) = "/"  Цикл
				НавигационнаяСсылка = Сред(НавигационнаяСсылка,2);
			КонецЦикла;
			Если Результат.Протокол = "file" или Результат.Протокол = "cid" Или Результат.Протокол = "data" Тогда
				Результат.Путь = НавигационнаяСсылка;
				НавигационнаяСсылка = "";
			КонецЕсли;	
		ИначеЕсли Длина = 1 Тогда  //считаем, что поймали букву диска, и это файловая ссылка без префикса протокола
			Результат.Протокол = "file";
			Результат.Путь = Результат.Ссылка;
			Результат.Ссылка = "file:///" + Результат.Ссылка;
			НавигационнаяСсылка = "";
		КонецЕсли;
		
	Иначе //протокола нет, возвращаем как есть
			//Возврат Результат;
	КонецЕсли;
		
	Если ПустаяСтрока(НавигационнаяСсылка) Тогда Возврат Результат; КонецЕсли;
	
	ПозицияРазделителя = Найти(НавигационнаяСсылка, "?");
		
	Если ПозицияРазделителя = 0 Тогда
		
		Результат.Путь = НавигационнаяСсылка;
		Результат.Параметры = "";
		
	Иначе
		Результат.Путь = Лев(НавигационнаяСсылка, ПозицияРазделителя - 1);
		сПараметры = Сред(НавигационнаяСсылка, ПозицияРазделителя + 1);
		ПодстрокиСсылки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(сПараметры, ",",Истина);
		Результат.Параметры = Новый Структура;
		Для Каждого Параметр Из ПодстрокиСсылки Цикл
			ПозицияРазделителя = Найти(Параметр, "=");
			Если ПозицияРазделителя = 0 Тогда
				Результат.Параметры.Вставить(Параметр, Истина);
			Иначе
				Результат.Параметры.Вставить(Лев(Параметр, ПозицияРазделителя - 1), Сред(Параметр, ПозицияРазделителя + 1)) ;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	//ищем ссылку базы
	Если Найти(Результат.Путь, "e1cib") > 0 Тогда
		ПодстрокиСсылки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Результат.Путь, "/",Истина);
		колво = ПодстрокиСсылки.Количество();
		Для инд = 0 по колво-1 Цикл 
			Если ПодстрокиСсылки[инд] = "e1cib"  и инд < колво-2 Тогда  //Как минимум долженбыть тип ссылки и путь метаданных. хотя...
				Результат.ЭтоСсылкаИБ = Истина;
				Результат.Тип = ПодстрокиСсылки[инд+1];
				Результат.Путь = ПодстрокиСсылки[инд+2];
				Если ПустаяСтрока(Результат.Протокол) Тогда
					Результат.Протокол = "e1c";
					Результат.Ссылка = ПолучитьНавигационнуюСсылкуИнформационнойБазы() + "/" + Результат.Ссылка;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ИмпортироватьДокументВЭлемент(Документ, Элемент, ДокументИмпорта) Экспорт
	
	//Namespaces 
	//AlexSyS:
	//Раскомменченное прокатывает, но бессмысленно т.к. похоже налету не применяется
	//Закомменченное падает, как и импорт элементов для xmlns:v, xmlns:o etc. 
	//Пока делем через попытку в цикле.
	// TODO: КАК БЛЯТЬ хотябы грамотно вырезать долбаные офисные расширенные теги???
	// Убил бы человека, пишущего письма в ворде...
	
	Если ДокументИмпорта.ЭлементДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Атрибут ИЗ ДокументИмпорта.ЭлементДокумента.Атрибуты Цикл
		Если НЕ Документ.ЭлементДокумента.ЕстьАтрибут(Атрибут.Имя) Тогда
			Документ.ЭлементДокумента.УстановитьАтрибут(Атрибут.Имя, Атрибут.Значение);
			//Документ.ЭлементДокумента.УстановитьСоответствиеПространстваИмен(Атрибут.Имя, Атрибут.Значение);
		КонецЕсли;
	КонецЦикла;
	
	//Стили. АХТУНГ: не знаю что будет, если стили будут переопределяться. (многократное цитирование?)
	Стили = ДокументИмпорта.ПолучитьЭлементыПоИмени("style");
	Если Стили.Количество() Тогда
		Элементы = Документ.ПолучитьЭлементыПоИмени("head");
		Если Элементы.Количество() Тогда
			Голова = Элементы[0];
		Иначе
			Голова = Документ.СоздатьЭлемент("head");
			Документ.ЭлементДокумента.ВставитьПеред(Голова, Документ.ЭлементДокумента.ПервыйДочерний);
		КонецЕсли;
		Для Каждого Стиль ИЗ Стили Цикл
			Попытка 
				Голова.ДобавитьДочерний(Документ.ИмпортироватьУзел(Стиль,Истина));
			Исключение
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	//BODY
	//Узлы = ДокументИмпорта.ЭлементДокумента.АдаптироватьУзел();
	Для Каждого ТекЭлемент Из ДокументИмпорта.Тело.ДочерниеУзлы Цикл
		Попытка
			НовыйЭлемент = Документ.ИмпортироватьУзел(ТекЭлемент,Истина);    
			Элемент.ДобавитьДочерний(НовыйЭлемент);    
		Исключение
			//Агли ХАК: пробуем преобразовать в текст, и вставить его
			//ТУДУ: Найти способ нормально очищать документ от невалидного контента!!!!!!
			//пока форматированный док рулит :(
			НовыйЭлемент = Документ.СоздатьЭлемент("p"); 
			Текст = РаботаСHTML_КлиентСервер_ат.ПолучитьОбычныйТекстИзHTML(
			РаботаСHTML_КлиентСервер_ат.ПолучитьТекстHTMLИзОбъектаДокументHTML(ТекЭлемент));
			НовыйЭлемент.ДобавитьДочерний(Документ.СоздатьТекстовыйУзел(Текст));
			Элемент.ДобавитьДочерний(НовыйЭлемент);    
			//Продолжить;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Создает атрибут элемента HTML и устанавливает его текстовое содержимое (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  ЭлементHTML  - ЭлементHTML - элемент для которого устанавливается атрибут
//  Имя  - Строка - имя атрибута HTML
//  ТекстовоеСодержимое  - Строка - текстовое содержимое атрибута
//
Процедура УстановитьАтрибутЭлементаHTML(ЭлементHTML,Имя,ТекстовоеСодержимое) Экспорт
	
	АтрибутHTML = ЭлементHTML.ДокументВладелец.СоздатьАтрибут(Имя);
	АтрибутHTML.ТекстовоеСодержимое = ТекстовоеСодержимое;
	ЭлементHTML.Атрибуты.УстановитьИменованныйЭлемент(АтрибутHTML);
	
КонецПроцедуры

// Добавляет дочерний элемент с атрибутами (!КОПИЯ из БСП.ОМ.Взаимодействия)
//
// Параметры
//  ЭлементРодитель  - ЭлементHTML - элемент,к которому будет добавлен дочерний элемент
//  Имя  - Строка - имя элемента HTML
//  Атрибуты  - Соответствие - ключ содержит имя атрибута, значение текстовое содержимое
//
// Возвращаемое значение:
//   ЭлементHTML   - добавленный элемент
//
Функция   ДобавитьЭлементСАтрибутами(ЭлементРодитель,Имя,Атрибуты) Экспорт
	
	ЭлементHTML = ЭлементРодитель.ДокументВладелец.СоздатьЭлемент(Имя);
	
	Для Каждого Атрибут Из Атрибуты Цикл
		
		УстановитьАтрибутЭлементаHTML(ЭлементHTML, Атрибут.Ключ, Атрибут.Значение);
		
	КонецЦикла;
	
	ЭлементРодитель.ДобавитьДочерний(ЭлементHTML);
	
	Возврат ЭлементHTML;
	
КонецФункции
