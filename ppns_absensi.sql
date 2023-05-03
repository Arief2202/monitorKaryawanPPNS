-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 03, 2023 at 05:31 PM
-- Server version: 10.6.12-MariaDB-0ubuntu0.22.04.1
-- PHP Version: 8.2.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ppns/absensi`
--

-- --------------------------------------------------------

--
-- Table structure for table `history_location`
--

CREATE TABLE `history_location` (
  `id` int(255) NOT NULL,
  `nuid` int(255) NOT NULL,
  `x` double NOT NULL,
  `y` double NOT NULL,
  `ruang` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `monitor_karyawan`
--

CREATE TABLE `monitor_karyawan` (
  `id` int(255) NOT NULL,
  `nuid` varchar(255) NOT NULL,
  `ruang` varchar(255) NOT NULL DEFAULT '-',
  `pesan` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `nuid` int(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`nuid`, `name`, `username`, `email`, `password`) VALUES
(1, 'riza', 'riza', 'riza', 'password'),
(2, 'vicky', 'vicky13', 'vicky', 'vicky'),
(3, 'vicky', 'vickyrisky', 'vicky', 'vicky');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `history_location`
--
ALTER TABLE `history_location`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FOREIGN` (`nuid`) USING BTREE;

--
-- Indexes for table `monitor_karyawan`
--
ALTER TABLE `monitor_karyawan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`nuid`),
  ADD UNIQUE KEY `UNIQUE` (`username`,`email`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `history_location`
--
ALTER TABLE `history_location`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `monitor_karyawan`
--
ALTER TABLE `monitor_karyawan`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `nuid` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `history_location`
--
ALTER TABLE `history_location`
  ADD CONSTRAINT `nuid` FOREIGN KEY (`nuid`) REFERENCES `user` (`nuid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
