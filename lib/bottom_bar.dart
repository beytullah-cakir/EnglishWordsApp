import 'package:flutter/material.dart';
import 'addword_page.dart';
import 'words_page.dart';
import 'training_start_page.dart';

class BottomBar extends StatefulWidget {
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0; // Aktif tab'ın indeksi

  // Sayfalar listesi
  final List<Widget> _pages = [
    AddWordPage(),        // Kelime ekleme sayfası
    WordsPage(),          // Kelime listesi sayfası
    TrainingStartPage(),  // Alıştırma başlangıç sayfası
  ];

  // Tab değiştirildiğinde tetiklenen metod
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Aktif tab'ı değiştir
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Aktif sayfa
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Word',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Words',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reddit_rounded),
            label: 'Training',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
