# uas-bdl

A. ERD
![erd](https://github.com/suryawangsa/uas-bdl/assets/173679468/943277ea-ba29-43fb-9509-7cddabc699e5)

B. Deskripsi Project
Project Database Restoran
Proyek ini bertujuan untuk mengembangkan sistem basis data yang efisien untuk mengelola operasi sehari-hari restoran. Sistem ini akan mencakup manajemen data pelanggan, menu makanan dan minuman, transaksi, dan stok bahan baku. Dengan menggunakan basis data ini, restoran dapat dengan mudah melacak pesanan, pembayaran, dan inventaris, serta meningkatkan pengalaman pelanggan.

Lingkup Proyek
Proyek ini mencakup desain dan implementasi basis data yang mencakup entitas utama berikut:
- Pelanggan
- Makanan
- Minuman
- Transaksi
- Stok Bahan Baku

Manfaat
- Efisiensi Operasional: Mempermudah pengelolaan pesanan dan inventaris.
- Pelaporan yang Akurat: Menyediakan laporan penjualan dan stok secara real-time.
- Peningkatan Layanan Pelanggan: Memungkinkan pelacakan preferensi pelanggan untuk meningkatkan pengalaman mereka.

Dengan basis data ini, restoran akan memiliki alat yang andal untuk mengelola operasi mereka dengan lebih efektif dan efisien, memungkinkan mereka untuk fokus pada memberikan layanan yang lebih baik kepada pelanggan mereka.

C. Skema basis data, relasi, trigger, view
Deskripsi Tabel dan Relasi
1. Tabel tb_pelanggan
Menyimpan informasi tentang pelanggan yang bertransaksi di restoran.
Kolom:
  - id_pelanggan (Primary Key): ID unik untuk setiap pelanggan.
  - nama: Nama pelanggan.
  - alamat: Alamat pelanggan.
  - kontak: Informasi kontak pelanggan (telepon/email).

2. Tabel tb_makanan
Menyimpan data tentang menu makanan yang tersedia di restoran.
Kolom:
  - id_makanan (Primary Key): ID unik untuk setiap makanan.
  - nama: Nama makanan.
  - harga: Harga makanan.
  - deskripsi: Deskripsi singkat tentang makanan.

3. Tabel tb_minuman
Menyimpan data tentang menu minuman yang tersedia di restoran.
Kolom:
  - id_minuman (Primary Key): ID unik untuk setiap minuman.
  - nama: Nama minuman.
  - harga: Harga minuman.
  - deskripsi: Deskripsi singkat tentang minuman.

4. Tabel tb_transaksi
Menyimpan data tentang setiap transaksi yang terjadi di restoran.
Kolom:
  - id_transaksi (Primary Key): ID unik untuk setiap transaksi.
  - id_pelanggan (Foreign Key): ID pelanggan yang melakukan transaksi.
  - id_menu_makanan (Foreign Key): ID makanan yang dipesan.
  - id_menu_minuman (Foreign Key): ID minuman yang dipesan.
  - jumlah: Jumlah item yang dipesan.
  - tanggal: Tanggal transaksi.
  - total_pembayaran: Total pembayaran untuk transaksi tersebut.

5. Tabel tb_staff
Menyimpan data tentang stok bahan baku di restoran.
Kolom:
  - id_staff(Primary Key): ID unik untuk setiap staff.
  - nama: nama staff.
  - shift: shift kerja yang didapatkan oleh staff.
  - jenis_kelamin: jenis_kelamin dari staff.
  - jabatan: jabatan dari staff tersebut di restoran.
  - TTL: tempat, tanggal dan tahun lahir dari staff tersebut.

6. Relasi Antar Tabel
- tb_pelanggan ke tb_transaksi: Hubungan satu-ke-banyak (one-to-many). Satu pelanggan dapat memiliki banyak transaksi.
- tb_makanan ke tb_transaksi: Hubungan satu-ke-banyak (many-to-many). Banyak jenis makanan dapat muncul dalam banyak transaksi.
- tb_minuman ke tb_transaksi: Hubungan satu-ke-banyak (many-to-many). Banyak jenis minuman dapat muncul dalam banyak transaksi.
- tb_staff le tb_pelanggan: Hubungan satu-ke-satu (one-to-one). Satu staff dapat melayani satu pelanggan.

7. Fitur Utama
- Manajemen Pelanggan: Menambah, mengubah, dan menghapus data pelanggan.
- Manajemen Menu: Menambah, mengubah, dan menghapus data menu makanan dan minuman.
- Manajemen Transaksi: Melacak semua transaksi yang terjadi di restoran, termasuk perhitungan total pembayaran.
- Manajemen Staff: Memantau semua staff yang bekerja di restoran, staff tersebut melayani pelanggan yang mana saja.

Inner Join
- Query
Select id_transaksi, tb_pelanggan.nama, tb_makanan.nama as makanan, tb_makanan.harga as harga_makanan, tb_minuman.nama as minuman, tb_minuman.harga as harga_minuman from (((tb_transaksi INNER JOIN tb_pelanggan on tb_transaksi.id_pelanggan = tb_pelanggan.id_pelanggan) INNER JOIN tb_makanan ON tb_transaksi.id_menu_makanan = tb_makanan.id_makanan) INNER JOIN tb_minuman ON tb_transaksi.id_menu_minuman = tb_minuman.id_minuman);
- Penjelasan
Query diatas menggabungkan data dari tabel transaksi, pelanggan, makanan, dan minuman untuk memberikan rincian lengkap dari setiap transaksi yang melibatkan pelanggan, makanan, dan minuman tertentu, dimana pada table pelanggan mengambil data nama, table makanan mengambil data nama dan harga, table minuman mengambil data nama dan harga. Menggabungkannya menggunakan id yang sudah berelasi disetiap tabelnya.

Left Join
- Query
select * from tb_pelanggan left join tb_transaksi on tb_pelanggan.id_pelanggan = tb_transaksi.id_transaksi;
- Penjelasan
Query diatas menampilkan semua data dari tabel pelanggan yang sudah melakukan transaksi. Menggabungkannya menggunakan id yang sudah berelasi disetiap tabelnya.

Wildcard
- Query
SELECT * FROM tb_pelanggan WHERE nama LIKE '%a';
- Penjelasan
Query diatas akan menampilkan semua data dari table pelanggan yang memiliki nama dengan akhiran ‘a’.

Having
- Query
SELECT id_menu_makanan AS makanan, SUM(jumlah) AS jumlah_penjualan FROM tb_transaksi t HAVING SUM(jumlah) < 10;
- Penjelasan
Query diatas menampilkan id_menu_makanan, menjumlahkan semua makanan pada tabel transaksi dan menampilkan transaksi yang jumlah makanannya kurang dari 10.

Sub Query
- Query
SELECT makanan, total_penjualan FROM (SELECT tb_makanan.nama AS makanan, SUM(tb_transaksi.jumlah) AS total_penjualan FROM tb_transaksi JOIN tb_makanan ON tb_transaksi.id_menu_makanan = tb_makanan.id_makanan GROUP BY tb_makanan.nama) AS Subquery HAVING total_penjualan > 4;
- Penjelasan
Query diatas akan digunakan untuk mengambil nama makanan dan total penjualannya dari tabel tb_makanan dan tb_transaksi, dengan syarat total penjualan lebih dari 4,, yang dimana query select sebagai sub querynya.

View
- Query
CREATE VIEW view_total_penjualan_per_pelanggan AS SELECT p.id_pelanggan, p.nama, SUM(t.total_pembayaran) AS total_penjualan FROM tb_pelanggan p JOIN tb_transaksi t ON p.id_pelanggan = t.id_pelanggan GROUP BY p.id_pelanggan, p.nama;
- Penjelasan
Pada query view diatas akan digunakan untuk membuat view bernama view_total_penjualan_per_pelanggan yang berisi total penjualan per pelanggan. Dimana membuat sebuah view yang berisi data total penjualan untuk setiap pelanggan. View ini akan menampilkan ID pelanggan,     nama pelanggan, dan total penjualan yang telah dilakukan oleh pelanggan tersebut.

Agregate(SUM)
- Query
SELECT SUM(jumlah) AS total_penjualan FROM tb_transaksi;
- Penjelasan
Query diatas akan menampilkan jumlah semua makanan dan minuman yang terjual pada tabel transaksi dengan query SUM. 

Index
- Query
CREATE INDEX idx_id_pelanggan ON tb_pelanggan(id_pelanggan);
- Penjelasan
Query diatas akan digunakan untuk membuat sebuah indeks pada kolom id_pelanggan di tabel tb_pelanggan, yang akan meningkatkan kinerja operasi query yang sering menggunakan kolom tersebut, seperti pencarian atau penggabungan (JOIN).

Trigger
- Query
CREATE TRIGGER update_total_pembayaran AFTER INSERT ON tb_transaksi FOR EACH ROW BEGIN DECLARE total DECIMAL(10,2); SET total = ( SELECT SUM(IFNULL(m.harga, 0) * NEW.jumlah) + SUM(IFNULL(d.harga, 0) * NEW.jumlah) FROM tb_transaksi t LEFT JOIN tb_makanan m ON         t.id_menu_makanan = m.id_makanan LEFT JOIN tb_minuman d ON t.id_menu_minuman = d.id_minuman WHERE t.id_transaksi = NEW.id_transaksi ); UPDATE tb_transaksi SET total_pembayaran = total WHERE id_transaksi = NEW.id_transaksi; END;
- Penjelasan
Pada query trigger diatas akan secara otomatis menghitung dan memperbarui total pembayaran untuk setiap transaksi baru yang dimasukkan ke dalam tabel tb_transaksi. Ini memastikan bahwa kolom total_pembayaran selalu terisi dengan jumlah total harga makanan dan minuman   yang termasuk dalam transaksi tersebut.


Sekian penjelasan mengenai project uas db_restoran, terimakasih.



