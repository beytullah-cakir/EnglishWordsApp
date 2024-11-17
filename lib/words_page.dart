import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "datas.dart";

class WordsPage extends StatefulWidget {
  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  void _showEditDialog(BuildContext context, int index, String currentWord,
      String currentMeaning) {
    final TextEditingController wordController =
        TextEditingController(text: currentWord);
    final TextEditingController meaningController =
        TextEditingController(text: currentMeaning);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Kelimeyi Düzenle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                decoration: const InputDecoration(labelText: "İngilizce Kelime"),
              ),
              TextField(
                controller: meaningController,
                decoration: const InputDecoration(labelText: "Anlamı"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                editWord(index, wordController.text, meaningController.text);
                Navigator.pop(context);
              },
              child: Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

   @override
  void initState() {
    super.initState();
    _loadWords(); 
  }

Future<void> _loadWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wordsString = prefs.getString('words');
    if (wordsString != null) {
      List<dynamic> wordsList = jsonDecode(wordsString);
      setState(() {
        words = wordsList
            .map((item) => {
                  'word': item['word'] as String,
                  'meaning': item['meaning'] as String,
                })
            .toList();
      });
    }
  }

  Future<void> saveWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String wordsString = jsonEncode(words);
    await prefs.setString('words', wordsString);
  }


void deleteWord(int index) {
    setState(() {
      words.removeAt(index);
    });
    saveWords();
  }

  void editWord(int index, String newWord, String newMeaning) {
    setState(() {
      words[index] = {'word': newWord, 'meaning': newMeaning};
    });
    saveWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              shadowColor: Colors.grey,
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  words[index]['word'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueGrey[800],
                  ),
                ),
                subtitle: Text(
                  words[index]['meaning'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(
                        context,
                        index,
                        words[index]['word'] ?? '',
                        words[index]['meaning'] ?? '',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () =>deleteWord(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
