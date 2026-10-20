# FashionHub Mobile E-Commerce Application (Full-Stack)

Proyek **FashionHub Mobile App** adalah aplikasi *mobile e-commerce* fashion berbasis **Flutter** (State Management **Provider**) yang terintegrasi secara modular dengan RESTful API berbasis **Golang (Gin-Gonic)** dan basis data relasional **PostgreSQL (GORM)**.

---

## Struktur Direktori Proyek

```text
fashionhub_project/
├── docker-compose.yml              # Konfigurasi kontainer PostgreSQL (opsional)
├── README.md                       # Dokumentasi & panduan menjalankan proyek
├── postman/
│   └── FashionHub_API.postman_collection.json  # Koleksi Postman siap impor
├── backend/                        # Backend RESTful API (Golang + Gin-Gonic + GORM)
│   ├── .env.example
│   ├── go.mod
│   ├── cmd/
│   │   └── api/
│   │       └── main.go             # Entrypoint server API
│   ├── config/
│   │   └── database.go             # Koneksi PostgreSQL & Auto-Migration
│   ├── internal/
│   │   ├── model/
│   │   │   └── models.go           # Entitas Database (6 Tabel)
│   │   ├── repository/             # Layer akses database (GORM queries)
│   │   ├── service/                # Layer logika bisnis & validasi
│   │   ├── handler/                # Layer REST API Controller (Gin)
│   │   └── middleware/             # CORS, Logger, dan JWT Auth Guard
│   └── db/
│       └── seeder/
│           └── seeder.go           # Mock data otomatis (16 produk Men & Women)
└── mobile/                         # Aplikasi Mobile Flutter (Provider + Dio)
    ├── pubspec.yaml
    └── lib/
        ├── main.dart
        ├── config/
        │   └── api_config.dart
        ├── models/                 # Model data JSON (Product, Cart, Invoice)
        ├── services/
        │   └── api_service.dart    # HTTP Client Dio & Session ID
        ├── providers/              # State Management Provider (Catalog, Cart, Checkout)
        ├── widgets/                # Komponen UI (AppBar, Drawer, Cart Side Sheet, Card)
        └── screens/                # 7 Layar Utama sesuai PRD
```

---

## Panduan Menjalankan Backend (Golang + PostgreSQL)

### 1. Persiapan Database PostgreSQL
Anda dapat menggunakan PostgreSQL lokal (pgAdmin / psql) atau menjalankan via Docker:

**Opsi A — Menggunakan PostgreSQL Lokal:**
Buat database baru bernama `fashionhub_db`:
```sql
CREATE DATABASE fashionhub_db;
```

**Opsi B — Menggunakan Docker Compose:**
```bash
docker compose up -d
```

### 2. Konfigurasi & Menjalankan Server Golang
```bash
cd backend
cp .env.example .env
# Sesuaikan DB_USER, DB_PASSWORD, DB_NAME di file .env jika diperlukan

# Unduh seluruh dependency Go
go mod tidy

# Jalankan server API (otomatis menjalankan migrasi tabel & seeder 16 produk)
go run cmd/api/main.go
```
Server akan berjalan di `http://localhost:8080`.

---

## Daftar Endpoint API (`/api/v1`)

| Method | Endpoint | Deskripsi |
| :--- | :--- | :--- |
| `GET` | `/api/v1/products` | Mengambil katalog produk (mendukung query `category=Men\|Women`, `page`, `limit`, `sort`) |
| `GET` | `/api/v1/products/:id` | Mengambil detail produk spesifik beserta rekomendasi `"You May Also Like"` |
| `GET` | `/api/v1/cart` | Mengambil daftar item di keranjang belanja beserta kalkulasi subtotal |
| `POST` | `/api/v1/cart` | Menambahkan produk ke keranjang (`{"product_id": 1, "quantity": 1}`) |
| `PUT` | `/api/v1/cart/:id` | Mengubah kuantitas item di keranjang (`{"quantity": 2}`) |
| `DELETE` | `/api/v1/cart/:id` | Menghapus item dari keranjang belanja |
| `POST` | `/api/v1/checkout` | Menyelesaikan simulasi pembayaran & menghasilkan nomor invoice unik (`INV-YYYYMMDD-XXX`) |
| `POST` | `/api/v1/contact` | Mengirimkan pesan melalui formulir Contact Us |

> **Catatan Session Keranjang:** Backend menggunakan header `X-Session-ID` (dibuat otomatis oleh aplikasi Flutter dan disimpan di `SharedPreferences`) sehingga pengguna dapat langsung berbelanja tanpa wajib registrasi akun terlebih dahulu (*Guest Mode*).

---

## Panduan Menjalankan Frontend (Flutter Mobile)

### 1. Instalasi Paket Flutter
```bash
cd mobile
flutter pub get
```

### 2. Konfigurasi URL API (`lib/config/api_config.dart`)
Secara *default*, aplikasi mendeteksi URL lokal:
* **Android Emulator:** menggunakan `http://10.0.2.2:8080/api/v1`
* **iOS Simulator / Web / Desktop:** menggunakan `http://localhost:8080/api/v1`
* **Perangkat Fisik (HP):** ubah `customBaseUrl` pada `lib/config/api_config.dart` menjadi IP lokal laptop Anda (misal `http://192.168.1.10:8080/api/v1`).
* **Mode Fallback Offline Otomatis:** Jika server backend sedang belum dinyalakan saat demo UI, aplikasi dilengkapi *fallback mock data* otomatis agar seluruh alur layar tetap dapat didemokan tanpa *crash*.

### 3. Menjalankan Aplikasi
```bash
flutter run
```

---

## Kode Kupon Diskon Simulasi (Cart Drawer)
Saat menguji fitur keranjang belanja (*Cart Drawer*), Anda dapat memasukkan kode kupon berikut:
* `FASHION10` — Diskon 10% dari subtotal belanja.
* `HEMAT50K` — Potongan langsung Rp 50.000 (minimum belanja Rp 300.000).
