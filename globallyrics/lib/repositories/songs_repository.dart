import '../models/song.dart';

class SongsRepository {
  final List<Song> songs = [
    Song(
      id: '1',
      title: 'Birds of a Feather',
      artist: 'Billie Eilish',
      audioVersions: {
        'English': 'songs/birds_of_a_feather/birds_of_a_feather_en.mp3',
        'Spanish': 'songs/birds_of_a_feather/birds_of_a_feather_es.mp3',
      },
      lyricsVersions: {
        'English': 'songs/birds_of_a_feather/birds_of_a_feather_en.txt',
        'Spanish': 'songs/birds_of_a_feather/birds_of_a_feather_es.txt',
      },
    ),
  ];

  List<Song> getAllSongs() => songs;
  
  Song? getSongById(String id) {
    try {
      return songs.firstWhere((song) => song.id == id);
    } catch (e) {
      return null;
    }
  }
}