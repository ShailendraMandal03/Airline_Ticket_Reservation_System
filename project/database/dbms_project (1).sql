-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 16, 2024 at 09:54 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbms_project`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`username`, `password`, `Name`, `Email`) VALUES
('a1', 'p1', 'Ananya Gupta', 'ananya@gmail.com'),
('a2', 'p2', 'Vikram Patel', 'vikram@gmail.com'),
('a3', 'p3', 'Neha Mishra', 'neha@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `airline_details`
--

CREATE TABLE `airline_details` (
  `Airline_id` varchar(10) NOT NULL,
  `Airline_type` varchar(20) DEFAULT NULL,
  `total_capacity` int(5) DEFAULT NULL,
  `active` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `airline_details`
--

INSERT INTO `airline_details` (`Airline_id`, `Airline_type`, `total_capacity`, `active`) VALUES
('10001', 'Dreamliner', 300, 'Yes'),
('10002', 'Airbus A380', 275, 'No'),
('10003', 'Go India', 50, 'Yes'),
('10004', 'Air Indai', 225, 'Yes'),
('10005', 'IndiGo', 300, 'No'),
('10007', 'Test_Model', 250, 'Yes');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `Phone_No` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`username`, `password`, `NAME`, `Email`, `Age`, `Phone_No`) VALUES
('ankit', '1234', 'Ankit Gond', 'ankit@gmail.com', 22, 2147483647),
('c1', 'p1', 'Rajesh Kumar', 'rajesh@gmail.com', 30, 2147483647),
('c2', 'p2', 'Priya Sharma', 'priya@hotmail.com', 25, 2147483647),
('e1', 'p1', 'eikansh', 'eika@gmail.com', 20, 23681234),
('ram1', '321', 'Ram Mohan', 'ram@gmail.com', 23, 7654321),
('shailendra12', '12345', 'shailendra Kumar', 'shailendramandal1289@gmail.com', 21, 2147483647),
('Skdon', '321', 'sam Danail', 'skm@gm.com', 28, 1232511),
('u1', 'p1', 'Rajesh Kumar', 'rajesh@gmail.com', 30, 98765432),
('u2', 'p2', 'Priya Sharma', 'priya@hotmail.com', 25, 8765432);

-- --------------------------------------------------------

--
-- Table structure for table `flight_detail`
--

CREATE TABLE `flight_detail` (
  `flight_no` varchar(10) NOT NULL,
  `from_location` varchar(20) DEFAULT NULL,
  `to_location` varchar(20) DEFAULT NULL,
  `date` date NOT NULL,
  `arrival_date` date DEFAULT NULL,
  `departure_time` time DEFAULT NULL,
  `arrival_time` time DEFAULT NULL,
  `price_economy` int(10) DEFAULT NULL,
  `price_business` int(10) DEFAULT NULL,
  `Airline_id` varchar(10) DEFAULT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `flight_detail`
--

INSERT INTO `flight_detail` (`flight_no`, `from_location`, `to_location`, `date`, `arrival_date`, `departure_time`, `arrival_time`, `price_economy`, `price_business`, `Airline_id`) VALUES
('AA103', 'Delhi', 'Jaipur', '2024-04-20', '2024-04-20', '10:05:00', '11:05:00', 3000, 5000, '10003'),
('AA104', 'Delhi', 'Mumbai', '2024-04-20', '2024-04-20', '08:50:00', '10:10:00', 5000, 7000, '10004'),
('AA105', 'Delhi', 'Mumbai', '2024-04-20', '2024-04-20', '16:35:00', '17:50:00', 4800, 7000, '10005'),
('AA109', 'Goa', 'Chennai', '2024-04-21', '2024-04-21', '07:08:00', '08:08:00', 4000, 8000, '10003');

-- --------------------------------------------------------

--
-- Table structure for table `passenger`
--

CREATE TABLE `passenger` (
  `passenger_id` int(11) NOT NULL,
  `pnr` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `Email` varchar(40) DEFAULT NULL,
  `Gender` varchar(10) DEFAULT NULL,
  `ID_type` varchar(30) DEFAULT NULL,
  `ID_no` int(11) NOT NULL,
  `meal_choice` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passenger`
--

INSERT INTO `passenger` (`passenger_id`, `pnr`, `Name`, `Age`, `Email`, `Gender`, `ID_type`, `ID_no`, `meal_choice`) VALUES
(1, 66512817, 'SUman', 18, 'SUmo@gmail.com', 'Male', 'Voter ID Card', 991234, 'yes'),
(1, 72105250, 'shkm', 21, 'skm@gm.com', 'Male', 'Voter ID Card', 987654, 'yes'),
(2, 66512817, 'Ankit', 24, 'ankit@gmail.com', 'Male', 'Voter ID Card', 7654208, 'yes'),
(2, 72105250, 'ram', 26, 'ram@gmail.com', 'Male', 'Voter ID Card', 1376543, 'no');

-- --------------------------------------------------------

--
-- Table structure for table `payment_details`
--

CREATE TABLE `payment_details` (
  `transaction_id` varchar(20) NOT NULL,
  `pnr` int(11) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `payment_amount` int(6) DEFAULT NULL,
  `payment_mode` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `payment_details`
--

INSERT INTO `payment_details` (`transaction_id`, `pnr`, `payment_date`, `payment_amount`, `payment_mode`) VALUES
('35891997', 72105250, '2024-04-14', 7500, 'net banking'),
('66402726', 66512817, '2024-04-14', 16100, 'debit card');

--
-- Triggers `payment_details`
--
DELIMITER $$
CREATE TRIGGER `update_ticket_after_payment` AFTER INSERT ON `payment_details` FOR EACH ROW UPDATE ticket_details
     SET booking_status='CONFIRMED', payment_id= NEW.transaction_id
   WHERE pnr = NEW.pnr
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_details`
--

CREATE TABLE `ticket_details` (
  `pnr` int(11) NOT NULL,
  `date_of_reservation` date DEFAULT NULL,
  `flight_no` varchar(10) DEFAULT NULL,
  `journey_date` date DEFAULT NULL,
  `class` varchar(10) DEFAULT NULL,
  `booking_status` varchar(20) DEFAULT NULL,
  `no_of_passengers` int(5) DEFAULT NULL,
  `lounge_access` varchar(5) DEFAULT NULL,
  `priority_checkin` varchar(5) DEFAULT NULL,
  `insurance` varchar(5) DEFAULT NULL,
  `payment_id` varchar(20) DEFAULT NULL,
  `customer_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ticket_details`
--

INSERT INTO `ticket_details` (`pnr`, `date_of_reservation`, `flight_no`, `journey_date`, `class`, `booking_status`, `no_of_passengers`, `lounge_access`, `priority_checkin`, `insurance`, `payment_id`, `customer_id`) VALUES
(66512817, '2024-04-14', 'AA104', '2024-04-20', 'business', 'CONFIRMED', 2, 'yes', 'yes', 'yes', '66402726', 'ankit '),
(72105250, '2024-04-14', 'AA103', '2024-04-20', 'economy', 'CONFIRMED', 2, 'yes', 'yes', 'yes', '35891997', 'ankit ');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `airline_details`
--
ALTER TABLE `airline_details`
  ADD PRIMARY KEY (`Airline_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `flight_detail`
--
ALTER TABLE `flight_detail`
  ADD PRIMARY KEY (`flight_no`,`date`),
  ADD KEY `flight_details_ibfk_1` (`Airline_id`);

--
-- Indexes for table `passenger`
--
ALTER TABLE `passenger`
  ADD PRIMARY KEY (`passenger_id`,`pnr`),
  ADD KEY `pnr` (`pnr`);

--
-- Indexes for table `payment_details`
--
ALTER TABLE `payment_details`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `fk_pnr` (`pnr`);

--
-- Indexes for table `ticket_details`
--
ALTER TABLE `ticket_details`
  ADD PRIMARY KEY (`pnr`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `journey_date` (`journey_date`),
  ADD KEY `flight_no` (`flight_no`),
  ADD KEY `flight_no_2` (`flight_no`,`journey_date`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `flight_detail`
--
ALTER TABLE `flight_detail`
  ADD CONSTRAINT `flight_details_ibfk_1` FOREIGN KEY (`Airline_id`) REFERENCES `airline_details` (`Airline_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `passenger`
--
ALTER TABLE `passenger`
  ADD CONSTRAINT `passengers_ibfk_1` FOREIGN KEY (`pnr`) REFERENCES `ticket_details` (`pnr`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment_details`
--
ALTER TABLE `payment_details`
  ADD CONSTRAINT `payment_details_ibfk_1` FOREIGN KEY (`pnr`) REFERENCES `ticket_details` (`pnr`) ON UPDATE CASCADE;

--
-- Constraints for table `ticket_details`
--
ALTER TABLE `ticket_details`
  ADD CONSTRAINT `ticket_details_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ticket_details_ibfk_3` FOREIGN KEY (`flight_no`,`journey_date`) REFERENCES `flight_detail` (`flight_no`, `date`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
