///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Производит запись в служебных регистр информации о наличии заметки по предмету.
//
// Параметры совпадают с параметрами обработчика при записи у элемента справочника.
Процедура ПроверитьНаличиеЗаметокПоПредмету(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Источник.Предмет) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Заметки.Ссылка
	|ИЗ
	|	Справочник.Заметки КАК Заметки
	|ГДЕ
	|	Заметки.Предмет = &Предмет
	|	И Заметки.Автор = &Пользователь
	|	И Заметки.ПометкаУдаления = ЛОЖЬ";
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Предмет", Источник.Предмет);
	Запрос.УстановитьПараметр("Пользователь", Источник.Автор);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.Заметки");
	ЭлементБлокировки.УстановитьЗначение("Предмет", Источник.Предмет);
	ЭлементБлокировки.УстановитьЗначение("Автор", Источник.Автор);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений._ДемоНаличиеЗаметокПоПредмету");
	ЭлементБлокировки.УстановитьЗначение("Предмет", Источник.Предмет);
	ЭлементБлокировки.УстановитьЗначение("Автор", Источник.Автор);
	
	НаборЗаписей = РегистрыСведений._ДемоНаличиеЗаметокПоПредмету.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Автор.Установить(Источник.Автор);
	НаборЗаписей.Отбор.Предмет.Установить(Источник.Предмет);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выборка = Запрос.Выполнить().Выбрать();
		НаборЗаписей.Прочитать();
		
		ЕстьЗаметки = Выборка.Количество() > 0;
		Если ЕстьЗаметки Тогда 
			Если НаборЗаписей.Количество() = 0 Тогда
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Источник);
				НоваяЗапись.ЕстьЗаметки = Истина;
			Иначе
				Для Каждого Запись Из НаборЗаписей Цикл
					Запись.ЕстьЗаметки = Истина;
				КонецЦикла;
			КонецЕсли;
		Иначе
			НаборЗаписей.Очистить();
		КонецЕсли;
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
