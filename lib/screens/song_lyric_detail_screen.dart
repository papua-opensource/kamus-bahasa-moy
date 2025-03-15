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
    }
  }

  void _initAudioPlayer() {
    if (widget.song['hasAudio'] == true && widget.song['audioUrl'] != null) {
      _audioPlayer = AudioPlayer();
      _loadAudio();
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
      await _audioPlayer!.setUrl(widget.song['audioUrl']);
      setState(() {
        _isLoadingAudio = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingAudio = false;
        _hasError = true;
        _errorMessage = 'Gagal memuat audio: ${e.toString()}';
      });
    }
  }

  void _playPause() {
    if (_audioPlayer == null) return;

    if (_isPlaying) {
      _audioPlayer!.pause();
    } else {
      _audioPlayer!.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
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
                  widget.song['artist'] != null
                      ? 'Pengarang: ${widget.song['artist']}'
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
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
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
