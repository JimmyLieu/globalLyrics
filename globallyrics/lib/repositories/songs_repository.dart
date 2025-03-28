import '../models/song.dart';

class SongsRepository {
  final List<Song> songs = [
    Song(
      id: '1',
      title: 'Birds of a Feather',
      artist: 'Billie Eilish',
      audioVersions: {
        'English': 'songs/birds_of_feather/birds_off_a_feather_en.mp3',
        'Spanish': 'songs/birds_of_feather/birds_off_a_feather_es.mp3',
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