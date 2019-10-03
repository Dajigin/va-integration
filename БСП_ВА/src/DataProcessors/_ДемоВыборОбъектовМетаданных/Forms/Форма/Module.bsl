///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбранныйОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = ПараметрыФормы(ВыбранныйОбъект, Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбранныйОбъектНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовМетаданных", ПараметрыФормы,,,,, ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПараметрыФормы = ПараметрыФормы(Объект.ОбъектыМетаданных, Ложь);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВыборОбъектовМетаданных", ПараметрыФормы,,,,, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбранныйОбъектНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ВыбранныйОбъект = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Объект.ОбъектыМетаданных = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПараметрыФормы(ВыбранныеОбъекты, ВыборЕдинственного)
	
	ОтборМетаданных = Неопределено;
	Если ТолькоСправочникиИДокументы Тогда
		ОтборМетаданных = Новый СписокЗначений;
		ОтборМетаданных.Добавить("Справочники");
		ОтборМетаданных.Добавить("Документы");
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КоллекцииВыбираемыхОбъектовМетаданных", ОтборМетаданных);
	ПараметрыФормы.Вставить("ВыбранныеОбъектыМетаданных", ВыбранныеОбъекты);
	ПараметрыФормы.Вставить("УникальныйИдентификаторИсточник", УникальныйИдентификатор);
	ПараметрыФормы.Вставить("ВыборЕдинственного", ВыборЕдинственного);
	
	Возврат ПараметрыФормы;
	
КонецФункции

#КонецОбласти