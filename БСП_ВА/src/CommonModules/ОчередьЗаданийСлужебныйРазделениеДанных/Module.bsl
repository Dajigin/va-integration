///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при заполнении массива справочников, которые могут использоваться для
// хранения заданий очереди заданий.
//
// Параметры:
//  МассивСправочников - Массив Из СправочникМенеджер - в этот параметр в данном методе должны быть добавлены
//    менеджеры справочников, которые могут использоваться для хранения заданий очереди.
//
Процедура ПриЗаполненииСправочниковЗаданий(МассивСправочников) Экспорт
	
	МассивСправочников.Добавить(Справочники.ОчередьЗаданийОбластейДанных);
	
КонецПроцедуры

// Определяет значение разделителя ОбластьДанныхОсновныеДанные, которое необходимо установить
//  перед выполнением задания.
//
// Параметры:
//  Задание - СправочникСсылка - задание очереди заданий.
//
// Возвращаемое значение:
//   Произвольный
//
Функция ОпределитьОбластьДанныхДляЗадания(Знач Задание) Экспорт
	
	Если ТипЗнч(Задание) = Тип("СправочникСсылка.ОчередьЗаданийОбластейДанных") Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Задание, "ОбластьДанныхВспомогательныеДанные");
	КонецЕсли;
	
КонецФункции

// Корректирует запланированный момент запуска задания с учетом часового пояса области данных.
//
// Параметры:
//  ПараметрыЗадания - Структура - параметры добавляемого задания, возможные ключи:
//   * ОбластьДанных - Число - номер области данных.
//   * Использование - Булево - признак использования задания.
//   * ЗапланированныйМоментЗапуска - Дата - дата и время.
//   * ЭксклюзивноеВыполнение - Булево - признак эксклюзивного выполнения.
//   * ИмяМетода - Строка - обязательно для указания.
//   * Параметры - Массив - параметры метода.
//   * Ключ - Строка - ключ уникальности регламентного задания.
//   * ИнтервалПовтораПриАварийномЗавершении - Число
//   * Расписание - РасписаниеРегламентногоЗадания - расписание.
//   * КоличествоПовторовПриАварийномЗавершении - Число
//  Результат - Дата - запланированный момент запуска для задания (дата и время).
//  СтандартнаяОбработка - Булево - признак необходимости приведения времени задания к часовому поясу сервера.
//
Процедура ПриОпределенииЗапланированногоМоментаЗапуска(Знач ПараметрыЗадания, Результат, СтандартнаяОбработка) Экспорт
	
	ОбластьДанных = Неопределено;
	Если Не ПараметрыЗадания.Свойство("ОбластьДанных", ОбластьДанных) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбластьДанных <> - 1 Тогда
		
		// Перевод времени из часового пояса области.
		ЧасовойПояс = РаботаВМоделиСервиса.ПолучитьЧасовойПоясОбластиДанных(ПараметрыЗадания.ОбластьДанных);
		Результат = УниверсальноеВремя(ПараметрыЗадания.ЗапланированныйМоментЗапуска, ЧасовойПояс);
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

///  Обновляет задания очереди созданные на основе шаблонов.
Процедура ОбновитьЗаданияОчередиПоШаблонам(Параметры = Неопределено) Экспорт
	
	Если НЕ РаботаВМоделиСервиса.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры = Неопределено Тогда
		Параметры = Новый Структура;
		Параметры.Вставить("МонопольныйРежим", Истина);
	КонецЕсли;
	
	ЗапускВМонопольномРежиме = Параметры.МонопольныйРежим;
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Справочник.ОчередьЗаданийОбластейДанных");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		ИзмененияШаблонов = ОбновитьШаблоныЗаданийОчереди(Параметры);
		Если НЕ ЗапускВМонопольномРежиме 
			И Параметры.МонопольныйРежим Тогда
			
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		Если ИзмененияШаблонов.Удаленные.Количество() > 0
			ИЛИ ИзмененияШаблонов.ДобавленныеИзмененные.Количество() > 0 Тогда
			
			// Удаление заданий по удаленным шаблонам.
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Очередь.Ссылка
			|ИЗ
			|	Справочник.ОчередьЗаданийОбластейДанных КАК Очередь
			|ГДЕ
			|	Очередь.Шаблон В(&УдаленныеШаблоны)");
			Запрос.УстановитьПараметр("УдаленныеШаблоны", ИзмененияШаблонов.Удаленные);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Задание = Выборка.Ссылка.ПолучитьОбъект();
				Задание.ОбменДанными.Загрузка = Истина;
				Задание.Удалить();
				
			КонецЦикла;
			
			// Добавление заданий по добавленным шаблонам.
			ДобавленныеИзмененные = ИзмененияШаблонов.ДобавленныеИзмененные;
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Области.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
			|	Очередь.Ссылка КАК Идентификатор,
			|	Шаблоны.Ссылка КАК Шаблон,
			|	ЕСТЬNULL(Очередь.ДатаНачалаПоследнегоЗапуска, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаНачалаПоследнегоЗапуска,
			|	ЧасовыеПояса.Значение КАК ЧасовойПояс
			|ИЗ
			|	РегистрСведений.ОбластиДанных КАК Области
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШаблоныЗаданийОчереди КАК Шаблоны
			|		ПО (Шаблоны.Ссылка В (&ДобавленныеИзмененныеШаблоны))
			|			И (Области.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбластейДанных.Используется))
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОчередьЗаданийОбластейДанных КАК Очередь
			|		ПО Области.ОбластьДанныхВспомогательныеДанные = Очередь.ОбластьДанныхВспомогательныеДанные
			|			И (Шаблоны.Ссылка = Очередь.Шаблон)
			|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ЧасовойПоясОбластиДанных КАК ЧасовыеПояса
			|		ПО Области.ОбластьДанныхВспомогательныеДанные = ЧасовыеПояса.ОбластьДанныхВспомогательныеДанные");
			Запрос.УстановитьПараметр("ДобавленныеИзмененныеШаблоны", ДобавленныеИзмененные.ВыгрузитьКолонку("Ссылка"));
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				
				СтрокаШаблона = ДобавленныеИзмененные.Найти(Выборка.Шаблон, "Ссылка");
				Если СтрокаШаблона = Неопределено Тогда
					ШаблонСообщения = НСтр("ru = 'При обновлении не найден шаблон задания %1'");
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Выборка.Ссылка);
					ВызватьИсключение(ТекстСообщения);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Выборка.Идентификатор) Тогда
					Задание = Выборка.Идентификатор.ПолучитьОбъект();
				Иначе
					
					Задание = Справочники.ОчередьЗаданийОбластейДанных.СоздатьЭлемент();
					Задание.Шаблон = Выборка.Шаблон;
					Задание.ОбластьДанныхВспомогательныеДанные = Выборка.ОбластьДанных;
					
				КонецЕсли;
				
				Задание.Использование = СтрокаШаблона.Использование;
				Задание.Ключ = СтрокаШаблона.Ключ;
				
				Задание.ЗапланированныйМоментЗапуска = 
					ОчередьЗаданийСлужебный.ПолучитьЗапланированныйМоментЗапускаЗадания(
						СтрокаШаблона.Расписание,
						Выборка.ЧасовойПояс,
						Выборка.ДатаНачалаПоследнегоЗапуска);
						
				Если ЗначениеЗаполнено(Задание.ЗапланированныйМоментЗапуска) Тогда
					Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.Запланировано;
				Иначе
					Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.НеЗапланировано;
				КонецЕсли;
				
				Задание.Записать();
				
			КонецЦикла;
		
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Создает в текущей области данных задания по шаблонам.
Процедура СоздатьЗаданияОчередиПоШаблонамВТекущейОбласти() Экспорт
	
	Если НЕ РаботаВМоделиСервиса.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("Справочник.ОчередьЗаданийОбластейДанных");
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Очередь.Ссылка КАК Идентификатор,
		|	Шаблоны.Ссылка КАК Шаблон,
		|	ЕСТЬNULL(Очередь.ДатаНачалаПоследнегоЗапуска, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаНачалаПоследнегоЗапуска,
		|	ЧасовыеПояса.Значение КАК ЧасовойПояс,
		|	Шаблоны.Расписание КАК Расписание,
		|	Шаблоны.Использование КАК Использование,
		|	Шаблоны.Ключ КАК Ключ
		|ИЗ
		|	Справочник.ШаблоныЗаданийОчереди КАК Шаблоны
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОчередьЗаданийОбластейДанных КАК Очередь
		|		ПО Шаблоны.Ссылка = Очередь.Шаблон
		|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ЧасовойПоясОбластиДанных КАК ЧасовыеПояса
		|		ПО (ИСТИНА)";
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если ЗначениеЗаполнено(Выборка.Идентификатор) Тогда
				Задание = Выборка.Идентификатор.ПолучитьОбъект();
			Иначе
				Задание = Справочники.ОчередьЗаданийОбластейДанных.СоздатьЭлемент();
				Задание.Шаблон = Выборка.Шаблон;
			КонецЕсли;
			
			Задание.Использование = Выборка.Использование;
			Задание.Ключ = Выборка.Ключ;
			Задание.ЗапланированныйМоментЗапуска = 
				ОчередьЗаданийСлужебный.ПолучитьЗапланированныйМоментЗапускаЗадания(Выборка.Расписание.Получить(), 
					Выборка.ЧасовойПояс, 
					Выборка.ДатаНачалаПоследнегоЗапуска);
					
			Если ЗначениеЗаполнено(Задание.ЗапланированныйМоментЗапуска) Тогда
				Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.Запланировано;
			Иначе
				Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.НеЗапланировано;
			КонецЕсли;
			
			Задание.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
// Параметры:
//	Обработчики - см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.Обработчики
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Если Не РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ОчередьЗаданийСлужебныйРазделениеДанных.СоздатьЗаданияОчередиПоШаблонамВТекущейОбласти";
	Обработчик.МонопольныйРежим = Истина;
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 98;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.Процедура = "ОчередьЗаданийСлужебныйРазделениеДанных.ОбновитьЗаданияОчередиПоШаблонам";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.МонопольныйРежим = Истина;
	Обработчик.Приоритет = 63;
	
КонецПроцедуры

// См. РаботаВМоделиСервисаПереопределяемый.ПриВключенииРазделенияПоОбластямДанных.
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	
	ОбновитьЗаданияОчередиПоШаблонам();
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиДанных.
Процедура ПослеЗагрузкиДанных(Контейнер) Экспорт
	
	СоздатьЗаданияОчередиПоШаблонамВТекущейОбласти();
	
	// Устанавливать использование регламентных заданий только после создания заданий очереди.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		
		МодульРегламентныеЗаданияСлужебный = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСлужебный");
		МодульРегламентныеЗаданияСлужебный.УстановитьИспользованиеРегламентныхЗаданийПоФункциональнымОпциям(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// Параметры:
//	Типы - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Справочники.ОчередьЗаданийОбластейДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет справочник ШаблоныЗаданийОчереди списком регламентных заданий, использующихся 
// в качестве шаблонов для заданий очереди, а также принудительно снимает признак Использование
// для этих заданий.
//
// Возвращаемое значение:
//  Структура - добавленные, измененные и удаленные в процессе обновления шаблоны, ключи:
//	 * ДобавленныеИзмененные - ТаблицаЗначений - колонки:
//		* Ссылка - СправочникСсылка.ШаблоныЗаданийОчереди - ссылка шаблона. Идентификатор ссылки равен идентификатору регламентного задания.
//		* Использование - Булево - флаг использования задания.
//		* Расписание - РасписаниеРегламентногоЗадания - расписание задания.
//  * Удаленные - Массив значений УникальныйИдентификатор - идентификаторы  удаленных шаблонов.
// 
Функция ОбновитьШаблоныЗаданийОчереди(Параметры)
	
	Если НЕ РаботаВМоделиСервиса.РазделениеВключено() Тогда
		Возврат Новый Структура("Добавленные, Удаленные", Новый Массив, Новый Массив);
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Справочник.ШаблоныЗаданийОчереди");
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Строка_255 = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(255, ДопустимаяДлина.Переменная));
		Число_10_0 = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0));
		
		ТаблицаШаблонов = Новый ТаблицаЗначений;
		ТаблицаШаблонов.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.ШаблоныЗаданийОчереди"));
		ТаблицаШаблонов.Колонки.Добавить("Использование", Новый ОписаниеТипов("Булево"));
		ТаблицаШаблонов.Колонки.Добавить("ИмяМетода", Строка_255);
		ТаблицаШаблонов.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(128, ДопустимаяДлина.Переменная)));
		ТаблицаШаблонов.Колонки.Добавить("КоличествоПовторовПриАварийномЗавершении", Число_10_0);
		ТаблицаШаблонов.Колонки.Добавить("ИнтервалПовтораПриАварийномЗавершении", Число_10_0);
		ТаблицаШаблонов.Колонки.Добавить("Расписание", Новый ОписаниеТипов("РасписаниеРегламентногоЗадания"));
		ТаблицаШаблонов.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
		ТаблицаШаблонов.Колонки.Добавить("Имя", Строка_255);
		
		ИменаШаблонов = ОчередьЗаданий.ШаблоныЗаданийОчереди();
		
		Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
		Для Каждого Задание Из Задания Цикл
			Если ИменаШаблонов.Найти(Задание.Метаданные.Имя) <> Неопределено Тогда
				НоваяСтрока = ТаблицаШаблонов.Добавить();
				НоваяСтрока.Ссылка = Справочники.ШаблоныЗаданийОчереди.ПолучитьСсылку(Задание.УникальныйИдентификатор);
				НоваяСтрока.Использование = Задание.Метаданные.Использование;
				НоваяСтрока.ИмяМетода = Задание.Метаданные.ИмяМетода;
				НоваяСтрока.Ключ = Задание.Метаданные.Ключ;
				НоваяСтрока.КоличествоПовторовПриАварийномЗавершении = 
					Задание.Метаданные.КоличествоПовторовПриАварийномЗавершении;
				НоваяСтрока.ИнтервалПовтораПриАварийномЗавершении = 
					Задание.Метаданные.ИнтервалПовтораПриАварийномЗавершении;
				НоваяСтрока.Расписание = Задание.Расписание;
				НоваяСтрока.Представление = Задание.Метаданные.Представление();
				НоваяСтрока.Имя = Задание.Метаданные.Имя;
				
				Если НЕ Параметры.МонопольныйРежим
					И Задание.Использование Тогда
					
					Параметры.МонопольныйРежим = Истина;
					
					ОтменитьТранзакцию();
					
					Возврат Неопределено;
				КонецЕсли;
				
				Задание.Использование = Ложь;
				Задание.Записать();
			КонецЕсли;
		КонецЦикла;
		
		УдаленныеШаблоны = Новый Массив;
		ДобавленныеИзмененныеШаблоны = Новый ТаблицаЗначений;
		ДобавленныеИзмененныеШаблоны.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.ШаблоныЗаданийОчереди"));
		ДобавленныеИзмененныеШаблоны.Колонки.Добавить("Использование", Новый ОписаниеТипов("Булево"));
		ДобавленныеИзмененныеШаблоны.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(128, ДопустимаяДлина.Переменная)));
		ДобавленныеИзмененныеШаблоны.Колонки.Добавить("Расписание", Новый ОписаниеТипов("РасписаниеРегламентногоЗадания"));
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ШаблоныЗаданийОчереди.Ссылка КАК Ссылка,
		|	ШаблоныЗаданийОчереди.Использование,
		|	ШаблоныЗаданийОчереди.Ключ,
		|	ШаблоныЗаданийОчереди.Расписание
		|ИЗ
		|	Справочник.ШаблоныЗаданийОчереди КАК ШаблоныЗаданийОчереди";
		ИсходнаяТаблицаШаблонов = Запрос.Выполнить().Выгрузить();
		
		// Обработка добавленных / измененных шаблонов.
		Для каждого СтрокаТаблицы Из ТаблицаШаблонов Цикл
			
			ШаблонИзменен = Ложь;
			
			ИсходнаяСтрокаШаблона = ИсходнаяТаблицаШаблонов.Найти(СтрокаТаблицы.Ссылка, "Ссылка");
			Если ИсходнаяСтрокаШаблона = Неопределено
				ИЛИ СтрокаТаблицы.Использование <> ИсходнаяСтрокаШаблона.Использование
				ИЛИ СтрокаТаблицы.Ключ <> ИсходнаяСтрокаШаблона.Ключ
				ИЛИ НЕ ОбщегоНазначенияКлиентСервер.РасписанияОдинаковые(СтрокаТаблицы.Расписание, 
					ИсходнаяСтрокаШаблона.Расписание.Получить()) Тогда
					
				СтрокаИзменения = ДобавленныеИзмененныеШаблоны.Добавить();
				СтрокаИзменения.Ссылка = СтрокаТаблицы.Ссылка;
				СтрокаИзменения.Использование = СтрокаТаблицы.Использование;
				СтрокаИзменения.Ключ = СтрокаТаблицы.Ключ;
				СтрокаИзменения.Расписание = СтрокаТаблицы.Расписание;
				
				ШаблонИзменен = Истина;
				
			КонецЕсли;
			
			Если ИсходнаяСтрокаШаблона = Неопределено Тогда
				Шаблон = Справочники.ШаблоныЗаданийОчереди.СоздатьЭлемент();
				Шаблон.УстановитьСсылкуНового(СтрокаТаблицы.Ссылка);
			Иначе
				Шаблон = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
				ИсходнаяТаблицаШаблонов.Удалить(ИсходнаяСтрокаШаблона);
			КонецЕсли;
			
			Если ШаблонИзменен
				ИЛИ Шаблон.Наименование <> СтрокаТаблицы.Представление
				ИЛИ Шаблон.ИмяМетода <> СтрокаТаблицы.ИмяМетода
				ИЛИ Шаблон.КоличествоПовторовПриАварийномЗавершении <> СтрокаТаблицы.КоличествоПовторовПриАварийномЗавершении
				ИЛИ Шаблон.ИнтервалПовтораПриАварийномЗавершении <> СтрокаТаблицы.ИнтервалПовтораПриАварийномЗавершении
				ИЛИ Шаблон.Имя <> СтрокаТаблицы.Имя Тогда
				
				Если НЕ Параметры.МонопольныйРежим Тогда
					Параметры.МонопольныйРежим = Истина;
					ОтменитьТранзакцию();
					Возврат Неопределено;
				КонецЕсли;
				
				Шаблон.Наименование = СтрокаТаблицы.Представление;
				Шаблон.Использование = СтрокаТаблицы.Использование;
				Шаблон.ИмяМетода = СтрокаТаблицы.ИмяМетода;
				Шаблон.Ключ = СтрокаТаблицы.Ключ;
				Шаблон.КоличествоПовторовПриАварийномЗавершении = СтрокаТаблицы.КоличествоПовторовПриАварийномЗавершении;
				Шаблон.ИнтервалПовтораПриАварийномЗавершении = СтрокаТаблицы.ИнтервалПовтораПриАварийномЗавершении;
				Шаблон.Расписание = Новый ХранилищеЗначения(СтрокаТаблицы.Расписание);
				Шаблон.Имя = СтрокаТаблицы.Имя;
				Шаблон.Записать();
			КонецЕсли;
			
		КонецЦикла;
		
		// Обработка удаленных шаблонов.
		Для каждого ИсходнаяСтрокаШаблона Из ИсходнаяТаблицаШаблонов Цикл
			Если НЕ Параметры.МонопольныйРежим Тогда
				Параметры.МонопольныйРежим = Истина;
				ОтменитьТранзакцию();
				Возврат Неопределено;
			КонецЕсли;
			
			Шаблон = ИсходнаяСтрокаШаблона.Ссылка.ПолучитьОбъект();
			Шаблон.ОбменДанными.Загрузка = Истина;
			Шаблон.Удалить();
			
			УдаленныеШаблоны.Добавить(ИсходнаяСтрокаШаблона.Ссылка);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Новый Структура("ДобавленныеИзмененные, Удаленные", ДобавленныеИзмененныеШаблоны, УдаленныеШаблоны);
	
КонецФункции

#КонецОбласти
