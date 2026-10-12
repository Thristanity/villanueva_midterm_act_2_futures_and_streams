import 'package:flutter/material.dart';
import 'package:villanueva_midterm_act_2_futures_and_streams/screens/top_books.dart';
import 'package:villanueva_midterm_act_2_futures_and_streams/screens/random_genre.dart';

void main() {
  runApp(const VillanuevaMidtermApp());
}

class VillanuevaMidtermApp extends StatelessWidget {
  const VillanuevaMidtermApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Villanueva Midterm Act 2: Futures & Streams',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainTabScreen(),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    OrderScreen(),
    BeltScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Top Classic Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt),
            label: 'Book for your Genre!',
          ),
        ],
      ),
    );
  }
}