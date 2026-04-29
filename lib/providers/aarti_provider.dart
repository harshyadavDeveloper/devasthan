import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum PlayerState { idle, playing, paused }

class AartiTrack {
  final String id;
  final String title;
  final String deity;
  final String asset; // assets/audio/filename.mp3

  const AartiTrack({
    required this.id,
    required this.title,
    required this.deity,
    required this.asset,
  });
}

class AartiProvider extends ChangeNotifier {
  final _player = AudioPlayer();
  PlayerState _state = PlayerState.idle;
  AartiTrack? _current;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _repeat = false;

  PlayerState get state => _state;
  AartiTrack? get current => _current;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get repeat => _repeat;
  bool get isPlaying => _state == PlayerState.playing;

  double get progress {
    if (_duration.inSeconds == 0) return 0;
    return _position.inSeconds / _duration.inSeconds;
  }

  String get positionLabel => _format(_position);
  String get durationLabel => _format(_duration);

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Catalog ────────────────────────────────────────────────
  // Add your mp3 files to assets/audio/ and match names here
  // For now tracks are listed — just_audio wired in next step
  static const List<AartiTrack> catalog = [
    AartiTrack(
        id: 'ganesh_1',
        title: 'Jai Ganesh Jai Ganesh Deva',
        deity: 'Ganesha',
        asset: 'assets/audio/jai_ganesh.mp3'),
    AartiTrack(
        id: 'shiv_1',
        title: 'Om Jai Shiv Omkara',
        deity: 'Shiva',
        asset: 'assets/audio/om_jai_shiv.mp3'),
    AartiTrack(
        id: 'lakshmi_1',
        title: 'Om Jai Lakshmi Mata',
        deity: 'Lakshmi',
        asset: 'assets/audio/jai_lakshmi.mp3'),
    AartiTrack(
        id: 'hanuman_1',
        title: 'Jai Hanuman Gyan Gun Sagar',
        deity: 'Hanuman',
        asset: 'assets/audio/jai_hanuman.mp3'),
    AartiTrack(
        id: 'krishna_1',
        title: 'Achyutam Keshavam',
        deity: 'Krishna',
        asset: 'assets/audio/achyutam.mp3'),
    AartiTrack(
        id: 'durga_1',
        title: 'Jai Ambe Gauri',
        deity: 'Durga',
        asset: 'assets/audio/jai_ambe.mp3'),
    AartiTrack(
        id: 'saraswati_1',
        title: 'Jai Saraswati Mata',
        deity: 'Saraswati',
        asset: 'assets/audio/jai_saraswati.mp3'),
  ];

  AartiTrack get dailyTrack {
    final day = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return catalog[day % catalog.length];
  }

  // ── Controls ───────────────────────────────────────────────
  // TODO: replace simulation with just_audio calls below

  AartiProvider() {
    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    _player.durationStream.listen((dur) {
      if (dur != null) { _duration = dur; notifyListeners(); }
    });
    _player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        if (_repeat && _current != null) {
          _player.seek(Duration.zero);
          _player.play();
        } else {
          _state = PlayerState.idle;
          _position = Duration.zero;
          notifyListeners();
        }
      }
    });
  }

 
  Future<void> play(AartiTrack track) async {
    _current = track;
    _state = PlayerState.playing;
    notifyListeners();
    await _player.setAsset(track.asset);
    await _player.play();
  }

 Future<void> pause() async {
    await _player.pause();
    _state = PlayerState.paused;
    notifyListeners();
  }


  Future<void> resume() async {
    await _player.play();
    _state = PlayerState.playing;
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _state = PlayerState.idle;
    _current = null;
    _position = Duration.zero;
    notifyListeners();
  }

   void seekTo(double val) {
    _player.seek(Duration(seconds: (val * _duration.inSeconds).round()));
  }

   void toggleRepeat() {
    _repeat = !_repeat;
    notifyListeners();
  }

   @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }


  // Simulates playback tick — remove when just_audio is added
  

  // ── just_audio wiring (uncomment in Phase 4 final) ────────
  // import 'package:just_audio/just_audio.dart';
  // final _player = AudioPlayer();
  //
  // Future<void> play(AartiTrack track) async {
  //   _current = track;
  //   _state   = PlayerState.playing;
  //   notifyListeners();
  //   await _player.setAsset(track.asset);
  //   await _player.play();
  //   _player.positionStream.listen((pos) { _position = pos; notifyListeners(); });
  //   _player.durationStream.listen((dur) { if (dur != null) { _duration = dur; notifyListeners(); } });
  // }
  //
  // Future<void> pause()  async { await _player.pause();  _state = PlayerState.paused;  notifyListeners(); }
  // Future<void> resume() async { await _player.play();   _state = PlayerState.playing; notifyListeners(); }
  // Future<void> stop()   async { await _player.stop();   _state = PlayerState.idle;    _current = null; _position = Duration.zero; notifyListeners(); }
  // void seekTo(double val) async { await _player.seek(Duration(seconds: (val * _duration.inSeconds).round())); }
}
