import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';

class CurrentSongScreen extends StatefulWidget {
  final Song song;
  
  const CurrentSongScreen({
    super.key,
    required this.song,
  });

  @override
  State<CurrentSongScreen> createState() => _CurrentSongScreenState();
}

class _CurrentSongScreenState extends State<CurrentSongScreen> {
  late String currentLanguage;
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // This would store the available languages for the current song
  final List<String> availableLanguages = ['English', 'Spanish', ];

  @override
  void initState() {
    super.initState();
    currentLanguage = widget.song.audioVersions.keys.first;
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _setupAudioPlayer() async {
    try {
      await _audioPlayer.setSource(AssetSource(widget.song.audioVersions[currentLanguage]!));
      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      });
    } catch (e) {
      debugPrint('Error setting up audio player: $e');
    }
  }

  void switchLanguage(String language) async {
    setState(() {
      currentLanguage = language;
    });
    
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource(widget.song.audioVersions[language]!));
      if (isPlaying) {
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint('Error switching language: $e');
    }
  }

  void _togglePlayback() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint('Error toggling playback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album artwork
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: widget.song.albumArt != null
                ? Image.asset(widget.song.albumArt!)
                : const Icon(Icons.music_note, size: 100),
          ),
          const SizedBox(height: 30),
          // Song title
          Text(
            widget.song.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Artist name
          Text(
            widget.song.artist,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // Language selector
          DropdownButton<String>(
            value: currentLanguage,
            items: widget.song.audioVersions.keys.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                switchLanguage(newValue);
              }
            },
          ),
          const SizedBox(height: 30),
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 40),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 60,
                ),
                onPressed: _togglePlayback,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 40),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}