///////////////////////////////////////////////////////////////////////////////////
// ОчередьЗаданийПереопределяемый: Работа с неразделенными регламентными заданиями.
//
///////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Формирует список шаблонов заданий очереди.
//
// Параметры:
//  Шаблоны - Массив строк. В параметр следует добавить имена предопределенных
//   неразделенных регламентных заданий, которые должны использоваться в качестве
//   шаблонов для заданий очереди.
//
Процедура ПриПолученииСпискаШаблонов(Шаблоны) Экспорт
	
	
	
КонецПроцедуры

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий
//
// Параметры:
//  СоответствиеИменПсевдонимам - Соответствие
//   Ключ - Псевдоним метода, например ОчиститьОбластьДанных
//   Значение - Имя метода для вызова, например РаботаВМоделиСервиса.ОчиститьОбластьДанных
//    В качестве значения можно указать Неопределено, в этом случае считается что имя 
//    совпадает с псевдонимом
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	
	
КонецПроцедуры

// Заполняет соответствие методов обработчиков ошибок псевдонимам методов, при возникновении
// ошибок в которых они вызываются.
//
// Параметры:
//  ОбработчикиОшибок - Соответствие
//   Ключ - Псевдоним метода, например ОчиститьОбластьДанных
//   Значение - Имя метода - обработчика ошибок, для вызова при возникновении ошибки. 
//    Обработчик ошибок вызывается в случае завершения выполнения исходного задания
//    с ошибкой. Обработчик ошибок вызывается в той же области данных, что и исходное
//    задание.
//    Метод обработчика ошибок считается разрешенным к вызову механизмами очереди. 
//    Параметры обработчика ошибок:
//     ПараметрыЗадания - Структура - параметры задания очереди
//      Параметры
//      НомерПопытки
//      КоличествоПовторовПриАварийномЗавершении
//      ДатаНачалаПоследнегоЗапуска
//
Процедура ПриОпределенииОбработчиковОшибок(ОбработчикиОшибок) Экспорт
	
КонецПроцедуры

// Формирует таблицу регламентных заданий
// с признаком использования в модели сервиса
//
// Параметры:
// ТаблицаИспользования - ТаблицаЗначений - таблица, которую необходимо 
// заполнить регламентными заданиями и признаком использования, колонки:
//  РегламентноеЗадание - Строка - имя предопределенного регламентного задания
//  Использование - Булево - Истина, если регламентное задание должно
//   выполняться в модели сервиса. Ложь - если не должно.
//
Процедура ПриОпределенииИспользованияРегламентныхЗаданий(ТаблицаИспользования) Экспорт
	
	
	
КонецПроцедуры

// Устарело. Рекомендуется использовать ПриПолученииСпискаШаблонов().
//
Процедура ЗаполнитьСписокРазделенныхРегламентныхЗаданий(СписокРазделенныхРегламентныхЗаданий) Экспорт

	
	
КонецПроцедуры

// Устарело. Рекомендуется использовать ПриОпределенииПсевдонимовОбработчиков().
//
Процедура ПолучитьРазрешенныеМетодыОчередиЗаданий(Знач РазрешенныеМетоды) Экспорт
	
	
	
КонецПроцедуры
