-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: db
-- Время создания: Фев 15 2021 г., 14:24
-- Версия сервера: 10.5.8-MariaDB-1:10.5.8+maria~focal
-- Версия PHP: 7.4.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `EXADEL_DIMA`
--

-- --------------------------------------------------------

--
-- Структура таблицы `Result`
--

CREATE TABLE `Result` (
  `ID` int(10) NOT NULL,
  `StudentId` int(5) DEFAULT NULL,
  `Task1` varchar(10) DEFAULT NULL,
  `Task2` varchar(10) DEFAULT NULL,
  `Task3` varchar(10) DEFAULT NULL,
  `Task4` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `Result`
--

INSERT INTO `Result` (`ID`, `StudentId`, `Task1`, `Task2`, `Task3`, `Task4`) VALUES
(1, 1, 'pass', 'pass', 'pass', 'pass'),
(2, 2, 'pass', 'pass', 'pass', ''),
(3, 3, 'pass', 'pass', 'pass', 'pass'),
(4, 4, 'pass', 'pass', 'not passed', ''),
(5, 5, 'pass', 'pass', 'not passed', ''),
(6, 6, 'pass', 'pass', 'not passed', ''),
(7, 7, 'pass', 'not passed', 'not passed', ''),
(8, 8, 'pass', 'pass', 'pass', 'pass'),
(9, 9, 'pass', 'not passed', 'not passed', ''),
(10, 10, 'pass', 'pass', 'pass', 'pass'),
(11, 11, 'pass', 'pass', 'pass', 'pass'),
(12, 12, 'pass', 'pass', 'pass', 'pass'),
(13, 13, 'pass', 'not passed', 'not passed', ''),
(14, 14, 'pass', 'pass', 'pass', 'pass'),
(15, 15, 'pass', 'not passed', 'not passed', ''),
(16, 16, 'pass', 'pass', 'pass', ''),
(17, 17, 'pass', 'pass', 'pass', 'pass'),
(18, 18, 'pass', 'pass', 'pass', 'pass');

-- --------------------------------------------------------

--
-- Структура таблицы `Student`
--

CREATE TABLE `Student` (
  `ID` int(10) NOT NULL,
  `Student` varchar(40) DEFAULT NULL,
  `StudentId` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `Student`
--

INSERT INTO `Student` (`ID`, `Student`, `StudentId`) VALUES
(1, 'Ражабов Дамир Шарофович', 1),
(2, 'Сивожелезов Сергей Владимирович', 2),
(3, 'Чеснюк Дмитрий Александрович', 3),
(4, 'Мацкевич Андрей Анатольевич', 4),
(5, 'Шеронов Иван Петрович', 5),
(6, 'Гавриш Олег Николаевич', 6),
(7, 'Демьянков Владислав Витальевич', 7),
(8, 'Пехоцкий Юрий Васильевич', 8),
(9, 'Шерстюк Вадим Александрович', 9),
(10, 'Казимиров Сергей Анатольевич', 10),
(11, 'Назаров Павел Андреевич', 11),
(12, 'Шатров Игорь Олегович', 12),
(13, 'Никольский Валерий Александрович', 13),
(14, 'Гурин Сергей Владимирович', 14),
(15, 'Кузин Дмитрий Алексеевич', 15),
(16, 'Наливайко Алексей Викторович', 16),
(17, 'Чех Александр Борисович', 17),
(18, 'Есьман Михаил Михайлович', 18);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `Result`
--
ALTER TABLE `Result`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `StudentId` (`StudentId`);

--
-- Индексы таблицы `Student`
--
ALTER TABLE `Student`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `StudentId` (`StudentId`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `Result`
--
ALTER TABLE `Result`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT для таблицы `Student`
--
ALTER TABLE `Student`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `Result`
--
ALTER TABLE `Result`
  ADD CONSTRAINT `Result_ibfk_1` FOREIGN KEY (`StudentId`) REFERENCES `Student` (`StudentId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
