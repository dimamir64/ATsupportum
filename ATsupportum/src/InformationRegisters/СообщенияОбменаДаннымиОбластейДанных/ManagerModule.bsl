#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СообщенияОбменаДаннымиОбластейДанных");
	
КонецПроцедуры

Процедура УдалитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "СообщенияОбменаДаннымиОбластейДанных");
	
КонецПроцедуры

#КонецЕсли