-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 05, 2020 at 08:53 PM
-- Server version: 5.7.24
-- PHP Version: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `covid_regulations`
--

-- --------------------------------------------------------

--
-- Table structure for table `areas`
--

CREATE TABLE `areas` (
  `ID` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `masks` tinyint(1) DEFAULT NULL,
  `distancing` tinyint(1) DEFAULT NULL,
  `temps` tinyint(1) DEFAULT NULL,
  `sanitation` tinyint(1) DEFAULT NULL,
  `details` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `areas`
--

INSERT INTO `areas` (`ID`, `name`, `masks`, `distancing`, `temps`, `sanitation`, `details`) VALUES
(1, 'Maryland', 1, 1, 1, NULL, 'Not on lockdown, six foot distance enforced in public areas.'),
(2, 'PG County', NULL, NULL, NULL, NULL, ''),
(3, 'Maine', 1, 1, 1, NULL, 'Not locked down, but six foot distance enforced in public.');

-- --------------------------------------------------------

--
-- Stand-in structure for view `currentlocationentries`
-- (See below for the actual view)
--
CREATE TABLE `currentlocationentries` (
`ID` int(11)
,`name` varchar(30)
,`address` varchar(50)
,`type` int(11)
,`details` varchar(150)
,`masks` tinyint(1)
,`distancing` tinyint(1)
,`sanitation` tinyint(1)
,`temps` tinyint(1)
,`creator` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `entries`
--

CREATE TABLE `entries` (
  `ID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `address` varchar(50) NOT NULL,
  `name` varchar(30) NOT NULL,
  `masks` tinyint(1) DEFAULT NULL,
  `distancing` tinyint(1) DEFAULT NULL,
  `temps` tinyint(1) DEFAULT NULL,
  `sanitation` tinyint(1) DEFAULT NULL,
  `details` varchar(150) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creator` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `entries`
--

INSERT INTO `entries` (`ID`, `locationID`, `type`, `address`, `name`, `masks`, `distancing`, `temps`, `sanitation`, `details`, `timestamp`, `creator`) VALUES
(1, 1, 1, '123 Main Street', 'Tony\'s Pizza', 1, 1, 0, 0, '', '2020-12-04 00:38:53', 1),
(2, 1, 1, '123 Main Street', 'Tony\'s Pizzeria', 0, 0, 0, 0, 'This is the second entry.', '2020-12-04 14:41:40', 1);

-- --------------------------------------------------------

--
-- Table structure for table `locationareas`
--

CREATE TABLE `locationareas` (
  `ID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL,
  `areaID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `locationareas`
--

INSERT INTO `locationareas` (`ID`, `locationID`, `areaID`) VALUES
(1, 1, 2),
(2, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`ID`) VALUES
(1);

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `ID` int(11) NOT NULL,
  `areaID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`ID`, `areaID`) VALUES
(1, 1),
(2, 3);

-- --------------------------------------------------------

--
-- Table structure for table `types`
--

CREATE TABLE `types` (
  `ID` int(11) NOT NULL,
  `name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `types`
--

INSERT INTO `types` (`ID`, `name`) VALUES
(1, 'Restaurant');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `area` int(11) DEFAULT NULL,
  `isBlocked` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`ID`, `email`, `password`, `area`, `isBlocked`) VALUES
(1, 'lenhardt@umd.edu', 'goterps', NULL, 0);

-- --------------------------------------------------------

--
-- Structure for view `currentlocationentries`
--
DROP TABLE IF EXISTS `currentlocationentries`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `currentlocationentries`  AS  select `entries`.`locationID` AS `ID`,`entries`.`name` AS `name`,`entries`.`address` AS `address`,`entries`.`type` AS `type`,`entries`.`details` AS `details`,`entries`.`masks` AS `masks`,`entries`.`distancing` AS `distancing`,`entries`.`sanitation` AS `sanitation`,`entries`.`temps` AS `temps`,`entries`.`creator` AS `creator` from (`entries` join (select `entries`.`locationID` AS `locationID`,max(`entries`.`timestamp`) AS `timestamp` from `entries` group by `entries`.`locationID`) `subquery` on(((`entries`.`locationID` = `subquery`.`locationID`) and (`entries`.`timestamp` = `subquery`.`timestamp`)))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `entries`
--
ALTER TABLE `entries`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `creatorFK` (`creator`),
  ADD KEY `typeFK` (`type`),
  ADD KEY `locationIDFK` (`locationID`);

--
-- Indexes for table `locationareas`
--
ALTER TABLE `locationareas`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `locationAreaslocationIDFK` (`locationID`),
  ADD KEY `locationAreasAreaIDFK` (`areaID`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `statesAreaIDFK` (`areaID`);

--
-- Indexes for table `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `usersAreaFK` (`area`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `areas`
--
ALTER TABLE `areas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `entries`
--
ALTER TABLE `entries`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `locationareas`
--
ALTER TABLE `locationareas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `types`
--
ALTER TABLE `types`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `entries`
--
ALTER TABLE `entries`
  ADD CONSTRAINT `creatorFK` FOREIGN KEY (`creator`) REFERENCES `users` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `locationIDFK` FOREIGN KEY (`locationID`) REFERENCES `locations` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `typeFK` FOREIGN KEY (`type`) REFERENCES `types` (`ID`) ON UPDATE CASCADE;

--
-- Constraints for table `locationareas`
--
ALTER TABLE `locationareas`
  ADD CONSTRAINT `locationAreasAreaIDFK` FOREIGN KEY (`areaID`) REFERENCES `areas` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `locationAreaslocationIDFK` FOREIGN KEY (`locationID`) REFERENCES `locations` (`ID`) ON UPDATE CASCADE;

--
-- Constraints for table `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `statesAreaIDFK` FOREIGN KEY (`areaID`) REFERENCES `areas` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `usersAreaFK` FOREIGN KEY (`area`) REFERENCES `areas` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
