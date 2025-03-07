// import 'package:flutter/material.dart';
// import '../widgets/app_drawer.dart';
// import '../models/word.dart';
// import 'vocabulary_detail_screen.dart';

// class VocabularyScreen extends StatefulWidget {
//   const VocabularyScreen({Key? key}) : super(key: key);

//   @override
//   State<VocabularyScreen> createState() => _VocabularyScreenState();
// }

// class _VocabularyScreenState extends State<VocabularyScreen> {
//   final List<Word> _words = dummyWords;
//   final List<String> _alphabets = [
//     'A',
//     'B',
//     'C',
//     'D',
//     'E',
//     'F',
//     'G',
//     'H',
//     'I',
//     'J',
//     'K',
//     'L',
//     'M',
//     'N',
//     'O',
//     'P',
//     'Q',
//     'R',
//     'S',
//     'T',
//     'U',
//     'V',
//     'W',
//     'X',
//     'Y',
//     'Z'
//   ];
//   final ScrollController _scrollController = ScrollController();
//   String _selectedAlphabet =
//       'A'; // Inisialisasi dengan huruf 'A' sebagai default

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollLeft() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.offset - 150,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   void _scrollRight() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.offset + 150,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   // Mendapatkan kata-kata berdasarkan filter abjad
//   List<Word> get _filteredWords {
//     if (_selectedAlphabet.isEmpty) {
//       return _words;
//     }
//     return _words
//         .where((word) => word.word.startsWith(_selectedAlphabet))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Kosakata',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu, color: Colors.white),
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       drawer: const AppDrawer(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Telusuri kosakata bahasa Moy berdasarkan abjad. Tekan kata untuk melihat detail.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFF293241),
//               ),
//             ),
//           ),
//           // Alphabet filter dengan tombol navigasi
//           Container(
//             height: 50,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: [
//                 // Tombol navigasi kiri
//                 IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back_ios,
//                     size: 18,
//                     color: Color(0xFF293241),
//                   ),
//                   onPressed: _scrollLeft,
//                 ),
//                 // Daftar abjad dengan scroll
//                 Expanded(
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _alphabets.length,
//                     itemBuilder: (context, index) {
//                       final isSelected = _selectedAlphabet == _alphabets[index];
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             // Jika alphabet yang sama ditekan lagi, reset filter
//                             if (_selectedAlphabet == _alphabets[index]) {
//                               _selectedAlphabet = '';
//                             } else {
//                               _selectedAlphabet = _alphabets[index];
//                             }
//                           });
//                         },
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           margin: const EdgeInsets.symmetric(horizontal: 2),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: isSelected
//                                 ? const Color(0xFF495057)
//                                 : Colors.grey[200],
//                           ),
//                           child: Center(
//                             child: Text(
//                               _alphabets[index],
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w500
//                                     : FontWeight.w400,
//                                 color: isSelected
//                                     ? Colors.white
//                                     : Colors.grey[500],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Tombol navigasi kanan
//                 IconButton(
//                   icon: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 18,
//                     color: Color(0xFF495057),
//                   ),
//                   onPressed: _scrollRight,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Divider antara abjad dan daftar kata
//           const Divider(
//             height: 1,
//             thickness: 1,
//             color: Color(0xFFDEE2E6),
//           ),
//           // Word list atau pesan jika tidak ada data
//           Expanded(
//             child: _selectedAlphabet.isNotEmpty && _filteredWords.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.search_off,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Tidak ada kata yang dimulai dengan huruf "$_selectedAlphabet"',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _filteredWords.length,
//                     itemBuilder: (context, index) {
//                       final word = _filteredWords[index];
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           border:
//                               Border.all(color: Colors.grey.shade300, width: 1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     VocabularyDetailScreen(word: word),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFE9ECEF),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         word.word,
//                                         style: const TextStyle(
//                                           color: Color(0xFF293241),
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       // Tampilkan phoneticSpelling, wordClass dan meaning dalam satu baris
//                                       RichText(
//                                         text: TextSpan(
//                                           style: const TextStyle(
//                                             color: Color(0xFF293241),
//                                             fontSize: 16,
//                                           ),
//                                           children: [
//                                             TextSpan(
//                                                 text: word.phoneticSpelling),
//                                             const TextSpan(text: ' '),
//                                             TextSpan(
//                                               text: word.wordClass,
//                                               style: const TextStyle(
//                                                 fontStyle: FontStyle.italic,
//                                               ),
//                                             ),
//                                             const TextSpan(text: ' '),
//                                             TextSpan(text: word.meaning),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(
//                                     word.isFavorite
//                                         ? Icons.bookmark
//                                         : Icons.bookmark_border,
//                                     color: Color(0xFF6C757D),
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _words[_words.indexWhere(
//                                               (w) => w.word == word.word)]
//                                           .isFavorite = !word.isFavorite;
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../models/word.dart';
import '../services/vocabulary_service.dart';
import 'vocabulary_detail_screen.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final List<Word> _words = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  final int _limit = 15;
  int _totalCount = 0;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

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
  final ScrollController _listScrollController = ScrollController();
  String _selectedAlphabet = ''; // Diubah menjadi kosong sebagai default

  @override
  void initState() {
    super.initState();
    _fetchVocabulary();
    _listScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listScrollController.removeListener(_scrollListener);
    _listScrollController.dispose();
    super.dispose();
  }

  // Listener untuk infinite scroll
  void _scrollListener() {
    if (_listScrollController.position.pixels >=
        _listScrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  // Fungsi untuk memuat data awal
  Future<void> _fetchVocabulary() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final response = await VocabularyService.getVocabulary(
          page: 1, limit: _limit, startWith: _selectedAlphabet, languageId: 2);

      setState(() {
        _words.clear();
        _words.addAll(
            response.results.map(VocabularyService.mapApiWordToWord).toList());
        _totalCount = response.count;
        _currentPage = 1;
        _hasMoreData = response.next != null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  // Fungsi untuk memuat lebih banyak data (infinite scroll)
  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final response = await VocabularyService.getVocabulary(
          page: nextPage,
          limit: _limit,
          startWith: _selectedAlphabet,
          languageId: 2);

      if (response.results.isNotEmpty) {
        setState(() {
          _words.addAll(response.results
              .map(VocabularyService.mapApiWordToWord)
              .toList());
          _currentPage = nextPage;
          _hasMoreData = response.next != null;
        });
      } else {
        setState(() {
          _hasMoreData = false;
        });
      }
    } catch (e) {
      // Gagal memuat data tambahan, tapi tidak perlu mengganggu UI utama
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data tambahan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
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

  // Karena filter sudah diterapkan dari API, kita tidak perlu memfilter lagi di client
  List<Word> get _filteredWords {
    return _words;
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
        actions: [
          // Tombol refresh
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchVocabulary,
          ),
        ],
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
                color: Color(0xFF293241),
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
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Color(0xFF293241),
                  ),
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
                          final previousAlphabet = _selectedAlphabet;

                          // Perbarui selected alphabet
                          setState(() {
                            // Saat ini tidak diizinkan kosong, selalu harus ada huruf yang dipilih
                            // Jika alphabet yang sama ditekan lagi, tetap gunakan alphabet tersebut
                            _selectedAlphabet = _alphabets[index];

                            // Set loading state jika berbeda huruf
                            if (previousAlphabet != _selectedAlphabet) {
                              _isLoading = true; // Tambahkan loading state
                            }
                          });

                          // Jika huruf berbeda, muat ulang data
                          if (previousAlphabet != _selectedAlphabet) {
                            _fetchVocabulary();
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color(0xFF495057)
                                : Colors.grey[200],
                          ),
                          child: Center(
                            child: Text(
                              _alphabets[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[500],
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
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xFF495057),
                  ),
                  onPressed: _scrollRight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Divider antara abjad dan daftar kata
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFDEE2E6),
          ),
          // Tampilkan status loading atau error
          if (_isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Memuat kosakata...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF495057),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_hasError)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan: $_errorMessage',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchVocabulary,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          // Word list atau pesan jika tidak ada data
          else
            Expanded(
              child: _filteredWords.isEmpty
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
                      controller: _listScrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          _filteredWords.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Menampilkan loading indicator di akhir list
                        if (index == _filteredWords.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final word = _filteredWords[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
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
                                color: const Color(0xFFE9ECEF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          word.word,
                                          style: const TextStyle(
                                            color: Color(0xFF293241),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Tampilkan phoneticSpelling, wordClass dan meaning dalam satu baris
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              color: Color(0xFF293241),
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
                                      color: const Color(0xFF6C757D),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        final wordIndex = _words.indexWhere(
                                            (w) => w.word == word.word);
                                        if (wordIndex != -1) {
                                          _words[wordIndex].isFavorite =
                                              !word.isFavorite;
                                        }
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
