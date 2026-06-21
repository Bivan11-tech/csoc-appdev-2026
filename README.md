# 🍔 Food Delivery App

A full-stack Food Delivery Application built using **Flutter**, **Go (Gin Framework)**, and **MongoDB Atlas**.

The application enables users to browse restaurants, explore menus, manage carts, place orders, and view order history. It also includes offline caching, local notifications, promo code support, and persistent authentication.

---

# 📱 Features

## User Features

### Authentication

* User Registration
* User Login
* JWT Authentication
* Persistent Login Sessions
* Secure Logout

### Restaurant Browsing

* Browse Restaurants
* Search Restaurants
* Category Filtering
* Restaurant Sorting
* Pull-to-Refresh Support
* Restaurant Details Screen

### Menu Features

* Browse Menu Items
* Restaurant-specific Menus
* Cached Menu Loading
* Loading Shimmer Effects

### Cart Features

* Add Items to Cart
* Update Item Quantities
* Remove Individual Items
* Clear Cart
* Real-time Cart Updates

### Order Features

* Place Orders
* View Order History
* Refresh Orders
* Local Order Confirmation Notifications

### Promo Codes

Supported promo codes:

| Code      | Discount         |
| --------- | ---------------- |
| WELCOME10 | 10% off subtotal |
| SAVE50    | ₹50 off          |

### User Preferences

* Dark Mode Support
* Theme Persistence using SharedPreferences

### Offline Experience

* Restaurant Cache
* Menu Cache
* Order Cache

---

# 🏗️ Architecture Overview

## Frontend Architecture (Flutter)

```text
lib/
├── models/
├── services/
├── widgets/
├── isar_models/
├── theme/
├── data/
├── core/
└── screens/pages
```

### Layer Responsibilities

#### UI Layer

Responsible for:

* Screens
* Widgets
* User interactions

Examples:

```text
homepage.dart
restaurant_menu.dart
cartscreen.dart
orderscreen.dart
profilescreen.dart
```

#### Service Layer

Responsible for:

* API communication
* Business logic
* Local database interactions

Examples:

```text
auth_service.dart
restaurant_service.dart
menu_service.dart
cart_service.dart
order_service.dart
isar_service.dart
notification_service.dart
```

#### Model Layer

Responsible for:

* Data serialization
* API response mapping

Examples:

```text
restaurant.dart
menu_item.dart
order.dart
cart.dart
user.dart
```

#### Local Storage Layer

Uses Isar Database for caching:

```text
restaurant_cache.dart
menu_cache.dart
order_cache.dart
```

---

## Backend Architecture (Go)

```text
food-delivery-backend/
├── cmd/
├── config/
├── controllers/
├── database/
├── middleware/
├── models/
├── routes/
└── utils/
```

### Components

#### Controllers

Business logic for:

* Authentication
* Restaurants
* Cart
* Orders

#### Middleware

* JWT Authentication Middleware

#### Database

* MongoDB Atlas Integration

#### Utilities

* Password Hashing
* JWT Generation
* Promo Code Calculations

---

# 🛠 Frameworks & Technologies

## Mobile App

* Flutter
* Dart
* Material Design
* SharedPreferences
* Isar Community Database
* Flutter Local Notifications
* Path Provider

## Backend

* Go (Golang)
* Gin Web Framework
* JWT Authentication
* bcrypt Password Hashing
* CORS Middleware

## Database

* MongoDB Atlas

---

# 📂 Project Structure

```text
project-root/
│
├── food-delivery-backend/
│
├── lib/
│
├── android/
├── ios/
├── web/
│
└── README.md
```

---

# 🚀 Installation

## Prerequisites

### Backend

* Go 1.25+
* MongoDB Atlas Account

### Mobile

* Flutter SDK
* Android Studio
* Android Emulator or Physical Device

---

# ⚙️ Backend Setup

## 1. Navigate to Backend

```bash
cd food-delivery-backend
```

## 2. Create Environment File

Create:

```text
.env
```

Example:

```env
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/
JWT_SECRET=your_secret_key
PORT=8080
```

### Environment Variables

| Variable   | Description                       |
| ---------- | --------------------------------- |
| MONGO_URI  | MongoDB Atlas connection string   |
| JWT_SECRET | Secret used for JWT token signing |
| PORT       | Backend server port               |

---

## 3. Install Dependencies

```bash
go mod tidy
```

---

## 4. Run Backend

```bash
go run cmd/main.go
```

Backend starts on:

```text
http://localhost:8080
```

---

# 🐳 Docker Setup

## Backend Dockerfile

Create:

```dockerfile
FROM golang:1.25

WORKDIR /app

COPY . .

RUN go mod tidy

RUN go build -o server ./cmd

EXPOSE 8080

CMD ["./server"]
```

---

## Build Image

```bash
docker build -t food-delivery-backend .
```

---

## Run Container

```bash
docker run -d \
-p 8080:8080 \
--env-file .env \
food-delivery-backend
```

---

## Docker Compose Example

```yaml
version: "3.9"

services:
  backend:
    build: .
    ports:
      - "8080:8080"
    env_file:
      - .env
```

Run:

```bash
docker compose up -d
```

---

# 📲 Mobile Setup

## 1. Navigate to Flutter Project

```bash
cd mobile-app
```

---

## 2. Install Packages

```bash
flutter pub get
```

---

## 3. Configure API URL

Update:

```text
lib/core/api_constants.dart
```

Example:

```dart
const String baseUrl = "http://YOUR_SERVER_IP:8080";
```

### Android Emulator

```dart
http://10.0.2.2:8080
```

### Physical Device

```dart
http://YOUR_LOCAL_IP:8080
```

---

## 4. Run Code Generator (Isar)

Whenever Isar models change:

```bash
dart run build_runner build
```

---

## 5. Launch App

```bash
flutter run
```

---

# 🗄 Cache Strategy

The application uses **Isar Database** for local caching.

## Cached Data

### Restaurants

Cached:

* Restaurant ID
* Name
* Image
* Category
* Metadata

Purpose:

* Faster home screen loading
* Offline restaurant access

---

### Menus

Cached:

* Menu items
* Prices
* Descriptions
* Restaurant mapping

Purpose:

* Faster menu loading
* Reduced API calls

---

### Orders

Cached:

* Previous orders
* Order metadata

Purpose:

* Quick order history retrieval

---

## Cache Update Mechanism

### Restaurants

1. App requests restaurants from API.
2. Fresh data replaces local cache.
3. UI updates immediately.

```text
API → Isar Cache → UI
```

---

### Menus

1. User opens restaurant.
2. Menu fetched from API.
3. Cached locally.
4. Subsequent loads use cache until refreshed.

---

### Orders

1. Order history fetched from API.
2. Cache updated.
3. Latest data displayed.

---

### Refresh Strategy

The app uses:

```text
Pull-to-Refresh
```

to trigger cache invalidation and fetch fresh data.

---

# 🔔 Notifications

Uses:

```text
flutter_local_notifications
```

Current notification:

### Order Confirmation

Example:

```text
Order Confirmed 🎉
Order #ORD-1234 has been placed successfully.
```

---

# 🔐 Security

### Authentication

* JWT Token Authentication
* Protected Routes
* Token Persistence

### Password Security

* bcrypt Hashing
* Passwords never stored in plain text

---

# 📖 API Endpoints

## Authentication

```http
POST /api/auth/register
POST /api/auth/login
GET  /api/auth/profile
```

---

## Restaurants

```http
GET /api/restaurants
GET /api/restaurants/:id
GET /api/restaurants/:id/menu
```

---

## Cart

```http
POST   /api/cart
GET    /api/cart
PUT    /api/cart/:menuItemId
DELETE /api/cart/:menuItemId
DELETE /api/cart
```

---

## Orders

```http
POST /api/orders
GET  /api/orders
GET  /api/orders/:id
```

---

# 🍃 MongoDB Collections

```text
users
restaurants
menu
carts
orders
```

---

# 👤 Demo Admin Credentials

Email:

```text
admin@foodapp.com
```

Password:

```text
admin123
```

---

# 🚀 Future Enhancements

* Recently Viewed Restaurants
* Native Share Feature
* Promo Code Validation API
* Order Tracking
* Push Notifications
* Favorites/Wishlist
* Offline Order Sync
* Multi-address Support
* Payment Gateway Integration

---

# 📄 License

This project is intended for educational and portfolio purposes.
