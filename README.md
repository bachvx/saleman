# Sales Master - Professional Salesman App

A comprehensive Flutter mobile application designed for field sales teams with advanced CRM, order management, GPS tracking, and offline-first capabilities.

## 🚀 Features

### 1. Core Sales Features
- **Customer Relationship Management (CRM)**: Manage customer profiles, contact history, and geographical locations
- **Order Management (SFA)**: Create, track, and manage sales orders directly from mobile devices
- **Inventory Tracking**: Real-time visibility of stock levels to ensure product availability
- **Digital Product Catalog**: High-quality visual display of products with detailed specifications and pricing
- **Promotion & Discount Engine**: Automatically apply complex trade promotions and tiered discounts
- **Debt & Payment Management**: Track outstanding balances, credit limits, and payment collections

### 2. Field Operations & Monitoring
- **GPS Check-in/Check-out**: Verify sales visits at specific locations using geofencing technology
- **Route Optimization**: AI-driven suggestions for efficient daily visiting sequences
- **Retail Execution (Audit)**: Capture photos of shelves, record competitor activity, and conduct surveys
- **E-Signature**: Capture digital signatures from customers for order confirmation or delivery

### 3. Productivity & Reporting
- **Sales Performance Dashboard**: Real-time visualization of KPIs, sales targets vs. actual achievement
- **Push Notifications**: Instant alerts for order approvals, new promotions, or urgent tasks
- **Leaderboard & Gamification**: Motivate sales teams through rankings and performance-based badges
- **Task Management**: Daily to-do lists and reminders for follow-up calls or meetings

### 4. Technical Specifications
- **Offline-First Capability**: Data entry and retrieval work seamlessly without internet connectivity
- **Data Synchronization**: Robust background syncing to reconcile local data with the central server
- **Real-time Updates**: Support for concurrent users with low-latency updates
- **Barcode/QR Scanner**: Quick product lookup and asset tracking using the mobile camera

## 📱 Screenshots

The app features a modern Material Design 3 interface with:
- Clean blue and white color scheme
- Intuitive bottom navigation
- Interactive charts and visualizations
- Responsive card-based layouts

## 🛠️ Tech Stack

- **Framework**: Flutter 3.35.4
- **Language**: Dart 3.9.2
- **State Management**: Provider
- **Local Storage**: Hive + hive_flutter, shared_preferences
- **Networking**: HTTP
- **Charts**: FL Chart
- **Location**: Geolocator
- **Permissions**: Permission Handler
- **Barcode Scanner**: Mobile Scanner
- **Image Handling**: Image Picker

## 📦 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── customer.dart
│   ├── product.dart
│   ├── order.dart
│   ├── check_in.dart
│   ├── task.dart
│   └── sales_target.dart
├── screens/                  # UI screens
│   ├── dashboard_screen.dart
│   ├── customers_screen.dart
│   ├── orders_screen.dart
│   ├── products_screen.dart
│   └── more_screen.dart
└── services/                 # Business logic
    ├── storage_service.dart
    └── sample_data_service.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.35.4 or higher
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**Web:**
```bash
flutter build web --release
```

## 📊 Sample Data

The app initializes with sample data including:
- 5 sample customers (Retail, Wholesale, Distributor types)
- 8 sample products across different categories
- 2 sample orders
- 1 sales target for the current month
- 3 sample tasks

## 🔐 Permissions

The app requires the following permissions:
- **Internet**: For API communications and data synchronization
- **Location**: For GPS check-in/check-out and route optimization
- **Camera**: For barcode scanning and photo capture
- **Storage**: For saving photos and offline data

## 🎨 Design Philosophy

The app follows Material Design 3 guidelines with:
- Modern, clean interface
- Blue primary color (#1976D2)
- Card-based layouts
- Smooth animations and transitions
- Responsive design for various screen sizes

## 🔄 Offline-First Architecture

The app uses Hive for local storage, enabling:
- Complete offline functionality
- Fast data access
- Automatic synchronization when online
- Conflict resolution strategies

## 📈 Performance Metrics Dashboard

The dashboard displays:
- Monthly sales targets and achievement percentage
- Total orders, customers, and visits
- Sales trend charts
- Recent orders overview
- Quick access to key metrics

## 🛣️ Roadmap

Future enhancements:
- [ ] Real-time push notifications
- [ ] Advanced route optimization with Google Maps integration
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Export reports to PDF/Excel
- [ ] Voice-to-text for notes
- [ ] Integrated payment gateway
- [ ] Team collaboration features

## 📝 License

This project is licensed under the MIT License.

## 👥 Contributors

Sales Master is developed for professional sales teams worldwide.

## 📞 Support

For support, email support@salesmaster.com or visit our website.

---

**Version**: 1.0.0  
**Last Updated**: January 2026  
**Minimum SDK**: Android 21 (Lollipop) / iOS 12.0
