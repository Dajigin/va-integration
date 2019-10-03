
#Область СлужебныйПрограммныйИнтерфейс

Функция ПараметрыЗапроса() Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("method", "");
	ПараметрыЗапроса.Вставить("version", 4);
	ПараметрыЗапроса.Вставить("realmid", Константы.КлючОбластиДанных.Получить());
	ПараметрыЗапроса.Вставить("userid", Строка(Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса));
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция МетодыИнтерфейсамМенеджераСервиса() Экспорт 
	
	Методы = Новый Соответствие;
	Методы.Вставить("ПолучитьСписокДоступныхРасширений", 	"getlist");
	Методы.Вставить("ПолучитьПревьюРасширений", 			"getimages");
	Методы.Вставить("ПолучитьСписокНайденныхРасширений", 	"search");
	Методы.Вставить("ПолучитьДанныеВерсииРасширения", 		"get");
	Методы.Вставить("НачатьУстановкуРасширения", 			"install");
	Методы.Вставить("НачатьУдалениеРасширения", 			"delete");
	Методы.Вставить("ПолучитьСтатусРасширения", 			"getstatus");
	Методы.Вставить("ПолучитьСписокРазделов", 				"getsections");
	Методы.Вставить("ИзменитьОценкуПользователя",			"editrating");
	Методы.Вставить("УдалитьОценкуПользователя",			"deleterating");
	Методы.Вставить("ПолучитьРасширенияДляНовойОбласти",	"getextensionsforapplication");
	
	Возврат Новый ФиксированноеСоответствие(Методы);
	
КонецФункции

Функция СинонимыДопПараметровМетодов() Экспорт 
	
	ДопПараметры = Новый Соответствие;
	ДопПараметры.Вставить("ИдентификаторПоследнегоРасширения", "lastext");
	ДопПараметры.Вставить("КоличествоЭлементовВВыборке", "listlength");
	ДопПараметры.Вставить("ОтправлятьПревью", "sendimages");
	ДопПараметры.Вставить("СтрокаПоиска", "keyword");
	ДопПараметры.Вставить("ИдентификаторВерсииРасширения", "extversionid");
	ДопПараметры.Вставить("ИдентификаторРасширения", "extid");
	ДопПараметры.Вставить("ИдентификаторыВерсийРасширений", "extversionsid");
	ДопПараметры.Вставить("ТолькоУстановленные", "onlyinstalled");
	ДопПараметры.Вставить("МассивТиповДоступа", "sections");
	ДопПараметры.Вставить("Оценка", "rating");
	ДопПараметры.Вставить("Отзыв", "comment");
	ДопПараметры.Вставить("Заголовок", "caption");
	ДопПараметры.Вставить("НавигационнаяСсылкаИБ", "infobaseurl");
	
	Возврат Новый ФиксированноеСоответствие(ДопПараметры);
	
КонецФункции

Функция КоличествоЭлементовВВыборке() Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.КаталогРасширенийКоличествоЭлементовВВыборке.Получить();
	
КонецФункции

Функция ОтправлятьПревью() Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.КаталогРасширенийОтправлятьПревьюПриЗапросеСписка.Получить();
	
КонецФункции

#КонецОбласти