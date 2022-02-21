//@strict-types
#Область СлужебныйПрограммныйИнтерфейс	

// Объект тестирования при записи.
// 
// Параметры:
//  Источник - ДокументОбъектИмяДокумента: 
//  * ДополнительныеСвойства - Структура: 
//  ** ЭтоНовыйОбъект - Булево - признак исключения регистрации в регистре записей, созданных при тестировании.
//  Отказ - Булево - Отказ
Процедура ОбъектТестированияПриЗаписи(Источник, Отказ) Экспорт

	Если ПараметрыСеанса.ЛогироватьОбъектыАвтоТестирования <> Перечисления.ЛогироватьОбъектыАвтоТестирования.Да
		Или Не Источник.ДополнительныеСвойства.ЭтоНовыйОбъект Тогда  
		Возврат;
	КонецЕсли;
	
	Попытка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить();
	ЭлементБлокировки.Область = "РегистрСведений.СозданныеОбъектыТестирования";
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	ТекущийМаксНомер = МаксимальныйНомерОбъектаСозданногоПриТестировании();
	НовыйНомерЗаписи = ТекущийМаксНомер + 1;

	
	Менеджер = РегистрыСведений.СозданныеОбъектыТестирования.СоздатьМенеджерЗаписи();
	Менеджер.НомерЗаписи = НовыйНомерЗаписи;
	Менеджер.УникальныйИдентификатор = Источник.Ссылка.УникальныйИдентификатор();
	Менеджер.ИмяТипа = Источник.Метаданные().ПолноеИмя();
	Менеджер.Записать();
	Исключение
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

// Параметры:
//  Источник - ДокументОбъект - Источник
//  Отказ - Булево - Отказ
//  РежимЗаписи - РежимЗаписиДокумента - Режим записи
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения
Процедура ОбъектТестированияДокументПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	ОбъектТестированияПередЗаписью(Источник);
КонецПроцедуры

// Объект тестирования бизнес процесс перед записью перед записью.
// 
// Параметры:
//  Источник - ЗадачаОбъект, БизнесПроцессОбъект - Источник
//  Отказ - Булево - Отказ
Процедура ОбъектТестированияКромеДокументаИРегистраПередЗаписью(Источник, Отказ) Экспорт
	ОбъектТестированияПередЗаписью(Источник);
КонецПроцедуры


Процедура НаборЗаписейТестированиеПередЗаписью(Источник, Отказ, Замещение) Экспорт
	ИсключатьИзРегистрацииДляТестирования = Ложь;
	МетаданныеРегистра = Источник.Метаданные();
	  
	Если МетаданныеРегистра.РежимЗаписи <> Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый Тогда
		ИсключатьИзРегистрацииДляТестирования = Истина;		
	КонецЕсли;
	
	Если Не ИсключатьИзРегистрацииДляТестирования
		И Метаданные.Подсистемы.АвтоТестирование.Состав.Содержит(МетаданныеРегистра) Тогда
		ИсключатьИзРегистрацииДляТестирования = Истина;
	КонецЕсли;
	
	Если Не ИсключатьИзРегистрацииДляТестирования Тогда
		
		
		РегистрыБСПИсключаемыеИзПроверкиНаВхождение = Новый Соответствие;
		РегистрыБСПИсключаемыеИзПроверкиНаВхождение.Вставить(Метаданные.РегистрыСведений.ИсполнителиЗадач, Истина);
		РегистрыБСПИсключаемыеИзПроверкиНаВхождение.Вставить(Метаданные.РегистрыСведений.КалендарныеГрафики, Истина);
		РегистрыБСПИсключаемыеИзПроверкиНаВхождение.Вставить(Метаданные.РегистрыСведений.КурсыВалют, Истина);
		РегистрыБСПИсключаемыеИзПроверкиНаВхождение.Вставить(Метаданные.РегистрыСведений.ПериодыНерабочихДнейКалендаря, Истина);
		РегистрыБСПИсключаемыеИзПроверкиНаВхождение.Вставить(Метаданные.РегистрыСведений.СоставыГруппПользователей, Истина);
		РегистрыБСПИсключаемыеИзПроверкиНаВхождение.Вставить(Метаданные.РегистрыСведений.ТаблицыГруппДоступа, Истина);
		
		ПолноеИмяМетаданных = МетаданныеРегистра.ПолноеИмя();
		Если РегистрыБСПИсключаемыеИзПроверкиНаВхождение.Получить(МетаданныеРегистра) = Неопределено
				И АвтоТестированиеПовтИспПолныеПрава.ОбъектВходитВБСП(ПолноеИмяМетаданных)  Тогда
			ИсключатьИзРегистрацииДляТестирования = Истина;
		КонецЕсли;
	КонецЕсли;

	Если Не ИсключатьИзРегистрацииДляТестирования Тогда
		НаборПредыдущихЗаписей = РегистрыСведений[МетаданныеРегистра.Имя].СоздатьНаборЗаписей();
		Для Каждого ЭлементОтбора Из Источник.Отбор Цикл 
			НаборПредыдущихЗаписей.Отбор[ЭлементОтбора.Имя].Установить(ЭлементОтбора.Значение, Истина);
		КонецЦикла;
		НаборПредыдущихЗаписей.Прочитать();
		ЭтоРедактированиеСуществующего = НаборПредыдущихЗаписей.Количество() <> 0 И Источник.Количество() <> 0; 
		Если ЭтоРедактированиеСуществующего Тогда
			ИсключатьИзРегистрацииДляТестирования = Истина;
		КонецЕсли;
	
	КонецЕсли;	
	
	Источник.ДополнительныеСвойства.Вставить("ИсключатьИзРегистрацииДляТестирования", ИсключатьИзРегистрацииДляТестирования);
	
	Если ИсключатьИзРегистрацииДляТестирования Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	Для Каждого ЭлементОтбора Из Источник.Отбор Цикл
		СтруктураОтбора.Вставить(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
	КонецЦикла;
	
	ПараметрыОтбораСтрокой = ЗначениеВСтрокуВнутр(СтруктураОтбора);	
	Источник.ДополнительныеСвойства.Вставить("ПараметрыОтбораСтрокой", ПараметрыОтбораСтрокой);
	Источник.ДополнительныеСвойства.Вставить("ИмяРегистра", МетаданныеРегистра.Имя);
	
//	TODO: предусмотреть удаление и изменение записей.
//  Для этого можно сохранять структуру записи в случае, если запись с такими параметрами отбора
//  и именем регистра отсутствуют в регистре СозданныеПриТестированииЗаписиРегистров.
// Т.к. ПараметрыОтбораСтрокой - это строка неогр. длины, которую нельзя использовать в качестве измерения-
//  можно попробовать использовать для отбора  либо хэш, либо сокращать строку.
	
//	ЭтоУдаление = (Источник.Количество() = 0 И Не НаборПредыдущихЗаписей.Количество() = 0);
//	Источник.ДополнительныеСвойства.Вставить("ЭтоУдаление", ЭтоУдаление);
//	Если ЭтоУдаление Тогда
//		УдаленныеЗаписи = Новый Массив();
//		Для Каждого ПредыдущаяЗапись Из НаборПредыдущихЗаписей Цикл
//			СтруктураРегистра = СтруктураРегистра(МетаданныеРегистра);
//			ЗаполнитьЗначенияСвойств(СтруктураРегистра, ПредыдущаяЗапись);
//			УдаленныеЗаписи.Добавить(СтруктураРегистра);
//		КонецЦикла;
//		УдаленныеЗаписиСтрокой = ЗначениеВСтрокуВнутр(УдаленныеЗаписи);
//		
//		Источник.ДополнительныеСвойства.Вставить("СтруктураУдаленнойЗаписиСтрокой", УдаленныеЗаписиСтрокой);
//	КонецЕсли;
				
КонецПроцедуры


// Набор записей тестирование при записи.
// 
// Параметры:
//  Источник - РегистрСведенийНаборЗаписейИмяРегистраСведений: 
//  * ДополнительныеСвойства - Структура: 
//  ** ИсключатьИзРегистрацииДляТестирования - Булево - признак исключения регистрации в регистре записей, созданных при тестировании.
//  ** ПараметрыОтбораСтрокой - Строка - параметры отбора, сериализованные в строку функцией ЗначениеВСтрокуВнутр
//  									 Параметр существует только если ИсключатьИзРегистрацииДляТестирования = Ложь.
//  ** ИмяРегистра - Строка - Имя регистра сведений.Параметр существует только если ИсключатьИзРегистрацииДляТестирования = Ложь.									 
//  Отказ - Булево - Отказ
//  Замещение - Булево - Замещение
Процедура НаборЗаписейТестированиеПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если Не Источник.ДополнительныеСвойства.Свойство("ИсключатьИзРегистрацииДляТестирования")
		Или Источник.ДополнительныеСвойства.ИсключатьИзРегистрацииДляТестирования Тогда 
			Возврат;
	КонецЕсли;

	МенеджерЗаписи = РегистрыСведений.СозданныеПриТестированииЗаписиРегистров.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.УникальныйИдентификатор = Новый УникальныйИдентификатор();
	МенеджерЗаписи.ПараметрыОтбораСтрокой =  Источник.ДополнительныеСвойства["ПараметрыОтбораСтрокой"];
	МенеджерЗаписи.ИмяРегистраСведений =  Источник.ДополнительныеСвойства["ИмяРегистра"];
	МенеджерЗаписи.Записать();

КонецПроцедуры
// Установка параметров сеанса.
// 
// Параметры:
//  ИмяПараметра - Строка - Имя параметра.
//  УстановленныеПараметры - Массив из Строка - Установленные параметры
Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	Если ИмяПараметра = "ЛогироватьОбъектыАвтоТестирования" Тогда
		ПараметрЗапускаПриложения = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска"); // Строка -
		ЛогироватьПоПараметруЗапуска = СтрНайти(НРег(ПараметрЗапускаПриложения), "автотестирование") > 0;
		Если ЛогироватьПоПараметруЗапуска Тогда
			ПараметрыСеанса.ЛогироватьОбъектыАвтоТестирования =  Перечисления.ЛогироватьОбъектыАвтоТестирования.Да;
		Иначе
			ПараметрыСеанса.ЛогироватьОбъектыАвтоТестирования =  Перечисления.ЛогироватьОбъектыАвтоТестирования.Нет;
		КонецЕсли;
		УстановленныеПараметры.Добавить("ЛогироватьОбъектыАвтоТестирования");	
	КонецЕсли;
	
КонецПроцедуры

// Возвращает описание объектов, созданных при тестировании.
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//	* НомерЗаписи - Число
//	* УникальныйИдентификатор - УникальныйИдентификатор - ГУИД объекта
//	* ИмяТипа - Строка - полное имя типа объекта. Например, "Документ._ДемоЗаказПокупателя"
Функция ОбъектыСозданныеПриТестировании() Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	СозданныеОбъектыТестирования.НомерЗаписи КАК НомерЗаписи,
	|	СозданныеОбъектыТестирования.УникальныйИдентификатор КАК УникальныйИдентификатор,
	|	СозданныеОбъектыТестирования.ИмяТипа КАК ИмяТипа
	|ИЗ
	|	РегистрСведений.СозданныеОбъектыТестирования КАК СозданныеОбъектыТестирования
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерЗаписи УБЫВ");

	Выборка = Запрос.Выполнить().Выбрать();
	Возврат Выборка;
КонецФункции

// Описание записей независимых регистров сведений, созданных при тестировании.
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//	* УникальныйИдентификатор - УникальныйИдентификатор - ГУИД записи регистра изменений
//	* ПараметрыОтбораСтрокой - Строка - параметры отбора регистра, сериализованные функцией ЗначениеВСтрокуВнутр.
//								При десериализации представляет собо структуру, у которой ключ - имя измерения, 
//								а значение - значение измерения.
//* ИмяРегистраСведений - УникальныйИдентификатор - ГУИД записи регистра изменений
Функция ЗаписиНезависимыхРССозданныеПриТестировании() Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	СозданныеПриТестированииЗаписиРегистров.УникальныйИдентификатор,
	|	СозданныеПриТестированииЗаписиРегистров.ПараметрыОтбораСтрокой,
	|	СозданныеПриТестированииЗаписиРегистров.ИмяРегистраСведений
	|ИЗ
	|	РегистрСведений.СозданныеПриТестированииЗаписиРегистров КАК СозданныеПриТестированииЗаписиРегистров");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат Выборка;
КонецФункции

// Удалить регистрацию в регистре учета объектов, созданных при тестировании.
// 
// Параметры:
//  НомерЗаписи - Число - Номер записи
//  Идентификатор - УникальныйИдентификатор - Идентификатор
Процедура УдалитьРегистрациюСозданногоОбъектаТестирования(НомерЗаписи, Идентификатор) Экспорт
	МенеджерЗаписи = РегистрыСведений.СозданныеОбъектыТестирования.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.НомерЗаписи = НомерЗаписи;
	МенеджерЗаписи.УникальныйИдентификатор = Идентификатор;
	МенеджерЗаписи.Удалить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Источник - ДокументОбъект - 
//			 - БизнесПроцессОбъект -
//			 - ЗадачаОбъект -
//			 - СправочникОбъект -
//			 - ПланВидовХарактеристикОбъект -
Процедура ОбъектТестированияПередЗаписью(Источник) Экспорт
	Источник.ДополнительныеСвойства.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(Источник.Ссылка));
КонецПроцедуры
// Максимальный номер объекта, созданного при тестировании.
// 
// Возвращаемое значение:
//  Число - Максимальный номер объекта
Функция МаксимальныйНомерОбъектаСозданногоПриТестировании()
	ЗапросМаксНомер = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	СозданныеОбъектыТестирования.НомерЗаписи КАК НомерЗаписи
	|ИЗ
	|	РегистрСведений.СозданныеОбъектыТестирования КАК СозданныеОбъектыТестирования
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерЗаписи УБЫВ");
	РезультатЗапросаМаксНомер = ЗапросМаксНомер.Выполнить();
	Если РезультатЗапросаМаксНомер.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	Выборка = РезультатЗапросаМаксНомер.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.НомерЗаписи;	
КонецФункции

// TODO: заготовка для восстановления измененных записей регистра.
//Функция СтруктураРегистра(МетаданныеРегистра)
//	СтруктураРегистра = Новый Структура();
//	Для Каждого ИзмерениеРегистра Из МетаданныеРегистра.Измерения Цикл
//		СтруктураРегистра.Вставить(ИзмерениеРегистра.Имя);
//	КонецЦикла;
//	Для Каждого РесурсРегистра Из МетаданныеРегистра.Ресурсы Цикл
//		СтруктураРегистра.Вставить(РесурсРегистра.Имя);
//	КонецЦикла;
//	Для Каждого РеквизитРегистра Из МетаданныеРегистра.Реквизиты Цикл
//		СтруктураРегистра.Вставить(РеквизитРегистра.Имя);
//	КонецЦикла;
//	Возврат СтруктураРегистра;
//КонецФункции

#КонецОбласти