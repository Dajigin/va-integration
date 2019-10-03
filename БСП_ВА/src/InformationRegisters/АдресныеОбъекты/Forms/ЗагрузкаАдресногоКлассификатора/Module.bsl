///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Форма параметризуется. Необязательные параметры:
//
//     КодРегионаДляЗагрузки      - Число, Строка, Массив - Код субъекта РФ (или их массив), загрузка которого
//                                  предлагается.
//     НазваниеРегиона - Строка                - Название субъекта РФ, загрузка которого предлагается.
//     Режим                      - Строка                - Режим работы формы.
//
//   Если указан параметр КодРегионаДляЗагрузки или НазваниеРегиона, то предлагаемый регион или регионы
// будут отмечены для загрузки, первый из них выделен как текущий.
//   Если параметр Режим равен "ПроверкаОбновления", то будет запущена проверка обновления на сайте и предложено 
// загрузить обновленные.
//

#Область ОписаниеПеременных

&НаКлиенте
Перем ПодтверждениеЗакрытияФормы;

// Параметры загрузки для передачи между клиентскими вызовами.
&НаКлиенте
Перем ПараметрыФоновойЗагрузкиКлассификатора;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ДоступнаЗагрузкаАдресныхСведенийИзИнтернет = АдресныйКлассификаторСлужебный.ДоступнаЗагрузкаАдресныхСведенийИзИнтернет();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") 
		И ДоступнаЗагрузкаАдресныхСведенийИзИнтернет Тогда
		ЗаполнитьЗначенияСвойств(ДоступныеИсточникиЗагрузки.Добавить(), Элементы.ДоступныеИсточникиЗагрузкиСайт.СписокВыбора[0]);
		КодИсточникаЗагрузки = "САЙТ";
	Иначе
		Элементы.ГруппаИсточникиЗагрузки.ОтображатьЗаголовок = Ложь;
		Элементы.ГруппаЗагрузкиССайта.Видимость = Ложь;
		Элементы.ДоступныеИсточникиЗагрузкиКаталог.Видимость = Ложь;
		Элементы.АдресЗагрузки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
		КодИсточникаЗагрузки = "КАТАЛОГ";
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ДоступныеИсточникиЗагрузки.Добавить(), Элементы.ДоступныеИсточникиЗагрузкиКаталог.СписокВыбора[0]);
	ИдентификаторыДляОбновления = Новый Массив;
	
	// Получаем уже загруженные регионы.
	ТаблицаРегионов = АдресныйКлассификаторСлужебный.СведенияОЗагрузкеСубъектовРФ();
	ТаблицаРегионов.Колонки.Добавить("Загружать", Новый ОписаниеТипов("Булево"));
	ТаблицаРегионов.Колонки.Добавить("РежимРаботы", Новый ОписаниеТипов("Строка"));
	
	Если Параметры.Свойство("ВыборАдресаПоПочтовомуИндексу") И КодИсточникаЗагрузки = "САЙТ" Тогда
		РежимРаботы = "ОБНОВЛЕНИЕ";
		ПочтовыйИндекс = Параметры.Индекс;
		Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОбновлениеКлассификатора;
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
			МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
			СведенияОРегионе = МодульАдресныйКлассификаторСлужебный.ОпределитьРегионПоИндексу(ПочтовыйИндекс);
			Если СведенияОРегионе <> Неопределено Тогда
				ПредставлениеРегиона = " (" + СведенияОРегионе.Представление + ")";
				ТекущийКодРегиона = СведенияОРегионе.КодСубъектаРФ;
			КонецЕсли;
			Элементы.ТекстИндексНеНайден.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ТекстИндексНеНайден.Заголовок, ПочтовыйИндекс, ПредставлениеРегиона);
		КонецЕсли;
		Элементы.ОбновитьКлассификатор.КнопкаПоУмолчанию = Истина;
	Иначе
		РежимРаботы = "ЗАГРУЗКА";
		ТекущийКодРегиона = Неопределено;
		
		Параметры.Свойство("КодРегионаДляЗагрузки", ТекущийКодРегиона);
		
		Если ДоступнаЗагрузкаАдресныхСведенийИзИнтернет Тогда
			// Анализируем варианты работы - нас могли вызвать для проверки обновления.
			ДоступныеВерсии = АдресныйКлассификаторСлужебный.ДоступныеВерсииАдресныхСведений();
			Фильтр = Новый Структура("Загружено, ДоступноОбновление", Истина, Истина);
			ОбновленныеДанные = ДоступныеВерсии.Скопировать(Фильтр);
			КоличествоОбновлений = ОбновленныеДанные.Количество();
			
			Если КоличествоОбновлений > 0 Тогда
				ДатаОбновления = Формат(ОбновленныеДанные[0].ДатаОбновления, "ДЛФ=DD");
				ИнформацияОбОбновление = НСтр("ru = 'Доступно обновление от'") + " " + ДатаОбновления;
				
				// Будем загружать только обновленных, возможно добавленных субъекты РФ !
				ИдентификаторыДляОбновления = ОбновленныеДанные.ВыгрузитьКолонку("Идентификатор");
			Иначе
				Элементы.ИнформацияОбОбновление.Видимость = Ложь;
				Фильтр = Новый Структура("Загружено, ДоступноОбновление", Истина, Ложь);
				ОбновленныеДанные = ДоступныеВерсии.Скопировать(Фильтр);
				ИдентификаторыДляОбновления = ОбновленныеДанные.ВыгрузитьКолонку("Идентификатор");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Добавляем пометку для загружаемого региона-параметра и ставим его текущей строкой.
	ТипТекущегоКодаРегиона = ТипЗнч(ТекущийКодРегиона);
	ТипЧисло               = Новый ОписаниеТипов("Число");
	
	Если ТипТекущегоКодаРегиона = Тип("Массив") И ТекущийКодРегиона.Количество() > 0 Тогда
		// Указан массив для загрузки
		Фильтр = Новый Структура("КодСубъектаРФ");
		Для Каждого КодРегиона Из ТекущийКодРегиона Цикл 
			Фильтр.КодСубъектаРФ = ТипЧисло.ПривестиЗначение(КодРегиона);
			Кандидаты = ТаблицаРегионов.НайтиСтроки(Фильтр); 
			Если Кандидаты.Количество() > 0 Тогда
				Кандидаты[0].Загружать = Истина;
			КонецЕсли;
		КонецЦикла;
		ТекущийКодРегиона = ТекущийКодРегиона[0];
		
	ИначеЕсли ТипТекущегоКодаРегиона = Тип("Строка") Тогда
		// Как код
		ТекущийКодРегиона = ТипЧисло.ПривестиЗначение(ТекущийКодРегиона);
		
	ИначеЕсли Параметры.Свойство("НазваниеРегиона") Тогда
		// Как наименование
		ТекущийКодРегиона = АдресныйКлассификатор.КодРегионаПоНаименованию(Параметры.НазваниеРегиона);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущийКодРегиона) И ИдентификаторыДляОбновления.Количество() > 0 Тогда
		// Обновление строго указанных.
		Фильтр = Новый Структура("Идентификатор");
		Для Каждого Идентификатор Из ИдентификаторыДляОбновления Цикл 
			Фильтр.Идентификатор = Идентификатор;
			Кандидаты = ТаблицаРегионов.НайтиСтроки(Фильтр); 
			Если Кандидаты.Количество() > 0 Тогда
				Кандидаты[0].Загружать = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТаблицаРегионов, "СубъектыРФ");
	
	Если ТекущийКодРегиона <> Неопределено Тогда
		Кандидаты = СубъектыРФ.НайтиСтроки(Новый Структура("КодСубъектаРФ",  ТекущийКодРегиона));
		Если Кандидаты.Количество() > 0 Тогда
			ТекущаяСтрока = Кандидаты[0];
			ТекущаяСтрока.Загружать = Истина;
			Элементы.СубъектыРФ.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
		
	Если РежимРаботы = "ЗАГРУЗКА" Тогда
		// Установка текущей строки по коду.

		// Если не установили текущую строку по параметру, то пытаемся поставить ее на первый отмеченный.
		Если Элементы.СубъектыРФ.ТекущаяСтрока = Неопределено Тогда
			Кандидаты = СубъектыРФ.НайтиСтроки(Новый Структура("Загружать", Истина));
			Если Кандидаты.Количество() > 0 Тогда
				Элементы.СубъектыРФ.ТекущаяСтрока = Кандидаты[0].ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
		
		АутентификацияВыполнена                                     = ДанныеАутентификацииСайтаСохранены();
		Элементы.ИнформацияОбОбновление.Видимость                   = АутентификацияВыполнена;
		Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость = НЕ Элементы.ИнформацияОбОбновление.Видимость;
		
		// Автосохранение настроек
		СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	// Контроль корректности кода источника данных для загрузки.
	КодИсточника = Настройки["КодИсточникаЗагрузки"];
	Если ДоступныеИсточникиЗагрузки.НайтиПоЗначению(КодИсточника) = Неопределено Тогда
		// Оставляем умолчания
		Настройки.Удалить("КодИсточникаЗагрузки");
		Настройки.Удалить("АдресЗагрузки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПредупреждениеПриОткрытии <> "" Тогда
		ПоказатьПредупреждение(, ПредупреждениеПриОткрытии);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейсПоКоличествуЗагружаемых();
	ПроверитьДоступностьОбновленияКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Элементы.ШагиЗагрузки.ТекущаяСтраница <> Элементы.ОжиданиеЗагрузки 
		Или ПодтверждениеЗакрытияФормы = Истина Тогда
		Возврат;
	КонецЕсли;		
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗакрытиеФормыЗавершение", ЭтотОбъект);
	Текст = НСтр("ru = 'Прервать загрузку адресного классификатора?'");
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АдресныйКлассификаторКлиент.ВыбратьКаталог(ЭтотОбъект, "АдресЗагрузки", 
		НСтр("ru = 'Каталог с файлами адресного классификатора'"),
		СтандартнаяОбработка,
		Новый ОписаниеОповещения("ЗавершениеВыбораКаталогаАдресаЗагрузки", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектыРФЗагружатьПриИзменении(Элемент)
	
	ОбновитьИнтерфейсПоКоличествуЗагружаемых();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеИсточникиЗагрузкиПриИзменении(Элемент)
	
	УстановитьДоступностьИсточниковЗагрузки();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЗагрузкиПриИзменении(Элемент)
	
	УстановитьИсточникомЗагрузкиКаталог();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание > 0 Тогда
		УстановитьОтборВСпискеРегионов(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	УстановитьОтборВСпискеРегионов(Текст);
КонецПроцедуры

&НаКлиенте
Процедура ПоискОчистка(Элемент, СтандартнаяОбработка)
	Элементы.СубъектыРФ.ОтборСтрок = Неопределено;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСубъектыРФ

&НаКлиенте
Процедура СубъектыРФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.СубъектыРФПредставление Тогда
		ТекущиеДанные = СубъектыРФ.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные <> Неопределено Тогда
			ТекущиеДанные.Загружать = Не ТекущиеДанные.Загружать;
			ОбновитьИнтерфейсПоКоличествуЗагружаемых();
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьПометкиСпискаРегионов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкиСпискаРегионов(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если КодИсточникаЗагрузки = "КАТАЛОГ" Тогда
		Текст = НСтр("ru = 'Для загрузки адресного классификатора из папки
		                   |необходимо установить расширение для работы с 1С:Предприятием.'");
		КонтрольРасширенияРаботыСФайлами(Текст, КодИсточникаЗагрузки, АдресЗагрузки);
		
	ИначеЕсли КодИсточникаЗагрузки = "САЙТ" Тогда
		ЗагрузитьКлассификаторССайта();
		
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю( НСтр("ru = 'Не указан вариант загрузки классификатора.'") );
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьЗагрузку(Команда)
	
	ПодтверждениеЗакрытияФормы = Неопределено;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияНаСайтеПоддержкиПользователей(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЛогинИПароля", ЭтотОбъект);
	АдресныйКлассификаторКлиент.АвторизоватьНаСайтеПоддержкиПользователей(Оповещение, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаЛогинИПароля(Результат, Параметр) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость = Ложь;
		Элементы.ИнформацияОбОбновление.Видимость                   = Истина;
		АутентификацияВыполнена                                     = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезПодтверждения(Команда)
	
	ПодтверждениеЗакрытияФормы = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКлассификатор(Команда)
	
	Если КодИсточникаЗагрузки = "САЙТ" Тогда
		ЗагрузитьКлассификаторССайта();
		// грузим
		Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	Иначе
		Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьДоступностьОбновленияКлиент()
	
	Задание = ЗапуститьПроверкуДоступностиОбновления(УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ПослеПроверкиДоступностиОбновленияКлиент", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);

КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиДоступностиОбновленияКлиент(Задание, ДополнительныеПараметры) Экспорт
	
	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус = "Выполнено" Тогда
		Даты = ДатыОбновленияАдресногоКлассификатор(Задание.АдресРезультата);
			
		Если Даты.ДатаОбновления > Даты.ДатаСамойСтаройЗагрузки Тогда
			ДатаОбновленияСтрокой = Формат(Даты.ДатаОбновления, "ДЛФ=DD");
			ИнформацияОбОбновление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Доступно обновление от %1'"), ДатаОбновленияСтрокой);
			Элементы.ИнформацияОбОбновление.Видимость = НЕ Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольРасширенияРаботыСФайлами(Знач ТекстПредложения, Знач КодИсточника, Знач АдресИсточника)
	
	Оповещение = Новый ОписаниеОповещения("КонтрольРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("КодИсточникаЗагрузки", КодИсточника);
	Оповещение.ДополнительныеПараметры.Вставить("АдресЗагрузки",        АдресИсточника);
	
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
	
КонецПроцедуры

// Завершение диалога предложения расширения для работы с файлами.
//
&НаКлиенте
Процедура КонтрольРасширенияРаботыСФайламиЗавершение(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКлассификаторИзКаталога(ДополнительныеПараметры.АдресЗагрузки);
	
КонецПроцедуры

// Завершение диалога закрытия формы.
&НаКлиенте
Процедура ЗакрытиеФормыЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПодтверждениеЗакрытияФормы = Истина;
		Закрыть();
	Иначе 
		ПодтверждениеЗакрытияФормы = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазрешениеЗагрузки(Знач КоличествоЗагружаемых = Неопределено)
	
	Если КоличествоЗагружаемых = Неопределено Тогда
		Фильтр = Новый Структура("Загружать", Истина);
		КоличествоЗагружаемых = СубъектыРФ.НайтиСтроки(Фильтр).Количество();
	КонецЕсли;
	
	Элементы.Загрузить.Доступность = (КоличествоЗагружаемых > 0)
		И ДоступныеИсточникиЗагрузки.НайтиПоЗначению(КодИсточникаЗагрузки) <> Неопределено;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатыОбновленияАдресногоКлассификатор(АдресРезультата)
	
	Результат = Новый Структура("ДатаСамойСтаройЗагрузки, ДатаОбновления", Дата(1,1,1), Дата(1,1,1));
	
	ИнформацияОбновление = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если ЗначениеЗаполнено(ИнформацияОбновление)
		И ИнформацияОбновление.Свойство("Таблица")
		И ИнформацияОбновление.Таблица.Количество() > 0 Тогда
			ДатаОбновления = ИнформацияОбновление.Таблица[0].ДатаОбновления;
			Если ТипЗнч(ДатаОбновления) <> Тип("Дата") Тогда
				Возврат Ложь;
			КонецЕсли;
			Результат.ДатаОбновления = НачалоДня(ДатаОбновления);
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВЫБОР
			|		КОГДА НАЧАЛОПЕРИОДА(МИНИМУМ(ЗагруженныеВерсииАдресныхСведений.ДатаВерсии), ДЕНЬ) ЕСТЬ NULL 
			|			ТОГДА ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
			|		ИНАЧЕ НАЧАЛОПЕРИОДА(МИНИМУМ(ЗагруженныеВерсииАдресныхСведений.ДатаВерсии), ДЕНЬ)
			|	КОНЕЦ КАК ДатаВерсии
			|ИЗ
			|	РегистрСведений.ЗагруженныеВерсииАдресныхСведений КАК ЗагруженныеВерсииАдресныхСведений";
			
			РезультатЗапроса = Запрос.Выполнить().Выбрать();
			Если РезультатЗапроса.Следующий() Тогда
				Результат.ДатаСамойСтаройЗагрузки = РезультатЗапроса.ДатаВерсии;
			Иначе
				Результат.ДатаСамойСтаройЗагрузки = Дата(1, 1, 1);
			КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗапуститьПроверкуДоступностиОбновления(УникальныйИдентификатор)
	
	ПараметрыВызоваСервера = Новый Массив;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Проверка обновления для адресного классификатора'");
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("АдресныйКлассификаторСлужебный.ДоступныеВерсииАдресныхСведений",
		ПараметрыВызоваСервера, ПараметрыВыполнения);
	
	Возврат ФоновоеЗадание;
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Поля = Элемент.Поля.Элементы;
	Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("СубъектыРФКодСубъектаРФ");
	Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("СубъектыРФПредставление");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СубъектыРФ.Загружено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ВажнаяНадписьШрифт);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиСпискаРегионов(Знач Пометка)
	
	// Устанавливаем пометки только для видимых строк.
	ЭлементТаблицы = Элементы.СубъектыРФ;
	Для Каждого СтрокаРегиона Из СубъектыРФ Цикл
		Если ЭлементТаблицы.ДанныеСтроки( СтрокаРегиона.ПолучитьИдентификатор() ) <> Неопределено Тогда
			СтрокаРегиона.Загружать = Пометка;
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьИнтерфейсПоКоличествуЗагружаемых();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПоКоличествуЗагружаемых()
	
	// Страница выбора
	ВыбраноРегионовДляЗагрузки = СубъектыРФ.НайтиСтроки( Новый Структура("Загружать", Истина) ).Количество();
	
	// Страница загрузки
	ТекстОписанияЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Загружаются данные по выбранным регионам (%1)'"), ВыбраноРегионовДляЗагрузки);
	
	УстановитьРазрешениеЗагрузки(ВыбраноРегионовДляЗагрузки);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторИзКаталога(Знач КаталогДанных)
	
	КодыРегионов = КодыРегионовДляЗагрузки();
	
	// Проверка доступности и наличия файлов.
	ПараметрыЗагрузки = Новый Структура("КодИсточникаЗагрузки, ПолеОшибки", КодИсточникаЗагрузки, "АдресЗагрузки");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьКлассификаторИзКаталогаЗавершение", ЭтотОбъект);
	АдресныйКлассификаторКлиент.АнализДоступностиФайловКлассификатораВКаталоге(ОписаниеОповещения, КодыРегионов, КаталогДанных, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторИзКаталогаЗавершение(РезультатАнализа, ДополнительныеПараметры) Экспорт
	
	Если РезультатАнализа.Ошибки <> Неопределено Тогда
		// Не хватает файлов для загрузки по указанным режимам.
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(РезультатАнализа.Ошибки);
		Возврат;
	КонецЕсли;
	
	// Загружаем в фоне
	УдалитьПослеПередачиНаСервер = Новый Массив;
	РезультатАнализа.Вставить("УдалитьПослеПередачиНаСервер", УдалитьПослеПередачиНаСервер);
	
	ЗапуститьФоновуюЗагрузкуИзКаталогаКлиента(РезультатАнализа);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторССайта()
	
	КодыРегионов = КодыРегионовДляЗагрузки();
	
	Если НЕ АутентификацияВыполнена Тогда
		// Проходим через форму авторизации принудительно.
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьКлассификаторССайтаЗапросАутентификации", ЭтотОбъект, Новый Структура);
		Оповещение.ДополнительныеПараметры.Вставить("КодыРегионов", КодыРегионов);
		АдресныйКлассификаторКлиент.АвторизоватьНаСайтеПоддержкиПользователей(Оповещение, ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКлассификаторССайтаАутентификация(КодыРегионов);
КонецПроцедуры

// Завершение диалога авторизации.
//
&НаКлиенте
Процедура ЗагрузитьКлассификаторССайтаЗапросАутентификации(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЗагрузитьКлассификаторССайтаАутентификация(ДополнительныеПараметры.КодыРегионов);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторССайтаАутентификация(Знач КодыРегионов)
	
	ОчиститьСообщения();
	
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Загрузка файлов с Портала 1С:ИТС...'");
	
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПрогрессВыполнения", ЭтотОбъект);
	Задание = ЗапуститьФоновуюЗагрузкуССайтаНаСервере(КодыРегионов, ЗагружатьИсториюИзмененийАдресныхОбъектов, УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	НастройкиОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	Обработчик = Новый ОписаниеОповещения("ПослеФоновойЗагрузкиССайта", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);

	// Запущенное
	Элементы.ПрерватьЗагрузку.Доступность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПослеФоновойЗагрузкиССайта(Задание, ДополнительныеПараметры) Экспорт

	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус = "Ошибка" Тогда
		Если СтрНайти(Задание.КраткоеПредставлениеОшибки, "404 Not Found") > 0 ИЛИ СтрНайти(Задание.КраткоеПредставлениеОшибки, "401 Unauthorized") > 0 Тогда
			ТекстОшибки = НСтр("ru = 'Не удается загрузить адресные сведения. Возможные причины:
				| • Некорректно введен или не введен логин и пароль;
				| • Нет подключения к Интернету;
				| • На сайте ведутся технические работы, попробуйте повторить загрузку позднее;
				| • Брандмауэр или другое промежуточное ПО (антивирусы и т.п.) блокируют попытки программы подключиться к Интернету;
				| • Подключение к Интернету выполняется через прокси-сервер, но его параметры не заданы в программе.
				|
				|Техническая информация:'") + Символы.ПС + СтрПолучитьСтроку(Задание.КраткоеПредставлениеОшибки, 1);
		Иначе
			ТекстОшибки = НСтр("ru = 'Вероятно в данный момент на сайте ведутся технические работы. Попробуйте повторить загрузку позднее.
				|Техническая информация:'") + Символы.ПС + Задание.КраткоеПредставлениеОшибки;
		КонецЕсли;
		ВывестиСообщениеОбОшибке(ТекстОшибки);
	ИначеЕсли Задание.Статус = "Выполнено" Тогда
		ЗавершениеЗагрузки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗагрузки()
	
	// Для сброса признака АдресныйКлассификаторУстарел в параметрах работы клиента.
	ОбновитьПовторноИспользуемыеЗначения();
	Оповестить("ЗагруженАдресныйКлассификатор", Истина, ЭтотОбъект);
	
	ПодтверждениеЗакрытияФормы = Истина;
	Если РежимРаботы = "ОБНОВЛЕНИЕ" Тогда
		Закрыть(Истина);
	КонецЕсли;
	
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.УспешноеЗавершение;
	ТекстОписанияЗагрузки = НСтр("ru = 'Адресный классификатор успешно загружен.'");
	Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	ТекущийЭлемент = Элементы.Закрыть;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновуюЗагрузкуССайтаНаСервере(КодыРегионов, ЗагружатьИсторию, УникальныйИдентификатор)
	
	ПараметрыЗагрузки = АдресныйКлассификаторСлужебный.ПараметрыЗагрузкиКлассификатораАдресов();
	ПараметрыЗагрузки.ЗагружатьИсториюАдресов = ЗагружатьИсторию;
	
	ПараметрыВызоваСервера = Новый Массив;
	ПараметрыВызоваСервера.Добавить(КодыРегионов);
	ПараметрыВызоваСервера.Добавить(ПараметрыЗагрузки);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка адресного классификатора с сайта'");

	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("АдресныйКлассификаторСлужебный.ФоновоеЗаданиеЗагрузкиКлассификатораАдресовССайта",
		ПараметрыВызоваСервера, ПараметрыВыполнения);
		
	Возврат ФоновоеЗадание;
КонецФункции

&НаКлиенте
Процедура ПрогрессВыполнения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Выполняется" Тогда
		Прогресс = ПрочитатьПрогресс(Результат.ИдентификаторЗадания);
		Если Прогресс <> Неопределено Тогда
			ТекстСостоянияЗагрузки = Прогресс.Текст;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиента(Знач ПараметрыЗагрузки)
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Передача файлов на сервер приложения...'");
	ПараметрыФоновойЗагрузкиКлассификатора = Неопределено;
	
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
		
	// Список передаваемых на сервер файлов.
	ПомещаемыеФайлы = Новый Массив;
	Для Каждого КлючЗначение Из ПараметрыЗагрузки.ФайлыПоРегионам Цикл
		Если ТипЗнч(КлючЗначение.Значение) = Тип("Массив") Тогда
			Для Каждого ИмяФайла Из КлючЗначение.Значение Цикл
				ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайла));
			КонецЦикла;
		Иначе
			ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(КлючЗначение.Значение));
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыЗагрузки", ПараметрыЗагрузки);
	ДополнительныеПараметры.Вставить("Позиция", 0);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПомещенияФайлов",
		ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы,, Ложь, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПомещенияФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Позиция = ДополнительныеПараметры.Позиция;
	Если Позиция <= ПомещенныеФайлы.ВГраница() Тогда
		
		// Сохраняем время изменения - версию.
		Описание = ПомещенныеФайлы[Позиция];
		ДанныеФайла = Новый Структура("Имя, Хранение");
		ЗаполнитьЗначенияСвойств(ДанныеФайла, Описание);
		ДополнительныеПараметры.Вставить("ДанныеФайла", ДанныеФайла);
		ДополнительныеПараметры.Вставить("ПомещенныеФайлы", ПомещенныеФайлы);
		Файл = Новый Файл(Описание.ПолноеИмя);
		Файл.НачатьПолучениеУниверсальногоВремениИзменения(Новый ОписаниеОповещения("ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПолученияВремениИзменения",
			ЭтотОбъект, ДополнительныеПараметры));
		
	Иначе // выход из цикла
		
		Режим = Неопределено;
		ДополнительныеПараметры.ПараметрыЗагрузки.Свойство("Режим", Режим);
		
		ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПрогрессВыполнения", ЭтотОбъект);
		Задание = ЗапуститьФоновуюЗагрузкуНаСервере(ДополнительныеПараметры.ПараметрыЗагрузки.КодыРегионов, ПомещенныеФайлы, Режим, ЗагружатьИсториюИзмененийАдресныхОбъектов, УникальныйИдентификатор);
		
		НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
		НастройкиОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
		Обработчик = Новый ОписаниеОповещения("ПослеФоновойЗагрузкиИзКаталога", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);

		// Запущенное 
		Элементы.ПрерватьЗагрузку.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФоновойЗагрузкиИзКаталога(Задание, ДополнительныеПараметры) Экспорт

	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус = "Ошибка" Тогда
		
		ТекстОшибки = НСтр("ru = 'Не удается загрузить адресные сведения из файлов.'");
		ТекстОшибки = ТекстОшибки + НСтр("ru = 'Необходимо сохранить файлы с сайта «1С» http://its.1c.ru/download/fias2 на диск, а затем загрузить в программу.'") + Символы.ПС;
		ТекстОшибки = ТекстОшибки + НСтр("ru = 'Техническая информация:'") + Символы.ПС + Задание.КраткоеПредставлениеОшибки;
		ВывестиСообщениеОбОшибке(ТекстОшибки);
		
		Возврат;
	ИначеЕсли Задание.Статус = "Выполнено" Тогда
		ЗавершениеЗагрузки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСообщениеОбОшибке(Знач ТекстОшибки)
	ОчиститьСообщения();
	ПоказатьПредупреждение(, ТекстОшибки);
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПолученияВремениИзменения(ВремяИзменения, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ДанныеФайла.Вставить("ВремяИзменения", ВремяИзменения);
	ДополнительныеПараметры.ПомещенныеФайлы[ДополнительныеПараметры.Позиция] = ДополнительныеПараметры.ДанныеФайла;
	ДополнительныеПараметры.Позиция = ДополнительныеПараметры.Позиция + 1;
	ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПомещенияФайлов(ДополнительныеПараметры.ПомещенныеФайлы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновуюЗагрузкуНаСервере(Знач КодыРегионов, Знач ОписаниеФайловЗагрузки, Знач Режим, Знач ЗагружатьИсториюИзмененийАдресныхОбъектов, Знач УникальныйИдентификатор)
	
	Коды = Новый Массив;
	Для каждого КодРегиона Из КодыРегионов Цикл
		Коды.Добавить(КодРегиона.Значение);
	КонецЦикла;
	
	ПараметрыЗагрузки = АдресныйКлассификаторСлужебный.ПараметрыЗагрузкиКлассификатораАдресов();
	ПараметрыЗагрузки.ЗагружатьИсториюАдресов = ЗагружатьИсториюИзмененийАдресныхОбъектов;
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(Коды);
	
	// Файлы преобразуем в двоичные данные - хранилище не может быть разделено с сеансом фонового задания.
	ОписаниеФайлов = Новый Массив;
	Для Каждого Описание Из ОписаниеФайловЗагрузки Цикл
		ДанныеФайла = Новый Структура("Имя, ВремяИзменения");
		ЗаполнитьЗначенияСвойств(ДанныеФайла, Описание);
		ДанныеФайла.Вставить("Хранение", ПолучитьИзВременногоХранилища(Описание.Хранение));
		ОписаниеФайлов.Добавить(ДанныеФайла);
	КонецЦикла;
	ПараметрыМетода.Добавить(ОписаниеФайлов);
	ПараметрыМетода.Добавить(ПараметрыЗагрузки);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка адресного классификатора'");
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("АдресныйКлассификаторСлужебный.ФоновоеЗаданиеЗагрузкиКлассификатораАдресов",
		ПараметрыМетода, ПараметрыВыполнения);
		
	Возврат ФоновоеЗадание;
	
КонецФункции

&НаКлиенте
Функция КодыРегионовДляЗагрузки()
	Результат = Новый СписокЗначений;
	
	Для Каждого Регион Из СубъектыРФ.НайтиСтроки(Новый Структура("Загружать", Истина)) Цикл
		Результат.Добавить(Регион.КодСубъектаРФ, Регион.Представление);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеАутентификацииСайтаСохранены()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		Возврат МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеВыбораКаталогаАдресаЗагрузки(Каталог, ДополнительныеПараметры) Экспорт
	
	УстановитьИсточникомЗагрузкиКаталог();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИсточникомЗагрузкиКаталог()
	
	КодИсточникаЗагрузки = "КАТАЛОГ";

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьИсточниковЗагрузки()
	
	Элементы.АдресЗагрузки.Доступность = КодИсточникаЗагрузки = "КАТАЛОГ";
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВСпискеРегионов(Знач Текст)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Отбор = Новый ФиксированнаяСтруктура(Новый Структура("Представление", Текст));
		Элементы.СубъектыРФ.ОтборСтрок = Отбор;
	Иначе
		Элементы.СубъектыРФ.ОтборСтрок = Неопределено;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
