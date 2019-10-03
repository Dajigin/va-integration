///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиСобытийЭлементовТаблицыФормыДвижения

&НаКлиенте
Процедура Движения_ДемоОстаткиТоваровВМестахХраненияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		СтрокаДанные = Элементы.Движения_ДемоОстаткиТоваровВМестахХранения.ТекущиеДанные;
		СтрокаДанные.Период = Объект.Дата;
		СтрокаДанные.ВидДвижения = ВидДвиженияНакопления.Приход;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти