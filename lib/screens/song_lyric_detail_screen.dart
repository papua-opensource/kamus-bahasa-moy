import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class SongDetailScreen extends StatefulWidget {
  final dynamic song;

  const SongDetailScreen({Key? key, required this.song}) : super(key: key);

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen>
    with WidgetsBindingObserver {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAudioPlayer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Aplikasi berada di background, jeda audio
      _audioPlayer?.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _initAudioPlayer() {
    if (widget.song['hasAudio'] == true && widget.song['audioUrl'] != null) {
      _audioPlayer = AudioPlayer();

      // Tambahkan listener untuk menangani error pemutaran
      _audioPlayer!.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
          });
        }
      });

      // Listener khusus untuk error
      _audioPlayer!.playbackEventStream.listen(
        (event) {},
        onError: (Object e, StackTrace stackTrace) {
          setState(() {
            _hasError = true;
            if (e is PlayerException) {
              _errorMessage = _getErrorMessage(e);
            } else {
              _errorMessage = 'Terjadi kesalahan saat memutar audio';
            }

            if (_isPlaying) {
              _isPlaying = false;
            }
          });
        },
      );

      _loadAudio();
    }
  }

  // Helper untuk menerjemahkan error pemutaran menjadi pesan yang lebih user-friendly
  String _getErrorMessage(PlayerException e) {
    // Cetak error untuk debugging
    print('Player error: ${e.code} - ${e.message}');

    // Cek error "Source Error" yang biasanya muncul saat tidak ada koneksi internet
    if (e.message?.contains('Source Error') == true ||
        e.message?.toString().contains('(0)') == true) {
      return 'Tidak dapat memutar audio: Periksa koneksi internet Anda';
    }

    // Cek error koneksi lainnya
    else if (e.code == 'network-error' ||
        e.message?.contains('network') == true ||
        e.message?.contains('connection') == true ||
        e.message?.contains('connect') == true ||
        e.code == 'source-error') {
      return 'Tidak dapat memutar audio: Masalah koneksi internet';
    }

    // Error file tidak tersedia
    else if (e.message?.contains('404') == true ||
        e.message?.contains('not found') == true) {
      return 'Audio tidak tersedia: File tidak ditemukan';
    }

    // Error lainnya
    else {
      return 'Tidak dapat memutar audio. Silakan coba lagi nanti.';
    }
  }

  Future<void> _loadAudio() async {
    if (_audioPlayer == null || widget.song['audioUrl'] == null) return;

    setState(() {
      _isLoadingAudio = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      await _audioPlayer!.setUrl(widget.song['audioUrl']).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw PlayerException(1001, 'Koneksi timeout');
        },
      );
      setState(() {
        _isLoadingAudio = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingAudio = false;
        _hasError = true;

        // Cek error yang biasanya muncul saat tidak ada koneksi
        if (e.toString().contains('Source Error') ||
            e.toString().contains('(0)')) {
          _errorMessage =
              'Tidak dapat memutar audio: Periksa koneksi internet Anda';
        }
        // Cek error koneksi lainnya
        else if (e.toString().contains('network') ||
            e.toString().contains('connect') ||
            e.toString().contains('connection') ||
            e.toString().contains('timeout')) {
          _errorMessage = 'Tidak dapat memutar audio: Masalah koneksi internet';
        }
        // Error file tidak ditemukan
        else if (e.toString().contains('404') ||
            e.toString().contains('not found')) {
          _errorMessage = 'Audio tidak tersedia: File tidak ditemukan';
        }
        // Error lainnya
        else {
          _errorMessage = 'Tidak dapat memutar audio. Silakan coba lagi nanti.';
        }
      });
    }
  }

  void _playPause() {
    if (_audioPlayer == null) return;

    if (_hasError) {
      // Jika terjadi error, coba load ulang audio
      _retryLoadAudio();
      return;
    }

    if (_isPlaying) {
      _audioPlayer!.pause();
    } else {
      _audioPlayer!.play().catchError((error) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Gagal memutar audio: ${error.toString()}';
          _isPlaying = false;
        });
      });
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Fungsi untuk mencoba muat ulang audio
  void _retryLoadAudio() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    _loadAudio();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer?.positionStream ?? Stream.value(Duration.zero),
        _audioPlayer?.bufferedPositionStream ?? Stream.value(Duration.zero),
        _audioPlayer?.durationStream ?? Stream.value(null),
        (position, bufferedPosition, duration) => PositionData(
          position: position,
          bufferedPosition: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool hasAudio =
        widget.song['hasAudio'] == true && widget.song['audioUrl'] != null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Lirik Lagu"),
        backgroundColor: const Color(0xFF164B8F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.song['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.song['category'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.song['author'] != null
                      ? 'Pengarang: ${widget.song['author']}'
                      : 'Pengarang: Tidak diketahui',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            // Audio Player Section
            if (hasAudio) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Audio Lagu:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingAudio)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_hasError)
                      _buildErrorWidget()
                    else
                      Column(
                        children: [
                          // Progress bar with play button to the left
                          StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data ??
                                  PositionData(
                                    position: Duration.zero,
                                    bufferedPosition: Duration.zero,
                                    duration: Duration.zero,
                                  );

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Play/Pause button on the left
                                  IconButton(
                                    icon: Icon(_isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled),
                                    iconSize: 42,
                                    color: const Color(0xFF164B8F),
                                    onPressed: _playPause,
                                    padding: EdgeInsets.zero,
                                  ),
                                  // Slider and duration in a column
                                  Expanded(
                                    child: Column(
                                      children: [
                                        // Slider
                                        SliderTheme(
                                          data: SliderThemeData(
                                            thumbColor: const Color(0xFF164B8F),
                                            activeTrackColor:
                                                const Color(0xFF164B8F),
                                            inactiveTrackColor:
                                                Colors.grey[300],
                                            trackHeight: 4.0,
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 8.0),
                                          ),
                                          child: Slider(
                                            min: 0.0,
                                            max: positionData
                                                        .duration.inMilliseconds
                                                        .toDouble() >
                                                    0
                                                ? positionData
                                                    .duration.inMilliseconds
                                                    .toDouble()
                                                : 1.0,
                                            value: min(
                                              positionData
                                                  .position.inMilliseconds
                                                  .toDouble(),
                                              positionData
                                                  .duration.inMilliseconds
                                                  .toDouble(),
                                            ),
                                            onChanged: (value) {
                                              _audioPlayer?.seek(Duration(
                                                  milliseconds: value.toInt()));
                                            },
                                          ),
                                        ),
                                        // Duration text
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatDuration(
                                                    positionData.position),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                _formatDuration(
                                                    positionData.duration),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.music_off, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Audio untuk lagu ini belum tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Lyrics section
            const SizedBox(height: 24),
            const Text(
              'Lirik:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.song['lyrics'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan pesan error dan tombol retry
  Widget _buildErrorWidget() {
    // Tentukan ikon berdasarkan pesan error
    IconData errorIcon = Icons.error_outline;

    if (_errorMessage.contains('koneksi') ||
        _errorMessage.contains('internet') ||
        _errorMessage.contains('Periksa koneksi') ||
        _errorMessage.contains('network')) {
      errorIcon = Icons.signal_wifi_off;
    } else if (_errorMessage.contains('tidak tersedia') ||
        _errorMessage.contains('tidak ditemukan') ||
        _errorMessage.contains('rusak')) {
      errorIcon = Icons.broken_image_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              errorIcon,
              color: Colors.black54,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _retryLoadAudio,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF164B8F),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}

// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';
// import 'dart:math';

// class SongDetailScreen extends StatefulWidget {
//   final dynamic song;

//   const SongDetailScreen({Key? key, required this.song}) : super(key: key);

//   @override
//   State<SongDetailScreen> createState() => _SongDetailScreenState();
// }

// class _SongDetailScreenState extends State<SongDetailScreen>
//     with WidgetsBindingObserver {
//   AudioPlayer? _audioPlayer;
//   bool _isPlaying = false;
//   bool _isLoadingAudio = false;
//   bool _hasError = false;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initAudioPlayer();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _audioPlayer?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       // Aplikasi berada di background, jeda audio
//       _audioPlayer?.pause();
//       setState(() {
//         _isPlaying = false;
//       });
//     }
//   }

//   void _initAudioPlayer() {
//     if (widget.song['hasAudio'] == true && widget.song['audioUrl'] != null) {
//       _audioPlayer = AudioPlayer();

//       // Tambahkan listener untuk menangani error pemutaran
//       _audioPlayer!.playerStateStream.listen((playerState) {
//         if (playerState.processingState == ProcessingState.completed) {
//           setState(() {
//             _isPlaying = false;
//           });
//         }
//       });

//       // Listener khusus untuk error
//       _audioPlayer!.playbackEventStream.listen(
//         (event) {},
//         onError: (Object e, StackTrace stackTrace) {
//           setState(() {
//             _hasError = true;
//             if (e is PlayerException) {
//               _errorMessage = _getErrorMessage(e);
//             } else {
//               _errorMessage = 'Terjadi kesalahan saat memutar audio';
//             }

//             if (_isPlaying) {
//               _isPlaying = false;
//             }
//           });
//         },
//       );

//       _loadAudio();
//     }
//   }

//   // Helper untuk menerjemahkan error pemutaran menjadi pesan yang lebih user-friendly
//   String _getErrorMessage(PlayerException e) {
//     if (e.code == 'network-error' ||
//         e.message?.contains('network') == true ||
//         e.message?.contains('connection') == true ||
//         e.message?.contains('connect') == true) {
//       return 'Gangguan koneksi internet saat memutar audio';
//     } else if (e.code == 'source-error' ||
//         e.message?.contains('source') == true) {
//       return 'File audio tidak tersedia atau rusak';
//     } else {
//       return 'Gagal memutar audio: ${e.message}';
//     }
//   }

//   Future<void> _loadAudio() async {
//     if (_audioPlayer == null || widget.song['audioUrl'] == null) return;

//     setState(() {
//       _isLoadingAudio = true;
//       _hasError = false;
//       _errorMessage = '';
//     });

//     try {
//       await _audioPlayer!.setUrl(widget.song['audioUrl']).timeout(
//         const Duration(seconds: 15),
//         onTimeout: () {
//           throw PlayerException(1001, 'Koneksi timeout');
//         },
//       );
//       setState(() {
//         _isLoadingAudio = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoadingAudio = false;
//         _hasError = true;

//         if (e.toString().contains('network') ||
//             e.toString().contains('connect') ||
//             e.toString().contains('connection') ||
//             e.toString().contains('timeout')) {
//           _errorMessage = 'Gagal memuat audio: Masalah koneksi internet';
//         } else {
//           _errorMessage = 'Gagal memuat audio: ${e.toString()}';
//         }
//       });
//     }
//   }

//   void _playPause() {
//     if (_audioPlayer == null) return;

//     if (_hasError) {
//       // Jika terjadi error, coba load ulang audio
//       _retryLoadAudio();
//       return;
//     }

//     if (_isPlaying) {
//       _audioPlayer!.pause();
//     } else {
//       _audioPlayer!.play().catchError((error) {
//         setState(() {
//           _hasError = true;
//           _errorMessage = 'Gagal memutar audio: ${error.toString()}';
//           _isPlaying = false;
//         });
//       });
//     }

//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }

//   // Fungsi untuk mencoba muat ulang audio
//   void _retryLoadAudio() {
//     setState(() {
//       _hasError = false;
//       _errorMessage = '';
//     });
//     _loadAudio();
//   }

//   Stream<PositionData> get _positionDataStream =>
//       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//         _audioPlayer?.positionStream ?? Stream.value(Duration.zero),
//         _audioPlayer?.bufferedPositionStream ?? Stream.value(Duration.zero),
//         _audioPlayer?.durationStream ?? Stream.value(null),
//         (position, bufferedPosition, duration) => PositionData(
//           position: position,
//           bufferedPosition: bufferedPosition,
//           duration: duration ?? Duration.zero,
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     final bool hasAudio =
//         widget.song['hasAudio'] == true && widget.song['audioUrl'] != null;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Lirik Lagu"),
//         backgroundColor: const Color(0xFF164B8F),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.song['title'],
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     widget.song['category'],
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   widget.song['author'] != null
//                       ? 'Pengarang: ${widget.song['author']}'
//                       : 'Pengarang: Tidak diketahui',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),

//             // Audio Player Section
//             if (hasAudio) ...[
//               const SizedBox(height: 24),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Audio Lagu:',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     if (_isLoadingAudio)
//                       const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: CircularProgressIndicator(),
//                         ),
//                       )
//                     else if (_hasError)
//                       _buildErrorWidget()
//                     else
//                       Column(
//                         children: [
//                           // Progress bar with play button to the left
//                           StreamBuilder<PositionData>(
//                             stream: _positionDataStream,
//                             builder: (context, snapshot) {
//                               final positionData = snapshot.data ??
//                                   PositionData(
//                                     position: Duration.zero,
//                                     bufferedPosition: Duration.zero,
//                                     duration: Duration.zero,
//                                   );

//                               return Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Play/Pause button on the left
//                                   IconButton(
//                                     icon: Icon(_isPlaying
//                                         ? Icons.pause_circle_filled
//                                         : Icons.play_circle_filled),
//                                     iconSize: 42,
//                                     color: const Color(0xFF164B8F),
//                                     onPressed: _playPause,
//                                     padding: EdgeInsets.zero,
//                                   ),
//                                   // Slider and duration in a column
//                                   Expanded(
//                                     child: Column(
//                                       children: [
//                                         // Slider
//                                         SliderTheme(
//                                           data: SliderThemeData(
//                                             thumbColor: const Color(0xFF164B8F),
//                                             activeTrackColor:
//                                                 const Color(0xFF164B8F),
//                                             inactiveTrackColor:
//                                                 Colors.grey[300],
//                                             trackHeight: 4.0,
//                                             thumbShape:
//                                                 const RoundSliderThumbShape(
//                                                     enabledThumbRadius: 8.0),
//                                           ),
//                                           child: Slider(
//                                             min: 0.0,
//                                             max: positionData
//                                                         .duration.inMilliseconds
//                                                         .toDouble() >
//                                                     0
//                                                 ? positionData
//                                                     .duration.inMilliseconds
//                                                     .toDouble()
//                                                 : 1.0,
//                                             value: min(
//                                               positionData
//                                                   .position.inMilliseconds
//                                                   .toDouble(),
//                                               positionData
//                                                   .duration.inMilliseconds
//                                                   .toDouble(),
//                                             ),
//                                             onChanged: (value) {
//                                               _audioPlayer?.seek(Duration(
//                                                   milliseconds: value.toInt()));
//                                             },
//                                           ),
//                                         ),
//                                         // Duration text
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 20),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 _formatDuration(
//                                                     positionData.position),
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 _formatDuration(
//                                                     positionData.duration),
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ] else ...[
//               const SizedBox(height: 24),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.music_off, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text(
//                       'Audio untuk lagu ini belum tersedia',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],

//             // Lyrics section
//             const SizedBox(height: 24),
//             const Text(
//               'Lirik:',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               widget.song['lyrics'],
//               style: const TextStyle(
//                 fontSize: 16,
//                 height: 1.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget untuk menampilkan pesan error dan tombol retry
//   Widget _buildErrorWidget() {
//     // Tentukan ikon berdasarkan pesan error
//     IconData errorIcon = Icons.error_outline;
//     if (_errorMessage.contains('koneksi') ||
//         _errorMessage.contains('internet') ||
//         _errorMessage.contains('network')) {
//       errorIcon = Icons.signal_wifi_off;
//     } else if (_errorMessage.contains('tidak tersedia') ||
//         _errorMessage.contains('rusak')) {
//       errorIcon = Icons.broken_image_outlined;
//     }

//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Icon(
//               errorIcon,
//               color: Colors.red[700],
//               size: 36,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _errorMessage,
//               style: TextStyle(
//                 color: Colors.red[700],
//                 fontSize: 14,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: _retryLoadAudio,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Coba Lagi'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF164B8F),
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }
// }

// class PositionData {
//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;

//   PositionData({
//     required this.position,
//     required this.bufferedPosition,
//     required this.duration,
//   });
// }

// // import 'package:flutter/material.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:rxdart/rxdart.dart';
// // import 'dart:math';

// // class SongDetailScreen extends StatefulWidget {
// //   final dynamic song;

// //   const SongDetailScreen({Key? key, required this.song}) : super(key: key);

// //   @override
// //   State<SongDetailScreen> createState() => _SongDetailScreenState();
// // }

// // class _SongDetailScreenState extends State<SongDetailScreen>
// //     with WidgetsBindingObserver {
// //   AudioPlayer? _audioPlayer;
// //   bool _isPlaying = false;
// //   bool _isLoadingAudio = false;
// //   bool _hasError = false;
// //   String _errorMessage = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addObserver(this);
// //     _initAudioPlayer();
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     _audioPlayer?.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (state == AppLifecycleState.paused) {
// //       // Aplikasi berada di background, jeda audio
// //       _audioPlayer?.pause();
// //     }
// //   }

// //   void _initAudioPlayer() {
// //     if (widget.song['hasAudio'] == true && widget.song['audioUrl'] != null) {
// //       _audioPlayer = AudioPlayer();
// //       _loadAudio();
// //     }
// //   }

// //   Future<void> _loadAudio() async {
// //     if (_audioPlayer == null || widget.song['audioUrl'] == null) return;

// //     setState(() {
// //       _isLoadingAudio = true;
// //       _hasError = false;
// //       _errorMessage = '';
// //     });

// //     try {
// //       await _audioPlayer!.setUrl(widget.song['audioUrl']);
// //       setState(() {
// //         _isLoadingAudio = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _isLoadingAudio = false;
// //         _hasError = true;
// //         _errorMessage = 'Gagal memuat audio: ${e.toString()}';
// //       });
// //     }
// //   }

// //   void _playPause() {
// //     if (_audioPlayer == null) return;

// //     if (_isPlaying) {
// //       _audioPlayer!.pause();
// //     } else {
// //       _audioPlayer!.play();
// //     }

// //     setState(() {
// //       _isPlaying = !_isPlaying;
// //     });
// //   }

// //   Stream<PositionData> get _positionDataStream =>
// //       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
// //         _audioPlayer?.positionStream ?? Stream.value(Duration.zero),
// //         _audioPlayer?.bufferedPositionStream ?? Stream.value(Duration.zero),
// //         _audioPlayer?.durationStream ?? Stream.value(null),
// //         (position, bufferedPosition, duration) => PositionData(
// //           position: position,
// //           bufferedPosition: bufferedPosition,
// //           duration: duration ?? Duration.zero,
// //         ),
// //       );

// //   @override
// //   Widget build(BuildContext context) {
// //     final bool hasAudio =
// //         widget.song['hasAudio'] == true && widget.song['audioUrl'] != null;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Detail Lirik Lagu"),
// //         backgroundColor: const Color(0xFF164B8F),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               widget.song['title'],
// //               style: const TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 8,
// //                     vertical: 4,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey[400],
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Text(
// //                     widget.song['category'],
// //                     style: const TextStyle(
// //                       fontSize: 14,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Text(
// //                   widget.song['author'] != null
// //                       ? 'Pengarang: ${widget.song['author']}'
// //                       : 'Pengarang: Tidak diketahui',
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey,
// //                   ),
// //                 ),
// //               ],
// //             ),

// //             // Audio Player Section
// //             if (hasAudio) ...[
// //               const SizedBox(height: 24),
// //               Container(
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[100],
// //                   borderRadius: BorderRadius.circular(12),
// //                   border: Border.all(color: Colors.grey[300]!),
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       'Audio Lagu:',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     if (_isLoadingAudio)
// //                       const Center(
// //                         child: Padding(
// //                           padding: EdgeInsets.all(8.0),
// //                           child: CircularProgressIndicator(),
// //                         ),
// //                       )
// //                     else if (_hasError)
// //                       Center(
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: Text(
// //                             _errorMessage,
// //                             style: const TextStyle(
// //                               color: Colors.red,
// //                               fontSize: 14,
// //                             ),
// //                           ),
// //                         ),
// //                       )
// //                     else
// //                       Column(
// //                         children: [
// //                           // Progress bar with play button to the left
// //                           StreamBuilder<PositionData>(
// //                             stream: _positionDataStream,
// //                             builder: (context, snapshot) {
// //                               final positionData = snapshot.data ??
// //                                   PositionData(
// //                                     position: Duration.zero,
// //                                     bufferedPosition: Duration.zero,
// //                                     duration: Duration.zero,
// //                                   );

// //                               return Row(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   // Play/Pause button on the left
// //                                   IconButton(
// //                                     icon: Icon(_isPlaying
// //                                         ? Icons.pause_circle_filled
// //                                         : Icons.play_circle_filled),
// //                                     iconSize: 42,
// //                                     color: const Color(0xFF164B8F),
// //                                     onPressed: _playPause,
// //                                     padding: EdgeInsets.zero,
// //                                   ),
// //                                   // Slider and duration in a column
// //                                   Expanded(
// //                                     child: Column(
// //                                       children: [
// //                                         // Slider
// //                                         SliderTheme(
// //                                           data: SliderThemeData(
// //                                             thumbColor: const Color(0xFF164B8F),
// //                                             activeTrackColor:
// //                                                 const Color(0xFF164B8F),
// //                                             inactiveTrackColor:
// //                                                 Colors.grey[300],
// //                                             trackHeight: 4.0,
// //                                             thumbShape:
// //                                                 const RoundSliderThumbShape(
// //                                                     enabledThumbRadius: 8.0),
// //                                           ),
// //                                           child: Slider(
// //                                             min: 0.0,
// //                                             max: positionData
// //                                                         .duration.inMilliseconds
// //                                                         .toDouble() >
// //                                                     0
// //                                                 ? positionData
// //                                                     .duration.inMilliseconds
// //                                                     .toDouble()
// //                                                 : 1.0,
// //                                             value: min(
// //                                               positionData
// //                                                   .position.inMilliseconds
// //                                                   .toDouble(),
// //                                               positionData
// //                                                   .duration.inMilliseconds
// //                                                   .toDouble(),
// //                                             ),
// //                                             onChanged: (value) {
// //                                               _audioPlayer?.seek(Duration(
// //                                                   milliseconds: value.toInt()));
// //                                             },
// //                                           ),
// //                                         ),
// //                                         // Duration text
// //                                         Padding(
// //                                           padding: const EdgeInsets.symmetric(
// //                                               horizontal: 20),
// //                                           child: Row(
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Text(
// //                                                 _formatDuration(
// //                                                     positionData.position),
// //                                                 style: const TextStyle(
// //                                                   fontSize: 12,
// //                                                   color: Colors.grey,
// //                                                 ),
// //                                               ),
// //                                               Text(
// //                                                 _formatDuration(
// //                                                     positionData.duration),
// //                                                 style: const TextStyle(
// //                                                   fontSize: 12,
// //                                                   color: Colors.grey,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               );
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                   ],
// //                 ),
// //               ),
// //             ] else ...[
// //               const SizedBox(height: 24),
// //               Container(
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[100],
// //                   borderRadius: BorderRadius.circular(12),
// //                   border: Border.all(color: Colors.grey[300]!),
// //                 ),
// //                 child: const Row(
// //                   children: [
// //                     Icon(Icons.music_off, color: Colors.grey),
// //                     SizedBox(width: 8),
// //                     Text(
// //                       'Audio untuk lagu ini belum tersedia',
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.grey,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],

// //             // Lyrics section
// //             const SizedBox(height: 24),
// //             const Text(
// //               'Lirik:',
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               widget.song['lyrics'],
// //               style: const TextStyle(
// //                 fontSize: 16,
// //                 height: 1.5,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   String _formatDuration(Duration duration) {
// //     String twoDigits(int n) => n.toString().padLeft(2, '0');
// //     final minutes = twoDigits(duration.inMinutes.remainder(60));
// //     final seconds = twoDigits(duration.inSeconds.remainder(60));
// //     return '$minutes:$seconds';
// //   }
// // }

// // class PositionData {
// //   final Duration position;
// //   final Duration bufferedPosition;
// //   final Duration duration;

// //   PositionData({
// //     required this.position,
// //     required this.bufferedPosition,
// //     required this.duration,
// //   });
// // }
