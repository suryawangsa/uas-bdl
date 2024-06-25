-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2024 at 12:45 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_restoran`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_makanan`
--

CREATE TABLE `tb_makanan` (
  `id_makanan` int(10) NOT NULL,
  `harga` int(11) NOT NULL,
  `nama` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_makanan`
--

INSERT INTO `tb_makanan` (`id_makanan`, `harga`, `nama`) VALUES
(1, 12000, 'Nasi Goreng'),
(6, 12000, 'Tahu tek');

-- --------------------------------------------------------

--
-- Table structure for table `tb_minuman`
--

CREATE TABLE `tb_minuman` (
  `id_minuman` int(11) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_minuman`
--

INSERT INTO `tb_minuman` (`id_minuman`, `nama`, `harga`) VALUES
(1, 'Es teh', 5000);

-- --------------------------------------------------------

--
-- Table structure for table `tb_pelanggan`
--

CREATE TABLE `tb_pelanggan` (
  `id_pelanggan` int(5) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `no_tlp` varchar(12) NOT NULL,
  `jenis_kelamin` enum('P','L') NOT NULL,
  `alamat` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_pelanggan`
--

INSERT INTO `tb_pelanggan` (`id_pelanggan`, `nama`, `no_tlp`, `jenis_kelamin`, `alamat`) VALUES
(1, 'Eggy Yuliandika', '081333333333', 'P', 'Denpasar'),
(2, 'Surya Wangsa', '081222222222', 'L', 'Denpasar'),
(3, 'Sup', '081333333333', 'L', 'Denpasar'),
(4, 'Nathanael', '081333333333', 'L', 'Denpasar');

-- --------------------------------------------------------

--
-- Table structure for table `tb_staff`
--

CREATE TABLE `tb_staff` (
  `id_staff` int(5) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `jenis_kelamin` enum('P','L') NOT NULL,
  `shift` enum('Pagi','Sore','Middle') NOT NULL,
  `TTL` date NOT NULL,
  `divisi` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_staff`
--

INSERT INTO `tb_staff` (`id_staff`, `nama`, `jenis_kelamin`, `shift`, `TTL`, `divisi`) VALUES
(1, 'staff1', 'P', 'Pagi', '1999-06-09', 'Pelayan'),
(2, 'staff2', 'L', 'Sore', '1994-06-01', 'Pelayan'),
(3, 'staff3', 'L', 'Middle', '1998-06-03', 'Pelayan'),
(4, 'staff4', 'L', 'Pagi', '1997-06-11', 'Kasir');

-- --------------------------------------------------------

--
-- Table structure for table `tb_transaksi`
--

CREATE TABLE `tb_transaksi` (
  `id_menu_makanan` int(30) NOT NULL,
  `id_menu_minuman` int(11) NOT NULL,
  `id_transaksi` int(30) NOT NULL,
  `id_pelanggan` int(30) NOT NULL,
  `id_staff` int(30) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `total_pembayaran` int(11) NOT NULL,
  `total_belanja` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_transaksi`
--

INSERT INTO `tb_transaksi` (`id_menu_makanan`, `id_menu_minuman`, `id_transaksi`, `id_pelanggan`, `id_staff`, `jumlah`, `total_pembayaran`, `total_belanja`) VALUES
(1, 1, 2, 1, 1, 2, 17000, 17000),
(6, 1, 3, 4, 2, 2, 17000, 17000),
(1, 1, 4, 2, 3, 2, 17000, 17000);

--
-- Triggers `tb_transaksi`
--
DELIMITER $$
CREATE TRIGGER `update_total_pembayaran` AFTER INSERT ON `tb_transaksi` FOR EACH ROW BEGIN
    DECLARE total DECIMAL(10,2);

    SET total = (
        SELECT 
            SUM(IFNULL(m.harga, 0) * NEW.jumlah) + SUM(IFNULL(d.harga, 0) * NEW.jumlah)
        FROM 
            tb_transaksi t
        LEFT JOIN 
            tb_makanan m ON t.id_menu_makanan = m.id_makanan
        LEFT JOIN 
            tb_minuman d ON t.id_menu_minuman = d.id_minuman
        WHERE 
            t.id_transaksi = NEW.id_transaksi
    );

    UPDATE tb_transaksi
    SET total_pembayaran = total
    WHERE id_transaksi = NEW.id_transaksi;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_total_penjualan_per_pelanggan`
-- (See below for the actual view)
--
CREATE TABLE `view_total_penjualan_per_pelanggan` (
`id_pelanggan` int(5)
,`nama` varchar(30)
,`total_penjualan` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Structure for view `view_total_penjualan_per_pelanggan`
--
DROP TABLE IF EXISTS `view_total_penjualan_per_pelanggan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_total_penjualan_per_pelanggan`  AS SELECT `p`.`id_pelanggan` AS `id_pelanggan`, `p`.`nama` AS `nama`, sum(`t`.`total_pembayaran`) AS `total_penjualan` FROM (`tb_pelanggan` `p` join `tb_transaksi` `t` on(`p`.`id_pelanggan` = `t`.`id_pelanggan`)) GROUP BY `p`.`id_pelanggan`, `p`.`nama``nama`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_makanan`
--
ALTER TABLE `tb_makanan`
  ADD PRIMARY KEY (`id_makanan`);

--
-- Indexes for table `tb_minuman`
--
ALTER TABLE `tb_minuman`
  ADD PRIMARY KEY (`id_minuman`);

--
-- Indexes for table `tb_pelanggan`
--
ALTER TABLE `tb_pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`),
  ADD KEY `idx_id_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `tb_staff`
--
ALTER TABLE `tb_staff`
  ADD PRIMARY KEY (`id_staff`);

--
-- Indexes for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_menu` (`id_menu_makanan`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `id_staff` (`id_staff`),
  ADD KEY `id_menu_minuman` (`id_menu_minuman`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_makanan`
--
ALTER TABLE `tb_makanan`
  MODIFY `id_makanan` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tb_minuman`
--
ALTER TABLE `tb_minuman`
  MODIFY `id_minuman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tb_pelanggan`
--
ALTER TABLE `tb_pelanggan`
  MODIFY `id_pelanggan` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_staff`
--
ALTER TABLE `tb_staff`
  MODIFY `id_staff` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  MODIFY `id_transaksi` int(30) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_transaksi`
--
ALTER TABLE `tb_transaksi`
  ADD CONSTRAINT `tb_transaksi_ibfk_1` FOREIGN KEY (`id_menu_makanan`) REFERENCES `tb_makanan` (`id_makanan`),
  ADD CONSTRAINT `tb_transaksi_ibfk_2` FOREIGN KEY (`id_pelanggan`) REFERENCES `tb_pelanggan` (`id_pelanggan`),
  ADD CONSTRAINT `tb_transaksi_ibfk_3` FOREIGN KEY (`id_staff`) REFERENCES `tb_staff` (`id_staff`),
  ADD CONSTRAINT `tb_transaksi_ibfk_4` FOREIGN KEY (`id_menu_minuman`) REFERENCES `tb_minuman` (`id_minuman`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
