import 'package:flutter/material.dart';
import 'package:soul_gate/features/home/views/home_page.dart';
import '../../core/widgets/bottom_navigation/bottom_navigation.dart';
import 'features/card_reading/views/blessing_screen.dart';
import 'features/profile/views/profile_page.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  int lastTapTime = 0;

  final homeNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final favoriteNavKey = GlobalKey<NavigatorState>();
  final shoppingListNavKey = GlobalKey<NavigatorState>();

  void onTabSelected(int index) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (index == currentIndex && currentTime - lastTapTime < 500) {
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
      HomePage(),
      BlessingFlowPage(),
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
      bottomNavigationBar:Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 12, // Space at the bottom
        ),
        child: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTabSelected: onTabSelected,
        ),
      )

    );
  }
}
