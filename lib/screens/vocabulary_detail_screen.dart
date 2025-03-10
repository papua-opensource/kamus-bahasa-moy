import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/vocabulary_service.dart';
import 'dart:io';

class VocabularyDetailScreen extends StatefulWidget {
  final Word word;

  const VocabularyDetailScreen({Key? key, required this.word})
      : super(key: key);

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isNoConnection = false; // Flag untuk menandai masalah koneksi
  late ApiWord _wordDetail;

  @override
  void initState() {
    super.initState();
    _fetchWordDetail();
  }

  // Function to get word detail from API
  Future<void> _fetchWordDetail() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _isNoConnection = false;
    });

    try {
      final detail = await VocabularyService.getWordDetail(widget.word.id);
      setState(() {
        _wordDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;

        // Cek apakah error disebabkan oleh masalah koneksi
        if (e is SocketException ||
            e.toString().contains('SocketException') ||
            e.toString().contains('Connection refused') ||
            e.toString().contains('Network is unreachable') ||
            e.toString().contains('Connection timed out') ||
            e.toString().contains('No internet')) {
          _isNoConnection = true;
          _errorMessage = 'Tidak dapat terhubung ke internet';
        } else {
          _errorMessage = e.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Kosakata',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // Refresh button to reload details
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchWordDetail,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Memuat detail kosakata...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF495057),
                    ),
                  ),
                ],
              ),
            )
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isNoConnection ? Icons.wifi_off : Icons.error_outline,
                        size: 64,
                        color: _isNoConnection ? Colors.black54 : Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isNoConnection
                            ? 'Tidak ada koneksi internet'
                            : 'Terjadi kesalahan: $_errorMessage',
                        style: TextStyle(
                          fontSize: 16,
                          color: _isNoConnection ? Colors.black54 : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (_isNoConnection)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Pastikan perangkat Anda terhubung ke internet untuk melihat detail kosakata',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _fetchWordDetail,
                        icon: const Icon(Icons.refresh),
                        label:
                            Text(_isNoConnection ? 'Coba Lagi' : 'Muat Ulang'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                )
              : _buildDetailContent(),
    );
  }

  Widget _buildDetailContent() {
    // Check if example sentences exist
    final hasMoyExample = _wordDetail.exampleOriginal.isNotEmpty;
    final hasIndonesianExample = _wordDetail.exampleTranslation.isNotEmpty;
    final hasAnyExample = hasMoyExample || hasIndonesianExample;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word Card without shadow, only border
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECEF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _wordDetail.text.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF293241),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Line with pronunciation and word class (inline)
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xFF293241),
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                            text: '[${_wordDetail.pronunciation}]',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: _wordDetail.wordClassId.abbreviation,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: _wordDetail.meanings.join('; ')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Example Sentence Header
            const Text(
              'Contoh Kalimat',
              style: TextStyle(
                color: Color(0xFF293241),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            // Example sentence container with border (without shadow)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: !hasAnyExample
                  ? // No examples available
                  const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Belum ada contoh kalimat untuk kata ini',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bahasa Moy example
                        if (hasMoyExample) ...[
                          Row(
                            children: [
                              const Text(
                                'Bahasa Moy',
                                style: TextStyle(
                                  color: Color(0xFF293241),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE9ECEF),
                                ),
                                child: const Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      backgroundColor: Color(0xFFE9ECEF),
                                      color: Color(0xFF293241),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _wordDetail.exampleOriginal,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF293241),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ] else
                          const Text(
                            'Belum ada contoh kalimat bahasa Moy',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Bahasa Indonesia example
                        const Text(
                          'Bahasa Indonesia',
                          style: TextStyle(
                            color: Color(0xFF293241),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        hasIndonesianExample
                            ? Text(
                                _wordDetail.exampleTranslation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF293241),
                                ),
                              )
                            : const Text(
                                'Belum ada contoh kalimat bahasa Indonesia',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../models/word.dart';
// import '../services/vocabulary_service.dart';

// class VocabularyDetailScreen extends StatefulWidget {
//   final Word word;

//   const VocabularyDetailScreen({Key? key, required this.word})
//       : super(key: key);

//   @override
//   State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
// }

// class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
//   bool _isLoading = true;
//   bool _hasError = false;
//   String _errorMessage = '';
//   late ApiWord _wordDetail;

//   @override
//   void initState() {
//     super.initState();
//     _fetchWordDetail();
//   }

//   // Function to get word detail from API
//   Future<void> _fetchWordDetail() async {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//       _errorMessage = '';
//     });

//     try {
//       final detail = await VocabularyService.getWordDetail(widget.word.id);
//       setState(() {
//         _wordDetail = detail;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Detail Kosakata',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         actions: [
//           // Refresh button to reload details
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _fetchWordDetail,
//           ),
//         ],
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text(
//                     'Memuat detail kosakata...',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF495057),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : _hasError
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.error_outline,
//                         size: 64,
//                         color: Colors.red,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Terjadi kesalahan: $_errorMessage',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.red,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _fetchWordDetail,
//                         child: const Text('Coba Lagi'),
//                       ),
//                     ],
//                   ),
//                 )
//               : _buildDetailContent(),
//     );
//   }

//   Widget _buildDetailContent() {
//     // Check if example sentences exist
//     final hasMoyExample = _wordDetail.exampleOriginal.isNotEmpty;
//     final hasIndonesianExample = _wordDetail.exampleTranslation.isNotEmpty;
//     final hasAnyExample = hasMoyExample || hasIndonesianExample;

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Word Card without shadow, only border
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE9ECEF),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300, width: 1),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _wordDetail.text.toUpperCase(),
//                     style: const TextStyle(
//                       color: Color(0xFF293241),
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Line with pronunciation and word class (inline)
//                   RichText(
//                     text: TextSpan(
//                       style: const TextStyle(
//                         color: Color(0xFF293241),
//                         fontSize: 16,
//                       ),
//                       children: [
//                         TextSpan(text: '[${_wordDetail.pronunciation}]'),
//                         const TextSpan(text: ' '),
//                         TextSpan(
//                           text: _wordDetail.wordClassId.abbreviation,
//                           style: const TextStyle(
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                         const TextSpan(text: ' '),
//                         TextSpan(text: _wordDetail.meanings.join('; ')),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Example Sentence Header
//             const Text(
//               'Contoh Kalimat',
//               style: TextStyle(
//                 color: Color(0xFF293241),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Example sentence container with border (without shadow)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300, width: 1),
//               ),
//               child: !hasAnyExample
//                   ? // No examples available
//                   const Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                         child: Text(
//                           'Belum ada contoh kalimat untuk kata ini',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                             fontStyle: FontStyle.italic,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Bahasa Moy example
//                         if (hasMoyExample) ...[
//                           Row(
//                             children: [
//                               const Text(
//                                 'Bahasa Moy',
//                                 style: TextStyle(
//                                   color: Color(0xFF293241),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Container(
//                                 width: 24,
//                                 height: 24,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xFFE9ECEF),
//                                 ),
//                                 child: const Center(
//                                   child: Text(
//                                     '1',
//                                     style: TextStyle(
//                                       backgroundColor: Color(0xFFE9ECEF),
//                                       color: Color(0xFF293241),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             _wordDetail.exampleOriginal,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Color(0xFF293241),
//                             ),
//                           ),
//                         ] else
//                           const Text(
//                             'Belum ada contoh kalimat bahasa Moy',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),

//                         const SizedBox(height: 16),

//                         // Bahasa Indonesia example
//                         const Text(
//                           'Bahasa Indonesia',
//                           style: TextStyle(
//                             color: Color(0xFF293241),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         hasIndonesianExample
//                             ? Text(
//                                 _wordDetail.exampleTranslation,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Color(0xFF293241),
//                                 ),
//                               )
//                             : const Text(
//                                 'Belum ada contoh kalimat bahasa Indonesia',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
