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
  int? _currentSongIndex = 0;
  Duration _currentPosition = Duration.zero;
  Duration _currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // _currentSong = Playlist.songs.children[0]; //
    _player.setAudioSource(Playlist.songs); // Set the audio source

    // Listen to player state changes
    _player.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        // _player.seekToNext();
        setState(() {
          _currentSongIndex = 0;
          //_currentPosition = Duration.zero;
        });
        await _player.seek(Duration.zero, index: _currentSongIndex);
        // if _player.stop(), just_audio will free resource from the web url,
        // generally has some buffered resources which can still be used, but it is safer to perform checks,even refetch data.
        if (_player.audioSource == null) {
          await _player.setAudioSource(Playlist.songs);
        }
        await _player.play();
      }
    });

    //Listen to current song index, index related to sequenceStateStream
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        setState(() {
          _currentSongIndex = index;
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              color: const Color.fromARGB(255, 201, 236, 127),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
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
                      //******* */
                      '${Playlist.songs.children.length} songs',
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
                //****** */
                itemCount: Playlist.songs.children.length,
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
                    title: Text(
                        (Playlist.songs.children[index] as UriAudioSource)
                            .tag
                            .title),
                    subtitle: Text(
                        (Playlist.songs.children[index] as UriAudioSource)
                            .tag
                            .artist),
                    onTap: () async {
                      setState(() {
                        _currentSongIndex = index;
                        //_currentPosition = Duration.zero;
                      });
                      // Seek to the beginning of the selected song
                      await _player.seek(Duration.zero, index: index);
                      if (_player.audioSource == null) {
                        await _player.setAudioSource(Playlist.songs);
                      }
                      await _player.play();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    selected: _currentSongIndex == index,
                    selectedTileColor: const Color.fromARGB(146, 231, 234, 229),
                    selectedColor: Colors.grey.shade900,
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.19,
              color: Colors.grey.shade900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _formatDuration(_currentPosition),
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
                      activeTrackColor:
                          const Color.fromARGB(255, 201, 236, 127),
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
                      label: _formatDuration(_currentPosition),
                      onChanged: (value) async {
                        await _player.seek(Duration(seconds: value.toInt()));
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
                          onPressed: () async {
                            _currentSongIndex = (_currentSongIndex! - 1) %
                                (Playlist.songs.children.length);
                            await _player.seek(Duration.zero,
                                index: _currentSongIndex);
                            if (_player.audioSource == null) {
                              await _player.setAudioSource(Playlist.songs);
                            }
                            await _player.play();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                              _player.playing
                                  ? Icons.pause_circle
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 40),
                          onPressed: () async {
                            if (_player.playing) {
                              await _player.pause();
                            } else {
                              if (_player.audioSource == null) {
                                await _player.setAudioSource(Playlist.songs);
                              }
                              await _player.play();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.stop,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () async {
                            await _player.stop();
                            await _player.seek(Duration.zero);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () async {
                            //next related to the loopMode
                            // _player.hasNext ? await _player.seekToNext() : null;
                            _currentSongIndex = (_currentSongIndex! + 1) %
                                (Playlist.songs.children.length);
                            await _player.seek(Duration.zero,
                                index: _currentSongIndex);
                            if (_player.audioSource == null) {
                              await _player.setAudioSource(Playlist.songs);
                            }
                            await _player.play();
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
