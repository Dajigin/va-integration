///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает наименования видов контактной информации на разных языках.
//
// Параметры:
//  Наименования - Соответствие - представление вида контактной информации на переданном языке:
//     * Ключ     - Строка - Имя вида контактной информации. Например, "_ДемоАдресПартнера".
//     * Значение - Строка - Наименование вида контактной информации для переданного кода языка.
//  КодЯзыка - Строка - Код языка. Например, "en".
//
// Пример:
//  Наименования["_ДемоАдресПартнера"] = НСтр("ru='Адрес'; en='Address';", КодЯзыка);
//
Процедура ПриПолученииНаименованийВидовКонтактнойИнформации(Наименования, КодЯзыка) Экспорт
	
	// _Демо начало примера
	
	// Контактная информация справочника "Партнеры"
	Наименования["_ДемоАдресПартнера"]   = НСтр("ru = 'Адрес'", КодЯзыка);
	Наименования["_ДемоТелефонПартнера"] = НСтр("ru = 'Телефон партнера'", КодЯзыка);
	Наименования["_ДемоEmailПартнера"]   = НСтр("ru = 'Электронная почта партнера'", КодЯзыка);
	Наименования["_ДемоВебСайтПартнера"] = НСтр("ru = 'Веб-сайт'", КодЯзыка);
	
	// Контактная информация справочника "Демо: Организации"
	Наименования["_ДемоЮридическийАдресОрганизации"]   = НСтр("ru = 'Юридический адрес'", КодЯзыка);
	Наименования["_ДемоФактическийАдресОрганизации"]   = НСтр("ru = 'Фактический адрес'", КодЯзыка);
	Наименования["_ДемоПочтовыйАдресОрганизации"]      = НСтр("ru = 'Почтовый адрес'", КодЯзыка);
	Наименования["_ДемоМеждународныйАдресОрганизации"] = НСтр("ru = 'Международный адрес для платежей / Address for payments'", КодЯзыка);
	Наименования["_ДемоТелефонОрганизации"]            = НСтр("ru = 'Телефон'", КодЯзыка);
	Наименования["_ДемоФаксОрганизации"]               = НСтр("ru = 'Факс'", КодЯзыка);
	Наименования["_ДемоEmailОрганизации"]              = НСтр("ru = 'Электронная почта'", КодЯзыка);
	Наименования["_ДемоДругаяИнформацияОрганизации"]   = НСтр("ru = 'Другое'", КодЯзыка);
	
	// Контактная информация справочника "Контрагенты"
	Наименования["_ДемоАдресКонтрагента"] = НСтр("ru = 'Адрес'", КодЯзыка);
	Наименования["_ДемоEmailКонтрагента"] = НСтр("ru = 'Электронная почта'", КодЯзыка);
	Наименования["_ДемоSkypeКонтрагенты"] = НСтр("ru = 'Skype'", КодЯзыка);
	
	// Контактная информация справочника "Контактные лица партнеров"
	Наименования["_ДемоАдресКонтактногоЛица"] = НСтр("ru = 'Адрес контактного лица'", КодЯзыка);
	Наименования["_ДемоEmailКонтактногоЛица"] = НСтр("ru = 'Электронная почта контактного лица'", КодЯзыка);
	
	// Контактная информация справочника "Демо: Физические лица"
	Наименования["_ДемоEmailФизическогоЛица"] = НСтр("ru = 'Электронная почта'", КодЯзыка);
	
	// Контактная информация табличной части "Партнеры и контактные лица"
	// Контактная информация документа "Заказ покупателя"
	Наименования["_ДемоПартнерыИКонтактныеЛицаАдресПартнера"]   = НСтр("ru = 'Адрес партнера'", КодЯзыка);
	Наименования["_ДемоПартнерыИКонтактныеЛицаТелефонПартнера"] = НСтр("ru = 'Телефон партнера'", КодЯзыка);
	Наименования["_ДемоПартнерыИКонтактныеЛицаEmailПартнера"]   = НСтр("ru = 'Электронная почта'", КодЯзыка);
	
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
