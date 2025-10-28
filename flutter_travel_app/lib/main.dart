import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/app_config.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_hotels_screen.dart';
import 'screens/swipe_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/swipeable_hotels_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/hotel_results_screen.dart';
import 'models/hotel.dart';
import 'providers/app_provider.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize API service
  await ApiService().initSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: GetMaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppConfig.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConfig.primaryColor,
            primary: AppConfig.primaryColor,
            secondary: AppConfig.secondaryColor,
          ),
          scaffoldBackgroundColor: AppConfig.backgroundColor,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: AppConfig.primaryColor,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConfig.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConfig.paddingLarge,
                vertical: AppConfig.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: AppConfig.fontSizeMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: AppConfig.cardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
              borderSide:
                  const BorderSide(color: AppConfig.primaryColor, width: 2),
            ),
            hintStyle: GoogleFonts.poppins(
              color: AppConfig.textSecondary,
              fontSize: AppConfig.fontSizeMedium,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: AppConfig.primaryColor,
            unselectedItemColor: AppConfig.textSecondary,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
        ),
        home: const SplashScreen(),
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(name: '/home', page: () => const HomeScreen()),
          GetPage(
              name: '/search-hotels', page: () => const SearchHotelsScreen()),
          GetPage(
              name: '/hotel-results', page: () => const HotelResultsScreen()),
          GetPage(name: '/swipe', page: () => const SwipeScreen()),
          GetPage(name: '/bookings', page: () => const BookingsScreen()),
          GetPage(
            name: '/swipeable-hotels',
            page: () {
              final args = Get.arguments as Map<String, dynamic>?;
              final hotels = args?['hotels'] as List<dynamic>? ?? [];
              return SwipeableHotelsScreen(
                hotels: hotels.cast<Hotel>(),
              );
            },
          ),
          GetPage(name: '/cart', page: () => const CartScreen()),
        ],
      ),
    );
  }
}
