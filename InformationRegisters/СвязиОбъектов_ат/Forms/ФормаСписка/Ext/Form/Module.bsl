
&НаКлиенте
Процедура ОчиститьРегистр(Команда)
	
	УдалитьРС();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРС()
	
	НЗ = РегистрыСведений.СвязиОбъектов_ат.СоздатьНаборЗаписей();
	НЗ.Записать();
	
КонецПроцедуры