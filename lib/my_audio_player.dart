import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'playlist.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key});

  @override
  State<MyAudioPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  late UriAudioSource _currentSong;
  int? _currentSongIndex;
  //PlayerState _currentState = PlayerState(false, ProcessingState.idle);
  Duration _currentPosition = Duration.zero;
  Duration _currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentSong = Playlist.songs.first; // Set the current song
    _player.setAudioSource(_currentSong); // Set the audio source

    // Listen to player state changes
    _player.playerStateStream.listen((playerState) {
      // When the current song is completed, stop the audio, and reset the current position
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          _onStop();
        });
      }
    });

    // Listen to player position changes
    _player.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Listen to player duration changes
    _player.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _currentDuration = duration; // Duration is non-nullable
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose(); // Dispose the player
    super.dispose();
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _setSource() async {
    await _player.setAudioSource(_currentSong);
  }

  void _onPlay() async {
    _currentSongIndex ??= 0; // Set the current song index if null
    await _player.play(); // Play the audio
  }

  void _onPause() async {
    if (_player.playing) {
      await _player.pause();
    }
  }

  void _onSeek(double value) async {
    await _player.seek(Duration(seconds: value.toInt()));
  }

  void _onStop() async {
    await _player.stop(); // stop the audio but current position is not reset
    _onSeek(0); // reset the current position
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
            color: const Color.fromARGB(255, 201, 236, 127),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.125,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'My Playlist',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    '${Playlist.songs.length} songs',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: Playlist.songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  titleTextStyle: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitleTextStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  title: Text(Playlist.songs[index].tag.title),
                  subtitle: Text(Playlist.songs[index].tag.artist),
                  onTap: () {
                    setState(() {
                      _currentSong = Playlist.songs[index];
                      _setSource();
                      _currentSongIndex = index;
                      _onPlay();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selected: _currentSongIndex == index,
                  selectedTileColor: const Color.fromARGB(146, 234, 235, 232),
                  selectedColor: Colors.grey.shade900,
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.15,
            color: Colors.grey.shade900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  formatDuration(_currentPosition),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 5,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 8),
                    thumbColor: const Color.fromARGB(255, 201, 236, 127),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 20),
                    overlayColor: const Color.fromARGB(100, 201, 236, 127),
                    activeTrackColor: const Color.fromARGB(255, 201, 236, 127),
                    inactiveTrackColor: Colors.white,
                    tickMarkShape: const RoundSliderTickMarkShape(),
                    showValueIndicator: ShowValueIndicator.always,
                    valueIndicatorShape:
                        const PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor:
                        const Color.fromARGB(255, 201, 236, 127),
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                  ),
                  child: Slider(
                    value: _currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: _currentDuration.inSeconds.toDouble(),
                    label: _currentPosition
                        .toString() // 0:00:00.000000
                        .split('.') // [0:00:00, 000000]
                        .first // 0:00:00
                        .substring(2), // 00:00
                    onChanged: (value) {
                      _onSeek(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          //skipToPrevious();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                            _player.playing
                                ? Icons.pause_circle
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40),
                        onPressed: () {
                          if (_player.playing) {
                            _onPause();
                          } else {
                            _onPlay();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          _onStop();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          //skipToNext();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
