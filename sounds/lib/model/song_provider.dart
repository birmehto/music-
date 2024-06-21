import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'songs_model.dart';

class SongProvider extends ChangeNotifier {
  final List<SongModel> _playList = [
    SongModel(
      songName: 'Daaku',
      artistName: 'Badshah',
      imagePath: 'assets/image/daaku.jpg',
      audioPath: 'audio/Daaku.mp3',
    ),
    SongModel(
      songName: 'Hass Hass',
      artistName: 'Diljit Dosanjh',
      imagePath: 'assets/image/hass-hass.jpg',
      audioPath: 'audio/HassHass.mp3',
    ),
    SongModel(
      songName: 'Moye Moye',
      artistName: 'Teya Dora',
      imagePath: 'assets/image/moye-moye.jpg',
      audioPath: 'audio/MoyeMoye.mp3',
    ),
    SongModel(
      songName: 'O Sajna',
      artistName: 'Badshah',
      imagePath: 'assets/image/osajna.jpg',
      audioPath: 'audio/OSajna.mp3',
    ),
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  int? _currentSongIndex;

  SongProvider() {
    _audioPlayer.onPlayerStateChanged.listen((playerState) {
      _isPlaying = playerState == PlayerState.playing;
      notifyListeners();
    });
    listenToDuration();
  }

  void play() async {
    if (_currentSongIndex != null) {
      final String pathSong = _playList[_currentSongIndex!].audioPath;
      log('Attempting to play: $pathSong');
      await _audioPlayer.stop();
      try {
        await _audioPlayer.play(AssetSource(pathSong));
      } catch (e) {
        log('Error playing audio: $e');
      }
      _isPlaying = true;
      notifyListeners();
    }
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void playOrPause() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void playNext() {
    if (_currentSongIndex != null &&
        _currentSongIndex! < _playList.length - 1) {
      _currentSongIndex = _currentSongIndex! + 1;
    } else {
      _currentSongIndex = 0;
    }
    play();
  }

  void playPrevious() {
    if (_currentSongIndex != null && _currentDuration.inSeconds < 2) {
      seek(Duration.zero);
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        _currentSongIndex = _playList.length - 1;
      }
      play();
    } else {
      seek(Duration.zero);
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });
  }

  List<SongModel> get playList => _playList;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get totalDuration => _totalDuration;
  Duration get currentDuration => _currentDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
