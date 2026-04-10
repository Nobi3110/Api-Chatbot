# AI Chatbot App

A Flutter-based AI Assistant application that integrates with OpenAI and other free APIs to provide helpful responses.

## 🚀 Features

- **AI Chatbot**: Powered by OpenAI's GPT models.
- **Multiple API Support**: Fallback to free joke APIs or other services.
- **Theme Support**: Dark and Light mode switching.
- **Secure Configuration**: Uses environment variables to manage API keys safely.

## 🛠️ Setup Instructions

To run this project locally, follow these steps:

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- An OpenAI API Key (get one from [OpenAI Dashboard](https://platform.openai.com/)).

### 2. Environment Configuration
Create a `.env` file in the root directory of the project and add your API keys:

```env
OPENAI_API_KEY=your_openai_api_key_here
FREE_API_KEY=your_free_api_key_here
```

*Note: The `.env` file is excluded from version control for security.*

### 3. Install Dependencies
Run the following command in your terminal:
```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

## 📂 Project Structure

- `lib/data/services/`: API integration logic.
- `lib/providers/`: State management using Provider.
- `lib/ui/`: UI screens and custom widgets.

## 📄 License

This project is for educational purposes.
