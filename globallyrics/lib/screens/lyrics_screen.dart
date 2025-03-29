import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/song.dart';

class LyricsScreen extends StatefulWidget {
  final Song song;
  final String currentLanguage;

  const LyricsScreen({
    super.key,
    required this.song,
    required this.currentLanguage,
  });

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  String _lyrics = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLyrics();
  }

  Future<void> _loadLyrics() async {
    try {
      final String lyricsPath = widget.song.lyricsVersions[widget.currentLanguage]!;
      final String lyrics = await rootBundle.loadString('assets/$lyricsPath');
      setState(() {
        _lyrics = lyrics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lyrics = 'Lyrics not available';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.song.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.song.artist,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text(
                _lyrics,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
            ),
    );
  }
}