import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_player/model/song.dart';
import '../model/song_repository.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key});

  @override
  _MyPlayerState createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyAudioPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.paused;
  Duration duration = Duration();
  Duration currentPosition = Duration();
  late Song currentSong;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });

    // Set the first song as the current song
    currentSong = SongRepository.songs.first;
  }

  @override
  void dispose() {
    super.dispose(); // Call the super class
    audioPlayer.dispose(); // Dispose the audio player
    audioPlayer.release(); // Release the audio player
  }

  Future<void> playMusic() async {
    await audioPlayer.play(UrlSource(currentSong.url));
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
  }

  void seekMusic(double value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.25,
              color: const Color.fromARGB(255, 201, 236, 127),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
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
                        playMusic();
                      });
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade900,
              ),
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Slider(
                    activeColor: const Color.fromARGB(255, 201, 236, 127),
                    inactiveColor: Colors.white,
                    value: currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: currentSong.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      seekMusic(value);
                    },
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
                            // Implement skip functionality
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
                            // Implement stop functionality
                            setState(() {
                              audioPlayer.stop();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            // Implement skip functionality
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
      ),
    );
  }
}
