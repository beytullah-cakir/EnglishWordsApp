import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TrainingPage extends StatefulWidget {
  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late List<Map<String, String>> shuffledWords; // Karışık liste
  int currentIndex = 0; // Gösterilen kelimenin indeksi
  bool showMeaning = false; // Anlamı gösterme durumu
  bool isLoading = true; // Asenkron işlem durumu

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  // Bir sonraki karta geçiş
  void getNextCard() {
    setState(() {
      if (currentIndex < shuffledWords.length - 1) {
        currentIndex++;
        showMeaning = false; // Yeni karta geçerken anlamı gizle
      } else {
        // Eğer tüm kartlar biterse başlangıç sayfasına dön
        Navigator.pop(context);
      }
    });
  }

  // Kart üzerine tıklanıldığında anlamı gösterme
  void toggleMeaning() {
    setState(() {
      showMeaning = !showMeaning; // Mevcut durumu tersine çevir
    });
  }

  Future<void> _loadWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wordsString = prefs.getString('words');
    if (wordsString != null) {
      List<dynamic> wordsList = jsonDecode(wordsString);
      setState(() {
        shuffledWords = List<Map<String, String>>.from(
          wordsList.map(
            (item) => {
              'word': item['word'] as String,
              'meaning': item['meaning'] as String,
            },
          ),
        )..shuffle(); // Listeyi karıştır
        isLoading = false; // Yükleme tamamlandı
      });
    } else {
      // Kelimeler yoksa boş liste ata ve yüklemeyi tamamla
      setState(() {
        shuffledWords = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
      appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(), // Yükleme göstergesi
        ),
      );
    }

    if (shuffledWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Kelime Kartları')),
        body: Center(
          child: Text(
            'Kelimeler yüklenemedi. Lütfen kelime listesini kontrol edin.',
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap:
                  toggleMeaning, // Kelimeye tıklandığında anlamı göster/gizle
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: 300,
                  height: 200,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    showMeaning
                        ? shuffledWords[currentIndex]['meaning'] ?? '' // Anlamı
                        : shuffledWords[currentIndex]['word'] ?? '', // Kelime
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: getNextCard, // Yeni karta geçiş
              child: Text('Sonraki Kart'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
