
&НаСервере
Процедура УстановитьСтатусНаСервере()

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатус(Команда)
ТекущийСтатус = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Документ);
Если НЕ ТекущийСтатус = Статус тогда 
	ВопросНаСменуСтатуса = Вопрос("Документ уже имеет статус """ + ТекущийСтатус + """, Вы действиетельно хотите его поменять?",
		РежимДиалогаВопрос.ДаНет); 
	Если ВопросНаСменуСтатуса = КодВозвратаДиалога.Да тогда 
		СтатусЗаписать();
	КонецЕсли;
Иначе
	Сообщить("Статус не изменен!",СтатусСообщения.Внимание);
КонецЕсли;
//УстановитьСтатусНаСервере();
Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.Документ;
	Статус   = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Документ);
	
КонецПроцедуры

&НаСервере
Процедура СтатусЗаписать()

	ЗаписьСтатуса = РегистрыСведений.СтатусыЗаявокНаАренду_ат.СоздатьНаборЗаписей();
	ЗаписьСтатуса.Отбор.Заявка.Установить(Документ);
		НаборЗаписей = ЗаписьСтатуса.Добавить();
		НаборЗаписей.Период = ТекущаяДата();
		НаборЗаписей.Заявка = Документ;
		НаборЗаписей.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		НаборЗаписей.Статус = Статус;
	ЗаписьСтатуса.Записать(ложь);
	//Закрыть();
	

КонецПроцедуры
