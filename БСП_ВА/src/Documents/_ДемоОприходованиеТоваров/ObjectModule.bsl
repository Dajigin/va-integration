///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
//
// Параметры:
//   Таблица - ТаблицаЗначений - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения:    Организация И МестоХранения.
	// Изменения: Организация И МестоХранения И Ответственный.
	
	// Чтение: набор №1.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.ЗначениеДоступа = МестоХранения;
	
	// Добавление, Изменение: набор №2.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.Изменение       = Истина;
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.ЗначениеДоступа = МестоХранения;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.ЗначениеДоступа = Ответственный;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвиженияПоМестамХранения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияПоМестамХранения()
	
	Движения._ДемоОстаткиТоваровВМестахХранения.Записывать = Истина;
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		Движение = Движения._ДемоОстаткиТоваровВМестахХранения.Добавить();
		
		Движение.Период        = Дата;
		Движение.ВидДвижения   = ВидДвиженияНакопления.Приход;
		
		Движение.Организация   = Организация;
		Движение.МестоХранения = МестоХранения;
		
		Движение.Номенклатура  = СтрокаТовары.Номенклатура;
		Движение.Количество    = СтрокаТовары.Количество;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли