///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик чтения настроек варианта отчета.
//
// Параметры:
//   КлючОтчета        - Строка - Полное имя отчета с точкой.
//   КлючВарианта      - Строка - Ключ варианта отчета.
//   Настройки         - Произвольный     - Настройки варианта отчета.
//   ОписаниеНастроек  - ОписаниеНастроек - Дополнительное описание настроек.
//   Пользователь      - Строка           - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаЗагрузки" в синтакс-помощнике.
//
Процедура ОбработкаЗагрузки(КлючОтчета, КлючВарианта, Настройки, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоЧтения() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(КлючОтчета, Истина);
		ОтчетСсылка = ОтчетИнформация.Отчет;
	Иначе
		ОтчетСсылка = КлючОтчета;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВариантыОтчетов.Представление,
	|	ВариантыОтчетов.Настройки
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Отчет = &Отчет
	|	И ВариантыОтчетов.КлючВарианта = &КлючВарианта");
	
	Запрос.УстановитьПараметр("Отчет",        ОтчетСсылка);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ОписаниеНастроек = Неопределено Тогда
			ОписаниеНастроек = Новый ОписаниеНастроек;
			ОписаниеНастроек.КлючОбъекта  = КлючОтчета;
			ОписаниеНастроек.КлючНастроек = КлючВарианта;
			ОписаниеНастроек.Пользователь = Пользователь;
		КонецЕсли;
		ОписаниеНастроек.Представление = Выборка.Представление;
		Настройки = Выборка.Настройки.Получить();
	КонецЕсли;
КонецПроцедуры

// Обработчик записи настроек варианта отчета.
//
// Параметры:
//   КлючОтчета        - Строка - Полное имя отчета с точкой.
//   КлючВарианта      - Строка - Ключ варианта отчета.
//   Настройки         - Произвольный         - Настройки варианта отчета.
//   ОписаниеНастроек  - ОписаниеНастроек     - Дополнительное описание настроек.
//   Пользователь      - Строка, Неопределено - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаСохранения" в синтакс-помощнике.
//
Процедура ОбработкаСохранения(КлючОтчета, КлючВарианта, Настройки, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоДобавления() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для сохранения вариантов отчетов'");
	КонецЕсли;
	
	ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(КлючОтчета, Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетов.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Отчет = &Отчет
	|	И ВариантыОтчетов.КлючВарианта = &КлючВарианта");
	
	Запрос.УстановитьПараметр("Отчет",        ОтчетИнформация.Отчет);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	СсылкаВарианта = Выборка.Ссылка;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СсылкаВарианта);
		Блокировка.Заблокировать();
		
		ВариантОбъект = СсылкаВарианта.ПолучитьОбъект();
		Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда // Для платформы.
			Адрес = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Настройки.ДополнительныеСвойства, "Адрес");
			Если ТипЗнч(Адрес) = Тип("Строка") И ЭтоАдресВременногоХранилища(Адрес) Тогда
				Настройки = ПолучитьИзВременногоХранилища(Адрес);
			КонецЕсли;
		КонецЕсли;
		ВариантОбъект.Настройки = Новый ХранилищеЗначения(Настройки);
		Если ОписаниеНастроек <> Неопределено Тогда
			ВариантОбъект.Наименование = ОписаниеНастроек.Представление;
		КонецЕсли;
		ВариантОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработчик получения описания настроек варианта отчета.
//
// Параметры:
//   КлючОтчета       - Строка - Полное имя отчета с точкой.
//   КлючВарианта     - Строка - Ключ варианта отчета.
//   ОписаниеНастроек - ОписаниеНастроек     - Дополнительное описание настроек.
//   Пользователь     - Строка, Неопределено - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаПолученияОписания" в синтакс-помощнике.
//
Процедура ОбработкаПолученияОписания(КлючОтчета, КлючВарианта, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоЧтения() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(КлючОтчета, Истина);
		ОтчетСсылка = ОтчетИнформация.Отчет;
	Иначе
		ОтчетСсылка = КлючОтчета;
	КонецЕсли;
	
	Если ОписаниеНастроек = Неопределено Тогда
		ОписаниеНастроек = Новый ОписаниеНастроек;
	КонецЕсли;
	
	ОписаниеНастроек.КлючОбъекта  = КлючОтчета;
	ОписаниеНастроек.КлючНастроек = КлючВарианта;
	
	Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
		ОписаниеНастроек.Пользователь = Пользователь;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Варианты.Представление,
	|	Варианты.ПометкаУдаления,
	|	Варианты.Пользовательский
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.КлючВарианта = &КлючВарианта");
	
	Запрос.УстановитьПараметр("Отчет",        ОтчетСсылка);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ОписаниеНастроек.Представление = Выборка.Представление;
		ОписаниеНастроек.ДополнительныеСвойства.Вставить("ПометкаУдаления", Выборка.ПометкаУдаления);
		ОписаниеНастроек.ДополнительныеСвойства.Вставить("Пользовательский", Выборка.Пользовательский);
	КонецЕсли;
КонецПроцедуры

// Обработчик установки описания настроек варианта отчета.
//
// Параметры:
//   КлючОтчета       - Строка - Полное имя отчета с точкой.
//   КлючВарианта     - Строка - Ключ варианта отчета.
//   ОписаниеНастроек - ОписаниеНастроек - Дополнительное описание настроек.
//   Пользователь     - Строка           - Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
// См. также:
//   "ХранилищеНастроекМенеджер.<Имя хранилища>.ОбработкаУстановкиОписания" в синтакс-помощнике.
//
Процедура ОбработкаУстановкиОписания(КлючОтчета, КлючВарианта, ОписаниеНастроек, Пользователь)
	Если Не ВариантыОтчетовПовтИсп.ПравоДобавления() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для сохранения вариантов отчетов'");
	КонецЕсли;
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(КлючОтчета, Истина);
		ОтчетСсылка = ОтчетИнформация.Отчет;
	Иначе
		ОтчетСсылка = КлючОтчета;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Варианты.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.КлючВарианта = &КлючВарианта");
	
	Запрос.УстановитьПараметр("Отчет",        ОтчетСсылка);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	СсылкаВарианта = Выборка.Ссылка;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СсылкаВарианта);
		Блокировка.Заблокировать();
		
		ВариантОбъект = СсылкаВарианта.ПолучитьОбъект();
		ВариантОбъект.Наименование = ОписаниеНастроек.Представление;
		ВариантОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

#КонецЕсли

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:361-выкл В инструкцию препроцессора обернута не вся функция, а только ее реализация, чтобы она всегда возвращала
// значение типа СписокЗначений

// Возвращает список вариантов отчета пользователя.
//
Функция ПолучитьСписок(КлючОтчета, Знач Пользователь = Неопределено) Экспорт // АПК:307 Является аналогом метода стандартного хранилища настроек
	Список = Новый СписокЗначений;

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	Если ТипЗнч(КлючОтчета) = Тип("Строка") Тогда
		ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(КлючОтчета, Истина);
		Отчет = ОтчетИнформация.Отчет;
	Иначе
		Отчет = КлючОтчета;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Варианты.КлючВарианта,
	|	Варианты.Наименование
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.Автор = &Автор
	|	И Варианты.Автор.ИдентификаторПользователяИБ = &GUID
	|	И НЕ Варианты.ПометкаУдаления
	|	И Варианты.Пользовательский");
	
	Запрос.УстановитьПараметр("Отчет", Отчет);
	
	Если Пользователь = "" Тогда
		Пользователь = Пользователи.СсылкаНеуказанногоПользователя();
	ИначеЕсли Пользователь = Неопределено Тогда
		Пользователь = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		Запрос.УстановитьПараметр("Автор", Пользователь);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Автор.ИдентификаторПользователяИБ = &GUID", "");
	Иначе
		Если ТипЗнч(Пользователь) = Тип("УникальныйИдентификатор") Тогда
			ИдентификаторПользователя = Пользователь;
		Иначе
			Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
				УстановитьПривилегированныйРежим(Истина);
				ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
				УстановитьПривилегированныйРежим(Ложь);
				Если ПользовательИБ = Неопределено Тогда
					Возврат Список;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Пользователь) = Тип("ПользовательИнформационнойБазы") Тогда
				ПользовательИБ = Пользователь;
			Иначе
				Возврат Список;
			КонецЕсли;
			ИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		Запрос.УстановитьПараметр("GUID", ИдентификаторПользователя);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Автор = &Автор", "");
	КонецЕсли;
	
	ТаблицаВариантов = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
		Список.Добавить(СтрокаТаблицы.КлючВарианта, СтрокаТаблицы.Наименование);
	КонецЦикла;
#КонецЕсли

	Возврат Список;
КонецФункции

// АПК:361-вкл

Процедура Удалить(КлючОтчета, КлючВарианта, Знач Пользователь) Экспорт
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Варианты.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.Отчет = &Отчет
	|	И Варианты.Автор = &Автор
	|	И Варианты.Автор.ИдентификаторПользователяИБ = &GUID
	|	И Варианты.КлючВарианта = &КлючВарианта
	|	И НЕ Варианты.ПометкаУдаления
	|	И Варианты.Пользовательский";
	
	Запрос = Новый Запрос;
	
	Если КлючОтчета = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Варианты.Отчет = &Отчет", "ИСТИНА");
	Иначе
		ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(КлючОтчета, Истина);
		Запрос.УстановитьПараметр("Отчет", ОтчетИнформация.Отчет);
	КонецЕсли;
	
	Если КлючВарианта = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.КлючВарианта = &КлючВарианта", "");
	Иначе
		Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	КонецЕсли;
	
	Если Пользователь = "" Тогда
		Пользователь = Пользователи.СсылкаНеуказанногоПользователя();
	КонецЕсли;
	
	Если Пользователь = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор = &Автор", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор.ИдентификаторПользователяИБ = &GUID", "");
		
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		Запрос.УстановитьПараметр("Автор", Пользователь);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор.ИдентификаторПользователяИБ = &GUID", "");
		
	Иначе
		Если ТипЗнч(Пользователь) = Тип("УникальныйИдентификатор") Тогда
			ИдентификаторПользователя = Пользователь;
		Иначе
			Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
				УстановитьПривилегированныйРежим(Истина);
				ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
				УстановитьПривилегированныйРежим(Ложь);
				Если ПользовательИБ = Неопределено Тогда
					Возврат;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Пользователь) = Тип("ПользовательИнформационнойБазы") Тогда
				ПользовательИБ = Пользователь;
			Иначе
				Возврат;
			КонецЕсли;
			ИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		Запрос.УстановитьПараметр("GUID", ИдентификаторПользователя);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Автор = &Автор", "");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ВариантОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВариантОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
#КонецЕсли
КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ДобавитьВариантыВнешнегоОтчета(ВариантыОтчета, ПолноеИмяОтчета, ИмяОтчета) Экспорт 
	Попытка
		ОтчетОбъект = ОтчетыСервер.ОтчетОбъект(ПолноеИмяОтчета);
	Исключение
		ШаблонСообщения = НСтр("ru = 'Не удалось получить список предопределенных вариантов внешнего отчета ""%1"":%2%3'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, ИмяОтчета, Символы.ПС, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВариантыОтчетов.ЗаписатьВЖурнал(УровеньЖурналаРегистрации.Ошибка, Сообщение, ПолноеИмяОтчета);
		
		Возврат Ложь;
	КонецПопытки;
	
	Если ОтчетОбъект.СхемаКомпоновкиДанных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого ВариантНастроекКД Из ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Вариант = ВариантыОтчета.Добавить();
		Вариант.Пользовательский = Ложь;
		Вариант.Наименование = ВариантНастроекКД.Представление;
		Вариант.КлючВарианта = ВариантНастроекКД.Имя;
		Вариант.ТолькоДляАвтора = Ложь;
		Вариант.АвторТекущийПользователь = Ложь;
		Вариант.Порядок = 1;
		Вариант.ИндексКартинки = 5;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

#КонецЕсли

#КонецОбласти