import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_player/model/song.dart';
import '../model/song_repository.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key});

  @override
  State<MyAudioPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyAudioPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.paused;
  Duration currentPosition = const Duration();
  Duration currentDuration = const Duration();
  Song? currentSong;
  int? currentSongIndex;

  @override
  void initState() {
    super.initState();

    // Listen to the player state changes
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });

    // Listen to the position changes of the current song, used to update the slider
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });

    // Listen to the duration changes of the current song
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        currentDuration = duration;
      });
    });

    // Set the first song as the current song
    currentSong = SongRepository.songs.first;
    // currentSongIndex = 0;
  }

  @override
  void dispose() {
    print('dispose!');
    super.dispose(); // Call the super class
    audioPlayer.stop(); // Stop the audio player
    audioPlayer.dispose(); // Dispose the audio player
    audioPlayer.release(); // Release the audio player
  }

  Future<void> playMusic() async {
    //print('Duration: $currentDuration');
    currentSongIndex ??= 0; // used to trigger the tile selection color
    await audioPlayer.play(UrlSource(currentSong!.url));
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
  }

  Future<void> seekMusic(double value) async {
    await audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  Future<void> stopMusic() async {
    await audioPlayer.stop();
    currentPosition = const Duration();
  }

  void skipToNext() {
    if (currentSongIndex! < SongRepository.songs.length - 1) {
      setState(() {
        currentSong = SongRepository.songs[currentSongIndex! + 1];
        currentSongIndex = currentSongIndex! + 1;
        currentPosition = const Duration();
      });
      playMusic();
    }
  }

  void skipToPrevious() {
    if (currentSongIndex! > 0) {
      setState(() {
        currentSong = SongRepository.songs[currentSongIndex! - 1];
        currentSongIndex = currentSongIndex! - 1;
        currentPosition = const Duration();
      });
      playMusic();
    }
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
                    '${SongRepository.songs.length} songs',
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
              itemCount: SongRepository.songs.length,
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
                  title: Text(SongRepository.songs[index].title),
                  subtitle: Text(SongRepository.songs[index].artist),
                  onTap: () {
                    setState(() {
                      currentSong = SongRepository.songs[index];
                      currentPosition = const Duration();
                      currentSongIndex = index;
                      playMusic();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selected: currentSongIndex == index,
                  selectedTileColor: const Color.fromARGB(146, 234, 235, 232),
                  selectedColor: Colors.grey.shade900,
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.125,
            color: Colors.grey.shade900,
            child: Column(
              children: [
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
                    value: currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: currentDuration.inSeconds.toDouble(),
                    label: currentPosition
                        .toString() // 0:00:00.000000
                        .split('.') // [0:00:00, 000000]
                        .first // 0:00:00
                        .substring(2), // 00:00
                    onChanged: (value) {
                      seekMusic(value);
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
                          skipToPrevious();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                            playerState == PlayerState.playing
                                ? Icons.pause_circle
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40),
                        onPressed: () {
                          if (playerState == PlayerState.playing) {
                            pauseMusic();
                          } else {
                            playMusic();
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
                          stopMusic();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          skipToNext();
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
