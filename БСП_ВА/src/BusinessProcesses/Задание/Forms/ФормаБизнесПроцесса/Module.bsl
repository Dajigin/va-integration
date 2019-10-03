///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОткрытаФормаВыбораИсполнителя;  // Признак того, что исполнитель выбирается из формы, а не быстрым вводом.
&НаКлиенте
Перем ОткрытаФормаВыбораПроверяющего; // Признак того, что проверяющий выбирается из формы, а не быстрым вводом.
&НаКлиенте
Перем КонтекстВыбора;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ГиперссылкаФайлов = МодульРаботаСФайлами.ГиперссылкаФайлов();
		ГиперссылкаФайлов.Размещение = "КоманднаяПанель";
		МодульРаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ГиперссылкаФайлов);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьКомандОстановки();
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборРолиИсполнителя") Тогда
		
		Если КонтекстВыбора = "ИсполнительПриИзменении" Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
				Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
			КонецЕсли;
			
			УстановитьДоступностьПроверяющего(ЭтотОбъект);
			
		ИначеЕсли КонтекстВыбора = "ПроверяющийПриИзменении" Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
				Объект.Проверяющий = ВыбранноеЗначение.РольИсполнителя;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаНастройкаОтложенногоСтарта" Тогда
		Отложен = (Параметр.Отложен И Параметр.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияПроцессовДляЗапуска.ГотовКСтарту"));
		ДатаОтложенногоСтарта = Параметр.ДатаОтложенногоСтарта;
		УстановитьСвойстваЭлементовФормы(ЭтотОбъект);
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ПроверитьДатуЗавершенияОтложенногоПроцесса(ТекущийОбъект, Отказ);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	Если НачальныйПризнакСтарта И ИзменятьЗаданияЗаднимЧислом Тогда
		УстановитьПривилегированныйРежим(Истина); 
		ТекущийОбъект.ИзменитьРеквизитыНевыполненныхЗадач();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Задание", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("Запись_ЗадачаИсполнителя", ПараметрыЗаписи, Неопределено);
	Если ПараметрыЗаписи.Свойство("Старт") И ПараметрыЗаписи.Старт Тогда
		ПодключитьОбработчикОжидания("ОбновитьФорму", 0.2, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму()
	УстановитьСвойстваЭлементовФормы(ЭтотОбъект);
	ОбновитьДоступностьКомандОстановки();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаПроверкеПриИзменении(Элемент)
	
	УстановитьДоступностьПроверяющего(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяЗадачаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.ГлавнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнфоНадписьЗаголовокОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьНастройкуОтложенногоСтарта();
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(Элемент, Объект.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	Если ОткрытаФормаВыбораИсполнителя = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
		
		Если ИспользуетсяСОбъектамиАдресации(Объект.Исполнитель) Тогда 
			
			КонтекстВыбора = "ИсполнительПриИзменении";
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РольИсполнителя", Объект.Исполнитель);
			ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			
			ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьДоступностьПроверяющего(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытаФормаВыбораИсполнителя = ТипЗнч(ВыбранноеЗначение) = Тип("Структура");
	Если ОткрытаФормаВыбораИсполнителя Тогда
		СтандартнаяОбработка = Ложь;
		Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
		Объект.ОсновнойОбъектАдресации = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		Объект.ДополнительныйОбъектАдресации = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(Элемент, Объект.Проверяющий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийПриИзменении(Элемент)
	
	Если ОткрытаФормаВыбораПроверяющего = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Проверяющий) Тогда
		
		Если ИспользуетсяСОбъектамиАдресации(Объект.Проверяющий) Тогда
			
			КонтекстВыбора = "ПроверяющийПриИзменении";
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РольИсполнителя", Объект.Проверяющий);
			ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			
			ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытаФормаВыбораПроверяющего = ТипЗнч(ВыбранноеЗначение) = Тип("Структура");
	Если ОткрытаФормаВыбораПроверяющего Тогда
		СтандартнаяОбработка = Ложь;
		Объект.Проверяющий = ВыбранноеЗначение.РольИсполнителя;
		Объект.ОсновнойОбъектАдресацииПроверяющий = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		Объект.ДополнительныйОбъектАдресацииПроверяющий = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	Если Объект.СрокИсполнения = НачалоДня(Объект.СрокИсполнения) Тогда
		Объект.СрокИсполнения = КонецДня(Объект.СрокИсполнения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СрокПроверкиПриИзменении(Элемент)
	Если Объект.СрокПроверки = НачалоДня(Объект.СрокПроверки) Тогда
		Объект.СрокПроверки = КонецДня(Объект.СрокПроверки);
	КонецЕсли;
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОстановитьБизнесПроцессИзФормыОбъекта(ЭтотОбъект);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПродолжитьБизнесПроцессИзФормыОбъекта(ЭтотОбъект);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтложенныйСтарт(Команда)
	ОткрытьНастройкуОтложенногоСтарта();
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Проверяющий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаПроверке");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Проверяющий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Проверяющий.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаПроверке");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Проверяющий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормы()
	
	НачальныйПризнакСтарта = Объект.Стартован;
	
	УстановитьРеквизитыОтложенногоСтарта();
	
	ИспользоватьДатуИВремяВСрокахЗадач    = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	ИзменятьЗаданияЗаднимЧислом           = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");
	
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);
	
	Если Объект.ГлавнаяЗадача = Неопределено Или Объект.ГлавнаяЗадача.Пустая() Тогда
		ГлавнаяЗадачаСтрокой = НСтр("ru = 'не задана'");
	Иначе	
		ГлавнаяЗадачаСтрокой = Строка(Объект.ГлавнаяЗадача);
	КонецЕсли;
	
	УстановитьСвойстваЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКомандОстановки()
	
	Если Объект.Завершен Тогда
		
		Элементы.ФормаОстановить.Видимость = Ложь;
		Элементы.ФормаПродолжить.Видимость = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Остановлен") Тогда
		Элементы.ФормаОстановить.Видимость = Ложь;
		Элементы.ФормаПродолжить.Видимость = Истина;
	Иначе
		Элементы.ФормаОстановить.Видимость = Объект.Стартован;
		Элементы.ФормаПродолжить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПроверяющего(Форма)
	
	ДоступностьПоля = Форма.Объект.НаПроверке;
	Форма.Элементы.ГруппаПроверяющий.Доступность = ДоступностьПоля;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользуетсяСОбъектамиАдресации(ПроверяемыйОбъект)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроверяемыйОбъект, "ИспользуетсяСОбъектамиАдресации");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовФормы(Форма)
	
	Если Форма.ТолькоПросмотр Тогда
		Форма.Элементы.ФормаОстановить.Видимость               = Ложь;
		Форма.Элементы.ФормаЗаписатьИЗакрыть.Видимость         = Ложь;
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Видимость = Ложь;
		Форма.Элементы.ФормаЗаписать.Видимость                 = Ложь;
		Форма.Элементы.ФормаПродолжить.Видимость               = Ложь;
	Иначе
		ОбъектСтартован = ОбъектСтартован(Форма);
		
		Форма.Элементы.СрокИсполненияВремя.Видимость             = Форма.ИспользоватьДатуИВремяВСрокахЗадач;
		Форма.Элементы.СрокПроверкиВремя.Видимость               = Форма.ИспользоватьДатуИВремяВСрокахЗадач;
		Форма.Элементы.Дата.Формат                               = ?(Форма.ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
		Форма.Элементы.Предмет.Гиперссылка                       = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
		Форма.Элементы.ФормаСтартИЗакрыть.Видимость              = Не ОбъектСтартован;
		Форма.Элементы.ФормаСтартИЗакрыть.КнопкаПоУмолчанию      = Не ОбъектСтартован;
		Форма.Элементы.ФормаСтарт.Видимость                      = Не ОбъектСтартован;
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Видимость   = Не ОбъектСтартован;
		Форма.Элементы.ФормаЗаписатьИЗакрыть.Видимость           = ?(Форма.Объект.Завершен, Ложь, ОбъектСтартован);
		Форма.Элементы.ФормаЗаписать.Видимость                   = НЕ Форма.Объект.Завершен;
		Форма.Элементы.ФормаЗаписатьИЗакрыть.КнопкаПоУмолчанию   = ОбъектСтартован;
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Доступность = Не Форма.Объект.Стартован;
		
		Если Форма.Объект.ГлавнаяЗадача = Неопределено Или Форма.Объект.ГлавнаяЗадача.Пустая() Тогда
			Форма.Элементы.ГлавнаяЗадача.Гиперссылка             = Ложь;
		КонецЕсли;
		
		Если Не Форма.ИспользоватьПодчиненныеБизнесПроцессы Тогда
			Форма.Элементы.ГлавнаяЗадача.Видимость               = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьСвойстваГруппеСостояний(Форма);
	УстановитьДоступностьПроверяющего(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваГруппеСостояний(Форма)

	ОтображатьГруппу = Форма.Объект.Завершен Или ОбъектСтартован(Форма);
	Форма.Элементы.ГруппаСостояние.Видимость = ОтображатьГруппу;
	
	Если НЕ ОтображатьГруппу Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	Высота = 1;
	
	Если Форма.Объект.Завершен Тогда
		ДатаЗавершенияСтрокой = ?(Форма.ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(Форма.Объект.ДатаЗавершения, "ДЛФ=DT"), Формат(Форма.Объект.ДатаЗавершения, "ДЛФ=D"));
		СтрокаТекста = ?(Форма.Объект.Выполнено, 
			НСтр("ru = 'Задание выполнено %1.'"), 
			НСтр("ru = 'Задание отменено %1.'"));
		ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаТекста, ДатаЗавершенияСтрокой);
		МассивСтрок.Добавить(ТекстСостояния);
		
		Для каждого Элемент Из Форма.Элементы Цикл
			Если ТипЗнч(Элемент) <> Тип("ПолеФормы") И ТипЗнч(Элемент) <> Тип("ГруппаФормы") Тогда
				Продолжить;
			КонецЕсли;
			Элемент.ТолькоПросмотр = Истина;
		КонецЦикла;	
		
	ИначеЕсли Форма.Объект.Стартован Тогда
		ТекстСостояния = ?(Форма.ИзменятьЗаданияЗаднимЧислом, 
			НСтр("ru = 'Изменения формулировки, важности, автора, а также перенос сроков исполнения и проверки задания вступят в силу немедленно для ранее выданной задачи.'"), 
			НСтр("ru = 'Изменения формулировки, важности, автора, а также перенос сроков исполнения и проверки задания не будут отражены в ранее выданной задаче.'"));
		МассивСтрок.Добавить(ТекстСостояния);
		Высота = 2;
		
	ИначеЕсли Форма.Отложен Тогда
		ДатаОтложенногоСтартаСтрокой = ?(Форма.ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(Форма.ДатаОтложенногоСтарта, "ДЛФ=DT"), Формат(Форма.ДатаОтложенногоСтарта, "ДЛФ=D"));
		ТекстСостояния = НСтр("ru = 'Задание будет запущено'") + " ";
		МассивСтрок.Добавить(ТекстСостояния);
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ДатаОтложенногоСтартаСтрокой,,,, "ОткрытьНастройкуОтложенногоСтарта"));
	КонецЕсли;
	
	Форма.ИнфоНадписьЗаголовок = Новый ФорматированнаяСтрока(МассивСтрок);
	Форма.Элементы.ИнфоНадписьЗаголовок.МаксимальнаяВысота = Высота;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДатуЗавершенияОтложенногоПроцесса(ПроверяемыйОбъект, Отказ)

	Если Не ЗначениеЗаполнено(ПроверяемыйОбъект.СрокИсполнения) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаОтложенногоСтарта = БизнесПроцессыИЗадачиСервер.ДатаОтложенногоСтартаПроцесса(ПроверяемыйОбъект.Ссылка);
	
	Если ПроверяемыйОбъект.СрокИсполнения < ДатаОтложенногоСтарта Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Срок исполнения задания не может быть меньше даты отложенного старта.'"),,
			"СрокИсполнения", "Объект.СрокИсполнения");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуОтложенногоСтарта()

	Если КлючевыеРеквизитыФормыЗаполнены() Тогда
		БизнесПроцессыИЗадачиКлиент.НастроитьОтложенныйСтарт(Объект.Ссылка, Объект.СрокИсполнения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция КлючевыеРеквизитыФормыЗаполнены()

	Если Объект.Стартован Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	РеквизитыФормыЗаполнены = Истина;
	Если НЕ ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Исполнитель"" не заполнено.'"),,
			"Исполнитель", "Объект.Исполнитель");
		РеквизитыФормыЗаполнены = Ложь;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Задание"" не заполнено.'"),,
			"Исполнитель", "Объект.Наименование");
		РеквизитыФормыЗаполнены = Ложь;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Поле ""Срок"" исполнения не заполнено.'"),,
			"СрокИсполнения", "Объект.СрокИсполнения");
		РеквизитыФормыЗаполнены = Ложь;
	КонецЕсли;
	
	Возврат РеквизитыФормыЗаполнены;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбъектСтартован(Форма)
	Возврат Форма.Объект.Стартован ИЛИ Форма.Отложен;
КонецФункции

&НаСервере
Процедура УстановитьРеквизитыОтложенногоСтарта()

	ДатаОтложенногоСтарта = БизнесПроцессыИЗадачиСервер.ДатаОтложенногоСтартаПроцесса(Объект.Ссылка);
	Отложен = (ДатаОтложенногоСтарта <> '00010101');
	
КонецПроцедуры

#КонецОбласти
