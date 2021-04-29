Перем мСчетчик;
Перем СтандартныйРазмерПаузы;
Перем БлокировкаРесурса;

// Конструктор.
//
// Параметры:
//   Счетчик - Число - Начальное значение мСчетчика захватов семафора.
//
Процедура ПриСозданииОбъекта(Счетчик = 1)
	// Обход проблемы неинициализации значений по умолчанию в конструкторах
	// на старых версиях движка OneScript
	Если Счетчик = Неопределено Тогда
		мСчетчик = 1;
	Иначе
		мСчетчик = Счетчик;
	КонецЕсли;
	
	СтандартныйРазмерПаузы = 10;
	БлокировкаРесурса      = Новый БлокировкаРесурса(ЭтотОбъект);

КонецПроцедуры

// Осуществить захват семафора.
// Уменьшает значение счетчика на единицу.
// В случае истечения таймаута ожидания на захват семафора
// выбрасывает исключение.
//
// Параметры:
//   ТаймаутОжидания - Число - Таймаут ожидания захвата семафора в миллисекундах.
//
Процедура Захватить(ТаймаутОжидания = 0) Экспорт
	ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Пока Истина Цикл
		БлокировкаРесурса.Заблокировать();
		мСчетчик = мСчетчик - 1;
		Если мСчетчик < 0 Тогда
			мСчетчик = мСчетчик + 1;
			БлокировкаРесурса.Разблокировать();
			Если ЗначениеЗаполнено(ТаймаутОжидания) Тогда
				ТекущееВремя = ТекущаяУниверсальнаяДатаВМиллисекундах();
				Если (ВремяНачала + ТаймаутОжидания) < ТекущееВремя Тогда
					ВызватьИсключение "Истекло время ожидания захвата семафора";
				КонецЕсли;
			КонецЕсли;
			Приостановить(СтандартныйРазмерПаузы);
		Иначе
			БлокировкаРесурса.Разблокировать();
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Освободить семафор.
// Увеличивает значение счетчика на единицу.
//
Процедура Освободить() Экспорт
	мСчетчик = мСчетчик + 1;
КонецПроцедуры
