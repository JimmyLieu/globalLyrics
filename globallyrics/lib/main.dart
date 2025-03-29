import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'screens/current_song_screen.dart';
import 'screens/library_screen.dart';
import 'models/song.dart';
import 'widgets/mini_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Lyrics',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.black87,
          secondary: Colors.deepOrange,
          background: Colors.white,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.black87),
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      home: const MainNavigator(),
    );
  }
}

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
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          LibraryScreen(
            onSongSelected: updateCurrentSong,
            audioPlayer: _audioPlayer,
          ),
          if (currentSong != null)
            CurrentSongScreen(
              song: currentSong!,
              audioPlayer: _audioPlayer,
              onPlayingChanged: (playing) {
                setState(() {
                  isPlaying = playing;
                });
              },
            ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentSong != null && _selectedIndex == 0)
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
            ],
          ),
        ],
      ),
    );
  }
}