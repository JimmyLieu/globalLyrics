import 'package:flutter/material.dart';
import '../models/song.dart';
import '../repositories/songs_repository.dart';
import 'current_song_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: song.albumArt != null
                  ? Image.asset(song.albumArt!)
                  : const Icon(Icons.music_note),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🌐 ${song.audioVersions.length}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.more_vert),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrentSongScreen(song: song),
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