import 'package:flutter/material.dart';
import 'screens/current_song_screen.dart';
import 'screens/library_screen.dart';
import 'models/song.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Lyrics',
      theme: ThemeData.dark(),
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
  Song? selectedSong;

  List<Widget> get _screens => [
    const LibraryScreen(),
    if (selectedSong != null) CurrentSongScreen(song: selectedSong!),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1 && selectedSong == null) {
            // Don't navigate to Now Playing if no song is selected
            return;
          }
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
    );
  }
}