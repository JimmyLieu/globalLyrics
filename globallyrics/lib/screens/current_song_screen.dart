import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import 'lyrics_screen.dart';
import 'package:flutter/services.dart' show rootBundle;

class CurrentSongScreen extends StatefulWidget {
  final Song song;
  final Function(bool)? onPlayingChanged;
  
  const CurrentSongScreen({
    super.key,
    required this.song,
    this.onPlayingChanged,
  });

  @override
  State<CurrentSongScreen> createState() => _CurrentSongScreenState();
}

class _CurrentSongScreenState extends State<CurrentSongScreen> {
  late String currentLanguage;
  bool isPlaying = false;
  bool isLiked = false;
  bool isShuffleOn = false;
  bool isRepeatOn = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  
  // This would store the available languages for the current song
  final List<String> availableLanguages = ['English', 'Spanish', ];

  @override
  void initState() {
    super.initState();
    currentLanguage = widget.song.audioVersions.keys.first;
    _setupAudioPlayer();
    // TODO: Load liked state from persistent storage
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _setupAudioPlayer() async {
    try {
      await _audioPlayer.setSource(AssetSource(widget.song.audioVersions[currentLanguage]!));
      
      // Listen to duration changes
      _audioPlayer.onDurationChanged.listen((Duration d) {
        setState(() => _duration = d);
      });

      // Listen to position changes
      _audioPlayer.onPositionChanged.listen((Duration p) {
        setState(() => _position = p);
      });

      // Listen to player state changes
      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
        widget.onPlayingChanged?.call(state == PlayerState.playing);
      });

      // Auto-play the song
      await _audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      debugPrint('Error setting up audio player: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
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

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    // TODO: Save liked state to persistent storage
  }

  void _toggleShuffle() {
    setState(() {
      isShuffleOn = !isShuffleOn;
    });
    // TODO: Implement shuffle logic with AudioPlayer
  }

  void _toggleRepeat() async {
    setState(() {
      isRepeatOn = !isRepeatOn;
    });
    await _audioPlayer.setReleaseMode(
      isRepeatOn ? ReleaseMode.loop : ReleaseMode.release
    );
  }

  void _showLyrics() async {
    final lyrics = await rootBundle.loadString('assets/${widget.song.lyricsVersions[currentLanguage]!}');
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet expandable
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7, // Takes up 70% of screen initially
        minChildSize: 0.2, // Can be collapsed to 20%
        maxChildSize: 0.95, // Can expand to 95%
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title and artist
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  Text(
                    widget.song.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.song.artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Lyrics
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Text(
                  lyrics,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Now playing'),
        actions: [
          // Language switcher
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Container(
              height: 32,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.song.audioVersions.keys.map((lang) {
                  final isSelected = lang == currentLanguage;
                  return GestureDetector(
                    onTap: () => switchLanguage(lang),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black87 : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          lang.substring(0, 2).toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          // Album artwork with rounded corners
          Container(
            width: 340,
            height: 340,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: widget.song.albumArt != null
                  ? Image.asset(widget.song.albumArt!, fit: BoxFit.cover)
                  : Container(color: Colors.grey[200]),
            ),
          ),
          const SizedBox(height: 32),
          // Song title and artist
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.song.artist,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.deepOrange : Colors.black54,
                  ),
                  onPressed: _toggleLike,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: Colors.black87,
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: Colors.black87,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inMilliseconds.toDouble(),
                    value: _position.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      final position = Duration(milliseconds: value.round());
                      _audioPlayer.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position),
                          style: TextStyle(color: Colors.grey[600])),
                      Text(_formatDuration(_duration),
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shuffle,
                  color: isShuffleOn ? Colors.deepOrange : Colors.black54,
                ),
                onPressed: _toggleShuffle,
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () {},
                iconSize: 36,
                color: Colors.black87,
              ),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayback,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () {},
                iconSize: 36,
                color: Colors.black87,
              ),
              IconButton(
                icon: Icon(
                  Icons.repeat,
                  color: isRepeatOn ? Colors.deepOrange : Colors.black54,
                ),
                onPressed: _toggleRepeat,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Lyrics button at bottom
          TextButton(
            onPressed: _showLyrics,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lyrics, size: 20, color: Colors.black87),
                const SizedBox(width: 8),
                const Text(
                  'Lyrics',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}