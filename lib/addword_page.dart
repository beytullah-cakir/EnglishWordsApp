import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'datas.dart';

class AddWordPage extends StatelessWidget {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();

  Future<void> saveWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String wordsString = jsonEncode(words);
    await prefs.setString('words', wordsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _wordController,
              decoration: InputDecoration(
                labelText: 'English Word',
                labelStyle: TextStyle(color: Colors.blueGrey[700]),
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _meaningController,
              decoration: InputDecoration(
                labelText: 'Meaning',
                labelStyle: TextStyle(color: Colors.blueGrey[700]),
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String word = _wordController.text;
          String meaning = _meaningController.text;

          if (word.isNotEmpty && meaning.isNotEmpty) {
            //onAddWord(word, meaning);
            words.add({"word": word, "meaning": meaning});
            saveWords();
            _wordController.clear();
            _meaningController.clear();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lütfen her iki alanı da doldurun')),
            );
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Yeni Ekle', // Butonun üstüne geldiğinde görünen metin
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
