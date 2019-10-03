
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает имя файла описания порядка обработки и идентификаторов обработчиков файлов начального заполнения области.
// Пример содержимого файла файла: {"upload": [{"file":"base_data.json","handler":"base_data"}]}, где
//  - upload - секция с описаниями порядка обработки, может содержать несколько элементов.
//  - file - имя файла начальных данных для обработки.
//  - handler - идентификатор обработчика файла начальных данных.
//
// Возвращаемое значение:
//   Строка - имя файла манифеста "manifest.json".
//
Функция ИмяФайлаМанифеста() Экспорт
	
    Возврат "manifest.json";	
	
КонецФункции
 
// Возвращает имя свойства порядка обработки файла описания порядка обработки файлов начального заполнения области.
// 
// Возвращаемое значение:
//   Строка - имя свойства порядка обработки.
//
Функция ИмяПоляСоставаДанных() Экспорт
	
	Возврат "upload";
	
КонецФункции

#Область ПоляДанных

Функция ПолеОсновнойРаздел() Экспорт
	
	Возврат "general";
	
КонецФункции

Функция ПолеКодВозврата() Экспорт
	
	Возврат "response";
	
КонецФункции

Функция ПолеОшибка() Экспорт
	
	Возврат "error";
	
КонецФункции

Функция ПолеСообщениеОбОшибке() Экспорт
	
	Возврат "message";
	
КонецФункции

Функция ПолеОбработчик() Экспорт
	
    Возврат "handler";	
	
КонецФункции

Функция ПолеВерсия() Экспорт
	
    Возврат "version";	
	
КонецФункции

Функция ПолеФайл() Экспорт
	
    Возврат "file";	
	
КонецФункции

Функция ПолеХранилище() Экспорт
	
	Возврат "storage";
	
КонецФункции

Функция ПолеИдентификатор() Экспорт
	
	Возврат "id";
	
КонецФункции

#КонецОбласти

Функция УдалениеФайла() Экспорт
	
    Возврат НСтр("ru = 'Удаление файла'", ОбщегоНазначения.КодОсновногоЯзыка())
	
КонецФункции
 
Функция ФайлНеНайден() Экспорт
	
	НСтр("ru = 'Не найден файл ''%1'''");
	
КонецФункции

Функция ФайлПоврежден() Экспорт
	
	Возврат НСтр("ru = 'Файл поврежден.'");
	
КонецФункции

Функция МанифестНеЗадан() Экспорт
    
    Возврат НСтр("ru = 'Не задан манифест.'");
	
КонецФункции

Функция МанифестНеВерногоФормата() Экспорт
    
	Возврат НСтр("ru = 'Манифест не верного формата. Ожидается файл в формате json.'");
	
КонецФункции

Функция ОтсутствуетСвойствоМанифеста() Экспорт 
	
    Возврат НСтр("ru = 'Отсутствует свойство манифеста ''%1'''");
	
КонецФункции
    
Функция ОбработчикНеНайден() Экспорт
	
	Возврат НСтр("ru = 'Не найден обработчик ''%1'''");
	
КонецФункции

Функция МетодНеПоддерживается() Экспорт
    
    Возврат НСтр("ru = 'Метод не поддерживается.'");
	
КонецФункции

Функция КодыВозврата() Экспорт
	
	КодыВозврата = Новый Структура;
    КодыВозврата.Вставить("Выполнено", 10200);
    КодыВозврата.Вставить("ОшибкаДанных", 10400);
    КодыВозврата.Вставить("НеНайдено", 10404);
    КодыВозврата.Вставить("ВнутренняяОшибка", 10500);
    КодыВозврата.Вставить("ВыполненоСПредупреждениями", 10240);
    Возврат КодыВозврата;
    
КонецФункции
    
#КонецОбласти  


