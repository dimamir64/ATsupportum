
&НаКлиенте
Процедура ДанныеПриИзменении(Элемент)
	ДанныеПриИзмененииНаСервере();
		//Объект.ДанныеВBase64 = ОбщиеКоманды_ат.КодBase64(Объект.Данные);
ОбновитьИнтерфейс();

КонецПроцедуры

//&НаСервере
&НаКлиенте
Процедура ДанныеПриИзмененииНаСервере()
Объект.ДанныеВBase64 = РаботаССерверамиСлужебный_ат.КодBase64(Объект.Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеВBase64ПриИзменении(Элемент)
	ДанныеВBase64ПриИзмененииНаСервере();

КонецПроцедуры

&НаСервере
Процедура ДанныеВBase64ПриИзмененииНаСервере()
	
	Данные = Base64Строка(Объект.ДанныеВBase64);
	
	
	
КонецПроцедуры


#Область старое


//&НаКлиенте
//Процедура Реквизит1ПриИзменении(Элемент)
//	
////	Реквизит1ПриИзмененииНаСервере(Реквизит1);
//	КодВозврата = 0;	
////	Каталог = "D:\1C\work";
//	ПутьКом = "D:\1c\";
//	СтрКом = "Perl " + ПутьКом + "Base64.pl -data=""" + Реквизит1 + " ";
//	Реквизит2 = Запустить(СтрКом);
//	ОбновитьИнтерфейс();
//	
//КонецПроцедуры

////	&НаКлиенте
//&НаСервере
//функция Запустить(Команда)
//		Шелл = Новый COMОбъект("WScript.Shell");
//		//запускаем консоль, далее очищаем экран и через конвеер 
//		//выводим содержимое каталога windows (через гл. переменную)
//  		//      СтрокаЗапуска = "cmd.exe /C cls|dir %windir%";
//		СтрокаЗапуска = "cmd.exe /C cls|" + Команда;

//		//можно вывести информацию системного окружения
//		//СтрокаЗапуска = "cmd.exe /C cls|set";
//		
//		Вывод = Шелл.Exec(СтрокаЗапуска);
//		СтрокаМаршрутов = "";
//		//пока не достигнут конец потока
//		Пока Не Вывод.StdOut.AtEndOfStream Цикл
//				СтрокаМаршрутов = СтрокаМаршрутов + Вывод.StdOut.Read(1);
//		КонецЦикла;
////      	Элементы.СтрокаВывода.ВыделенныйТекст = СтрокаМаршрутов;
////			Сообщить(СтрокаМаршрутов);
//		возврат(СтрокаМаршрутов);
//КонецФункции




//&НаКлиенте
//&НаСервере
//Процедура Реквизит1ПриИзмененииНаСервере(Реквизит1)
//	

////	
////	
////	// Тестовая Хрень
////	
////	//кодирование в base64 возможно только для двоичных данных, т.е.
////	// для файлов. по этому создадаи временный файлик, запишем в него нашу строку
////	//получим ее как двоичные данные. эти данные преобразуем в строку base64
////	//
////	КодВозврата = 0;	
////	//Каталог = КаталогВременныхФайлов();
////	
////	Каталог = "D:\1C\work";
////	ИмяФайла = Каталог + ?(Прав(Каталог, 1) = "\","", "\") + "КомандаСистемы.txt";
////	ИмяФайла2 = Каталог + ?(Прав(Каталог, 1) = "\","", "\") + "ЗапуститьПриложение.txt";

////	//ТекущаяУниверсальнаяДатаВМиллисекундах();
////	// строка команды
////	ПутьКом = "D:\1c\";
////	//ИмяФайла= "asd";
////	//	СтрКом = "Perl "+ ПутьКом+"Base64.pl -data=" + Реквизит1 + " > " + ИмяФайла;
////	СтрКом = "Perl " + ПутьКом + "Base64.pl -data=""" + Реквизит1 + " "; // + """ > " + ИмяФайла;
//	//ЗапуститьПриложение(СтрКом,"D:/1c",Истина);
//	////ЗапуститьПриложение(СтрКом,"C:\Users\Администратор\",Истина);
//	////ЗапуститьПриложение(СтрКом,,Истина,КодВозврата);
//	////ЗапуститьПриложение(константы.ПутьКPerl_ат.Получить()+"\"+СтрКом,константы.ПутьКPerl_ат.Получить(),Истина,КодВозврата);
//	//КомандаСистемы(СтрКом,ПутьКом); 
//	//Сообщить("выполняется команда КомандаСистемы(...)");
//	//Сообщить(СтрКом);
//	//Сообщить("имя файла с данными ");
//	//Сообщить(ИмяФайла);
//	//
//	//СтрКом = "Perl " + ПутьКом + "Base64.pl -data=""" + Реквизит1 + """ > " + ИмяФайла2;
//	//ЗапуститьПриложение(СтрКом,"D:/1c",Истина);
//	//Сообщить("выполняется команда ЗапуститьПриложение(...)");
//	//Сообщить(СтрКом);
//	//Сообщить("имя файла с данными ");
//	//Сообщить(ИмяФайла2);
//	
//	////	Файл = Новый Файл(ИмяФайла);
//	////	Если НЕ Файл.Существует() Тогда Возврат; 
//	////	КонецЕсли;
//	////	УдалитьФайлы(ИмяФайла);


//	//
//	//стр = ""; 		//создаем переменную с нулевым значением
//	//// i = 1;		// не требуется
//	//ДАТА ="";
//	//
//	//
//	//Для i = 1 по СтрДлина(Реквизит1) Цикл
//	//	стр = КодСимвола(Реквизит1,i);
//	//	Сообщить(стр);
//	//	ДАТА = ДАТА + стр;
//	//	
//	//	
//	//	//	i=i+1;
//	//	//	Сообщить("проблема?");
//	//	//	ФаилBase64 = Новый ЗаписьТекста(ИмяФайла,КодировкаТекста.UTF16,,,);
//	//	//	ФаилBase64.ЗаписатьСтроку(Реквизит1,ложь);
//	//	//	ФаилBase64.Закрыть();
//	//	//	Реквизит2 = Base64Строка(ИмяФайла);
//	//	//	УдалитьФайлы(ИмяФайла,);
//	//КонецЦикла;
//	//Сообщить(ДАТА);
//	//ФаилBase64 = Новый ТекстовыйДокумент;	
//	//ФаилBase64.ДобавитьСтроку(ДАТА);
//	//ФаилBase64 = Новый ЗаписьТекста(ИмяФайла,КодировкаТекста.UTF16);
//	//ФаилBase64.ЗаписатьСтроку(ДАТА);
//	//ФаилBase64.Закрыть();
//	//ФаилBase64.Записать(ИмяФайла,КодировкаТекста.UTF16);
//	//	
//	//Реквизит2 = Base64Строка(ИмяФайла);
//	//	УдалитьФайлы(ИмяФайла,);
//
//КонецПроцедуры
#КонецОбласти

