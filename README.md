# Voice Assistant Flutter App

## Overview
This is a Flutter-based voice assistant application that uses speech-to-text to recognize voice commands and process them using the Groq API.

## Features
- **Speech Recognition**: Uses the `speech_to_text` plugin to convert spoken words into text.
- **API Integration**: Connects to the Groq API to process text and generate responses.
- **User-Friendly Interface**: Simple and intuitive UI for interacting with the voice assistant.

## Installation
1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/your-repo-name.git
    cd your-repo-name
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Run the app**:
    ```sh
    flutter run
    ```

## Usage
1. **Press the microphone button** to start listening.
2. **Speak your command**.
3. **Press the microphone button again** to stop listening and process the command.

## Configuration
To use the Groq API, you need to obtain an API key and set it in your project.

1. **Get your Groq API key** from the Groq platform.
2. **Add the API key** in the `GroqKey.dart` file:
    ```dart
    const String GroqAPIKey = 'your_groq_api_key';
    ```

## Dependencies
- `speech_to_text`: For speech recognition.
- `http`: For making HTTP requests.

## License
This project is licensed under the MIT License.
