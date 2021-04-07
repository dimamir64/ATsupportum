
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеОбластейДанных.ПолучитьНастройкиРезервногоКопированияОбласти(
		РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиРезервногоКопирования);
	
	Для НомерМесяца = 1 По 12 Цикл
		Элементы.МесяцФормированияЕжегодныхКопий.СписокВыбора.Добавить(НомерМесяца, 
			Формат(Дата(2, НомерМесяца, 1), "ДФ=MMMM"));
	КонецЦикла;
	
	ЧасовойПояс = ЧасовойПоясСеанса();
	ЧасовойПоясОбласти = ЧасовойПояс + " (" + ПредставлениеЧасовогоПояса(ЧасовойПояс) + ")";
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Ответ = Вопрос(НСтр("ru = 'Настройки были изменены. Сохранить изменения?'"), 
			РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаписатьНастройкиРезервногоКопирования();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура УстановитьПоУмолчанию(Команда)
	
	УстановитьПоУмолчаниюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНастройкиРезервногоКопирования();
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьПоУмолчаниюНаСервере()
	
	НастройкиРезервногоКопирования = РезервноеКопированиеОбластейДанных.ПолучитьНастройкиРезервногоКопированияОбласти();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиРезервногоКопирования);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиРезервногоКопирования()

	СоответствиеНастроек = РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	
	НастройкиРезервногоКопирования = Новый Структура;
	Для Каждого КлючИЗначение Из СоответствиеНастроек Цикл
		НастройкиРезервногоКопирования.Вставить(КлючИЗначение.Значение, ЭтаФорма[КлючИЗначение.Значение]);
	КонецЦикла;
	
	РезервноеКопированиеОбластейДанных.УстановитьНастройкиРезервногоКопированияОбласти(
		РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), НастройкиРезервногоКопирования);
		
КонецПроцедуры
