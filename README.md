# Week 4 - API Integration

## Features

- Fetch data from REST API using http package
- Parse JSON response
- Display users in ListView
- Profile image using network avatar
- Pull to refresh support
- Error handling with retry button
- Loading indicator

## Tech Used

- Flutter
- Dart
- http package

## API Used

https://jsonplaceholder.typicode.com/users

## How It Works

1. App sends GET request to API
2. JSON response is parsed into list
3. Data displayed using ListView
4. Handles:
   - Loading state
   - Error state
   - Success state

```md
## Improvements

- Clean architecture structure
- Reusable API service class
- Proper error handling