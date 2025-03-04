import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/word.dart';
import 'vocabulary_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Opsi filter kelas kata
  final List<String> _sortOptions = [
    'Semua',
    'Nomina (n)',
    'Verba (v)',
    'Adjektiva (a)',
    'Adverbia (adv)',
    'Pronomina (pron)',
    'Numeralia (num)',
    'Partikel (p)'
  ];
  String _selectedSortOption = 'Semua';

  // Fungsi untuk mendapatkan kata favorit berdasarkan filter kelas kata
  List<Word> get _filteredFavoriteWords {
    List<Word> favorites = dummyWords.where((word) => word.isFavorite).toList();

    if (_selectedSortOption == 'Semua') {
      return favorites;
    }

    String classCode = '';
    switch (_selectedSortOption) {
      case 'Nomina (n)':
        classCode = 'n';
        break;
      case 'Verba (v)':
        classCode = 'v';
        break;
      case 'Adjektiva (a)':
        classCode = 'a';
        break;
      case 'Adverbia (adv)':
        classCode = 'adv';
        break;
      case 'Pronomina (pron)':
        classCode = 'pron';
        break;
      case 'Numeralia (num)':
        classCode = 'num';
        break;
      case 'Partikel (p)':
        classCode = 'p';
        break;
    }

    return favorites.where((word) => word.wordClass == classCode).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorit',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Daftar kata-kata favorit Anda. Anda dapat mengurutkan kata berdasarkan kelas kata.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          // Sorting dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSortOption,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSortOption = newValue;
                      });
                    }
                  },
                  items: _sortOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Word list atau pesan kosong
          Expanded(
            child: _filteredFavoriteWords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.bookmark_border,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedSortOption == 'Semua'
                              ? 'Belum ada kata favorit'
                              : 'Tidak ada kata favorit dengan kelas kata $_selectedSortOption',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFavoriteWords.length,
                    itemBuilder: (context, index) {
                      final word = _filteredFavoriteWords[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    VocabularyDetailScreen(word: word),
                              ),
                            )
                                .then((_) {
                              // Refresh the list when returning from detail screen
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2973B2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        word.word,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Tampilkan phoneticSpelling, wordClass dan meaning dalam satu baris
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: word.phoneticSpelling),
                                            const TextSpan(text: ' '),
                                            TextSpan(
                                              text: word.wordClass,
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const TextSpan(text: ' '),
                                            TextSpan(text: word.meaning),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.bookmark,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      dummyWords[dummyWords.indexWhere(
                                              (w) => w.word == word.word)]
                                          .isFavorite = !word.isFavorite;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
