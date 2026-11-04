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


## 🚀 Installation & Setup Instructions <under_construction>

Follow these step-by-step instructions to get a local copy running.

### 1. Clone the Repository
```bash
git clone https://github.com/username/taskmaster-pro.git
cd taskmaster-pro
```

### 2. Environment Configuration
Create a `.env` file in the root directory (or in both `/client` and `/server` if split):

```env
# Server Configuration
PORT=5000
NODE_ENV=development

# Database
MONGO_URI=mongodb://localhost:27017/taskmaster_db

# Security
JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRES_IN=7d
```

### 3. Install Dependencies <under_construction>
```bash
# Install root/backend dependencies
npm install

# Install frontend dependencies (if structured as a monorepo)
cd client && npm install && cd ..
```

---

## 🏃 Running the Application

### Development Mode
Runs both client and server concurrently with hot reloading:

```bash
# Start backend server (Nodemon)
npm run dev:server

# Start frontend development server (Vite/React)
npm run dev:client

# Alternatively (if concurrently is configured):
npm run dev
```
* **Frontend:** `http://localhost:3000`
* **Backend API:** `http://localhost:5000`

### Production Build
To test the production build locally:

```bash
# Build client assets
cd client && npm run build && cd ..

# Start production server
npm start
```

---

## 📁 Project Structure <under_construction>

```text
taskmaster-pro/
├── client/                   # Frontend React Application
│   ├── public/               # Static assets (favicons, images)
│   └── src/
│       ├── assets/           # Dynamic media assets
│       ├── components/       # Reusable UI components
│       ├── pages/            # Application routes/views
│       ├── services/         # API request modules (Axios/Fetch)
│       └── App.jsx           # Main App entry point
├── server/                   # Backend Express API
│   ├── config/               # DB connection & app config
│   ├── controllers/          # Route handlers / business logic
│   ├── middleware/           # Auth and error middleware
│   ├── models/               # Mongoose DB Schemas
│   ├── routes/               # Express API endpoints
│   └── server.js             # Express server entry point
├── tests/                    # Unit and Integration test scripts
├── .env.example              # Example environment variables schema
├── .gitignore                # Git ignore rules
├── package.json              # Project scripts and dependencies
└── README.md                 # Project documentation
```

