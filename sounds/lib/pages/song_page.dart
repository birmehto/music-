import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sounds/model/song_provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Songs'),
      ),
      body: Consumer<SongProvider>(
        builder: (context, value, _) {
          final playlist = value.playList;
          final currentIndex = value.currentSongIndex ?? 0;

          if (playlist.isEmpty) {
            return const Center(child: Text('No songs available.'));
          }

          final currentSong = playlist[currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Song Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ClipOval(
                      child: Image.asset(
                        currentSong.imagePath,
                        width: 400, // Adjust the width as needed
                        height: 400, // Adjust the height as needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Song Title and Artist
                Text(
                  currentSong.songName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  currentSong.artistName,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(value.currentDuration)),
                    Text(_formatDuration(value.totalDuration)),
                  ],
                ),
                const SizedBox(height: 10),
                // Slider
                Slider(
                  min: 0,
                  value: value.currentDuration.inSeconds.toDouble(),
                  max: value.totalDuration.inSeconds.toDouble() > 0
                      ? value.totalDuration.inSeconds.toDouble()
                      : 1.0,
                  activeColor: Colors.green.shade400,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (double newValue) {
                    setState(() {});
                  },
                  onChangeEnd: (double newValue) {
                    value.seek(Duration(seconds: newValue.toInt()));
                  },
                ),
                const SizedBox(height: 20),
                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        value.playPrevious();
                      },
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 40,
                    ),
                    IconButton(
                      onPressed: () {
                        value.playOrPause();
                      },
                      icon: Icon(
                        value.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                      ),
                      iconSize: 60,
                    ),
                    IconButton(
                      onPressed: () {
                        value.playNext();
                      },
                      icon: const Icon(Icons.skip_next),
                      iconSize: 40,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
