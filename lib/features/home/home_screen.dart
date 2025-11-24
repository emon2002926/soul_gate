import 'package:flutter/material.dart';
import 'package:soul_gate/features/home/views/home_page.dart';
import '../../core/widgets/bottom_navigation/bottom_navigation.dart';
import '../card_reading/views/card_reading_screen.dart';
import '../profile/views/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  int lastTapTime = 0; // For double-tap detection

  // Global keys for each tab's navigator
  final homeNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final favoriteNavKey = GlobalKey<NavigatorState>();
  final shoppingListNavKey = GlobalKey<NavigatorState>();

  void onTabSelected(int index) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Double-tap detection: If the same tab is tapped twice in quick succession
    if (index == currentIndex && currentTime - lastTapTime < 500) {
      // If double-tapped on the same tab, pop all the routes and go back to the first screen of the tab
      if (index == 0) {
        homeNavKey.currentState?.popUntil((route) => route.isFirst);
      } else if (index == 1) {
        notificationNavKey.currentState?.popUntil((route) => route.isFirst);
      } else if (index == 2) {
        favoriteNavKey.currentState?.popUntil((route) => route.isFirst);
      } else if (index == 3) {
        shoppingListNavKey.currentState?.popUntil((route) => route.isFirst);
      }
    } else {
      setState(() {
        currentIndex = index;
      });
    }

    lastTapTime = currentTime;
  }

  @override
  Widget build(BuildContext context) {
    // Screens corresponding to each tab


    final screens = [
      // HomeScreen(),
      ShuffleScreen(),
      CardReadingScreen(),
      ProfilePage(),
      // SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey,
      extendBody: true,
      body:
      WillPopScope(
        onWillPop: () {
          // Handle back navigation for each tab
          if (currentIndex == 0 && homeNavKey.currentState!.canPop() ?? false) {
            homeNavKey.currentState?.pop();
            return Future.value(false);
          } else if (currentIndex == 1 && notificationNavKey.currentState!.canPop() ?? false) {
            notificationNavKey.currentState?.pop();
            return Future.value(false);
          } else if (currentIndex == 2 && favoriteNavKey.currentState!.canPop() ?? false) {
            favoriteNavKey.currentState?.pop();
            return Future.value(false);
          }
          // else if (currentIndex == 3 && shoppingListNavKey.currentState!.canPop() ?? false) {
          //   shoppingListNavKey.currentState?.pop();
          //   return Future.value(false);
          // }
          return Future.value(true);
        },
        child: IndexedStack(
          index: currentIndex,
          children: [
            Navigator(
              key: homeNavKey,
              onGenerateInitialRoutes: (navigator, initialRoute) {
                return [
                  MaterialPageRoute(builder: (context) => screens[0])
                ];
              },
            ),
            Navigator(
              key: notificationNavKey,
              onGenerateInitialRoutes: (navigator, initialRoute) {
                return [
                  MaterialPageRoute(builder: (context) => screens[1])
                ];
              },
            ),
            Navigator(
              key: favoriteNavKey,
              onGenerateInitialRoutes: (navigator, initialRoute) {
                return [
                  MaterialPageRoute(builder: (context) => screens[2])
                ];
              },
            ),
            Navigator(
              key: shoppingListNavKey,
              onGenerateInitialRoutes: (navigator, initialRoute) {
                return [
                  MaterialPageRoute(builder: (context) => screens[3])
                ];
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
