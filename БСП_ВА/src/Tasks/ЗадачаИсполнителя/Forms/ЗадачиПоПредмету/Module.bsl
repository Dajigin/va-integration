///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");	
	
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда
		Элементы.Список.Видимость = Ложь;
		Элементы.КоманднаяПанельСписка.Видимость = Ложь;
		Элементы.ПоказыватьВыполненные.Видимость = Ложь;
		Элементы.ДеревоЗадач.Видимость = Истина;
	Иначе	
		Элементы.Список.Видимость = Истина;
		Элементы.КоманднаяПанельСписка.Видимость = Истина;
		Элементы.ПоказыватьВыполненные.Видимость = Истина;
		Элементы.ДеревоЗадач.Видимость = Ложь;
	КонецЕсли;	
	
	Список.Параметры.Элементы[0].Значение = Параметры.ЗначениеОтбора;
	Список.Параметры.Элементы[0].Использование = Истина;
	Заголовок = НСтр("ru = 'Задачи по предмету'");
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	УстановитьОтбор(Новый Структура("ПоказыватьВыполненные", ПоказыватьВыполненные));
	
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда 
		ЗаполнитьДеревоЗадач();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадач();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьОтбор(Настройки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьВыполненныеПриИзменении(Элемент)
	УстановитьОтбор(Новый Структура("ПоказыватьВыполненные", ПоказыватьВыполненные));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоЗадач

&НаКлиенте
Процедура ДеревоЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокЗадач();
	Для каждого Строка Из ДеревоЗадач.ПолучитьЭлементы() Цикл
		Элементы.ДеревоЗадач.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадач.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоЗадач.Просрочена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоЗадач.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоЗадач.Выполнена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗавершенныйБизнесПроцесс);

	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(ПараметрыОтбора)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Выполнена");
	Если НЕ ПараметрыОтбора["ПоказыватьВыполненные"] Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Выполнена", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗадач()
	
	Дерево = РеквизитФормыВЗначение("ДеревоЗадач");
	Дерево.Строки.Очистить();
	
	ДобавитьЗадачиПоПредмету(Дерево, Параметры.ЗначениеОтбора);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоЗадач");
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьСписокЗадач()
	
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда 
		ЗаполнитьДеревоЗадач();
	Иначе
		Элементы.Список.Обновить();
		// Цвет просроченных задач зависит от значения текущей даты,
		// поэтому нужно переинициализировать условное оформление.
		БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список); 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗадачиПоПредмету(Дерево, Предмет)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Задачи.Ссылка,
		|	Задачи.Наименование,
		|	Задачи.Исполнитель,
		|	Задачи.РольИсполнителя,
		|	Задачи.СрокИсполнения,
		|	Задачи.Выполнена,
		|	ВЫБОР
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА Задачи.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|   Задачи.Предмет = &Предмет
		|   И Задачи.ПометкаУдаления = ЛОЖЬ";
		
	Запрос.УстановитьПараметр("Предмет", Предмет);

	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Ветвь = Дерево.Строки.Найти(ВыборкаДетальныеЗаписи.Ссылка, "Ссылка", Истина);
		Если Ветвь = Неопределено Тогда
			Строка = Дерево.Строки.Добавить();
			
			Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
			Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
			Строка.Тип = 1;
			Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
			Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
			Строка.СрокИсполнения = ВыборкаДетальныеЗаписи.СрокИсполнения;
			Строка.Выполнена = ВыборкаДетальныеЗаписи.Выполнена;
			Если ВыборкаДетальныеЗаписи.СрокИсполнения <> "00010101"
				И ВыборкаДетальныеЗаписи.СрокИсполнения < ТекущаяДатаСеанса() Тогда
				Строка.Просрочена = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Исполнитель) Тогда
				Строка.Исполнитель = ВыборкаДетальныеЗаписи.Исполнитель;
			Иначе
				Строка.Исполнитель = ВыборкаДетальныеЗаписи.РольИсполнителя;
			КонецЕсли;
			
			ДобавитьПодчиненныеБизнесПроцессы(Дерево, ВыборкаДетальныеЗаписи.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодчиненныеБизнесПроцессы(Дерево, ЗадачаСсылка)
	
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		// У бизнес-процесса может и не быть главной задачи.
		РеквизитГлавнаяЗадача = МетаданныеБизнесПроцесса.Реквизиты.Найти("ГлавнаяЗадача");
		Если РеквизитГлавнаяЗадача = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	БизнесПроцессы.Ссылка,
			|	БизнесПроцессы.Наименование,
			|	БизнесПроцессы.Завершен,
			|	ВЫБОР
			|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
			|			ТОГДА 0
			|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
			|			ТОГДА 2
			|		ИНАЧЕ 1
			|	КОНЕЦ КАК Важность,
			|	ВЫБОР
			|		КОГДА БизнесПроцессы.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Остановлен
			|ИЗ
			|	%1 КАК БизнесПроцессы
			|ГДЕ
			|   БизнесПроцессы.ГлавнаяЗадача = &ГлавнаяЗадача
			|   И БизнесПроцессы.ПометкаУдаления = ЛОЖЬ";
			
		Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Запрос.Текст, МетаданныеБизнесПроцесса.ПолноеИмя());
		Запрос.УстановитьПараметр("ГлавнаяЗадача", ЗадачаСсылка);

		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, ВыборкаДетальныеЗаписи.Ссылка, ЗадачаСсылка);
			
		КонецЦикла;
		
	КонецЦикла;	

КонецПроцедуры

&НаСервере
Процедура ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, БизнесПроцессСсылка, ЗадачаСсылка)
	
	Ветвь = Дерево.Строки.Найти(ЗадачаСсылка, "Ссылка", Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Задачи.Ссылка,
		|	Задачи.Наименование,
		|	Задачи.Исполнитель,
		|	Задачи.РольИсполнителя,
		|	Задачи.СрокИсполнения,
		|	Задачи.Выполнена,
		|	ВЫБОР
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА Задачи.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|   Задачи.БизнесПроцесс = &БизнесПроцесс
		|   И Задачи.ПометкаУдаления = ЛОЖЬ";
		
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);

	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НайденнаяВетвь = Дерево.Строки.Найти(ВыборкаДетальныеЗаписи.Ссылка, "Ссылка", Истина);
		Если НайденнаяВетвь <> Неопределено Тогда
			Дерево.Строки.Удалить(НайденнаяВетвь);
		КонецЕсли;	
			
		Строка = Неопределено;
		Если Ветвь = Неопределено Тогда
			Строка = Дерево.Строки.Добавить();
		Иначе	
			Строка = Ветвь.Строки.Добавить();
		КонецЕсли;
		
		Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
		Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
		Строка.Тип = 1;
		Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
		Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
		Строка.СрокИсполнения = ВыборкаДетальныеЗаписи.СрокИсполнения;
		Строка.Выполнена = ВыборкаДетальныеЗаписи.Выполнена;
		Если ВыборкаДетальныеЗаписи.СрокИсполнения <> '00010101000000' 
			И ВыборкаДетальныеЗаписи.СрокИсполнения < ТекущаяДатаСеанса() Тогда
			Строка.Просрочена = Истина;
		КонецЕсли;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Исполнитель) Тогда
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.Исполнитель;
		Иначе
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.РольИсполнителя;
		КонецЕсли;
		
		ДобавитьПодчиненныеБизнесПроцессы(Дерево, ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущуюСтрокуДереваЗадач()
	
	Если Элементы.ДеревоЗадач.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(,Элементы.ДеревоЗадач.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти
