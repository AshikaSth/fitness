# 📦 Inventory App

A simple inventory management app built with **Flutter** and **Firebase Firestore**. This application allows users to **add**, **update**, and **view** inventory items in real time. It's designed as a lightweight solution for basic inventory tracking.

---

## Features

- Add new inventory items
- Update existing items
- View the most recent inventory data
- Pull-to-refresh or refresh button support to fetch the latest data
- Soft delete support: items are marked as deleted instead of being permanently removed
- Undo functionality with a SnackBar action:
  -Undo add: Revert a newly added item.
  -Undo edit: Restore an edited item's original values.
  -Undo delete: Recover a soft-deleted item.
- Timestamps to track creation, updates, and deletions
- Inventory list sorted by most recent `updated_at`, then `created_at`
- Form validations for item inputs:
  - Prevents alphabets in numeric fields
  - Disallows zero or negative values for price and quantity



---

## Objective

This project was created with the following goals:

- Integrate Firebase Firestore with a Flutter app
- Build a clean UI to manage inventory items
- Allow CRUD (Create, Read, Update) operations on Firestore documents
- Ensure data updates are reflected on refresh

---

## Tech Stack

- **Flutter** (UI framework)
- **Firebase Firestore** (cloud database)
- **Dart** (programming language)

---

## Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Cloud Firestore** in the Firebase project
3. Add Firebase configuration to your Flutter app (skip platform-specific steps if instructed)

---

## 🧪 Form Validation Rules

To ensure accurate inventory data, the form includes the following input validations:

- **Name**: Must not be empty.
- **Quantity**:
  - Must not be empty
  - Must be a valid integer
  - Cannot be zero or negative
  - Cannot contain alphabets
- **Price**:
  - Must not be empty
  - Must be a valid number (double)
  - Cannot be zero or negative
  - Cannot contain alphabets

---

## Timestamps and Soft Delete

Each item document includes metadata for tracking and soft deletion:

```json
{
  "name": "Item Name",
  "quantity": 10,
  "price": 99.99,
  "is_deleted": false,
  "created_at": Timestamp,
  "updated_at": Timestamp,
  "deleted_at": Timestamp (nullable)
}




## 📱 Flutter Setup

1. Add these dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^latest_version
  cloud_firestore: ^latest_version

