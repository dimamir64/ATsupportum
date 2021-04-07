////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование ИБ".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняет обработчик ожидания старта автоматического резервного копирования
// в процессе работы пользователя, а также повторного оповещения после игнорировании первоначального.
//
Процедура ОбработчикДействийРезервногоКопирования() Экспорт 
	
	РезервноеКопированиеИБКлиент.ОбработчикОжиданияЗапуска();
	
КонецПроцедуры
