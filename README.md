# 🏨 AI-Powered Hotel Booking App with Tinder-Style Swipe

An innovative hotel booking application that combines artificial intelligence with an intuitive Tinder-style swipe interface. Find your perfect hotel accommodation with smart recommendations and real hotel images powered by Google Gemini AI.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Google Gemini](https://img.shields.io/badge/Google%20Gemini-4285F4?style=for-the-badge&logo=google&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-2C2D72?style=for-the-badge&logo=pandas&logoColor=white)

## ✨ Features

### 🎯 Core Features
- **Tinder-Style Swipe Interface**: Intuitive card-based hotel browsing
- **AI-Powered Recommendations**: Smart hotel suggestions using Google Gemini AI
- **Real Hotel Images**: Authentic hotel photos via Unsplash integration
- **CSV + AI Fallback**: Fast CSV lookups with AI enhancement for complex queries
- **Multi-Agent Architecture**: Intelligent routing between data sources

### 🏨 Hotel Search Capabilities
- **Location-Based Search**: Find hotels in any Indian city
- **Budget Filtering**: Set price ranges for personalized results
- **Amenity Matching**: Filter by WiFi, Pool, Spa, Gym, etc.
- **Special Requests**: Natural language processing for unique requirements
- **Rating Display**: Visual star ratings for each hotel

### 🤖 AI Features
- **Intelligent Query Processing**: Natural language understanding
- **Dynamic Image Generation**: AI-powered hotel photo search terms
- **Smart Recommendations**: Personalized suggestions based on preferences
- **Context-Aware Responses**: Location and amenity-based recommendations

## 🛠️ Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile app development
- **Dart**: Programming language
- **Card Swiper**: Smooth swipe animations
- **HTTP Client**: REST API communication

### Backend
- **Python**: Core backend logic
- **FastAPI**: High-performance API framework
- **Google Gemini AI**: Advanced AI model for recommendations
- **Pandas**: Data processing and CSV handling
- **Uvicorn**: ASGI server

### Data & APIs
- **CSV Datasets**: Pre-processed hotel data for fast lookups
- **Google Generative AI**: AI-powered content generation
- **Unsplash API**: Real hotel images
- **RESTful APIs**: Clean API design

## 📋 Prerequisites

Before running this application, make sure you have the following installed:

### System Requirements
- **Python 3.8+**
- **Flutter SDK** (latest stable version)
- **Git**
- **Visual Studio Code** (recommended)

### API Keys Required
- **Google AI API Key**: For Gemini AI functionality
  - Get it from: [Google AI Studio](https://makersuite.google.com/app/apikey)

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Adichauhan39/Hack2skill-Phase-2-internal.git
cd Hack2skill-Phase-2-internal
```

### 2. Backend Setup (Python/FastAPI)

#### Install Python Dependencies
```bash
cd 7-multi-agent
pip install -r ../requirements.txt
```

#### Configure Environment Variables
Create a `.env` file in the `7-multi-agent` directory:
```env
GOOGLE_API_KEY=your_google_ai_api_key_here
GOOGLE_GENAI_USE_VERTEXAI=FALSE
```

**🔐 Security Note**: Never commit your `.env` file to version control!

### 3. Frontend Setup (Flutter)

#### Install Flutter Dependencies
```bash
cd ../flutter_travel_app
flutter pub get
```

#### Configure Flutter
Make sure Flutter is properly set up:
```bash
flutter doctor
```

## 🎮 Running the Application

### Start Backend Server
```bash
# From the 7-multi-agent directory
cd 7-multi-agent
python ultra_simple_server.py
```

The server will start on `http://localhost:8001`

### Start Flutter App
```bash
# From the flutter_travel_app directory
cd flutter_travel_app
flutter run
```

### Alternative: Run on Specific Platform
```bash
# For Chrome web browser
flutter run -d chrome

# For Android emulator
flutter run -d emulator

# For connected device
flutter run -d <device_id>
```

## 📖 Usage Guide

### 🏨 Finding Hotels

1. **Launch the App**: Start the Flutter application
2. **Enter Destination**: Type your destination city (e.g., "Goa", "Mumbai")
3. **Set Budget**: Use the slider to set your maximum budget per night
4. **Add Preferences**:
   - Room type (Executive, Deluxe, etc.)
   - Food preferences (Veg, Non-Veg)
   - Ambiance (Modern, Traditional)
   - Amenities (WiFi, Pool, Gym, Spa)
5. **Special Requests**: Add any special requirements in natural language
6. **Search**: Tap the search button to find hotels

### 🎯 Swipe Interface

- **❤️ Like**: Swipe right or tap heart icon to save hotel
- **👎 Pass**: Swipe left or tap X icon to skip
- **View Details**: Tap on hotel card to see full details
- **Cart**: Access saved hotels from the cart icon

### 🔍 Hotel Information Displayed

- **Hotel Name & Location**
- **Price per Night**
- **Star Rating**
- **Amenities List**
- **Detailed Description**
- **AI Recommendations**
- **Nearby Attractions**
- **Real Hotel Images**

## 🔧 API Documentation

### Hotel Search Endpoint
```http
POST /api/hotel/search
Content-Type: application/json

{
  "message": "Find hotels in Goa under ₹5000 with pool",
  "context": {
    "city": "Goa",
    "budget": 5000
  }
}
```

**Response:**
```json
{
  "status": "success",
  "powered_by": "CSV or Gemini AI",
  "ai_used": false,
  "hotels": [
    {
      "name": "Hotel Name",
      "city": "Goa",
      "price_per_night": 3500,
      "rating": 4.5,
      "type": "Hotel",
      "amenities": ["WiFi", "Pool", "Spa"],
      "description": "Detailed hotel description...",
      "why_recommended": "AI recommendation...",
      "nearby_attractions": ["Beach 1", "Beach 2"]
    }
  ],
  "count": 1
}
```

### Hotel Images Endpoint
```http
POST /api/hotel/images
Content-Type: application/json

{
  "message": "Get images for Taj Hotel",
  "context": {
    "hotel_name": "Taj Hotel",
    "city": "Mumbai"
  }
}
```

## 🏗️ Project Structure

```
Hack2skill-Phase-2-internal/
├── flutter_travel_app/          # Flutter frontend
│   ├── lib/
│   │   ├── screens/            # UI screens
│   │   ├── services/           # API services
│   │   └── models/             # Data models
│   ├── android/                # Android config
│   ├── ios/                    # iOS config
│   └── pubspec.yaml           # Flutter dependencies
├── 7-multi-agent/              # Python backend
│   ├── ultra_simple_server.py # FastAPI server
│   ├── data/                   # CSV datasets
│   ├── .env                    # Environment variables
│   └── requirements.txt        # Python dependencies
├── data/                       # Shared data files
├── requirements.txt           # Root dependencies
├── .gitignore                # Git ignore rules
└── README.md                 # This file
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature-name`
3. **Commit** your changes: `git commit -m 'Add feature'`
4. **Push** to the branch: `git push origin feature-name`
5. **Submit** a Pull Request

### Development Guidelines
- Follow Flutter/Dart best practices
- Write clear, documented code
- Test your changes thoroughly
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google Gemini AI**: For powering intelligent hotel recommendations
- **Unsplash**: For providing beautiful hotel images
- **Flutter Team**: For the amazing cross-platform framework
- **FastAPI**: For the robust API framework

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/Adichauhan39/Hack2skill-Phase-2-internal/issues) page
2. Create a new issue with detailed description
3. Include error logs and steps to reproduce

## 🎯 Future Enhancements

- [ ] User authentication and profiles
- [ ] Booking integration with real APIs
- [ ] Advanced filtering options
- [ ] Offline mode support
- [ ] Multi-language support
- [ ] Push notifications
- [ ] Hotel comparison feature

---

**Built with ❤️ for Hack2skill Phase 2**

*Experience the future of hotel booking with AI-powered recommendations and intuitive swipe interface!* 🚀
