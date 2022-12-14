////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управление доступом".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет описания поставляемых профилей групп доступа и
// переопределяет параметры обновления профилей и групп доступа.
//
//  Для автоматической подготовки содержимого процедуры следует
// воспользоваться инструментами разработчика для подсистемы
// Управление доступом.
//
// Параметры:
//  ОписанияПрофилей    - Массив в который нужно добавить описания.
//                        Пустая структура должна быть получена при помощи функции
//                        УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа().
//
//  ПараметрыОбновления - Структура со свойствами:
//
//                        ОбновлятьИзмененныеПрофили - Булево (начальное значение Истина).
//
//                        ЗапретитьИзменениеПрофилей - Булево (начальное значение Истина),
//                        если установить Ложь, тогда поставляемые профили будут открываться
//                        в режиме ТолькоПросмотр.
//
//                        ОбновлятьГруппыДоступа - Булево (начальное значение Истина).
//
//                        ОбновлятьГруппыДоступаСУстаревшимиНастройками - Булево (начальное
//                        значение Ложь), если установить Истина, то настройки значений,
//                        сделанные администратором по виду доступа, который удален из
//                        профиля, будут удалены из группы доступа.
//
Процедура ЗаполнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт
	
	
КонецПроцедуры

// Заполняет свойства видов доступа, добавленных прикладным разработчиком
// в план видов характеристик ВидыДоступа, как предопределенные элементы.
//
// Параметры:
//  Свойства - Структура со свойствами,
//             описание которых см. в комментарии к функции
//             ПланыВидовХарактеристик.ВидыДоступа.СвойстваВидовДоступа().
//
Процедура ЗаполнитьСвойстваВидаДоступа(Знач Свойства) Экспорт
	
	
КонецПроцедуры

// Заполняет использование видов доступа, добавленных прикладным разработчиком
// в план видов характеристик ВидыДоступа, как предопределенные элементы.
//
// Параметры:
//  ВидДоступа    - ПланВидовХарактеристикСсылка.ВидыДоступа.
//  Использование - Булево (возвращаемое значение). Начальное значение Истина.
// 
Процедура ЗаполнитьИспользованиеВидаДоступа(Знач ВидДоступа, Использование) Экспорт
	
	
	
КонецПроцедуры

// Заполняет описания возможных прав, назначаемых по значениям доступа.
// 
// Параметры:
//  ВозможныеПрава - ТаблицаЗначений, содержащая поля,
//                   описание которых  см. в комментарии к функции
//                   РегистрыСведений.ПраваПоЗначениямДоступа.ВозможныеПрава().
//
Процедура ЗаполнитьВозможныеПраваПоЗначениямДоступа(Знач ВозможныеПрава) Экспорт
	
	
	
КонецПроцедуры

// Позволяет реализовать перезапись зависимых наборов значений доступа других объектов.
//
//  Вызывается из процедур:
// УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// УправлениеДоступомСлужебный.ЗаписатьЗависимыеНаборыЗначенийДоступа().
//
// Параметры:
//  Ссылка       - СправочникСсылка, ДокументСсылка, ... - ссылка на объект для которого
//                 записаны наборы значений доступа.
//
//  СсылкиНаЗависимыеОбъекты - Массив элементов типа СправочникСсылка, ДокументСсылка, ...
//                 Содержит ссылки на объекты с зависимыми наборами значений доступа
//                 Начальное значение - пустой массив.
//
Процедура ПриИзмененииНаборовЗначенийДоступа(Знач Ссылка, СсылкиНаЗависимыеОбъекты) Экспорт
	
	
КонецПроцедуры

// Заполняет зависимости прав доступа "подчиненного" объекта, например, задачи ЗадачаИсполнителя,
// от "ведущего" объекта, например,  бизнес-процесса Задание, которые отличаются от стандартных.
//
// Зависимости прав используются в стандартном шаблоне ограничения доступа для вида доступа "Объект":
// 1) стандартно при чтении "подчиненного" объекта
//    проверяется наличие права чтения "ведущего" объекта
//    и проверяется отсутствие ограничения чтения "ведущего" объекта;
// 2) стандартно при добавлении, изменении, удалении "подчиненного" объекта
//    проверяется наличие права изменения "ведущего" объекта
//    и проверяется отсутствие ограничения изменения "ведущего" объекта.
//
// Параметры:
//  Таблица      - РегистрСведенийНаборЗаписей.ЗависимостиПравДоступа.
//                 Допустимые значения ресурсов:
//                   "ПланыВидовХарактеристик.ВидыДоступа.ПравоЧтения",
//                   "ПланыВидовХарактеристик.ВидыДоступа.ПравоДобавления",
//                   "ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения".
//
//                 Если задано недопустимое значение, будет установлено значение по умолчанию:
//                 для права Чтение                         - ПланыВидовХарактеристик.ВидыДоступа.ПравоЧтения,
//                 для прав Добавление, Изменение, Удаление - ПланыВидовХарактеристик.ВидыДоступа.ПравоИзменения.
//                 
//                 Следует иметь в виду, что обычная "жесткость" условия ограничения доступа
//                 уменьшается в порядке "Добавление", "Изменение", "Чтение",
//                 Т.е. то, что можно добавить, можно и изменить и прочитать,
//                 соответственно, то что можно изменить можно и прочитать, но не наоборот.
//
Процедура ЗаполнитьЗависимостиПравДоступа(Знач Таблица) Экспорт
	
	
КонецПроцедуры

// Возвращает вид используемого интерфейса для настройки прав доступа.
//
//  Упрощенный интерфейс удобен для конфигураций с небольшим количеством пользователей,
// так как много функций не требуются и они могут быть скрыты (скрытие не может быть
// выполнено только лишь функциональной опцией, так как потребуется пересмотр
// содержимого групп доступа и профилей).
//
// Возвращаемое значение:
//  Булево
//
Функция УпрощенныйИнтерфейсНастройкиПравДоступа() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Заполняет состав видов доступа, используемых при ограничении прав объектов метаданных.
// Если состав видов доступа не заполнен, отчет "Права доступа" покажет некорректные сведения.
//
// Обязательно требуется заполнить только виды доступа, используемые
// в шаблонах ограничения доступа явно, а виды доступа, используемые
// в наборах значений доступа могут быть получены из текущего состояния
// регистра сведений НаборыЗначенийДоступа.
//
//  Для автоматической подготовки содержимого процедуры следует
// воспользоваться инструментами разработчика для подсистемы
// Управление доступом.
//
// Параметры:
//  Описание     - Строка, многострочная строка формата <Таблица>.<Право>.<ВидДоступа>[.Таблица объекта]
//                 Например, Документ.ПриходнаяНакладная.Чтение.Организации
//                           Документ.ПриходнаяНакладная.Чтение.Контрагенты
//                           Документ.ПриходнаяНакладная.Добавление.Организации
//                           Документ.ПриходнаяНакладная.Добавление.Контрагенты
//                           Документ.ПриходнаяНакладная.Изменение.Организации
//                           Документ.ПриходнаяНакладная.Изменение.Контрагенты
//                           Документ.ЭлектронныеПисьма.Чтение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Добавление.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Изменение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.Файлы.Чтение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Чтение.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Добавление.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Добавление.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Изменение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Изменение.Объект.Документ.ЭлектронноеПисьмо
//                 Вид доступа Объект предопределен, как литерал, его нет в предопределенных элементах
//                 ПланыВидовХарактеристик.ВидыДоступа. Этот вид доступа используется в шаблонах ограничений доступа,
//                 как "ссылка" на другой объект, по которому ограничивается таблица.
//                 Когда вид доступа "Объект" задан, также требуется задать типы таблиц, которые используются
//                 для этого вида доступа. Т.е. перечислить типы, которые соответствующие полю,
//                 использованному в шаблоне ограничения доступа в паре с видом доступа "Объект".
//                 При перечислении типов по виду доступа "Объект" нужно перечислить только те типы поля,
//                 которые есть у поля РегистрыСведений.НаборыЗначенийДоступа.Объект, остальные типы лишние.
// 
Процедура ЗаполнитьВидыОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	
КонецПроцедуры
