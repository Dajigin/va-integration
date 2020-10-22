#Если Не ВебКлиент Тогда

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьКаталогТестов();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнициализироватьОбработку();
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьОбработку()
	Объект.Тесты.Очистить();
	БазовыйКаталогТестов = КаталогТестов;
	
	Если Не ЗначениеЗаполнено(БазовыйКаталогТестов) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите каталог тестов.");
			КаталогТестовОбъектов = БазовыйКаталогТестов + "\";
	Иначе	
		КаталогТестовОбъектов = БазовыйКаталогТестов + "\Объекты";
		ОбновитьСписокТестов();
	КонецЕсли;

	Если ЗначениеЗаполнено(ФайлНастроекНабора) Тогда
		ЗагрузитьНастройкиНабораИзФайла(ФайлНастроекНабора);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияИзменитьКаталогНажатие(Элемент)
	ОповещениеОВыборе =  Новый ОписаниеОповещения("ПослеЗакрытияФормыВыбораКаталога", ЭтотОбъект);
	ВАИНТ_ТестированиеКлиент.ОткрытьДиалогВыбораКаталогаТестирования(ОповещениеОВыборе);		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыВыбораКаталога(РезультатЗакрытия, ДопПараметр) Экспорт
	ЗаполнитьКаталогТестов();
	ИнициализироватьОбработку();
КонецПроцедуры
&НаКлиенте
Процедура КаталогТестовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПриИзмененииКаталогаТестов();
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьСписокТестовКоманда(Команда)
	ОчиститьСообщения();
	ПерезаполнитьФайлОписанийТестов();
	Модифицированность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьДляВыполненияКоманда(Команда)
	ОчиститьСообщения();
	СформироватьФайлыТестовДляВыполнения();

КонецПроцедуры
&НаКлиенте
Процедура ПодготовитьИВыполнить(Команда)
	глоФормаОбработкиВА = Неопределено;
	Если СформироватьФайлыТестовДляВыполнения() Тогда
	
		КаталогТестов = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуПодготовленныхТестов(БазовыйКаталогТестов);
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("КаталогПроекта", КаталогТестов);

		глоКоличествоПроверокОткрытияФормыВА = 0;
		глоФормаОбработкиВА = ОткрытьФорму("Обработка.VanessaAutomationsingle.Форма.УправляемаяФорма", 
												  ПараметрыФормы);
		ПодключитьОбработчикОжидания("ОжиданиеОткрытиеОбработкиВА", 2);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОжиданиеОткрытиеОбработкиВА() Экспорт
	Попытка
		МаксимальноеКоличествоПроверокОткрытияФормы = 10;
		Если глоФормаОбработкиВА.ФормаVanessaAutomationОткрылась
			Или глоКоличествоПроверокОткрытияФормыВА >= МаксимальноеКоличествоПроверокОткрытияФормы Тогда
	
			ОтключитьОбработчикОжидания("ОжиданиеОткрытиеОбработкиВА");
			Если глоФормаОбработкиВА.ФормаVanessaAutomationОткрылась Тогда
				ДопПараметры = Новый Структура();
				глоФормаОбработкиВА.Объект.КаталогФич = КаталогТестов;
				глоФормаОбработкиВА.Объект.ДелатьОтчетВФорматеАллюр = Истина;
				глоФормаОбработкиВА.Объект.ДелатьОтчетВФорматеCucumberJson = Истина;
				глоФормаОбработкиВА.Объект.ДелатьОтчетВФорматеjUnit = Истина;
				КаталогОтчетовAllure = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов_Allure(БазовыйКаталогТестов);
				глоФормаОбработкиВА.Объект.КаталогВыгрузкиAllure = КаталогОтчетовAllure;
				КаталогОтчетовCucumber = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов_Cucumber(БазовыйКаталогТестов);
				глоФормаОбработкиВА.Объект.КаталогВыгрузкиCucumberJson = КаталогОтчетовCucumber;
				КаталогОтчетовJUnit = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов_JUnit(БазовыйКаталогТестов);
				глоФормаОбработкиВА.Объект.КаталогВыгрузкиJUnit = КаталогОтчетовJUnit;
					
				ДопПараметры.Вставить("ПерезагрузитьИВыполнить", Истина);
				глоФормаОбработкиВА.ЗагрузитьФичи(ДопПараметры);
				ПодключитьОбработчикОжидания("ОжиданиеЗавершенияТестов", 5);
			КонецЕсли;
			глоФормаОбработкиВА = Неопределено;
		Иначе
			глоКоличествоПроверокОткрытияФормыВА = глоКоличествоПроверокОткрытияФормыВА + 1;		
		КонецЕсли;
	Исключение
		ОтключитьОбработчикОжидания("ОжиданиеОткрытиеОбработкиВА");
		глоФормаОбработкиВА = Неопределено;
		ВызватьИсключение;
	КонецПопытки;		
	
КонецПроцедуры

&НаКлиенте
Процедура ОжиданиеЗавершенияТестов() Экспорт
	КаталогЛогов = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов_Allure(БазовыйКаталогТестов);
	МассивФайлов = НайтиФайлы(КаталогЛогов, "*.json");
	Если МассивФайлов.Количество() <> 0 Тогда
		ОтключитьОбработчикОжидания("ОжиданиеЗавершенияТестов");
		ПутьКИсполняемомуФайлуAllure = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуДистрибутиваAllure(БазовыйКаталогТестов)
									   + "\bin\allure.bat";		
		ЗапуститьПриложение(ПутьКИсполняемомуФайлуAllure + " serve " + КаталогЛогов);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокТестовКоманда(Команда)
	ОбновитьСписокТестов();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогПодготовленныхТестов(Команда)
	ЗапуститьПриложение(ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуПодготовленныхТестов(БазовыйКаталогТестов));
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакНастройкиНабораКоманда(Команда)
	ОчиститьСообщения();
	СохранитьКакНастройкиНабора();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиНабораКоманда(Команда)
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(ФайлНастроекНабора) Тогда
		СохранитьНастройкиНабораВФайл(ФайлНастроекНабора);
	Иначе
		СохранитьКакНастройкиНабора();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройкиНабораКоманда(Команда)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Фильтр = "Настройки набора тестов (*.tsc)|*.tsc";
	ДиалогВыбораФайла.Фильтр = Фильтр;
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлу = ДиалогВыбораФайла.ПолноеИмяФайла;
		ЗагрузитьНастройкиНабораИзФайла(ПутьКФайлу);
	КонецЕсли;
 
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиПорядка(Команда)
		ОчиститьСообщения();
		ПерезаполнитьФайлОписанийТестов();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Настройки порядка выполнения тестов сохранены.");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКаталогТестов()
	
	КаталогТестов = ВАИНТ_ТестированиеКлиентСервер.БазовыйКаталогТестирования();
	
КонецПроцедуры

&НаКлиенте
Функция ОписанияСуществующихТестов(ВидОбъекта)
		
	Если ВидОбъекта = ПрочиеТесты() Тогда
		КаталогТестовДляОписания = КаталогТестов + "\ПрочиеТесты";   
	Иначе
		КаталогТестовДляОписания = КаталогТестовОбъектов + "\" + ВидОбъекта;
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

&НаКлиенте
Процедура ОписанияТестовИзФайлаИнициализации(ПутьФайла, ОписанияТестов)

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

&НаКлиенте
Процедура ЗаполнитьРеквизитФормыСписокТэгов()
	Результат = Новый Соответствие;
	Для Каждого СтрокаТэга Из Объект.Тэги Цикл
		Результат.Вставить(НРег(СтрокаТэга.ИмяТэга), Истина);		
	КонецЦикла;
	
	ЭтотОбъект.СписокТэгов = Новый ФиксированноеСоответствие(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьФайлОписанийТестов()

	ИмяФайлаИнициализации = БазовыйКаталогТестов + "\" + ИмяФайлаОписанияТестов();

	Запись = Новый ЗаписьТекста(ИмяФайлаИнициализации);

	Для Каждого СтрокаТаблицы Из Объект.Тесты Цикл

		НоваяСтрока = СтрокаТаблицы.ВидОбъекта + ":" + СтрокаТаблицы.ИмяОбъекта
			+ ":" + Строка(СтрокаТаблицы.Порядок);

		Запись.ЗаписатьСтроку(НоваяСтрока);

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
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

&НаКлиенте
Процедура ОбновитьСписокТестов()
	СправочникиОписанияТестов = ОписанияСуществующихТестов(ВидОбъектаСправочники());
	ДокументыОписанияТестов = ОписанияСуществующихТестов(ВидОбъектаДокументы());
	ПрочиеТестыОписанияТестов = ОписанияСуществующихТестов(ПрочиеТесты());
	
	ОписанияТестов = Новый Соответствие();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ОписанияТестов, СправочникиОписанияТестов, Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ОписанияТестов, ДокументыОписанияТестов, Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ОписанияТестов, ПрочиеТестыОписанияТестов, Истина);

	ПутьКФайлуОписанияТестов = БазовыйКаталогТестов + "\" + ИмяФайлаОписанияТестов();
	ФайлОписанияТестов = Новый Файл(ПутьКФайлуОписанияТестов);
	Если Не ФайлОписанияТестов.Существует() Тогда
		
		СообщениеПользователю =  "Файл " + ИмяФайлаОписанияТестов() + " не найден в указанном каталоге. 
																|Возможно, каталог не является базовым каталогом тестов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю);
		Возврат;
	КонецЕсли;
	ОписанияТестовИзФайлаИнициализации(ПутьКФайлуОписанияТестов, ОписанияТестов);
	Объект.Тесты.Очистить();

	Для Каждого ОписаниеТестаКлючИЗначение Из ОписанияТестов Цикл
		НовыйТест = Объект.Тесты.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйТест, ОписаниеТестаКлючИЗначение.Значение);
	КонецЦикла;

	Объект.Тесты.Сортировать("Порядок Возр");
КонецПроцедуры

&НаКлиенте
Функция СформироватьФайлыТестовДляВыполнения()
	
	Если Не Объект.ЭтоТаблицаИсключаемыхТегов 
		И Объект.Тэги.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите список тегов для выполнения.", , "Тесты");
			Возврат Ложь;
	КонецЕсли;

	ЗаполнитьРеквизитФормыСписокТэгов();
		
	ИмяКаталогаРезультата = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуПодготовленныхТестов(БазовыйКаталогТестов);
	
	ПодготовитьВременныеКаталогиТестирования(ИмяКаталогаРезультата);
	
	Для Каждого СтрокаОписанияТеста Из Объект.Тесты Цикл
		ВидОбъекта = СтрокаОписанияТеста.ВидОбъекта;
		ИмяОбъекта = СтрокаОписанияТеста.ИмяОбъекта;
		Порядок = СтрокаОписанияТеста.Порядок;
		
		ИмяИсходногоФайла = ИмяОбъекта + "РегрессионноеТестирование.feature";

		Если ВидОбъекта = ПрочиеТесты() Тогда
			ПутьКИсходномуФайлу = КаталогТестов + "\ПрочиеТесты" + "\" + ИмяОбъекта + "\" + ИмяИсходногоФайла;
		Иначе
			ПутьКИсходномуФайлу = КаталогТестовОбъектов + "\" +  ВидОбъекта + "\" + ИмяОбъекта + "\" + ИмяИсходногоФайла;
		КонецЕсли;

		ИсходныйФайл = Новый Файл(ПутьКИсходномуФайлу);
		Если Не ИсходныйФайл.Существует() Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьТэг = ЕстьТэгВФайлеИзСписка(ПутьКИсходномуФайлу);
		
		ПропуститьФайл = (Объект.ЭтоТаблицаИсключаемыхТегов И ЕстьТэг)
			 				Или (Не Объект.ЭтоТаблицаИсключаемыхТегов И Не ЕстьТэг);
		 				 
		Если  ПропуститьФайл Тогда
			 Продолжить;
		КонецЕсли;
			 
		ПутьКРезультирующемуФайлу = ИмяКаталогаРезультата + "\" 
									 + Формат(Порядок, "ЧРГ=; ЧГ=;")
									 + "_" + ВидОбъекта
									 + ИмяИсходногоФайла;

		КопироватьФайл(ПутьКИсходномуФайлу, ПутьКРезультирующемуФайлу);
								 
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Файлы тестов успешно созданы в каталоге " + ИмяКаталогаРезультата);
	Возврат Истина;	
КонецФункции

&НаКлиенте
Процедура ПодготовитьВременныеКаталогиТестирования(ИмяКаталогаРезультата)
		
	КаталогРезультата = Новый Файл(ИмяКаталогаРезультата);

	Если Не КаталогРезультата.Существует() Тогда
		СоздатьКаталог(ИмяКаталогаРезультата);
	Иначе
		УдалитьФайлы(ИмяКаталогаРезультата, "*");
	КонецЕсли;
	
	ФайлыКаталогаРезультата = НайтиФайлы(КаталогРезультата, "*");
	Если Не КаталогРезультата.Существует()
			Или ФайлыКаталогаРезультата.Количество() <> 0 Тогда
		ВызватьИсключение "Ошибка при создании/очистке каталога результата тестов.";
	КонецЕсли;
	
	СоздатьКаталог(ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов(БазовыйКаталогТестов));
	СоздатьКаталог(ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов_Allure(БазовыйКаталогТестов));
	СоздатьКаталог(ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов_Cucumber(БазовыйКаталогТестов));
	СоздатьКаталог(ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуЛогов_JUnit(БазовыйКаталогТестов));
	
	СоздатьКаталог(ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуДистрибутиваAllure(БазовыйКаталогТестов));
	РаспаковатьДистрибутивAllure();
	
КонецПроцедуры

 &НаКлиенте
 Процедура РаспаковатьДистрибутивAllure()
 	ПутьККаталогуДистрибутива = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуДистрибутиваAllure(БазовыйКаталогТестов);
 	ПутьКФайлуДистрибутива = ПутьККаталогуДистрибутива + "\alldistr.zip";
 	МакетДистрибутива = ПолучитьМакетДистрибутиваAllure();
 	МакетДистрибутива.Записать(ПутьКФайлуДистрибутива);
 	Архив = Новый ЧтениеZipФайла(ПутьКФайлуДистрибутива, "");
    Архив.ИзвлечьВсе(ПутьККаталогуДистрибутива, РежимВосстановленияПутейФайловZIP.Восстанавливать);
КонецПроцедуры
 
&НаСервере
Функция ПолучитьМакетДистрибутиваAllure()
 	Макет = ПолучитьОбщийМакет("ВАИНТ_Allure_Distrib");
 	Возврат Макет;
КонецФункции
 
&НаКлиенте
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
		Если ЭтотОбъект.СписокТэгов.Получить(ИмяТэга) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура СохранитьКакНастройкиНабора()
	ОчиститьСообщения();
	ПутьККаталогуНабора = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуНастроекНаборов(БазовыйКаталогТестов);
	ВАИНТ_ТестированиеКлиент.СоздатьКаталогПриОтсутствии(ПутьККаталогуНабора);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Фильтр = "Настройки набора тестов (*.tsc)|*.tsc";
	ДиалогВыбораФайла.Фильтр = Фильтр;
	ДиалогВыбораФайла.Каталог = ПутьККаталогуНабора + "\";
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлу = ДиалогВыбораФайла.ПолноеИмяФайла;
		СохранитьНастройкиНабораВФайл(ПутьКФайлу);
		ФайлНастроекНабора = ПутьКФайлу;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиНабораВФайл(ПутьКФайлу)
		НастройкиНабора = НастройкиНабораВСтруктуру();
		ФайлНастроек = Новый ЗаписьJSON();
		ФайлНастроек.ОткрытьФайл(ПутьКФайлу);
		ЗаписатьJSON(ФайлНастроек, НастройкиНабора);
		ФайлНастроек.Закрыть();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Настройки сохранены.");	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройкиНабораИзФайла(ПутьКФайлу)
	ФайлНастроек = Новый ЧтениеJSON();
	ФайлНастроек.ОткрытьФайл(ПутьКФайлу);
	Настройки = ПрочитатьJSON(ФайлНастроек, Ложь);
	Объект.ЭтоТаблицаИсключаемыхТегов = Настройки.ЭтоТаблицаИсключаемыхТегов;
	Настройки.Свойство("ИмяНабора", ИмяНабора);
	Настройки.Свойство("ОписаниеНабора", ОписаниеНабора);
	МассивВСписокТэгов(Настройки.Тэги);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Настройки набора прочитаны.");
    ФайлНастроекНабора = ПутьКФайлу;
КонецПроцедуры

&НаКлиенте
Функция НастройкиНабораВСтруктуру()
	Результат = Новый Структура();
	Результат.Вставить("ЭтоТаблицаИсключаемыхТегов", Объект.ЭтоТаблицаИсключаемыхТегов);
	Результат.Вставить("ИмяНабора", ИмяНабора);
	Результат.Вставить("ОписаниеНабора", ОписаниеНабора);
	МассивТэгов = СписокТэговВМассив();
	Результат.Вставить("Тэги", МассивТэгов);
	Возврат Результат;
КонецФункции

&НаСервере
Функция СписокТэговВМассив()
	МассивТэгов = Объект.Тэги.Выгрузить(, "ИмяТэга").ВыгрузитьКолонку("ИмяТэга");
	Возврат МассивТэгов;
КонецФункции

&НаСервере
Процедура МассивВСписокТэгов(Тэги)
	Объект.Тэги.Очистить();
	Для Каждого ИмяТэга Из Тэги Цикл
		СтрокаТэга = Объект.Тэги.Добавить();
		СтрокаТэга.ИмяТэга = ИмяТэга;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКаталогаТестов()
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		КаталогТестов = ДиалогВыбораФайла.Каталог;
		ИнициализироватьОбработку();
	КонецЕсли;
 
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоНабораТестов()
	КаталогТестов = ВАИНТ_ТестированиеКлиентСервер.ПутьККаталогуНастроекНаборов(БазовыйКаталогТестов);
КонецПроцедуры


#КонецОбласти
#Иначе
	// BSLLS:CodeOutOfRegion-off
	ВызватьИсключение "Управление тестами не доступно на веб-клиенте.";
	// BSLLS:CodeOutOfRegion-on
#КонецЕсли
