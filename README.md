# QuickSlot Flutter App

Flutter application for booking sports slots such as badminton courts and turf grounds.

## Tech Stack

* Flutter
* Bloc
* Dio
* Material Design

## Features

* User selection
* Venue listing
* Date selection
* Slot availability view
* Book slot
* Double booking handling
* My bookings
* Cancel booking
* Loading, error and empty states

## Project Structure

```text
lib/
├── core/
│   └── api/
│       └── api_client.dart
├── models/
│   ├── booking_model.dart
│   ├── slot_model.dart
│   ├── user_model.dart
│   └── venue_model.dart
├── features/
│   ├── auth/
│   ├── booking/
│   └── venue/
└── main.dart
```

## State Management

The application uses Bloc.

Why Bloc?

* Separates business logic from UI
* Predictable state transitions
* Easy loading, success and error handling
* Scales better as features grow

## Screens

### User Selection

Allows selecting a predefined user.

### Venue List

Displays all available sports venues.

### Venue Detail

Shows:

* Date picker
* Available slots
* Booked slots

### My Bookings

Displays bookings created by the selected user.

Users can cancel existing bookings.

## Setup

### Install dependencies

```bash
flutter pub get
```

### Run application

```bash
flutter run
```

## Backend Configuration

Update the API base URL inside:

```text
lib/core/api/api_client.dart
```

Example:

```dart
static const baseUrl =
    "http://10.0.2.2:5000";
```

For physical devices use your machine's local IP address.

## Booking Flow

1. Select user
2. Choose venue
3. Select date
4. Tap available slot
5. Confirm booking
6. Receive success or conflict response

## Conflict Handling

If another user books the slot before confirmation:

* Backend returns HTTP 409
* App shows an error message
* Slot list refreshes automatically

This ensures users always see the latest slot availability.

## What Was Prioritized

The project focuses on:

* Correct booking flow
* Reliable slot availability
* Concurrency handling
* Clear architecture

rather than advanced authentication or UI polish.

## Future Improvements

* Real-time updates using WebSockets
* Offline support
* Widget tests
* Dark mode
* Search and filtering
* Push notifications

## AI Usage Note

AI tools were used for:

* Boilerplate generation
* API scaffolding
* Flutter UI scaffolding
* Documentation assistance

All generated code was reviewed, modified and tested manually before integration.
