
#Область ПрограммныйИнтерфейс

// права

Функция   СотрудникОрганизации() Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.СотрудникОрганизации();
	
КонецФункции

Функция   СотрудникКлиента() Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.СотрудникКлиента();
	
КонецФункции

Функция   МенеджерПроектовИлиПолныеПрава() Экспорт // РазрешеноУправлениеПроектами
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.МенеджерПроектовИлиПолныеПрава();
	
КонецФункции

Функция   ДоступныФинансы() Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.ДоступныФинансы();
	
КонецФункции

Функция   ПолучитьСписокПользователейПоРоли(ИмяРоли) Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.ПолучитьСписокПользователейПоРоли(ИмяРоли);
	
КонецФункции

Функция   ПолучитьСписокПользователейПоНесколькимРолям(Роли) Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.ПолучитьСписокПользователейПоНесколькимРолям(Роли);
	
КонецФункции

Функция   ПользовательИмеетРоль(Пользователь, ИмяРоли) Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.ПользовательИмеетРоль(Пользователь, ИмяРоли);
	
КонецФункции

Функция   ПользователиИмеютРоль(Пользователи, ИмяРоли) Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.ПользователиИмеютРоль(Пользователи, ИмяРоли);
	
КонецФункции

Функция   ТекущийПользовательИмеетРольПолныеПрава() Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.ТекущийПользовательИмеетРольПолныеПрава();
	
КонецФункции

// системное

Функция   ПолучитьНаименованиеОрганизацииДляОтображения(Организация) Экспорт
	
	Возврат ВнутреннегоИспользования_ВызовСервера_ат.ПолучитьНаименованиеОрганизацииДляОтображения(Организация);
	
КонецФункции

#КонецОбласти 
