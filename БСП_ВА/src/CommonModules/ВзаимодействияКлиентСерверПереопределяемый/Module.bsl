///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Задает типы предметов взаимодействий, например: заказы, вакансии и т.п.
// Используется, если в конфигурации определен хотя бы один предмет взаимодействий. 
//
// Параметры:
//  ТипыПредметов  - Массив - предметы взаимодействий (Строка),
//                            например, "ДокументСсылка.ЗаказПокупателя" и т.п.
//
Процедура ПриОпределенииВозможныхПредметов(ТипыПредметов) Экспорт
	
	// _Демо начало примера
	ТипыПредметов.Добавить("ДокументСсылка._ДемоЗаказПокупателя");
	// _Демо конец примера
	
КонецПроцедуры

// Задает описания возможных типов контактов взаимодействий, например: партнеры, контактные лица и т.п.
// Используется, если в конфигурации определен хотя бы один тип контактов взаимодействий,
// помимо справочника Пользователи. 
//
// Параметры:
//  ТипыКонтактов - Массив - содержит описания типов контактов взаимодействий (Структура) и их свойства:
//     * Тип                               - Тип    - тип ссылки контакта.
//     * Имя                               - Строка - имя типа контакта , как оно определено в метаданных.
//     * Представление                     - Строка - представление типа контакта для отображения пользователю.
//     * Иерархический                     - Булево - признак того, является ли справочник иерархическим.
//     * ЕстьВладелец                      - Булево - признак того, что у контакта есть владелец.
//     * ИмяВладельца                      - Строка - имя владельца контакта, как оно определено в метаданных.
//     * ИскатьПоДомену                    - Булево - признак того, что контакты данного типа будет подбираться
//                                                    по совпадению домена, а не по полному адресу электронной почты.
//     * Связь                             - Строка - описывает возможную связь данного контакта с другим контактом, в
//                                                    случае когда текущий контакт является реквизитом другого контакта.
//                                                    Описывается следующей строкой "ИмяТаблицы.ИмяРеквизита".
//     * ИмяРеквизитаПредставлениеКонтакта - Строка - имя реквизита контакта, из которого будет получено
//                                                    представление контакта. Если не указано, то используется
//                                                    стандартный реквизит Наименование.
//     * ВозможностьИнтерактивногоСоздания - Булево - признак возможности интерактивного создания контакта из
//                                                    документов - взаимодействий.
//     * ИмяФормыНовогоКонтакта            - Строка - полное имя формы для создания нового контакта.
//                                                    Например, "Справочник.Партнеры.Форма.ПомощникНового".
//                                                    Если не заполнено, то открывается форма элемента по умолчанию.
//
Процедура ПриОпределенииВозможныхКонтактов(ТипыКонтактов) Экспорт

	// _Демо начало примера
	Контакт = ВзаимодействияКлиентСервер.НовоеОписаниеКонтакта();
	Контакт.Тип = Тип("СправочникСсылка._ДемоПартнеры");
	Контакт.Имя = "_ДемоПартнеры";
	Контакт.Представление = НСтр("ru = 'Демо: Партнеры'");
	Контакт.Иерархический = Истина;
	ТипыКонтактов.Добавить(Контакт);
	
	Контакт = ВзаимодействияКлиентСервер.НовоеОписаниеКонтакта();
	Контакт.Тип = Тип("СправочникСсылка._ДемоКонтактныеЛицаПартнеров");
	Контакт.Имя = "_ДемоКонтактныеЛицаПартнеров";
	Контакт.Представление = НСтр("ru = 'Демо: Контактные лица партнеров'");
	Контакт.ЕстьВладелец = Истина;
	Контакт.ИмяВладельца = "_ДемоПартнеры";
	ТипыКонтактов.Добавить(Контакт);
	// _Демо конец примера

КонецПроцедуры

#КонецОбласти



