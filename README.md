# 🌲 Favorite Parks App – SwiftUI TableView & Map Integration

Developed as part of **CSE 335 - Lab 5** at the School of Computing and Augmented Intelligence, this iOS app allows users to explore and manage a list of their favorite parks, complete with descriptions, photos, and live map-based location search features.

🔗 Visit my portfolio: [maharshi-patel.com](https://maharshi-patel.com)

## 📱 Overview

This SwiftUI-based iPhone application demonstrates the use of:

- **TableViews** using `List` and `NavigationStack`
- **MVVM architecture** in a clean, scalable SwiftUI environment
- **Dynamic park entry management** (Add/Delete)
- **Apple Maps integration** with live search capability

## 🎯 Objectives

- Build a multi-view iPhone application with SwiftUI
- Implement and understand `List`, `NavigationLink`, and `NavigationStack`
- Use `MapKit` to show city locations and nearby search results
- Follow the **MVVM** design pattern throughout the app

## 🛠 Features

- ✅ Pre-loaded list of 5 favorite parks
- ✅ Grouped table view by alphabetical park name
- ✅ Each row shows:
  - Park name
  - Location (City/State or Country)
  - Park image
- ✅ Detail View includes:
  - Park image
  - Park name
  - Short description
  - Interactive Apple Map centered on park location
- ✅ Search for nearby places like “coffee”, “pizza”, or “movie” directly on the map
- ✅ Add or delete parks dynamically
  - Default image is used if none provided

## 🧱 Architecture

The app follows the **MVVM (Model-View-ViewModel)** structure:

- **Model**: `Park` struct to hold name, location, description, and image
- **View**: SwiftUI views built with `List`, `NavigationStack`, `Map`, and `TextField`
- **ViewModel**: Handles logic for managing the park list and search queries


## 📦 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/MaharshiPatel2274/Favorite-Parks-App
   ```

2. Open in **Xcode** and run on a simulator or real device (iOS 15+ recommended).

## 📁 Project Structure

```
Favorite-Parks-App/
├── Models/
│   └── Park.swift
├── ViewModels/
│   └── ParkViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── ParkListView.swift
│   ├── ParkDetailView.swift
│   └── AddParkView.swift
└── Assets.xcassets/
    └── DefaultParkImage
```
---

**Author:** Maharshi Niraj Patel  
[Portfolio](https://maharshi-patel.com) • [GitHub](https://github.com/MaharshiPatel2274)
