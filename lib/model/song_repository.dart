import 'song.dart';

class SongRepository {
  static final List<Song> songs = [
    Song(
      title: '2670',
      artist: "PAS DANS LE CUL AUJOURD'HUI",
      duration: const Duration(minutes: 4, seconds: 40),
      url:
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-164754.mp3',
    ),
    Song(
      title: '2671',
      artist: "PAS DANS LE CUL AUJOURD'HUI",
      duration: const Duration(minutes: 6, seconds: 42),
      url:
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-164755.mp3',
    ),
    Song(
      title: 'A Christmas adventure (Part 2)',
      artist: 'TRG Banks',
      duration: const Duration(minutes: 2, seconds: 39),
      url:
          'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-184032.mp3',
    ),
    Song(
        title: 'A Good Start',
        artist: 'Monplaisir',
        duration: const Duration(seconds: 54),
        url:
            'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-182157.mp3'),
    Song(
        title: 'A weird mechanism',
        artist: 'Monplaisir',
        duration: const Duration(minutes: 2, seconds: 36),
        url:
            'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/items/loc-fma/fma-162973.mp3'),
  ];
}
