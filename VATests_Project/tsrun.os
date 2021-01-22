Перем ПараметрыКоманднойСтроки;
// Перем БазовыйКаталогТестов;
// Перем ИмяНабораТестов;
Перем НастройкиНабора;
// Перем ПутьКТестовойБазе;
// Перем ВерсияПлатформы;
Перем ИмяФайлаПараметров;
// Перем БазовыйВременныйКаталог, ВременныйКаталогНабора, ВременныйКаталогТестов;
Перем Тесты;
Перем УровеньЛогирования;

// Преобразует параметры командной строки, передаваемой при запуске скрипта, в соответствие.
// Параметры командной строки передаются виде "--ИмяПараметра1 ЗначениеПараметра1 --ИмяПараметра2 --ИмяПараметра3 ЗначениеПараметра3....."
// Результат:
// Соответствие - соответствие с полями:
// * Ключ - Строка - имя параметра.
// * Значение - Строка,Булево - значение параметра, или Истина, если значение параметра отсутствует.
Функция ПараметрыКоманднойСтрокиВСоответствие()
	Результат = Новый Соответствие();
	ИмяПараметра = Неопределено;
	Для Каждого Аргумент Из АргументыКоманднойСтроки Цикл
		Если ИмяПараметра = Неопределено И СтрДлина(Аргумент) < 2  Тогда
			ВызватьИсключение "Неизвестный параметр " + ИмяПараметра;
		КонецЕсли;

		Если СтрНайти(Аргумент, "--") > 0 И ИмяПараметра <> Неопределено Тогда
			Результат.Вставить(ИмяПараметра, Истина);
			ИмяПараметра = Неопределено;
		КонецЕсли;

		Если ИмяПараметра <> Неопределено Тогда
			Результат.Вставить(ИмяПараметра, Аргумент);
			ИмяПараметра = Неопределено;
			Сообщить("Аргумент:" + Аргумент);
		Иначе
			ИмяПараметра = СтрЗаменить(Аргумент, "-", "");
			Сообщить(Символы.ПС + "Имя параметра:" + ИмяПараметра);
		КонецЕсли;
	КонецЦикла;
	ВывестиРазделительЛогирования();
	Если ИмяПараметра <> Неопределено Тогда
		Результат.Вставить(ИмяПараметра, Истина);
	КонецЕсли;
	Возврат Результат;
КонецФункции
// Разбирает параметры командной строки и записывает значения в структуру
// Параметры:
// ОбязательныеПараметрыСтрокой - Строка - обязательные параметры, разделенные запятыми, кототрые должны присутствовать
// 											в командной строке запуска. При их отсутствии выбрасывается исключение.
// Результат:
// Структура - структура со следующими ключами:
// БазовыйКаталогТестов - Строка - каталог тестов, из которого будут формироваться тесты для выполнения (исходный).
// ИмяНабораТестов - Строка - имя набора или группы наборов тестов для выполнения.
// ПутьКТестовойБазе - Строка - строка соединения с тестовой базой, как он задается в строке запуска 1С (/F.... или /S....).
// ВерсияПлатформы - Строка - полная версия платформы, которая будет использоваться для запуска тестов (например, 8.3.14.1579).
Функция РазобратьПараметрыЗапуска(ОбязательныеПараметрыСтрокой)
	
	ОбязательныеПараметры = СтрРазделить(ОбязательныеПараметрыСтрокой, ",", Ложь);
	ОбязательныеПараметрыУказаны = Истина;
	Для Каждого ИмяПараметра Из ОбязательныеПараметры Цикл
		Если ПараметрыКоманднойСтроки.Получить(ИмяПараметра) = Неопределено Тогда
			ОбязательныеПараметрыУказаны = Ложь;
			Сообщить("Не указан обязательный параметр  --" + ИмяПараметра);
		КонецЕсли;
	КонецЦикла;

	Если Не ОбязательныеПараметрыУказаны Тогда
		ВызватьИсключение "Ошибка при разборе параметров командной строки";
	КонецЕсли;

	Результат = Новый Структура();
	Результат.Вставить("БазовыйКаталогТестов", ПараметрыКоманднойСтроки["testspath"]);
	Результат.Вставить("ИмяНабораТестов", ПараметрыКоманднойСтроки["testsetname"]);
	Результат.Вставить("ПутьКТестовойБазе", ПараметрыКоманднойСтроки["ibconnection"]);
	Результат.Вставить("ВерсияПлатформы", ПараметрыКоманднойСтроки.Получить("v8version"));
	Возврат Результат;
КонецФункции

// Возвращает параметры, используемые для выполнения тестов. Эти параметры, в частности, используются
// для формирования файла VAParams.json
// Результат:
// Структура - структура параметров с полями:
// * Ключ - Строка - Имя параметра  (для замены в шаблоне VAParams.json. В шаблоны параметры указаны конструкцией: $ИмяПараметра$).
// * Значение - Строка - значение параметро (в файле VAParams.json оно будет подставлено вместо параметра).
Функция ПараметрыВыполнения(ПараметрыКоманднойСтроки)
	ПараметрыВыполнения = Новый Структура();

	ПараметрыЗапуска = РазобратьПараметрыЗапуска("testspath,testsetname,ibconnection,v8version");
	Для Каждого КлючИЗначения Из ПараметрыЗапуска Цикл
		ПараметрыВыполнения.Вставить(КлючИЗначения.Ключ, КлючИЗначения.Значение);
	КонецЦикла;

	ИмяНабораТестов = ПараметрыВыполнения.ИмяНабораТестов;

	КаталогВФ = КаталогВременныхФайлов();
	БазовыйВременныйКаталог = КаталогВФ + "VATests";
	ПараметрыВыполнения.Вставить("БазовыйВременныйКаталог", БазовыйВременныйКаталог);
	Сообщить(БазовыйВременныйКаталог);
	
	ВременныйКаталогНабора = БазовыйВременныйКаталог + "\" + ИмяНабораТестов;
	ПараметрыВыполнения.Вставить("ВременныйКаталогНабора", ВременныйКаталогНабора);
	ПараметрыВыполнения.Вставить("ВременныйКаталогТестов", ВременныйКаталогНабора + "\features");
	Сообщить(БазовыйВременныйКаталог);
	Сообщить(ИмяНабораТестов);
	
	КаталогНабора = БазовыйВременныйКаталог + "\" + ПараметрыВыполнения.ИмяНабораТестов;
	ПараметрыВыполнения.Вставить("КаталогНабора", КаталогНабора);

	КаталогРезультатовТестов = КаталогНабора + "\Results";
	ПараметрыВыполнения.Вставить("КаталогРезультатовТестов", КаталогРезультатовТестов);
	Сообщить("Каталог результатов: " + КаталогРезультатовТестов);

	КаталогЛогаОшибок = КаталогРезультатовТестов +	"\Log";
	ПараметрыВыполнения.Вставить("КаталогЛогаОшибок", КаталогЛогаОшибок);

	ПутьКОтчетамAllure = КаталогРезультатовТестов +	"\Allure";
	ПараметрыВыполнения.Вставить("ПутьКОтчетамAllure", ПутьКОтчетамAllure);

	ПутьКОтчетамCucumber = КаталогРезультатовТестов +	"\Cucumber";
	ПараметрыВыполнения.Вставить("ПутьКОтчетамCucumber", ПутьКОтчетамCucumber);

	ПутьКОтчетамJunit = КаталогРезультатовТестов +	"\JUnit";
	ПараметрыВыполнения.Вставить("ПутьКОтчетамJunit", ПутьКОтчетамJunit);

	КаталогСкриншотов = КаталогРезультатовТестов +	"\Screenshots";
	ПараметрыВыполнения.Вставить("КаталогСкриншотов", КаталогСкриншотов);
	
	Возврат ПараметрыВыполнения;
КонецФункции

// Создает каталог при отсутствии либо очищает сущствующий каталог.
// Параметры:
// ПутьККаталогу - Строка - полный путь к создаваемому каталогу
// Очищать - Булево - если Истина то каталог будет очищен, в случае его наличия
Процедура СоздатьКаталогПриОтсутствии(ПутьККаталогу, Очищать = Ложь)
	Каталог = Новый Файл(ПутьККаталогу);
	Если Не Каталог.Существует() Тогда
		СоздатьКаталог(ПутьККаталогу);
	Иначе
		Если Очищать Тогда
			УдалитьФайлы(ПутьККаталогу, "*");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура СоздатьОчиститьВременныеКаталоги(ПараметрыВыполнения)
	// КаталогВФ = КаталогВременныхФайлов();
	// БазовыйВременныйКаталог = КаталогВФ + "VATests";
	// Сообщить(БазовыйВременныйКаталог);
	// ВременныйКаталогНабора = БазовыйВременныйКаталог + "\" + ИмяНабораТестов;
	// ВременныйКаталогТестов = ВременныйКаталогНабора + "\features";

	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.БазовыйВременныйКаталог);
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.ВременныйКаталогНабора);	
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.ВременныйКаталогТестов, Истина);	
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.КаталогНабора, Ложь);
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.КаталогРезультатовТестов, Истина);
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.КаталогЛогаОшибок, Истина);
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.ПутьКОтчетамAllure, Истина);
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.ПутьКОтчетамCucumber, Истина);
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.ПутьКОтчетамJunit, Истина);
	СоздатьКаталогПриОтсутствии(ПараметрыВыполнения.КаталогСкриншотов, Истина);

КонецПроцедуры

// Загружает настройки набора из файла набора.
// Параметры:
// ПутьКФайлуНабора - Строка - Полный путь к файлу набора.
// Результат:
// Структура - структура с полями:
// * ЭтоТаблицаИсключаемыхТэгов - Булево - если Ложь то выполняются только те тесты, у каторых указан тэг из списка тэгов набора.
//										   если Истина - то тесты, в которых нет тэга из списка тэгов набора.
// * ИмяНабора - Строка - имя набора тестов.
// * ОписаниеНабора - Строка - описание набора тестов.
// * Тэги - Массив - массив имен тэгов набора (без символа @).
// * Пользователи - ТаблицаЗначений - таблица пользователей, от имени которых должны выполняться тесты. Таблица с полями:
// 	** НомерСтроки - Число - номер строки пользователя
//  ** ИмяПользователя - Строка - имя пользователя (как задано в базе для входа).
//  ** Пароль - Строка - пароль пользователя в базе.
//  ** ИсходныйНомерСтроки - Число - хз что это. Не используется.
Функция ЗагрузитьНастройкиНабора(ПутьКФайлуНабора)
	
	ФайлНастроек = Новый ЧтениеJSON();
	ФайлНастроек.ОткрытьФайл(ПутьКФайлуНабора, КодировкаТекста.UTF8);
	Настройки = ПрочитатьJSON(ФайлНастроек, Ложь);
	Тэги = Новый Массив();
	Для Каждого ИмяТэга Из Настройки.Тэги Цикл
		Тэги.Добавить(СокрЛП(НРег(ИмяТэга)));
	КонецЦикла;
	Настройки.Тэги = Тэги;

	Если УровеньЛогирования = УровеньЛогирования_Полный() Тогда
		Сообщить("Набор: " + Настройки.ИмяНабора);
		Сообщить("ЭтоТаблицаИсключаемыхТэгов:" + Настройки.ЭтоТаблицаИсключаемыхТегов);
		Сообщить("Тэги набора:");
		Для Каждого ИмяТэга Из Настройки.Тэги Цикл
			Сообщить(ИмяТэга);
		КонецЦикла;
		Сообщить(Символы.ПС);
		ВывестиРазделительЛогирования();
	КонецЕсли;
	Возврат Настройки;
КонецФункции

// Формирует общую таблицу списка тестов (см. ТаблицаТестов()). 
// Результирующая таблица упорядочена по порядку теста для выполнения.
Процедура СформироватьСписокТестов(ПараметрыВыполнения)
	СправочникиОписанияТестов = ОписанияСуществующихТестов(ВидОбъектаСправочники(), ПараметрыВыполнения);
	ДокументыОписанияТестов = ОписанияСуществующихТестов(ВидОбъектаДокументы(), ПараметрыВыполнения);
	ПрочиеТестыОписанияТестов = ОписанияСуществующихТестов(ПрочиеТесты(), ПараметрыВыполнения);
	
	ОписанияТестов = Новый Соответствие();
	
	ДополнитьСоответствие(ОписанияТестов, СправочникиОписанияТестов);
	ДополнитьСоответствие(ОписанияТестов, ДокументыОписанияТестов);
	ДополнитьСоответствие(ОписанияТестов, ПрочиеТестыОписанияТестов);
	ПутьКФайлуИнициализации = ПараметрыВыполнения.БазовыйКаталогТестов + "\" + ИмяФайлаОписанияТестов();
	ОбновитьОписанияТестовИзФайлаИнициализации(ПутьКФайлуИнициализации, ОписанияТестов);

	Тесты.Очистить();
 
	Для Каждого ОписаниеТестаКлючИЗначение Из ОписанияТестов Цикл
		НовыйТест = Тесты.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйТест, ОписаниеТестаКлючИЗначение.Значение);
	КонецЦикла;
	Тесты.Сортировать("Порядок Возр");
КонецПроцедуры

Процедура ДополнитьСоответствие(Приемник, Источник)
	
	Для Каждого Элемент Из Источник Цикл
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает описание существующих тестов указанного вида объекта (см. ВидОбъектаСправочники(), ВидОбъектаДокументы(), ПрочиеТесты())
// Возвращаемое значение:
// Соответствие - соответствие с полями:
// * Ключ - Строка - строка - уникальный идентификатор теста ("ВидОбъекта + "\" + ИмяОбъекта").
// * Значение - Структура - структура с полями:
// ** ВидОбъекта - Строка - вид объекта
// ** ИмяОбъекта - Строка - имя объекта
// ** Порядок - Число - порядок. Если порядок задан в файле инициализации - то берется порядок из файла, иначе - 5000.
Функция ОписанияСуществующихТестов(ВидОбъекта, ПараметрыВыполнения)
	БазовыйКаталогТестов = ПараметрыВыполнения.БазовыйКаталогТестов;	
	Если ВидОбъекта = ПрочиеТесты() Тогда
		КаталогТестовДляОписания = БазовыйКаталогТестов + "\ПрочиеТесты";
	Иначе
		КаталогТестовДляОписания = БазовыйКаталогТестов + "\Объекты\" + ВидОбъекта;
	КонецЕсли;
	ОписанияТестов = Новый Соответствие();
	
	КаталогиТестов = НайтиФайлы(КаталогТестовДляОписания, "*");

	Для Каждого КаталогТеста Из КаталогиТестов Цикл
		Если Не КаталогТеста.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;
		ИмяКаталогаТеста = КаталогТеста.Имя;
		ОписаниеТеста = Новый Структура("ВидОбъекта, ИмяОбъекта, Порядок", ВидОбъекта, ИмяКаталогаТеста, 5000);
		
		ИдентификаторТеста = ИдентификаторТеста(ВидОбъекта, ИмяКаталогаТеста);
		
		ОписанияТестов.Вставить(ИдентификаторТеста, ОписаниеТеста);

	КонецЦикла;
	Возврат ОписанияТестов;
КонецФункции

// Обновляет порядок выполнения теста в структуре описания теста из файла инициализации тестов.
// Параметры:
// ПутьКФайлуИнициализации - Строка - полный путь к файлу инициализации.
// ОписанияТестов - Соответствие - см. ОписанияСуществующихТестов()
Процедура ОбновитьОписанияТестовИзФайлаИнициализации(ПутьКФайлуИнициализации, ОписанияТестов)
	// TODO: Переделать на JSON.
	Чтение = Новый ЧтениеТекста(ПутьКФайлуИнициализации);
	СтрокаФайла = Чтение.ПрочитатьСтроку();

	Пока СтрокаФайла <> Неопределено Цикл

		ОписаниеТеста = СтрРазделить(СтрокаФайла, ":");
		ВидОбъекта = ОписаниеТеста[0];
		ИмяОбъекта = ОписаниеТеста[1];
		Порядок    = ОписаниеТеста[2];
		
		ИдентификаторТеста = ИдентификаторТеста(ВидОбъекта, ИмяОбъекта);
		
		ТестСуществует = ?(ОписанияТестов.Получить(ИдентификаторТеста) = Неопределено, Ложь, Истина);
		
		Если Не ТестСуществует Тогда
			СтрокаФайла = Чтение.ПрочитатьСтроку();
			Продолжить;
		КонецЕсли;

		ОписаниеТеста = Новый Структура("ВидОбъекта, ИмяОбъекта, Порядок", ВидОбъекта, ИмяОбъекта, Порядок);
		ОписанияТестов[ИдентификаторТеста] = ОписаниеТеста;
		СтрокаФайла = Чтение.ПрочитатьСтроку();
	КонецЦикла;
КонецПроцедуры


Функция ТаблицаТестов()
	ТаблицаТестов = Новый ТаблицаЗначений();
	ТаблицаТестов.Колонки.Добавить("ВидОбъекта");
	ТаблицаТестов.Колонки.Добавить("ИмяОбъекта");
	ТаблицаТестов.Колонки.Добавить("Порядок");
	Возврат ТаблицаТестов;
КонецФункции

// Формирует во временном каталоге файлы тестов для выполнения
// Параметры:
// НастройкиНабора - Структура - см. ЗагрузитьНастройкиНабора().
Процедура СформироватьФайлыТестовДляВыполнения(НастройкиНабора, ПараметрыВыполнения)
	
	БазовыйКаталогТестов = ПараметрыВыполнения.БазовыйКаталогТестов;
	ВременныйКаталогТестов = ПараметрыВыполнения.ВременныйКаталогТестов;

	Если Не НастройкиНабора.ЭтоТаблицаИсключаемыхТегов 
		И НастройкиНабора.Тэги.Количество() = 0 Тогда
			ВызватьИсключение "В файле набора указана настройка выполнения тестов с
			| определенными тэгами, но список тэгов не заполнен.";
	КонецЕсли;

	Для Каждого СтрокаОписанияТеста Из Тесты Цикл
		ВидОбъекта = СтрокаОписанияТеста.ВидОбъекта;
		ИмяОбъекта = СтрокаОписанияТеста.ИмяОбъекта;
		Порядок = СтрокаОписанияТеста.Порядок;

		Сообщить(Строка(ВидОбъекта) + ", " + Строка(ИмяОбъекта) + ", " + Строка(Порядок	));
		
		ИмяИсходногоФайла = ИмяОбъекта + "РегрессионноеТестирование.feature";
		
		Если ВидОбъекта = ПрочиеТесты() Тогда
			ПутьКИсходномуФайлу = БазовыйКаталогТестов + "\ПрочиеТесты" + "\" + ИмяОбъекта + "\" + ИмяИсходногоФайла;
		Иначе
			ПутьКИсходномуФайлу = БазовыйКаталогТестов + "\Объекты\" + ВидОбъекта + "\" + ИмяОбъекта + "\" + ИмяИсходногоФайла;
		КонецЕсли;

		ИсходныйФайл = Новый Файл(ПутьКИсходномуФайлу);
		Если Не ИсходныйФайл.Существует() Тогда
			Сообщить(ПутьКИсходномуФайлу +  " Пропущен. Исходный файл теста отсутствует." + Символы.ПС);
			Продолжить;
		КонецЕсли;

		ЕстьТэг = ЕстьТэгВФайлеИзСписка(ПутьКИсходномуФайлу, НастройкиНабора);
		ПропуститьПоФильтру = (НастройкиНабора.ЭтоТаблицаИсключаемыхТегов И ЕстьТэг)
								Или (Не НастройкиНабора.ЭтоТаблицаИсключаемыхТегов И Не ЕстьТэг);
		Если ПропуститьПоФильтру Тогда
			 	Сообщить("Пропущен. Не проходит фильтр по тэгам." + Символы.ПС);
				 Продолжить;
		КонецЕсли;
			 
		Для Каждого СтрокаПользователя Из НастройкиНабора.Пользователи Цикл
			ПорядокСтрокой = ЧислоВСтроку(Порядок, 4);
			НомерПользователя = ЧислоВСтроку(СтрокаПользователя.НомерСтроки, 2);
			ИмяПользователя = СтрокаПользователя.ИмяПользователя;
			ПутьКРезультирующемуФайлу = ВременныйКаталогТестов + "\" 
										+ ПорядокСтрокой
										+ "_" + ВидОбъекта
										+ "_" + НомерПользователя
										+ ИмяИсходногоФайла;			

			СтрокиДляЗамены = Новый Соответствие();
			ЗаменяемаяСтрока = "я подключаю TestClient ""Этот клиент"" логин """" пароль """"";
			ЗаменяющаяСтрока = "я подключаю TestClient """
								+ ИмяПользователя 
								+ """ логин """
								+ ИмяПользователя + """"
								+ " пароль """
								+ СтрокаПользователя.Пароль
								+ """";
								
			СтрокиДляЗамены.Вставить(ЗаменяемаяСтрока, ЗаменяющаяСтрока);
			СтрокиДляЗамены.Вставить("Сценарий:", "Сценарий: " + ИмяПользователя);
			КопироватьФайлСЗаменойТекста(ПутьКИсходномуФайлу, ПутьКРезультирующемуФайлу, СтрокиДляЗамены);

			Сообщить("Добавлен: " + ПутьКРезультирующемуФайлу + Символы.ПС);
		КонецЦикла;
	КонецЦикла;	
КонецПроцедуры

Функция ЕстьТэгВФайлеИзСписка(ПутьКФайлу, НастройкиНабора)

	Если УровеньЛогирования = УровеньЛогирования_Полный() Тогда
		Сообщить("Поиск тэгов в списке настроек набора. Файл:" + ПутьКФайлу);
	КонецЕсли;

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПутьКФайлу);
	КоличествоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		СтрокаИзФайла = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		СтрокаИзФайла = НРег(СокрЛП(СтрокаИзФайла));
		
		Если СтрНайти(СтрокаИзФайла, "функционал:") > 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаИзФайла)
			Или Лев(СтрокаИзФайла, 1) <> "@" Тогда
				Продолжить;
		КонецЕсли;
		
		ИмяТэга = Сред(СтрокаИзФайла, 2);
		Если ИмяТэга = "tree" Тогда
			Продолжить;
		КонецЕсли;

		Если УровеньЛогирования = УровеньЛогирования_Полный() Тогда
			Сообщить("Тэг файла: " + ИмяТэга);
		КонецЕсли;
		
		Если НастройкиНабора.Тэги.Найти(ИмяТэга) <> Неопределено Тогда
			Если УровеньЛогирования = УровеньЛогирования_Полный() Тогда
				Сообщить("Найден в списке");
			КонецЕсли;
			Возврат Истина;
		КонецЕсли;
		Если УровеньЛогирования = УровеньЛогирования_Полный() Тогда
			Сообщить("Не найден");
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Процедура ВыполнитьТестыВА(ПараметрыВыполнения)
	БазовыйКаталогТестов = ПараметрыВыполнения.БазовыйКаталогТестов;
	ПутьКТестовойБазе = ПараметрыВыполнения.ПутьКТестовойБазе;

	ИмяФайлаЛога = ПараметрыВыполнения.КаталогЛогаОшибок + "\Log.txt";
	ПутьКФайлуЛогаВА = ПараметрыВыполнения.КаталогЛогаОшибок + "\VA_Log.txt";

	ВерсияПлатформы = ПараметрыКоманднойСтроки.Получить("v8version");
	ВерсияПлатформы = ?(ЗначениеЗаполнено(ВерсияПлатформы), ВерсияПлатформы, "");
	
	
	ПутьКОбработкеВА = БазовыйКаталогТестов + "\vanessa-automation-single.epf";

	

	ИмяПользователя = ПараметрыКоманднойСтроки.Получить("dbuser");
	СтрокаЗапуска = """C:\Program Files\1cv8\" + ВерсияПлатформы + "\bin\1cv8c"""
					+ "/N""" + ИмяПользователя + """"
					+ " /TestManager "
					+ "/Execute " + ПутьКОбработкеВА
					+ " /IBConnectionString ""File=""""" + ПутьКТестовойБазе + """"";"""
					+ " /C""StartFeaturePlayer;VBParams=" + ИмяФайлаПараметров + """";

	
	Сообщить("Запуск тестов на выполнение");
	Сообщить(СтрокаЗапуска);
	ЗапуститьПриложение(СтрокаЗапуска, , Истина);
КонецПроцедуры

// Выводит на экран Allure с результатами тестирования.
Процедура СгенерироватьОтчетыАллюр(ПараметрыВыполнения)

	Сообщить("Формирование отчета Allure:");

	БазовыйВременныйКаталог = ПараметрыВыполнения.БазовыйВременныйКаталог;
	БазовыйКаталогТестов = ПараметрыВыполнения.БазовыйКаталогТестов;

	КаталогДистрибутива = БазовыйВременныйКаталог + "\AllureDistrib";
	СоздатьКаталогПриОтсутствии(КаталогДистрибутива, Истина);
	ПолныйПутьКДистрибутиву = КаталогДистрибутива +	"\allure.zip";
	ПутьКИсточникуДистрибутива = БазовыйКаталогТестов + "\allure.zip";
	КопироватьФайл(ПутьКИсточникуДистрибутива, ПолныйПутьКДистрибутиву);

	Архиватор = Новый ЧтениеZipФайла(ПолныйПутьКДистрибутиву);
	Архиватор.ИзвлечьВсе(КаталогДистрибутива, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	ПутьИсходныхФайловОтчета = ПараметрыВыполнения.ПутьКОтчетамAllure;	
	СтрокаЗапуска = КаталогДистрибутива + "\bin\allure serve """ + ПараметрыВыполнения.ПутьКОтчетамAllure + """";
	Сообщить(СтрокаЗапуска);
	ЗапуститьПриложение(СтрокаЗапуска, ПутьИсходныхФайловОтчета, Истина);
КонецПроцедуры

Процедура ВыполнитьТесты(ПараметрыВыполнения)
	 ИнициализироватьФайлПараметров(ПараметрыВыполнения);
	 ВыполнитьТестыВА(ПараметрыВыполнения);
КонецПроцедуры

// Инициализирует файл параметров выполнения тестов (VAParams.json) на основе шаблона. 
// Шаблон содержит участки $ИмяПараметра$ которые в результирующем файле заменяются в соответствии с
// переданным параметром ПараметрыВыполнения.
// Параметры:
// ПараметрыВыполнения - Соответствие - строки, подлежащие замене в результирующем файле.
// * Ключ 	  - Строка - имя параметра, обозначенное в шаблоне как $ИмяПараметра$.
// * Значение - Строка - строка, которая должна быть подставлена в качестве параметра.
Функция ИнициализироватьФайлПараметров(ПараметрыВыполнения)
	БазовыйКаталогТестов = ПараметрыВыполнения.БазовыйКаталогТестов;
	ВременныйКаталогНабора = ПараметрыВыполнения.ВременныйКаталогНабора;


	Если УровеньЛогирования = УровеньЛогирования_Полный() Тогда
		Сообщить("Параметры для подстановки в VAParams.json:" + Символы.ПС);
		Для Каждого ОписаниеПараметра Из ПараметрыВыполнения Цикл
			Сообщить(ОписаниеПараметра.Ключ + " = " + ОписаниеПараметра.Значение);
		КонецЦикла;
		ВывестиРазделительЛогирования();
	КонецЕсли;
	ИмяФайлаИсточника = БазовыйКаталогТестов + "\VAParams_Tmplt.json";
	ИмяФайлаПараметров = ВременныйКаталогНабора + "\VAParams.json";
	КопироватьФайл(ИмяФайлаИсточника, ИмяФайлаПараметров);

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайлаПараметров);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	Для Каждого ПараметрВыполнения Из ПараметрыВыполнения Цикл
		ПараметрДляЗамены = "$" + ПараметрВыполнения.Ключ + "$";
		ЗначениеПараметраДляЗамены = СтрЗаменить(ПараметрВыполнения.Значение, "\", "\\");
		ТекстФайла = СтрЗаменить(ТекстФайла, ПараметрДляЗамены, ЗначениеПараметраДляЗамены);
	КонецЦикла;

	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ИмяФайлаПараметров);
	Сообщить("Файл параметров запуска VA: " + ИмяФайлаПараметров);
	ВывестиРазделительЛогирования();
	Возврат ИмяФайлаПараметров;
КонецФункции

Функция ВидОбъектаСправочники()
	Возврат "Справочники";
КонецФункции

&НаКлиенте
Функция ВидОбъектаДокументы()
	Возврат "Документы";
КонецФункции

&НаКлиенте
Функция ПрочиеТесты()
	Возврат "ПрочиеТесты";
КонецФункции

&НаКлиенте
Функция ИдентификаторТеста(ВидОбъекта, ИмяОбъекта)
	Возврат ВидОбъекта + "\" + ИмяОбъекта;
КонецФункции

&НаКлиенте
Функция ИмяФайлаОписанияТестов()
	Возврат "Testsorder.ini";
КонецФункции

Функция УровеньЛогирования_Сокращенный()
	Возврат 0;
КонецФункции

Функция УровеньЛогирования_Полный()
	Возврат 1;
КонецФункции

Процедура ВывестиРазделительЛогирования()
	Сообщить("///////////////////////////////////////////");
КонецПроцедуры

Функция ЧислоВСтроку(ПреобразуемоеЧисло, ЧислоДЦ = Неопределено, ДобавлятьЛидирующиеНули = Истина)
	ЧислоБезНПП = Строка(ПреобразуемоеЧисло);
	ЧислоБезНПП = СокрЛП(СтрЗаменить(ЧислоБезНПП, Символы.НПП, ""));
	Если Не ДобавлятьЛидирующиеНули
		Или ЧислоДЦ = Неопределено Тогда
		Возврат ЧислоБезНПП;
	КонецЕсли;
	ДлинаИсходногоЧисла = СтрДлина(ЧислоБезНПП);
	Если ДлинаИсходногоЧисла >= ЧислоДЦ Тогда
		Результат = Прав(ЧислоБезНПП, ЧислоДЦ);
		Возврат Результат;
	КонецЕсли;

	ЧислоДобавляемыхНулей = ЧислоДЦ - ДлинаИсходногоЧисла;
	Результат = "";
	Для ТекущаяПозиция = 1 По ЧислоДобавляемыхНулей Цикл
		Результат = Результат + "0";
	КонецЦикла;
	Результат = Результат + ЧислоБезНПП;
	Возврат Результат;
КонецФункции

// Копирует файл с заменой текста.
// Параметры:
// ИсходныйФайл - Строка - полный путь к исходному файлу.
// ФайлРезультата - Строка - полный путь к файлу результата.
// СтрокиДляЗамены - Соответствие - соответствие с полями:
// * Ключ - Строка - заменяемая строка.
// * Значение - Строка - заменяющая строка.
Процедура КопироватьФайлСЗаменойТекста(ИсходныйФайл, ФайлРезультата, СтрокиДляЗамены)
	КопироватьФайл(ИсходныйФайл, ФайлРезультата);
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ФайлРезультата);
	ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
	Для Каждого КлючИЗначения Из СтрокиДляЗамены Цикл
		ТекстФайла = СтрЗаменить(ТекстФайла, КлючИЗначения.Ключ, КлючИЗначения.Значение);
	КонецЦикла;
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
	ТекстовыйДокумент.Записать(ФайлРезультата);
КонецПроцедуры

УровеньЛогирования = УровеньЛогирования_Полный();
ПараметрыКоманднойСтроки = ПараметрыКоманднойСтрокиВСоответствие();
ПараметрыВыполнения = ПараметрыВыполнения(ПараметрыКоманднойСтроки);
 СоздатьОчиститьВременныеКаталоги(ПараметрыВыполнения);
 Тесты = ТаблицаТестов();
 СформироватьСписокТестов(ПараметрыВыполнения);
 ПутьКФайлуНабора = ПараметрыВыполнения.БазовыйКаталогТестов + "\НаборыТестов\" + ПараметрыВыполнения.ИмяНабораТестов + ".tsc";
 НастройкиНабора = ЗагрузитьНастройкиНабора(ПутьКФайлуНабора);
 СформироватьФайлыТестовДляВыполнения(НастройкиНабора, ПараметрыВыполнения);
 Если ПараметрыКоманднойСтроки.Получить("run") <> Неопределено Тогда
	  ВыполнитьТесты(ПараметрыВыполнения);
	  Если ПараметрыКоманднойСтроки.Получить("allure_show") <> Неопределено Тогда
		  СгенерироватьОтчетыАллюр(ПараметрыВыполнения);
	  КонецЕсли;
 КонецЕсли;