
#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
// Параметры:
//	Версия - Строка - версия интерфейса
//
Функция Пакет(Знач Версия = "") Экспорт
	
	Если ПустаяСтрока(Версия) Тогда
		
		Версия = Версия();
		
	КонецЕсли;
	
	Возврат "http://www.1c.ru/1cFresh/ConfigurationExtensions/Manifest/" + Версия;
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений
Функция Версия() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ConfigurationExtensionsCore";
	
КонецФункции

// Выполняет регистрацию поддерживаемых версий интерфейса сообщений
//
// Параметры:
//  СтруктураПоддерживаемыхВерсий - Структура - описание поддерживаемых версий:
//		* Ключ - Строка - название программного интерфейса
//		* Значение - Массив - массив поддерживаемых версий.
//
Процедура ЗарегистрироватьИнтерфейс(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.0.1");
	СтруктураПоддерживаемыхВерсий.Вставить(ПрограммныйИнтерфейс(), МассивВерсий);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - Массив - содержит обработчики
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Возвращает тип {http://www.1c.ru/1cFresh/ConfigurationExtensions/Core/a.b.c.d}Manifest
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO
//
Функция ТипМанифест(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "Manifest");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
		
	Если ИспользуемыйПакет = Неопределено Тогда
		
		ИспользуемыйПакет = Пакет();
		
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти