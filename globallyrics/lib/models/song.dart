class Song {
  final String id;
  final String title;
  final String artist;
  final Map<String, String> audioVersions; // language -> file path
  final Map<String, String> lyricsVersions;
  final String? albumArt;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioVersions,
    required this.lyricsVersions,
    this.albumArt,
  });
}