import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/word.dart';
import 'vocabulary_detail_screen.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final List<Word> _words = dummyWords;
  final List<String> _alphabets = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  final ScrollController _scrollController = ScrollController();
  String _selectedAlphabet = ''; // Untuk menyimpan huruf yang dipilih

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset - 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Mendapatkan kata-kata berdasarkan filter abjad
  List<Word> get _filteredWords {
    if (_selectedAlphabet.isEmpty) {
      return _words;
    }
    return _words
        .where((word) => word.word.startsWith(_selectedAlphabet))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kosakata',
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
              'Telusuri kosakata bahasa Moy berdasarkan abjad. Tekan kata untuk melihat detail.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          // Alphabet filter dengan tombol navigasi
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Tombol navigasi kiri
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: _scrollLeft,
                ),
                // Daftar abjad dengan scroll
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _alphabets.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedAlphabet == _alphabets[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // Jika alphabet yang sama ditekan lagi, reset filter
                            if (_selectedAlphabet == _alphabets[index]) {
                              _selectedAlphabet = '';
                            } else {
                              _selectedAlphabet = _alphabets[index];
                            }
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color(0xFF1976D2)
                                : Colors.grey[200],
                          ),
                          child: Center(
                            child: Text(
                              _alphabets[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Tombol navigasi kanan
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: _scrollRight,
                ),
              ],
            ),
          ),
          // Word list atau pesan jika tidak ada data
          Expanded(
            child: _selectedAlphabet.isNotEmpty && _filteredWords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada kata yang dimulai dengan huruf "$_selectedAlphabet"',
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
                    itemCount: _filteredWords.length,
                    itemBuilder: (context, index) {
                      final word = _filteredWords[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    VocabularyDetailScreen(word: word),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2),
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
                                  icon: Icon(
                                    word.isFavorite
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _words[_words.indexWhere(
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
