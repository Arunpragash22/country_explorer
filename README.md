````markdown
# Country Explorer

## 1. Project Description

Country Explorer is a Flutter mobile application that allows users to explore information about different countries.

The application retrieves country information from a REST API and displays details such as country name, capital, currency, phone code, population, and flag.

Users can search for countries, sort the country list, view detailed country information, save favorite countries to a bucket list, and add personal travel notes.

## 2. Instructions to Run

### Requirements

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android device or Android Emulator

### Install Dependencies

Open the project folder in a terminal and run:

```bash
flutter pub get
````

### Run the Application

Connect an Android device or start an Android emulator and run:

```bash
flutter run
```

To check connected devices:

```bash
flutter devices
```

### Build APK

To generate a release APK:

```bash
flutter build apk --release
```

The APK will be generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 3. State Management

Riverpod is used for state management in the Country Explorer application.

### Country Provider

`countryProvider` manages the country data retrieved from the REST API.

### Search Provider

`searchProvider` manages the search text entered by the user and filters the country list based on the search query.

### Sort Provider

`sortProvider` manages the sorting order of the country list.

Users can switch between:

* A-Z
* Z-A

### Bucket Provider

`bucketProvider` manages the countries saved by the user as favorites.

Users can add or remove countries from their bucket list.

### Notes Provider

`notesProvider` manages personal travel notes for individual countries.

### Hive

Hive is used for local storage of application data such as favorite countries and personal notes.

## 4. Architecture Overview

The project follows a simple layered architecture.

```text
lib/
│
├── models/
│   └── country.dart
│
├── providers/
│   ├── bucket_provider.dart
│   ├── country_provider.dart
│   ├── notes_provider.dart
│   ├── search_provider.dart
│   └── sort_provider.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── details_screen.dart
│   └── bucket_screen.dart
│
├── services/
│   └── country_service.dart
│
└── main.dart
```

### Architecture Flow

```text
User Interface
      ↓
Riverpod Providers
      ↓
Service Layer
      ↓
REST API
```

For local storage:

```text
User Interface
      ↓
Riverpod Providers
      ↓
Hive
```

### Models

The `models` folder contains the data model used to represent country information.

### Providers

The `providers` folder contains Riverpod providers responsible for application state management.

### Services

The `services` folder contains the API communication logic.

### Screens

The `screens` folder contains the user interface screens of the application.

## 5. Screenshots

### Splash Screen

*Add screenshot here.*

### Home Screen

*Add screenshot here.*

### Search

*Add screenshot here.*

### Country Details

*Add screenshot here.*

### Bucket List

*Add screenshot here.*
