import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class Playlist {
  static final List<UriAudioSource> songs = [
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-164754.mp3'),
      tag: MediaItem(
        id: '0',
        title: '2670',
        artist: "PAS DANS LE CUL AUJOURD'HUI",
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-164755.mp3'),
      tag: MediaItem(
        id: '1',
        title: '2671',
        artist: "PAS DANS LE CUL AUJOURD'HUI",
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-184032.mp3'),
      tag: MediaItem(
        id: '2',
        title: 'A Christmas adventure (Part 2)',
        artist: 'TRG Banks',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-182157.mp3'),
      tag: MediaItem(
        id: '3',
        title: 'A Good Start',
        artist: 'Monplaisir',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-162973.mp3'),
      tag: MediaItem(
        id: '4',
        title: 'A weird mechanism',
        artist: 'Monplaisir',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-155584.mp3'),
      tag: MediaItem(
        id: '5',
        title: 'Action Decisive Move',
        artist: 'Komiku',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-174838.mp3'),
      tag: MediaItem(
        id: '6',
        title: 'Adventures with Paddy',
        artist: 'TRG Banks',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-140809.mp3'),
      tag: MediaItem(
        id: 'Aimer les fourmis',
        title: 'Aimer les fourmis',
        artist: 'Monplaisir',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-116584.mp3'),
      tag: MediaItem(
        id: '7',
        title: 'Allegro Can Bro (Beethoven Symphony No.5)',
        artist: 'Mons J',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-155586.mp3'),
      tag: MediaItem(
        id: '8',
        title: 'Ambiant Point Of No Return',
        artist: 'Komiku',
      ),
    ),
  ];
}
