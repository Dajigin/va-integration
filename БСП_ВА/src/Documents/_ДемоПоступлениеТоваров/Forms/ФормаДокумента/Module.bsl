///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЭтоТовары = Не ОбщегоНазначения.ПустойБуферОбмена("Товары");
	Элементы.ТоварыВставитьСтроки.Доступность = ЭтоТовары;
	Элементы.ТоварыВставитьСтрокиМеню.Доступность = ЭтоТовары;
	
	Элементы.НДС.Видимость = Объект.УчитыватьНДС Или ПолучитьФункциональнуюОпцию("_ДемоУчитыватьНДС");
	Элементы.СтавкаНДС.Доступность = Объект.УчитыватьНДС;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ГруппаСтандартныеРеквизиты.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		Элементы.ГруппаОсновныеРеквизиты.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		Элементы.ТоварыНомерСтроки.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОпределитьНоменклатуруТребующуюВводГТД();
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	Если ЗначениеЗаполнено(Объект.СчетФактура) Тогда
		Элементы.ГруппаОтображениеСчетаФактура.ТекущаяСтраница = Элементы.ГруппаСчетФактура;
	Иначе
		Элементы.ГруппаОтображениеСчетаФактура.ТекущаяСтраница = Элементы.ГруппаВыписатьСчетФактуру;
	КонецЕсли;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСчетчикиСтрокТаблиц();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ОпределитьНоменклатуруТребующуюВводГТД();
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПослеЗаписиНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись__ДемоПоступлениеТоваров", , Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДанныеСкопированыВБуферОбмена" Тогда
		ЭтоТовары = (Параметр.Источник = "Товары");
		Элементы.ТоварыВставитьСтроки.Доступность = ЭтоТовары;
		Элементы.ТоварыВставитьСтрокиМеню.Доступность = ЭтоТовары;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УчитыватьНДСПриИзменении(Элемент)
	Элементы.СтавкаНДС.Доступность = Объект.УчитыватьНДС;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	ОбновитьСчетчикиСтрокТаблиц();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	Если Элементы.Товары.ТекущиеДанные <> Неопределено Тогда
		Элементы.Товары.ТекущиеДанные.ТребуетсяВводГТД = ОпределитьНеобходимостьГТД(Элементы.Товары.ТекущиеДанные.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАгентскиеУслуги

&НаКлиенте
Процедура АгентскиеУслугиПриИзменении(Элемент)
	ОбновитьСчетчикиСтрокТаблиц();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыписатьСчетФактуру(Команда)
	ВыписатьСчетФактуруСервер();
	Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если Элементы.Товары.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	СкопироватьСтрокиНаСервере();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Копирование в буфер обмена'"), Окно.ПолучитьНавигационнуюСсылку(), 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Скопировано товаров: %1'"), Элементы.Товары.ВыделенныеСтроки.Количество()));
	Оповестить("ДанныеСкопированыВБуферОбмена", Новый Структура("Источник", "Товары"), Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	Количество = ВставитьСтрокиНаСервере();
	Если Количество > 0 Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Вставка из буфера обмена'"), Окно.ПолучитьНавигационнуюСсылку(), 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вставлено товаров: %1'"), Количество));
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСчетчикиСтрокТаблиц()
	УстановитьЗаголовокСтраницы(Элементы.СтраницаТовары, Объект.Товары, НСтр("ru = 'Товары'"));
	УстановитьЗаголовокСтраницы(Элементы.СтраницаАгентскиеУслуги, Объект.АгентскиеУслуги, НСтр("ru = 'Агентские услуги'"));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокСтраницы(ЭлементСтраница, РеквизитТабличнаяЧасть, ЗаголовокПоУмолчанию)
	ЗаголовокСтраницы = ЗаголовокПоУмолчанию;
	Если РеквизитТабличнаяЧасть.Количество() > 0 Тогда
		ЗаголовокСтраницы = ЗаголовокПоУмолчанию + " (" + РеквизитТабличнаяЧасть.Количество() + ")";
	КонецЕсли;
	ЭлементСтраница.Заголовок = ЗаголовокСтраницы;
КонецПроцедуры

&НаСервере
Процедура ВыписатьСчетФактуруСервер()
	Если ПроверитьЗаполнение() Тогда
		ПоступлениеОбъект = РеквизитФормыВЗначение("Объект");
		Если Модифицированность Тогда
			ПоступлениеОбъект.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
		
		СчетФактураОбъект = Документы._ДемоСчетФактураПолученный.СоздатьДокумент();
		СчетФактураОбъект.Комитент = Объект.Контрагент;
		СчетФактураОбъект.Контрагент = Объект.Контрагент;
		СчетФактураОбъект.Продавец = Объект.Контрагент;
		СчетФактураОбъект.Дата = Объект.Дата;
		СчетФактураОбъект.Записать();
		
		ПоступлениеОбъект.СчетФактура = СчетФактураОбъект.Ссылка;
		ПоступлениеОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		ЗначениеВРеквизитФормы(ПоступлениеОбъект, "Объект");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	ОбщегоНазначения.СкопироватьСтрокиВБуферОбмена(Объект.Товары, Элементы.Товары.ВыделенныеСтроки, "Товары");

КонецПроцедуры

&НаСервере
Функция ВставитьСтрокиНаСервере()
	
	ДанныеИзБуфераОбмена = ОбщегоНазначения.СтрокиИзБуфераОбмена();
	Если ДанныеИзБуфераОбмена.Источник <> "Товары" Тогда
		Возврат 0;
	КонецЕсли;
		
	Таблица = ДанныеИзБуфераОбмена.Данные;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(Объект.Товары.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	
	ОпределитьНоменклатуруТребующуюВводГТД();
	
	Возврат Таблица.Количество();
	
КонецФункции

&НаСервере
Процедура ОпределитьНоменклатуруТребующуюВводГТД()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Товар.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ Товар
	|ИЗ
	|	&Товар КАК Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товар.Номенклатура КАК Номенклатура
	|ИЗ
	|	Товар КАК Товар
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник._ДемоНоменклатура КАК _ДемоНоменклатура
	|		ПО (Товар.Номенклатура = _ДемоНоменклатура.Ссылка)
	|ГДЕ 
	|	НЕ ЕСТЬNULL(_ДемоНоменклатура.СтранаПроисхождения.УчастникЕАЭС, ИСТИНА) = ИСТИНА";
	
	Запрос.УстановитьПараметр("Товар", Объект.Товары.Выгрузить(, "Номенклатура"));
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		Отбор = Новый Структура("Номенклатура", РезультатЗапроса.Номенклатура);
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Отбор);
		Для каждого СтрокаГдеТребуетсяГТД  Из НайденныеСтроки Цикл
			СтрокаГдеТребуетсяГТД.ТребуетсяВводГТД = Истина;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьНеобходимостьГТД(Номенклатура)
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат НЕ УправлениеКонтактнойИнформацией.ЭтоСтранаУчастникЕАЭС(Номенклатура.СтранаПроисхождения);
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ГруппаЭлементовОтбораДанных               = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбораДанных.ТипГруппы     = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ГруппаЭлементовОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных                = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Товары.ТребуетсяВводГТД");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОтбораДанных                = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Товары.НомерГТД");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля               = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле          = Новый ПолеКомпоновкиДанных(Элементы.ТоварыНомерГТД.Имя);
	ЭлементОформляемогоПоля.Использование = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.КонтрольВеденияУчета
&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

#КонецОбласти