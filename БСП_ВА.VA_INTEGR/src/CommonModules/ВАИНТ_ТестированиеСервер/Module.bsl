#Область СлужебныйПрограммныйИнтерфейс
Функция ОписаниеОбъектаПоИмениФормы(ИмяФормы) Экспорт
	КонечнаяПозиция = СтрНайти(ИмяФормы, ".Форма.");
	ИмяВладельца = Лев(ИмяФормы, КонечнаяПозиция-1);
	КонечнаяПозиция = СтрНайти(ИмяФормы, ".");
	ТипОбъекта = Лев(ИмяФормы, КонечнаяПозиция-1);
	ОбъектВладелец = Метаданные.НайтиПоПолномуИмени(ИмяВладельца);
	Результат = Новый Структура("ТипВладельца, ИмяВладельца, Формы",ТипОбъекта, ОбъектВладелец.Имя, Новый Массив);

	Для Каждого ФормаЭлемента Из ОбъектВладелец.Формы Цикл
		Результат.Формы.Добавить(ФормаЭлемента.Имя);
	КонецЦикла;
	Возврат Результат;
КонецФункции


// Преобразует соответствие в дерево значений
// 
// Параметры:
// 	ПреобразуемоеСоответствие - Соответствие - соответствие полями:
// 	* Ключ - Строка - наименование
// 	* Значение - Структура - структура с обязателиным полем "ПодчиненныеЭлементы" типа Соответствие
// 							 Остальные поля копируются в соответствующие поля дерева значений.
// 	Дерево - ДеревоЗначений - 
Процедура СоответствиеВДеревоЗначений(ПреобразуемоеСоответствие, Дерево) Экспорт
	Если ПреобразуемоеСоответствие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Для Каждого КлючИЗначение Из ПреобразуемоеСоответствие Цикл
		СтруктураЭлемента = КлючИЗначение.Значение;
		НоваяСтрока = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураЭлемента);
		СоответствиеВДеревоЗначений(СтруктураЭлемента.ПодчиненныеЭлементы, НоваяСтрока);
	КонецЦикла; 
КонецПроцедуры
#КонецОбласти

