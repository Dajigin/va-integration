Расширение для интеграции фреймворка тестирования Vanessa Automation в конфигурацию на базе БСП.

Проект Vanessa Automation: https://github.com/Pr-Mex/vanessa-automation 
Для использования текущего проекта скачивать Vanessa Automation не нужно: в расширение встроена обработка Vanessa Automation Single v. 1.2.027.

  Расширение подключается к конфигурациям на базе БСП (тестировалось на БСП 3.1.2.157).

  Для тестирования расширения можно использовать демонстрационную базу БСП, входящую в состав дистрибутива: 
https://releases.1c.ru/version_files?nick=SSL31&ver=3.1.2.157

  Расширение поставляется в виде набора проектов EDT. Кроме того, в состав проекта включен скомпилированный файл расширения va_integration.cfe,
который можно подключить к конфигурации в обычном порядке.

  Для работы расширения необходимо в настройках подключения снять галки "Безопасный режим" и "Защита от опасных действий". Так же
у пользователя, от имени которого запускается менеджер тестирования, должна быть отключена защита от опасных действий.

  Для того, чтобы в форме списка справочника(документа) появилась кнопка тестирования, форма списка должна быть подключена 
к подсистеме "Подключаемые команды" в соответствии с документацией БСП версии, используемой в конфигурации. Например, для версии 3.1.2 
порядок подключения описан в https://its.1c.ru/db/bsp312doc#content:54:hdoc

  В поставку, так же, входит шаблон каталога тестов VATests_Project, содержащий примеры тестов для справочника Демо:Контрагенты
и документа Демо:Оприходование товаров, входящих в состав демонстрационной базы БСП.

Для подключения к демонстрационной бзе БСП с использованием конфигуратора

1) Загрузить проект локально (для использования конфигуратора достаточно файла va_integration.cfe и каталога VATests_Project).
2) Развернуть демо-базу БСП.
3) Подключить расширение va_integration.cfe, сняв галки "Безопасный режим" и "Защита от опасных действий"
4) Запустить демо-базу в режиме Предприятия от имени Администратора с ключем запуска /TESTMANAGER
5) В пункте меню "Тестирование/Каталог тестов" выбрать путь к каталогу VATests_Project

Пример регрессионного теста конкретного документа:
1) Открыть форму списка документов "Интегрируемые подсистемы/Демо:Оприходование товаров" появилась кнопка "Регрессионное тестирование"
2) Убедиться, что над формой списка есть кнопка "Регрессионное тестирования"
3) При нажатии на эту кнопку должна запуститься обработка Vanessa Automation Single с демонстрационным примером теста документа "Оприходование товаров".

Пример приемочного теста:
Пример шаблона приемочного теста можно увидеть выбрав пункт меню "Тестирование/Приемочные тесты". 





