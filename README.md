# NSW-Explorer

Welcome to NSW-Explorer, an AI-powered trip planning application for discovering the best of New South Wales, Australia. This app is built with SwiftUI and leverages the Google Places API to generate personalized and optimized journeys based on your interests.

-----

## Features

  - **AI-Powered Trip Generation**: Get personalized trip recommendations by selecting your interests. Our smart algorithm, powered by the Google Places API, curates the best real-world locations for you.
  - **Interactive Map View**: Visualize your generated journey on a native MapKit interface with custom, color-coded annotations for each stop.
  - **Real-Time Data**: All trip suggestions are based on real-time data from Google Places, including ratings, reviews, and location information.
  - **Optimized Routes**: The app organizes stops based on proximity to ensure an efficient and enjoyable travel experience.
  - **Save & Manage Trips**: Save your favorite generated trips to the "My Trips" section and view them at any time.
  - **Trip Statistics**: Keep track of your adventures with statistics like total trips completed and total distance traveled.
  - **Active Journey Tracking**: Start a trip and track your progress in real-time, with the ability to "check-in" at each stop to create a travel log with notes, ratings, and photos.
  - **Journey Completion Summary**: Get a beautiful summary of your journey upon completion, with stats and highlights.
  - **Customizable UI**: Toggle between grid and list views for your saved trips and use the search and filter functionality to easily find what you're looking for.

-----

## Tech Stack

NSW-Explorer is built with a modern, native iOS tech stack:

| Category         | Technology/Library                     |
| ---------------- | -------------------------------------- |
| **UI Framework** | SwiftUI                                |
| **Mapping** | MapKit                                 |
| **API Integration**| `URLSession` for Google Places API     |
| **Data Persistence**| `TripStorageService` (using `@Published`) |
| **State Management**| `@StateObject`, `@Published`           |
| **Language** | Swift                                  |
| **IDE** | Xcode                                  |

-----

## Getting Started

To get started with the NSW-Explorer app, follow these simple steps:

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/your-username/NSW-Explorer.git
    ```

2.  **Open in Xcode**
    Navigate to the project directory and open `NSW-Explorer.xcodeproj`.

3.  **API Key**
    The Google Places API key is already included in the `GooglePlacesService.swift` file for demonstration purposes.

4.  **Build and Run**
    Select your target simulator or physical device and run the app from Xcode.

-----

## Author

  * **Tlaitirang Rathete**
