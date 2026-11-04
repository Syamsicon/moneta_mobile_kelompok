<!-- 
======================================================================
  PROJECT TITLE & BADGES
======================================================================
-->
# Moneta

![Node.js Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Build Status](https://img.shields.io/badge/build-passing-success)
![Course Grade](https://img.shields.io/badge/Assignment-Final%20Project-orange)

> **Course:** Mobile Development 
> **Submitted By:** Kelompok 3
> **Live Demo:<under_construction**

---

## 📌 Project Overview

**Moneta**, yang dapat melakukan pencatatan transaksi dan didukung dengan kemampuan menyimpan bukti dan/atau lokasi aktivitas keuangan tersebut terjadi. Aplikasi akan memisahkan antara alur kas masuk dan keluar, serta dapat melihat riwayat aktivitas yang telah dicatat. Ditambah dengan fitur alokasi hasil pendapatan agar pengguna dapat mengatur aktivitas keuangannya.

### Key Features
* **Dashboard**: Memperlihatkan ringkasan data pengeluaran dan alokasi secara singkat
* **Pencatatan & Edit**: Memperkenankan pengguna untuk menambah atau mengubah catatan transaksi
* **Riwayat**: Memperlihatkan daftar keseluruhan transaksi yang pernah dilakukan
* **Perencanaan**: Memperkenankan pengguna untuk mengatur pengeluarannya berdasarkan total pendapatannya
* **Rekomendasi**: Sistem merekomendasikan perencanaan pengeluaran yang disesuaikan
* **Auth**: Mengamankan data keuangan pengguna agar tidak tercampur dengan yang lain

---

## 🛠 Tech Stack

| Domain | Technology / Library | Purpose |
| :--- | :--- | :--- |
| **Frontend** | React 18, Tailwind CSS | Single-page application, responsive layout |
| **Backend** | Node.js, Express.js | RESTful API service & business logic |
| **Database** | MongoDB, Mongoose ORM | NoSQL data storage & schema validation |
| **Authentication** | JSON Web Tokens (JWT), bcrypt | Session security & password hashing |
| **Testing** | Jest, Supertest, React Testing Library | Unit & integration testing suites |
| **Deployment** | Vercel (Frontend), Render (Backend) | Cloud hosting and continuous deployment |

---

## ⚙️ Prerequisites

Ensure you have the following dependencies installed locally before setting up the project:

* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* Android Studio (AndroidSDK 37.0)


## 🚀 Setup Project Instructions <under_construction>

Follow these step-by-step instructions to get a local copy running.

### 1. Clone the Repository
```bash
git clone https://github.com/Syamsicon/moneta_mobile_kelompok
cd moneta_mobile_kelompok
```

### 2. Environment Configuration <under_construction>
Create a `.env` file in the root directory (or in both `/client` and `/server` if split):

```env

```

### 3. Install Dependencies <under_construction>
```bash
# Install frontend dependencies
flutter pub get

```

---

## 🏃 Running the Application <under_construction>


---

## 📁 Project Structure 

```text
moneta_mobile_kelompok/
├── lib/                       # Main Dart source directory
│   ├── main.dart              # Application entry point & State Management Setup
│   ├── controllers/           # State Management
│   ├── models/                # Data models and JSON serializers
│   ├── routes/                # Route setup
│   ├── services/              # APIs and core app 
│   ├── theme/                 # Global style reference
│   ├── view/                  # Main application views/pages
│   ├── widgets/               # Reusable UI components
├── pubspec.yaml               # Flutter package configuration & dependencies
└── README.md                  # Project documentation
```

