Перем ПараметрыКоманднойСтроки;
Перем БазовыйКаталогТестов;
Перем ИмяНабораТестов;
Перем НастройкиНабора;
Перем ПутьКТестовойБазе;
Перем ВерсияПлатформы;
Перем ИмяФайлаПараметров;
Перем БазовыйВременныйКаталог, ВременныйКаталогНабора, ВременныйКаталогТестов;
Перем Тесты;
Перем СписокТэгов;
Функция ПараметрыКоманднойСтрокиВСоответствие()
	Результат = Новый Соответствие();
	ИмяПараметра = Неопределено;
	Для Каждого Аргумент Из АргументыКоманднойСтроки Цикл
		Если ИмяПараметра = Неопределено И СтрДлина(Аргумент) < 2  Тогда
			ВызватьИсключение "Неизвестный параметр " + ИмяПараметра;
		КонецЕсли;

		Если ИмяПараметра <> Неопределено Тогда
			Результат.Вставить(ИмяПараметра, Аргумент);
			ИмяПараметра = Неопределено;
			Сообщить("Аргумент:" + Аргумент);
		Иначе
			ИмяПараметра = СтрЗаменить(Аргумент, "-", "");
			Сообщить("Имя параметра:" + ИмяПараметра);
		КонецЕсли;
	КонецЦикла;
	Если ИмяПараметра <> Неопределено Тогда
		Результат.Вставить(ИмяПараметра, Истина);
	КонецЕсли;
	Возврат Результат;
КонецФункции

Процедура РазобратьПараметрыЗапуска(ОбязательныеПараметрыСтрокой)
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

	БазовыйКаталогТестов = ПараметрыКоманднойСтроки["testspath"];
	ИмяНабораТестов = ПараметрыКоманднойСтроки["testsetname"];
	ПутьКТестовойБазе = ПараметрыКоманднойСтроки["ibconnection"];
	ВерсияПлатформы = ПараметрыКоманднойСтроки.Получить("v8version");
КонецПроцедуры

Процедура СоздатьКаталогПриОтсутствии(ПутьККаталогу, Очищать = Ложь)
	Каталог = Новый Файл(ПутьККаталогу);
	Если Не Каталог.Существует() Тогда
		СоздатьКаталог(ПутьККаталогу);
		Если Очищать Тогда
			УдалитьФайлы(ПутьККаталогу, "*");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
Процедура СоздатьВременныеКаталоги()
	КаталогВФ = КаталогВременныхФайлов();
	
	БазовыйВременныйКаталог = КаталогВФ + "VATests";
	СоздатьКаталогПриОтсутствии(БазовыйВременныйКаталог);
	Сообщить(БазовыйВременныйКаталог);

	ВременныйКаталогНабора = БазовыйВременныйКаталог + "\" + ИмяНабораТестов;
	СоздатьКаталогПриОтсутствии(ВременныйКаталогНабора);	

	ВременныйКаталогТестов = ВременныйКаталогНабора + "\features";
	СоздатьКаталогПриОтсутствии(ВременныйКаталогТестов, Истина);	
КонецПроцедуры

Функция ЗагрузитьНастройкиНабора()
	ПутьКФайлу = БазовыйКаталогТестов + "\НаборыТестов\" + ИмяНабораТестов + ".tsc";
	ФайлНастроек = Новый ЧтениеJSON();
	ФайлНастроек.ОткрытьФайл(ПутьКФайлу);
	Настройки = ПрочитатьJSON(ФайлНастроек, Ложь);

	СписокТэгов = Новый Соответствие();
	Сообщить("Список тэгов:");
	Для Каждого ИмяТэга Из Настройки.Тэги Цикл
		СписокТэгов.Вставить(НРег(ИмяТэга), Истина);
	КонецЦикла;
	Возврат Настройки;
КонецФункции

Процедура ОбновитьСписокТестов()
	СправочникиОписанияТестов = ОписанияСуществующихТестов(ВидОбъектаСправочники());
	ДокументыОписанияТестов = ОписанияСуществующихТестов(ВидОбъектаДокументы());
	ПрочиеТестыОписанияТестов = ОписанияСуществующихТестов(ПрочиеТесты());
	
	ОписанияТестов = Новый Соответствие();
	
	ДополнитьСоответствие(ОписанияТестов, СправочникиОписанияТестов);
	ДополнитьСоответствие(ОписанияТестов, ДокументыОписанияТестов);
	ДополнитьСоответствие(ОписанияТестов, ПрочиеТестыОписанияТестов);

	ПутьКФайлуОписанияТестов = БазовыйКаталогТестов + "\" + ИмяФайлаОписанияТестов();
	ФайлОписанияТестов = Новый Файл(ПутьКФайлуОписанияТестов);
	Если Не ФайлОписанияТестов.Существует() Тогда
		ВызватьИсключение "Файл " + ИмяФайлаОписанияТестов() + " не найден в указанном каталоге. 
																|Возможно, каталог не является базовым каталогом тестов";
	КонецЕсли;
	ОбновитьОписанияТестовИзФайлаИнициализации(ПутьКФайлуОписанияТестов, ОписанияТестов);
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
Функция ОписанияСуществующихТестов(ВидОбъекта)
		
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

Процедура ОбновитьОписанияТестовИзФайлаИнициализации(ПутьФайла, ОписанияТестов)
	// TODO: Переделать на JSON.
	Чтение = Новый ЧтениеТекста(ПутьФайла);
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

Процедура СформироватьФайлыТестовДляВыполнения()
	
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
		
		ИмяИсходногоФайла = ИмяОбъекта + "СозданиеТестовыхДанных.feature";
		
		Если ВидОбъекта = ПрочиеТесты() Тогда
			ПутьКИсходномуФайлу = БазовыйКаталогТестов + "\ПрочиеТесты" + "\" + ИмяОбъекта + "\" + ИмяИсходногоФайла;
		Иначе
			ПутьКИсходномуФайлу = БазовыйКаталогТестов + "\Объекты\" + ВидОбъекта + "\" + ИмяОбъекта + "\" + ИмяИсходногоФайла;
		КонецЕсли;

		ИсходныйФайл = Новый Файл(ПутьКИсходномуФайлу);
		Если Не ИсходныйФайл.Существует() Тогда
			Сообщить(ПутьКИсходномуФайлу +  " Пропущен. Исходный файл теста отсутствует.");
			Продолжить;
		КонецЕсли;
		
			 
		ЕстьТэг = ЕстьТэгВФайлеИзСписка(ПутьКИсходномуФайлу);
		
		Если (НастройкиНабора.ЭтоТаблицаИсключаемыхТегов И ЕстьТэг)
			 Или (Не НастройкиНабора.ЭтоТаблицаИсключаемыхТегов И Не ЕстьТэг) Тогда
			 	Сообщить("Пропущен. Не проходит фильтр по тэгам.");
				 Продолжить;
		КонецЕсли;
			 
		ПутьКРезультирующемуФайлу = ВременныйКаталогТестов + "\" 
									 + СтрЗаменить(Строка(Порядок), " ", "")
									 + "_" + ВидОбъекта
									 + "_" 
									 + ИмяИсходногоФайла;

		КопироватьФайл(ПутьКИсходномуФайлу, ПутьКРезультирующемуФайлу);

		Сообщить("Добавлен: " + ПутьКРезультирующемуФайлу);
								 
	КонецЦикла;	
КонецПроцедуры

Функция ЕстьТэгВФайлеИзСписка(ПутьКФайлу)
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
		Если СписокТэгов.Получить(ИмяТэга) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Процедура ВыполнитьТестыВА(ПараметрыВыполнения)
	ИмяФайлаЛога = ПараметрыВыполнения.КаталогЛогаОшибок + "\Log.txt";
	ПутьКФайлуЛогаВА = ПараметрыВыполнения.КаталогЛогаОшибок + "\VA_Log.txt";

	ВерсияПлатформы = ПараметрыКоманднойСтроки.Получить("v8version");
	ВерсияПлатформы = ?(ЗначениеЗаполнено(ВерсияПлатформы), ВерсияПлатформы, "");
	
	
	ПутьКОбработкеВА = БазовыйКаталогТестов + "\vanessa-automation-single.epf";

	

	ИмяПользователя = ПараметрыКоманднойСтроки.Получить("dbuser");
	ПараметрИмяПользователя = "";
	Если ЗначениеЗаполнено(ИмяПользователя) Тогда
		ПараметрИмяПользователя = " --db-user " + ИмяПользователя;
	КонецЕсли;

	ПараметрВерсияПлатформы = "";
	Если ЗначениеЗаполнено(ВерсияПлатформы) Тогда
		ПараметрВерсияПлатформы = " --v8version " + ВерсияПлатформы;
	КонецЕсли;

	СтрокаЗапуска = "vrunner run  --execute " + ПутьКОбработкеВА
					+ ПараметрВерсияПлатформы
					+ ПараметрИмяПользователя
					+ " --command ""StartFeaturePlayer;VBPARAMS=" + ИмяФайлаПараметров + """"
					+ " --ibconnection /F" + ПутьКТестовойБазе
					+ " --db-user 	АдминистраторНШР"
					+ "  --additional ""/TESTMANAGER"" >" + ПутьКФайлуЛогаВА;
	
	
	Сообщить(СтрокаЗапуска);
	ЗапуститьПриложение(СтрокаЗапуска, , Истина);

КонецПроцедуры

Процедура СгенерироватьОтчетыАллюр(ПараметрыВыполнения)

	ПутьКФайлуЛогаАллюр = ПараметрыВыполнения.КаталогЛогаОшибок + "\allure_log.txt";

	ПутьИсходныхФайловОтчета = ПараметрыВыполнения.ПутьКОтчетамAllure;	
	ПутьОтчетаРезультата = ПараметрыВыполнения.ПутьКОтчетамAllure + "\Report";

	СоздатьКаталогПриОтсутствии(ПутьОтчетаРезультата, Истина);


	СтрокаЗапуска = "allure generate  -o  "
						+ ПутьОтчетаРезультата
						+ " >" + ПутьКФайлуЛогаАллюр;
	Сообщить(СтрокаЗапуска);
	ЗапуститьПриложение(СтрокаЗапуска, ПутьИсходныхФайловОтчета, Истина);
КонецПроцедуры


Процедура ВыполнитьТесты()
	ПараметрыВыполнения = ПараметрыВыполнения();
	//  ИнициализироватьФайлПараметров(ПараметрыВыполнения);
	//  ВыполнитьТестыВА(ПараметрыВыполнения);

	СгенерироватьОтчетыАллюр(ПараметрыВыполнения);
КонецПроцедуры

Функция ИнициализироватьФайлПараметров(ПараметрыВыполнения)
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
	Возврат ИмяФайлаПараметров;
КонецФункции

Функция ПараметрыВыполнения()
	ПараметрыВыполнения = Новый Структура();
	ПараметрыВыполнения.Вставить("КаталогТестовДляВыполнения", ВременныйКаталогТестов);
	ПараметрыВыполнения.Вставить("ПутьКТестовойБазе", ПутьКТестовойБазе);
	ПараметрыВыполнения.Вставить("БазовыйКаталогТестов", БазовыйКаталогТестов);

	КаталогНабора = БазовыйВременныйКаталог + "\" + ИмяНабораТестов;
	СоздатьКаталогПриОтсутствии(КаталогНабора, Истина);

	КаталогРезультатовТестов = КаталогНабора + "\Results";
	СоздатьКаталогПриОтсутствии(КаталогРезультатовТестов, Истина);
	Сообщить("Каталог результатов: " + КаталогРезультатовТестов);

	КаталогЛогаОшибок = КаталогРезультатовТестов +	"\Log";
	СоздатьКаталогПриОтсутствии(КаталогЛогаОшибок, Истина);
	ПараметрыВыполнения.Вставить("КаталогЛогаОшибок", КаталогЛогаОшибок);

	ПутьКОтчетамAllure = КаталогРезультатовТестов +	"\Allure";
	СоздатьКаталогПриОтсутствии(ПутьКОтчетамAllure, Истина);
	ПараметрыВыполнения.Вставить("ПутьКОтчетамAllure", ПутьКОтчетамAllure);

	ПутьКОтчетамCucumber = КаталогРезультатовТестов +	"\Cucumber";
	СоздатьКаталогПриОтсутствии(ПутьКОтчетамCucumber, Истина);
	ПараметрыВыполнения.Вставить("ПутьКОтчетамCucumber", ПутьКОтчетамCucumber);

	ПутьКОтчетамJunit = КаталогРезультатовТестов +	"\JUnit";
	СоздатьКаталогПриОтсутствии(ПутьКОтчетамJunit, Истина);
	ПараметрыВыполнения.Вставить("ПутьКОтчетамJunit", ПутьКОтчетамJunit);

	КаталогСкриншотов = КаталогРезультатовТестов +	"\Screenshots";
	СоздатьКаталогПриОтсутствии(КаталогСкриншотов, Истина);
	ПараметрыВыполнения.Вставить("КаталогСкриншотов", КаталогСкриншотов);

	Возврат ПараметрыВыполнения;
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


ПараметрыКоманднойСтроки = ПараметрыКоманднойСтрокиВСоответствие();
РазобратьПараметрыЗапуска("testspath,testsetname,ibconnection");
СоздатьВременныеКаталоги();
НастройкиНабора = ЗагрузитьНастройкиНабора();
Тесты = ТаблицаТестов();
ОбновитьСписокТестов();
СформироватьФайлыТестовДляВыполнения();
Если ПараметрыКоманднойСтроки.Получить("run") <> Неопределено Тогда
	ВыполнитьТесты();
КонецЕсли;
