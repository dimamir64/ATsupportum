////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТекущаяКодировка", ТекущаяКодировка);
	
	ПоказыватьТолькоОсновныеКодировки = Истина;
	ЗаполнитьСписокКодировок(Не ПоказыватьТолькоОсновныеКодировки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПоказыватьТолькоОсновныеКодировкиПриИзменении(Элемент)
	
	ЗаполнитьСписокКодировок(Не ПоказыватьТолькоОсновныеКодировки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокКодировок

&НаКлиенте
Процедура СписокКодировокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗакрытьФормуСВозвратомКодировки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	ЗакрытьФормуСВозвратомКодировки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗакрытьФормуСВозвратомКодировки()
	
	Представление = Элементы.СписокКодировок.ТекущиеДанные.Представление;
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Представление = Элементы.СписокКодировок.ТекущиеДанные.Значение;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("Значение", Элементы.СписокКодировок.ТекущиеДанные.Значение);
	РезультатВыбора.Вставить("Представление", Представление);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодировок(ПолныйСписок)
	
	ИдЭлемента = Неопределено;
	СписокКодировокЛокальный = Неопределено;
	СписокКодировок.Очистить();
	
	Если Не ПолныйСписок Тогда
		СписокКодировокЛокальный = РаботаСФайламиСлужебный.ПолучитьСписокКодировок();
	Иначе
		СписокКодировокЛокальный = ПолучитьПолныйСписокКодировок();
	КонецЕсли;
	
	Для Каждого Кодировка Из СписокКодировокЛокальный Цикл
		
		ЭлементСписка = СписокКодировок.Добавить(Кодировка.Значение, Кодировка.Представление);
		
		Если НРег(Кодировка.Значение) = НРег(ТекущаяКодировка) Тогда
			ИдЭлемента = ЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИдЭлемента <> Неопределено Тогда
		Элементы.СписокКодировок.ТекущаяСтрока = ИдЭлемента;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
//Функция возвращает таблицу имен кодировок
//
//Параметры
//  НЕТ
//
//Возвращаемое значение:
//  Таблица значений
//
Функция ПолучитьПолныйСписокКодировок()

	СписокКодировок = Новый СписокЗначений;
	
	СписокКодировок.Добавить("Adobe-Standard-Encoding");
	СписокКодировок.Добавить("Big5");
	СписокКодировок.Добавить("Big5-HKSCS");
	СписокКодировок.Добавить("BOCU-1");
	СписокКодировок.Добавить("CESU-8");
	СписокКодировок.Добавить("cp1006");
	СписокКодировок.Добавить("cp1025");
	СписокКодировок.Добавить("cp1097");
	СписокКодировок.Добавить("cp1098");
	СписокКодировок.Добавить("cp1112");
	СписокКодировок.Добавить("cp1122");
	СписокКодировок.Добавить("cp1123");
	СписокКодировок.Добавить("cp1124");
	СписокКодировок.Добавить("cp1125");
	СписокКодировок.Добавить("cp1131");
	СписокКодировок.Добавить("cp1386");
	СписокКодировок.Добавить("cp33722");
	СписокКодировок.Добавить("cp437");
	СписокКодировок.Добавить("cp737");
	СписокКодировок.Добавить("cp775");
	СписокКодировок.Добавить("cp850");
	СписокКодировок.Добавить("cp851");
	СписокКодировок.Добавить("cp852");
	СписокКодировок.Добавить("cp855");
	СписокКодировок.Добавить("cp856");
	СписокКодировок.Добавить("cp857");
	СписокКодировок.Добавить("cp858");
	СписокКодировок.Добавить("cp860");
	СписокКодировок.Добавить("cp861");
	СписокКодировок.Добавить("cp862");
	СписокКодировок.Добавить("cp863");
	СписокКодировок.Добавить("cp864");
	СписокКодировок.Добавить("cp865");
	СписокКодировок.Добавить("cp866",   "CP866 (Кириллица DOS)");
	СписокКодировок.Добавить("cp868");
	СписокКодировок.Добавить("cp869");
	СписокКодировок.Добавить("cp874");
	СписокКодировок.Добавить("cp875");
	СписокКодировок.Добавить("cp922");
	СписокКодировок.Добавить("cp930");
	СписокКодировок.Добавить("cp932");
	СписокКодировок.Добавить("cp933");
	СписокКодировок.Добавить("cp935");
	СписокКодировок.Добавить("cp937");
	СписокКодировок.Добавить("cp939");
	СписокКодировок.Добавить("cp949");
	СписокКодировок.Добавить("cp949c");
	СписокКодировок.Добавить("cp950");
	СписокКодировок.Добавить("cp964");
	СписокКодировок.Добавить("ebcdic-ar");
	СписокКодировок.Добавить("ebcdic-de");
	СписокКодировок.Добавить("ebcdic-dk");
	СписокКодировок.Добавить("ebcdic-he");
	СписокКодировок.Добавить("ebcdic-xml-us");
	СписокКодировок.Добавить("EUC-JP");
	СписокКодировок.Добавить("EUC-KR");
	СписокКодировок.Добавить("GB_2312-80");
	СписокКодировок.Добавить("gb18030");
	СписокКодировок.Добавить("GB2312");
	СписокКодировок.Добавить("GBK");
	СписокКодировок.Добавить("hp-roman8");
	СписокКодировок.Добавить("HZ-GB-2312");
	СписокКодировок.Добавить("IBM01140");
	СписокКодировок.Добавить("IBM01141");
	СписокКодировок.Добавить("IBM01142");
	СписокКодировок.Добавить("IBM01143");
	СписокКодировок.Добавить("IBM01144");
	СписокКодировок.Добавить("IBM01145");
	СписокКодировок.Добавить("IBM01146");
	СписокКодировок.Добавить("IBM01147");
	СписокКодировок.Добавить("IBM01148");
	СписокКодировок.Добавить("IBM01149");
	СписокКодировок.Добавить("IBM037");
	СписокКодировок.Добавить("IBM1026");
	СписокКодировок.Добавить("IBM1047");
	СписокКодировок.Добавить("ibm-1047_P100-1995,swaplfnl");
	СписокКодировок.Добавить("ibm-1129");
	СписокКодировок.Добавить("ibm-1130");
	СписокКодировок.Добавить("ibm-1132");
	СписокКодировок.Добавить("ibm-1133");
	СписокКодировок.Добавить("ibm-1137");
	СписокКодировок.Добавить("ibm-1140_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1142_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1143_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1144_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1145_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1146_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1147_P100-1997,swaplfnl ");
	СписокКодировок.Добавить("ibm-1148_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1149_P100-1997,swaplfnl");
	СписокКодировок.Добавить("ibm-1153");
	СписокКодировок.Добавить("ibm-1153_P100-1999,swaplfnl");
	СписокКодировок.Добавить("ibm-1154");
	СписокКодировок.Добавить("ibm-1155");
	СписокКодировок.Добавить("ibm-1156");
	СписокКодировок.Добавить("ibm-1157");
	СписокКодировок.Добавить("ibm-1158");
	СписокКодировок.Добавить("ibm-1160");
	СписокКодировок.Добавить("ibm-1162");
	СписокКодировок.Добавить("ibm-1164");
	СписокКодировок.Добавить("ibm-12712_P100-1998,swaplfnl");
	СписокКодировок.Добавить("ibm-1363");
	СписокКодировок.Добавить("ibm-1364");
	СписокКодировок.Добавить("ibm-1371");
	СписокКодировок.Добавить("ibm-1388");
	СписокКодировок.Добавить("ibm-1390");
	СписокКодировок.Добавить("ibm-1399");
	СписокКодировок.Добавить("ibm-16684");
	СписокКодировок.Добавить("ibm-16804_X110-1999,swaplfnl");
	СписокКодировок.Добавить("IBM278");
	СписокКодировок.Добавить("IBM280");
	СписокКодировок.Добавить("IBM284");
	СписокКодировок.Добавить("IBM285");
	СписокКодировок.Добавить("IBM290");
	СписокКодировок.Добавить("IBM297");
	СписокКодировок.Добавить("IBM367");
	СписокКодировок.Добавить("ibm-37_P100-1995,swaplfnl");
	СписокКодировок.Добавить("IBM420");
	СписокКодировок.Добавить("IBM424");
	СписокКодировок.Добавить("ibm-4899");
	СписокКодировок.Добавить("ibm-4909");
	СписокКодировок.Добавить("ibm-4971");
	СписокКодировок.Добавить("IBM500");
	СписокКодировок.Добавить("ibm-5123");
	СписокКодировок.Добавить("ibm-803");
	СписокКодировок.Добавить("ibm-8482");
	СписокКодировок.Добавить("ibm-867");
	СписокКодировок.Добавить("IBM870");
	СписокКодировок.Добавить("IBM871");
	СписокКодировок.Добавить("ibm-901");
	СписокКодировок.Добавить("ibm-902");
	СписокКодировок.Добавить("IBM918");
	СписокКодировок.Добавить("ibm-971");
	СписокКодировок.Добавить("IBM-Thai");
	СписокКодировок.Добавить("IMAP-mailbox-name");
	СписокКодировок.Добавить("ISO_2022,locale=ja,version=3");
	СписокКодировок.Добавить("ISO_2022,locale=ja,version=4");
	СписокКодировок.Добавить("ISO_2022,locale=ko,version=1");
	СписокКодировок.Добавить("ISO-2022-CN");
	СписокКодировок.Добавить("ISO-2022-CN-EXT");
	СписокКодировок.Добавить("ISO-2022-JP");
	СписокКодировок.Добавить("ISO-2022-JP-2");
	СписокКодировок.Добавить("ISO-2022-KR");
	СписокКодировок.Добавить("iso-8859-1",   "ISO-8859-1 (Западноевропейская ISO)");
	СписокКодировок.Добавить("iso-8859-13");
	СписокКодировок.Добавить("iso-8859-15");
	СписокКодировок.Добавить("iso-8859-2",   "ISO-8859-2 (Центральноевропейская ISO)");
	СписокКодировок.Добавить("iso-8859-3",   "ISO-8859-3 (Латиница 3 ISO)");
	СписокКодировок.Добавить("iso-8859-4",   "ISO-8859-4 (Балтийская ISO)");
	СписокКодировок.Добавить("iso-8859-5",   "ISO-8859-5 (Кириллица ISO)");
	СписокКодировок.Добавить("iso-8859-6");
	СписокКодировок.Добавить("iso-8859-7",   "ISO-8859-7 (Греческая ISO)");
	СписокКодировок.Добавить("iso-8859-8");
	СписокКодировок.Добавить("iso-8859-9",   "ISO-8859-9 (Турецкая ISO)");
	СписокКодировок.Добавить("JIS_Encoding");
	СписокКодировок.Добавить("koi8-r",       "KOI8-R (Кириллица KOI8-R)");
	СписокКодировок.Добавить("koi8-u",       "KOI8-U (Кириллица KOI8-U)");
	СписокКодировок.Добавить("KSC_5601");
	СписокКодировок.Добавить("LMBCS-1");
	СписокКодировок.Добавить("LMBCS-11");
	СписокКодировок.Добавить("LMBCS-16");
	СписокКодировок.Добавить("LMBCS-17");
	СписокКодировок.Добавить("LMBCS-18");
	СписокКодировок.Добавить("LMBCS-19");
	СписокКодировок.Добавить("LMBCS-2");
	СписокКодировок.Добавить("LMBCS-3");
	СписокКодировок.Добавить("LMBCS-4");
	СписокКодировок.Добавить("LMBCS-5");
	СписокКодировок.Добавить("LMBCS-6");
	СписокКодировок.Добавить("LMBCS-8");
	СписокКодировок.Добавить("macintosh");
	СписокКодировок.Добавить("SCSU");
	СписокКодировок.Добавить("Shift_JIS");
	СписокКодировок.Добавить("us-ascii",     "US-ASCII США");
	СписокКодировок.Добавить("UTF-16");
	СписокКодировок.Добавить("UTF16_OppositeEndian");
	СписокКодировок.Добавить("UTF16_PlatformEndian");
	СписокКодировок.Добавить("UTF-16BE");
	СписокКодировок.Добавить("UTF-16LE");
	СписокКодировок.Добавить("UTF-32");
	СписокКодировок.Добавить("UTF32_OppositeEndian");
	СписокКодировок.Добавить("UTF32_PlatformEndian");
	СписокКодировок.Добавить("UTF-32BE");
	СписокКодировок.Добавить("UTF-32LE");
	СписокКодировок.Добавить("UTF-7");
	СписокКодировок.Добавить("UTF-8",        "UTF-8 (Юникод UTF-8)");
	СписокКодировок.Добавить("windows-1250", "Windows-1250 (Центральноевропейская Windows)");
	СписокКодировок.Добавить("windows-1251", "Windows-1251 (Кириллица Windows)");
	СписокКодировок.Добавить("windows-1252", "Windows-1252 (Западноевропейская Windows)");
	СписокКодировок.Добавить("windows-1253", "Windows-1253 (Греческая Windows)");
	СписокКодировок.Добавить("windows-1254", "Windows-1254 (Турецкая Windows)");
	СписокКодировок.Добавить("windows-1255");
	СписокКодировок.Добавить("windows-1256");
	СписокКодировок.Добавить("windows-1257", "Windows-1257 (Балтийская Windows)");
	СписокКодировок.Добавить("windows-1258");
	СписокКодировок.Добавить("windows-57002");
	СписокКодировок.Добавить("windows-57003");
	СписокКодировок.Добавить("windows-57004");
	СписокКодировок.Добавить("windows-57005");
	СписокКодировок.Добавить("windows-57007");
	СписокКодировок.Добавить("windows-57008");
	СписокКодировок.Добавить("windows-57009");
	СписокКодировок.Добавить("windows-57010");
	СписокКодировок.Добавить("windows-57011");
	СписокКодировок.Добавить("windows-874");
	СписокКодировок.Добавить("windows-949");
	СписокКодировок.Добавить("windows-950");
	СписокКодировок.Добавить("x-mac-centraleurroman");
	СписокКодировок.Добавить("x-mac-cyrillic");
	СписокКодировок.Добавить("x-mac-greek");
	СписокКодировок.Добавить("x-mac-turkish");
	
	Возврат СписокКодировок;

КонецФункции
