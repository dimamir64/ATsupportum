#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик обновления информационной базы.
Процедура ПереместитьДанныеВНовыйРегистр() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.ПраваПоЗначениямДоступа КАК ПраваПоЗначениямДоступа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УдалитьПраваПоЗначениямДоступа.ЗначениеДоступа,
	|	УдалитьПраваПоЗначениямДоступа.Пользователь,
	|	УдалитьПраваПоЗначениямДоступа.Право,
	|	МАКСИМУМ(УдалитьПраваПоЗначениямДоступа.Запрещено) КАК Запрещено,
	|	МАКСИМУМ(УдалитьПраваПоЗначениямДоступа.РаспространяетсяВИерархии) КАК РаспространяетсяВИерархии
	|ИЗ
	|	РегистрСведений.УдалитьПраваПоЗначениямДоступа КАК УдалитьПраваПоЗначениямДоступа
	|
	|СГРУППИРОВАТЬ ПО
	|	УдалитьПраваПоЗначениямДоступа.ЗначениеДоступа,
	|	УдалитьПраваПоЗначениямДоступа.Пользователь,
	|	УдалитьПраваПоЗначениямДоступа.Право";
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПраваПоЗначениямДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УдалитьПраваПоЗначениямДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		
		Если РезультатыЗапроса[0].Пустой()
		   И НЕ РезультатыЗапроса[1].Пустой() Тогда
			
			НаборЗаписей = РегистрыСведений.ПраваПоЗначениямДоступа.СоздатьНаборЗаписей();
			НаборЗаписей.Загрузить(РезультатыЗапроса[1].Выгрузить());
			НаборЗаписей.Записать();
			
			НаборЗаписей = РегистрыСведений.УдалитьПраваПоЗначениямДоступа.СоздатьНаборЗаписей();
			НаборЗаписей.Записать();
			
			РегистрыСведений.ПраваПоЗначениямДоступа.ОбновитьВспомогательныеДанныеРегистра();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли