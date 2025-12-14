# WebGIS Fasilitas Publik Kota Malang

Aplikasi WebGIS untuk visualisasi dan analisis fasilitas publik (sekolah dan rumah sakit/faskes) di Kota Malang menggunakan teknologi PostgreSQL/PostGIS, GeoServer, dan Leaflet.js.

## 📋 Daftar Isi

- [Fitur Utama](#-fitur-utama)
- [Teknologi yang Digunakan](#-teknologi-yang-digunakan)
- [Struktur Project](#-struktur-project)
- [Prasyarat](#-prasyarat)
- [Instalasi & Setup](#-instalasi--setup)
- [Penggunaan](#-penggunaan)
- [Konfigurasi](#-konfigurasi)
- [Troubleshooting](#-troubleshooting)
- [Data Source](#-data-source)

## ✨ Fitur Utama

### 1. **Visualisasi Peta Interaktif**
- Tampilan peta dengan base layer OpenStreetMap dan Google Maps
- Layer overlay untuk batas administrasi (kota, kecamatan, kelurahan)
- Visualisasi titik lokasi sekolah dan fasilitas kesehatan
- Buffer/radius area layanan untuk sekolah dan rumah sakit

### 2. **Pencarian Lokasi**
- Search bar untuk mencari sekolah atau fasilitas kesehatan berdasarkan nama
- Auto-complete dengan hasil real-time
- Zoom otomatis ke lokasi hasil pencarian

### 3. **Pengukuran Jarak**
- Tool untuk mengukur jarak antara dua titik di peta
- Hasil ditampilkan dalam kilometer
- Visual feedback dengan marker dan garis putus-putus

### 4. **Info Feature**
- Klik pada peta untuk mendapatkan informasi detail
- Data sekolah: nama, alamat
- Data faskes: nama, alamat, email, operator, emergency status

### 5. **Kontrol Layer**
- Toggle visibility untuk setiap layer
- Slider opacity untuk mengatur transparansi layer
- Legenda dinamis dengan preview style

## 🛠 Teknologi yang Digunakan

### Backend & Database
- **PostgreSQL 18.1** dengan **PostGIS 3.6** - Spatial database
- **GeoServer 2.28.0** - Map server untuk WMS/WFS services
- **Nginx** - Reverse proxy dan web server

### Frontend
- **Leaflet.js 1.9.4** - JavaScript library untuk peta interaktif
- **HTML5/CSS3/JavaScript** - Vanilla JavaScript tanpa framework

### Infrastructure
- **Docker & Docker Compose** - Container orchestration
- **Alpine Linux** - Base image untuk efisiensi

## 📁 Struktur Project

```
uas_kota_malang/
├── compose.yaml                 # Docker Compose configuration
├── index.html                   # Halaman web utama (standalone)
├── index.docker.html            # Halaman web untuk Docker deployment
├── .gitignore                   # Git ignore rules
├── .dockerignore                # Docker ignore rules
│
├── db/                          # Database initialization scripts
│   ├── dump-qgis_kota_malang-202512111731.sql  # Schema & data utama
│   └── 02_synthetic_data.sql    # Data synthetic untuk melengkapi field kosong
│
├── nginx/                       # Nginx configuration
│   ├── Dockerfile               # Nginx container build
│   └── nginx.conf               # Reverse proxy configuration
│
├── qgis/                        # QGIS source files (shapefile & geopackage)
│   ├── Kota Malang.gpkg
│   ├── Kecamatan Kota Malang.gpkg
│   ├── Desa Kelurahan Kota Malang.gpkg
│   ├── hospital_kota_malang.*   # Shapefile rumah sakit
│   └── school_kota_malang.*     # Shapefile sekolah
│
└── data/                        # Docker volumes (generated)
    ├── geoserver/               # GeoServer data directory
    │   └── workspaces/
    │       └── uas_kota_malang/
    │           └── koneksi_uas_kota_malang/
    └── pg/                      # PostgreSQL data directory
```

## 🔧 Prasyarat

### Software Requirements
- **Docker** >= 20.10
- **Docker Compose** >= 2.0
- **Git** (untuk clone repository)
- Web browser modern (Chrome, Firefox, Safari, Edge)

### Hardware Requirements (Minimal)
- RAM: 6 GB (2 GB untuk PostgreSQL, 4 GB untuk GeoServer)
- Storage: 5 GB free space
- CPU: 2 cores

## 🚀 Instalasi & Setup

### 1. Clone Repository

```bash
git clone https://github.com/JeremyJohnatan/uas_kota_malang.git
cd uas_kota_malang
```

### 2. Konfigurasi Database Connection (PENTING!)

Edit file GeoServer datastore configuration untuk menggunakan Docker networking:

```bash
# Edit file ini:
nano data/geoserver/workspaces/uas_kota_malang/koneksi_uas_kota_malang/datastore.xml
```

Ubah baris 19 dari:
```xml
<entry key="host">localhost</entry>
```

Menjadi:
```xml
<entry key="host">postgres</entry>
```

**Catatan:** Langkah ini HARUS dilakukan sebelum menjalankan Docker Compose, karena GeoServer perlu terhubung ke PostgreSQL container menggunakan service name `postgres`, bukan `localhost`.

### 3. Jalankan Docker Compose

```bash
# Build dan jalankan semua services
docker-compose up -d

# Cek status containers
docker-compose ps

# Lihat logs (opsional)
docker-compose logs -f
```

### 4. Verifikasi Database

```bash
# Masuk ke PostgreSQL container
docker exec -it uas_postgres psql -U postgres -d gis_kota_malang

# Cek tabel yang ada
\dt

# Cek jumlah data
SELECT 'hospital' as tabel, count(*) FROM hospital_kota_malang
UNION ALL
SELECT 'school', count(*) FROM school_kota_malang;

# Keluar
\q
```

### 5. Akses Aplikasi

- **WebGIS Application:** http://localhost
- **GeoServer Admin:** http://localhost:8080/geoserver/web
  - Username: `admin`
  - Password: `geoserver123`
- **PostgreSQL:** localhost:5432
  - Database: `gis_kota_malang`
  - Username: `postgres`
  - Password: `gis123`

## 💡 Penggunaan

### Menggunakan Fitur Pencarian

1. Ketik minimal 3 karakter di search bar (pojok kiri atas)
2. Klik hasil pencarian yang muncul
3. Peta akan zoom ke lokasi yang dipilih

### Mengukur Jarak

1. Klik tombol **📏 Hitung Jarak** di kiri atas
2. Klik pada peta untuk menandai titik pertama
3. Klik lagi untuk titik kedua
4. Jarak akan ditampilkan dalam popup
5. Klik **❌ Stop Ukur** untuk mengakhiri

### Mendapatkan Info Feature

1. Pastikan mode pengukuran tidak aktif
2. Klik pada layer sekolah, rumah sakit, kecamatan, atau kelurahan
3. Info detail akan muncul di popup

### Mengatur Layer

1. Gunakan Layer Control (pojok kanan atas) untuk toggle layer
2. Gunakan Opacity Slider (pojok kanan atas) untuk transparansi
3. Lihat Legenda (pojok kiri atas) untuk referensi style

## ⚙️ Konfigurasi

### Environment Variables (compose.yaml)

#### PostgreSQL Service
```yaml
POSTGRES_DB: gis_kota_malang      # Nama database
POSTGRES_USER: postgres            # Username database
POSTGRES_PASSWORD: gis123          # Password database
```

#### GeoServer Service
```yaml
GEOSERVER_ADMIN_USER: admin                    # Username GeoServer
GEOSERVER_ADMIN_PASSWORD: geoserver123         # Password GeoServer
POSTGRES_DB: gis_kota_malang                   # Nama database (harus sama)
POSTGRES_USER: postgres                        # Username DB (harus sama)
POSTGRES_PASS: gis123                          # Password DB (harus sama)
POSTGRES_HOST: postgres                        # Service name container
INITIAL_MEMORY: 2G                             # Memory awal GeoServer
MAXIMUM_MEMORY: 4G                             # Memory maksimal GeoServer
```

### Database Schema

Database `gis_kota_malang` memiliki struktur:

**Tabel Utama:**
- `hospital_kota_malang` - 12 record rumah sakit/faskes
- `school_kota_malang` - 90+ record sekolah
- `kecamatan_kota_malang` - 5 record kecamatan
- `kelurahan_kota_malang` - 57 record kelurahan
- `kota_malang` - 1 record batas kota

**Views (Buffer Radius):**
- `radius_rumah_sakit` - Buffer 1km dari rumah sakit
- `radius_sekolah1` - Buffer 500m dari sekolah

### GeoServer Layers

Workspace: `uas_kota_malang`

**Layer yang tersedia:**
1. `kota_malang` - Batas kota
2. `kecamatan_kota_malang` - Batas kecamatan
3. `kelurahan_kota_malang` - Batas kelurahan
4. `hospital_kota_malang` - Titik lokasi faskes
5. `school_kota_malang` - Titik lokasi sekolah
6. `radius_rumah_sakit` - Buffer area layanan faskes
7. `radius_sekolah1` - Buffer area layanan sekolah

## 🔍 Troubleshooting

### Error: Connection to localhost:5432 refused

**Penyebab:** GeoServer datastore masih menggunakan `localhost` sebagai host.

**Solusi:**
```bash
# Edit datastore.xml
nano data/geoserver/workspaces/uas_kota_malang/koneksi_uas_kota_malang/datastore.xml

# Ubah line 19:
# Dari: <entry key="host">localhost</entry>
# Ke:   <entry key="host">postgres</entry>

# Restart GeoServer
docker-compose restart geoserver
```

### Error: 429 Too Many Requests (Tile Loading)

**Penyebab:** Rate limiting dari OpenStreetMap tile server.

**Solusi:** Gunakan alternatif tile provider di `index.docker.html`:

```javascript
// Ganti OSM dengan CartoDB (lebih reliable)
var osm = L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
    maxZoom: 19,
    attribution: '© OpenStreetMap © CARTO'
}).addTo(map);
```

### Database Tidak Ter-initialize

**Solusi:**
```bash
# Hapus volume PostgreSQL dan recreate
docker-compose down -v
rm -rf data/pg/*
docker-compose up -d
```

### GeoServer Layer Tidak Muncul

**Cek:**
1. GeoServer healthcheck: `docker-compose ps`
2. GeoServer logs: `docker-compose logs geoserver`
3. Workspace configuration di http://localhost:8080/geoserver/web

### Memory Issue (GeoServer OOM)

**Solusi:** Sesuaikan memory di `compose.yaml`:

```yaml
INITIAL_MEMORY: 1G    # Kurangi jika RAM terbatas
MAXIMUM_MEMORY: 2G
```

### Port Sudah Digunakan

**Error:** `Bind for 0.0.0.0:5432 failed: port is already allocated`

**Solusi:**
```bash
# Cek process yang menggunakan port
lsof -i :5432
lsof -i :8080
lsof -i :80

# Kill process atau ubah port di compose.yaml
# Misalnya: "5433:5432" untuk map ke port 5433
```

## 📊 Data Source

### Database Dump
- **File:** `db/dump-qgis_kota_malang-202512111731.sql`
- **Source:** Export dari QGIS dengan data OSM dan administrasi Kota Malang
- **Total Records:** 165+ features
- **Extent:** Kota Malang, Jawa Timur
- **CRS:** EPSG:4326 (WGS 84)

### Shapefile Source (QGIS Directory)
- Data batas administrasi: GeoPackage (`.gpkg`)
- Data fasilitas: Shapefile (`.shp`, `.dbf`, `.prj`, `.shx`)
- Source: OpenStreetMap contributors

## 🛑 Menghentikan Aplikasi

```bash
# Stop containers (data tetap ada)
docker-compose down

# Stop dan hapus volumes (hapus semua data)
docker-compose down -v

# Restart services
docker-compose restart
```

## 📝 Catatan Penting

1. **First Run:** Build dan initialization mungkin memakan waktu 2-5 menit
2. **Data Persistence:** Data PostgreSQL dan GeoServer disimpan di folder `data/`
3. **Security:** Kredensial default HARUS diganti untuk production
4. **Network:** Semua services menggunakan custom network `gis_network`
5. **Health Checks:** GeoServer depends on PostgreSQL healthcheck
6. **Browser Cache:** Clear cache jika ada perubahan pada frontend

## 📧 Support

Untuk pertanyaan atau issue, silakan buka issue di repository GitHub.

---

**Dibuat untuk:** Ujian Akhir Semester - Sistem Informasi Geografis  
**Institusi:** [Nama Institusi]  
**Tahun:** 2025
