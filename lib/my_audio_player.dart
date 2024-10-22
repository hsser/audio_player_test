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
  Duration position = Duration();
  late Song currentSong;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      playerState == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_arrow_rounded,
                    ),
                    onPressed: () {
                      playerState == PlayerState.playing
                          ? pauseMusic()
                          : playMusic();
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pauseMusic();
                    },
                    child: const Text('Pause'),
                  ),
                ])));
  }
}
