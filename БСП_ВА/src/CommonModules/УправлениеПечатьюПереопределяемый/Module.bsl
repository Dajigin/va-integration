///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет настройки подсистемы.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы:
//   * ИспользоватьПодписиИПечати - Булево - при установке значения Ложь отключается возможность установки подписей 
//                                           и печатей в печатных формах.
//   * СкрыватьПодписиИПечатиДляРедактирования - Булево - удалять рисунки подписей и печатей табличных документов при
//                                           снятии флажка "Подписи и печати" в форме "Печать документов", для того,
//                                           чтобы они не мешали редактировать текст, находящийся под ними.
//
Процедура ПриОпределенииНастроекПечати(Настройки) Экспорт

КонецПроцедуры

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	// _Демо начало примера
	СписокОбъектов.Добавить(Справочники._ДемоКонтактныеЛицаПартнеров);
	СписокОбъектов.Добавить(Справочники._ДемоКонтрагенты);
	СписокОбъектов.Добавить(Справочники._ДемоОрганизации);
	СписокОбъектов.Добавить(Справочники._ДемоПартнеры);
	СписокОбъектов.Добавить(Справочники._ДемоФизическиеЛица);
	СписокОбъектов.Добавить(Документы._ДемоОприходованиеТоваров);
	СписокОбъектов.Добавить(Документы._ДемоПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы._ДемоСписаниеТоваров);
	СписокОбъектов.Добавить(Документы._ДемоСчетНаОплатуПокупателю);
	СписокОбъектов.Добавить(Документы._ДемоРасходныйКассовыйОрдер);
	// _Демо конец примера
	
КонецПроцедуры

// Позволяет переопределить список команд печати в произвольной форме.
// Может использоваться для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. 
// Например, если в общих формах нужны специфические команды печати.
// Вызывается из функции УправлениеПечатью.КомандыПечатиФормы.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
// Пример:
//  Если ИмяФормы = "ОбщаяФорма.ЖурналДокументов" Тогда
//    Если Пользователи.РолиДоступны("ПечатьСчетаНаОплатуНаПринтер") Тогда
//      КомандаПечати = КомандыПечати.Добавить();
//      КомандаПечати.Идентификатор = "Счет";
//      КомандаПечати.Представление = НСтр("ru = 'Счет на оплату (на принтер)'");
//      КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьСразу;
//      КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
//      КомандаПечати.СразуНаПринтер = Истина;
//    КонецЕсли;
//  КонецЕсли;
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Позволяет задать дополнительные настройки команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию - Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
//
// Пример:
//   Если НастройкиСписка.МенеджерКомандПечати = "ЖурналДокументов.СкладскиеДокументы" Тогда
//     НастройкиСписка.АвтоматическоеЗаполнение = Ложь;
//   КонецЕсли;
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
КонецПроцедуры

// Позволяет выполнить постобработку печатных форм при их формировании.
// Например, можно вставить в печатную форму дату формирования.
// Вызывается после завершения процедуры Печать менеджера печати объекта, имеет те же параметры.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит сформированные табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - для заполнения письма при отправке печатной формы по электронной почте.
//                    см. РаботаСПочтовымиСообщениямиКлиент.РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.
//   * ЗаголовокФормы - Строка - переопределяет заголовок формы печати документов (ПечатьДокументов).
//
// Пример:
//   ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктРеализация");
//   Если ПечатнаяФорма <> Неопределено Тогда
//     ПечатнаяФорма.ТабличныйДокумент.ПолеСлева = 20;
//     ...
//
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// _Демо начало примера
	ТекстНижнегоКолонтитула = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дата формирования: %1'"), 
		Формат(ТекущаяДатаСеанса(), "ДЛФ=DD"));
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФорм Цикл
		Если ПечатнаяФорма.ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			НижнийКолонтитул = ПечатнаяФорма.ТабличныйДокумент.НижнийКолонтитул;
			НижнийКолонтитул.ТекстСлева = ТекстНижнегоКолонтитула;
			НижнийКолонтитул.Выводить = Истина;
		КонецЕсли;
	КонецЦикла;
	// _Демо конец примера
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатная форма.
//
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
	// _Демо начало примера
	ПараметрыОтправки.Текст = СокрП(ПараметрыОтправки.Текст) + Символы.ПС + Символы.ПС 
		+ "____________________"
		+ Символы.ПС + Символы.ПС
		+ НСтр("ru = 'Информация в этом сообщении предназначена исключительно для конкретных лиц, которым она адресована. В сообщении может содержаться конфиденциальная информация, которая не может быть раскрыта или использована кем-либо, кроме адресатов. Если вы не адресат этого сообщения, то использование, переадресация, копирование или распространение содержания сообщения или его части незаконно и запрещено. Если Вы получили это сообщение ошибочно, пожалуйста, незамедлительно сообщите отправителю об этом и удалите со всем содержимым само сообщение и любые возможные его копии и вложения.'");
		
	// _Демо конец примера
	
КонецПроцедуры

// Определяет набор подписей и печатей для документов.
//
// Параметры:
//  Документы      - Массив    - коллекция ссылок на объекты печати;
//  ПодписиИПечати - Соответствие - коллекция объектов печати и комплектов подписей/печатей к ним:
//   * Ключ     - ЛюбаяСсылка - ссылка на объект печати;
//   * Значение - Структура   - комплект подписей и печатей:
//     ** Ключ     - Строка - идентификатор подписи или печати в макете печатной формы, 
//                            должен начинаться с "Подпись...", "Печать..." или "Факсимиле...",
//                            например, "ПодписьРуководителя", "ПечатьОрганизации";
//     ** Значение - Картинка - изображение подписи или печати.
//
Процедура ПриПолученииПодписейИПечатей(Документы, ПодписиИПечати) Экспорт
	
	// _Демо начало примера
	
	ДокументыПоТипам = Новый Соответствие;
	Для Каждого Документ Из Документы Цикл
		ТипДокумента = ТипЗнч(Документ);
		Если ДокументыПоТипам[ТипДокумента] = Неопределено Тогда
			ДокументыПоТипам[ТипДокумента] = Новый Массив;
		КонецЕсли;
		ДокументыПоТипам[ТипДокумента].Добавить(Документ);
	КонецЦикла;
	
	КомплектыПодписейИПечатей = Новый Соответствие;
	Для Каждого ДокументыПоТипу Из ДокументыПоТипам Цикл
		ТипДокумента = ДокументыПоТипу.Ключ;
		СписокДокументов = ДокументыПоТипу.Значение;
		Если ТипДокумента = Тип("ДокументСсылка._ДемоСчетНаОплатуПокупателю") Тогда
			ОрганизацииВДокументах = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокДокументов, "Организация");
			Для Каждого ОрганизацияВДокументе Из ОрганизацииВДокументах Цикл
				Документ = ОрганизацияВДокументе.Ключ;
				Организация = ОрганизацияВДокументе.Значение;
				КомплектПодписейИПечатей = КомплектыПодписейИПечатей[Организация];
				Если КомплектПодписейИПечатей = Неопределено Тогда
					КомплектПодписейИПечатей = Справочники._ДемоОрганизации.ПодписиИПечатиОрганизации(Организация);
					КомплектыПодписейИПечатей.Вставить(Организация, КомплектПодписейИПечатей);
				КонецЕсли;
				ПодписиИПечати.Вставить(Документ, КомплектПодписейИПечатей);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается из обработчика ПриСозданииНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет изменить внешний вид и поведение формы, например, разместить на ней дополнительные элементы:
// информационные надписи, кнопки, гиперссылки, различные настройки и т.п.
//
// При добавлении команд (кнопок) в качестве обработчика следует указывать имя "Подключаемый_ВыполнитьКоманду",
// а его реализацию размещать в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды (серверная часть),
// либо в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду (клиентская часть).
//
// Для того, чтобы добавить свою команду на форму, необходимо сделать следующее.
// 1. Создать команду и кнопку в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере.
// 2. Реализовать клиентский обработчик команды в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду.
// 3. (Опционально) Реализовать серверный обработчик команды в УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды.
//
// При добавлении гиперссылок в качестве обработчика нажатия следует указывать имя "Подключаемый_ОбработкаНавигационнойСсылки",
// а его реализацию размещать в УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовОбработкаНавигационнойСсылки.
//
// При размещении элементов, значение которых должны запоминаться между открытиями формы печати,
// следует воспользоваться процедурами ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере и
// ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Отказ                - Булево - признак отказа от создания формы. Если установить
//                                  данному параметру значение Истина, то форма создана не будет.
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения стандартной (системной) обработки
//                                  события. Если установить данному параметру значение Ложь, 
//                                  стандартная обработка события производиться не будет.
// 
// Пример:
//  КомандаФормы = Форма.Команды.Добавить("МояКоманда");
//  КомандаФормы.Действие = "Подключаемый_ВыполнитьКоманду";
//  КомандаФормы.Заголовок = НСтр("ru = 'Моя команда'");
//  
//  КнопкаФормы = Форма.Элементы.Добавить(КомандаФормы.Имя, Тип("КнопкаФормы"), Форма.Элементы.КоманднаяПанельПраваяЧасть);
//  КнопкаФормы.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
//  КнопкаФормы.ИмяКоманды = КомандаФормы.Имя;
//
Процедура ПечатьДокументовПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// _Демо начало примера
	
	Если Форма.НастройкиПечатныхФорм.Количество() = 1 Тогда
		ПутьКМакету = Форма.НастройкиПечатныхФорм[0].ПутьКМакету;
		Если Не (ЗначениеЗаполнено(ПутьКМакету) 
			И УправлениеПечатью.ИспользуетсяПользовательскийМакет(ПутьКМакету)
			И УправлениеПечатью.ПоставляемыйМакетИзменен(ПутьКМакету)) Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
		
	Группа = Форма.Элементы.Вставить("ГруппаПредупреждениеОбИзмененииМакета", Тип("ГруппаФормы"), , Форма.Элементы.ГруппаДополнительнаяИнформация);
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.ОтображатьЗаголовок = Ложь;
	
	Картинка = Форма.Элементы.Добавить("КартинкаПредупреждениеОбИзмененииМакета", Тип("ДекорацияФормы"), Группа);
	Картинка.Вид = ВидДекорацииФормы.Картинка;
	Картинка.Картинка = БиблиотекаКартинок.Предупреждение;

	Надпись = Форма.Элементы.Добавить("НадписьПредупреждениеОбИзмененииМакета", Тип("ДекорацияФормы"), Группа);
	Надпись.Вид = ВидДекорацииФормы.Надпись;
	Надпись.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Поставляемый макет этой печатной формы обновлен. Включить его использование можно в списке <a href = ""ПерейтиВСписокМакетов"">Макеты печатных форм</a>.'"));
	Надпись.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОбработкаНавигационнойСсылки");
	Надпись.АвтоМаксимальнаяШирина = Ложь;
	Надпись.РастягиватьПоГоризонтали = Истина;
	
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается из обработчика ПриЗагрузкеДанныхИзНастроекНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Совместно с ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере позволяет реализовать загрузку и сохранение 
// настроек элементов управления, размещенных с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма     - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Настройки - Соответствие     - значения реквизитов формы.
//
Процедура ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере(Форма, Настройки) Экспорт
	
КонецПроцедуры

// Вызывается из обработчика ПриСохраненииДанныхВНастройкахНаСервере формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Совместно с ПечатьДокументовПриЗагрузкеДанныхИзНастроекНаСервере позволяет реализовать загрузку и сохранение 
// настроек элементов управления, размещенных с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма     - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Настройки - Соответствие     - значения реквизитов формы.
//
Процедура ПечатьДокументовПриСохраненииДанныхВНастройкахНаСервере(Форма, Настройки) Экспорт

КонецПроцедуры

// Вызывается из обработчика Подключаемый_ВыполнитьКоманду формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет реализовать серверную часть обработчика команды, которая добавлена в форму 
// с помощью ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  ДополнительныеПараметры - Произвольный     - параметры, переданные из УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду.
//
// Пример:
//  Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") И ДополнительныеПараметры.ИмяКоманды = "МояКоманда" Тогда
//   ТабличныйДокумент = Новый ТабличныйДокумент;
//   ТабличныйДокумент.Область("R1C1").Текст = НСтр("ru = 'Пример использования серверного обработчика подключенной команды.'");
//  
//   ПечатнаяФорма = Форма[ДополнительныеПараметры.ИмяРеквизитаТабличногоДокумента];
//   ПечатнаяФорма.ВставитьОбласть(ТабличныйДокумент.Область("R1"), ПечатнаяФорма.Область("R1"), 
//    ТипСмещенияТабличногоДокумента.ПоГоризонтали)
//  КонецЕсли;
//
Процедура ПечатьДокументовПриВыполненииКоманды(Форма, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
