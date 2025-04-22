import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:globallyrics/models/song.dart';
import 'package:globallyrics/screens/current_song_screen.dart';
import 'package:globallyrics/screens/library_screen.dart';
import 'package:globallyrics/widgets/mini_player.dart';
import 'package:globallyrics/repositories/songs_repository.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  Song? currentSong;
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SongsRepository _songsRepository = SongsRepository();
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void updateCurrentSong(Song song, bool playing) {
    setState(() {
      currentSong = song;
      isPlaying = playing;
    });
  }

  void togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    if (_selectedIndex == 0) {
      currentScreen = LibraryScreen(
        onSongSelected: updateCurrentSong,
        audioPlayer: _audioPlayer,
      );
    } else if (_selectedIndex == 1 && currentSong != null) {
      currentScreen = CurrentSongScreen(
        song: currentSong!,
        audioPlayer: _audioPlayer,
        allSongs: _songsRepository.getAllSongs(),
        onSongChanged: (newSong) => updateCurrentSong(newSong, true),
        onPlayingChanged: (playing) {
          setState(() {
            isPlaying = playing;
          });
        },
      );
    } else {
      // Profile screen
      currentScreen = Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jimmy Lieu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.music_note, color: Colors.deepOrange),
              title: const Text('My Songs'),
              trailing: const Text('23'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.deepOrange),
              title: const Text('Liked Songs'),
              trailing: const Text('12'),
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.deepOrange),
              title: const Text('Languages'),
              trailing: const Text('English, Spanish'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentSong != null && _selectedIndex != 1)
            MiniPlayer(
              song: currentSong!,
              isPlaying: isPlaying,
              onPlayPause: togglePlayPause,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'Now Playing',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}