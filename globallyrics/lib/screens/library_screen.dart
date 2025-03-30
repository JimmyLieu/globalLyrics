import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../repositories/songs_repository.dart';
import 'current_song_screen.dart';

class LibraryScreen extends StatelessWidget {
  final Function(Song, bool) onSongSelected;
  final AudioPlayer audioPlayer;

  const LibraryScreen({
    super.key,
    required this.onSongSelected,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final songsRepository = SongsRepository();
    final songs = songsRepository.getAllSongs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: song.albumArt != null
                    ? Image.asset(
                        song.albumArt!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
              ),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: Text(
              '🌐 ${song.audioVersions.length}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {
              onSongSelected(song, true);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrentSongScreen(
                    song: song,
                    audioPlayer: audioPlayer,
                    onPlayingChanged: (playing) => onSongSelected(song, playing),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add song functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}