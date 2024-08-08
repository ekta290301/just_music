import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAudioPlayer extends StatefulWidget {
  @override
  _MyAudioPlayerState createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentAudio;
  bool _isSoundEnabled = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
    _player.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String audioFile) async {
    if (!_isSoundEnabled) return;

    try {
      await _player.setSource(AssetSource(audioFile));
      await _player.resume();
      setState(() {
        _isPlaying = true;
        _currentAudio = audioFile;
      });
      print('Playback started: $audioFile');
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _player.pause();
      setState(() {
        _isPlaying = false;
      });
      print('Playback paused');
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _player.stop();
      setState(() {
        _isPlaying = false;
        _currentAudio = null;
      });
      print('Playback stopped');
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final Map<LogicalKeyboardKey, String> keyToSound = {
        LogicalKeyboardKey.keyZ: 'note1.wav',
        LogicalKeyboardKey.keyX: 'note2.wav',
        LogicalKeyboardKey.keyC: 'note3.wav',
        LogicalKeyboardKey.keyV: 'note4.wav',
        LogicalKeyboardKey.keyB: 'note5.wav',
        LogicalKeyboardKey.keyN: 'note6.wav',
        LogicalKeyboardKey.keyM: 'note7.wav',
        LogicalKeyboardKey.digit1: 'note1.wav',
        LogicalKeyboardKey.digit2: 'note2.wav',
        LogicalKeyboardKey.digit3: 'note3.wav',
        LogicalKeyboardKey.digit4: 'note4.wav',
        LogicalKeyboardKey.digit5: 'note5.wav',
        LogicalKeyboardKey.digit6: 'note6.wav',
        LogicalKeyboardKey.digit7: 'note7.wav',
        LogicalKeyboardKey.space: _isPlaying ? 'pause' : 'play', // Handle spacebar key
      };

      if (event.logicalKey == LogicalKeyboardKey.space) {
        if (_isPlaying) {
          _pauseAudio(); // Pause if currently playing
        } else {
          _stopAudio(); // Stop if currently not playing
        }
      } else if (keyToSound.containsKey(event.logicalKey)) {
        _playAudio(keyToSound[event.logicalKey]!);
      } else {
        _playAudio('ringtone.mp3'); 
      }
    }
  }

  Widget _buildSoundButton(String audioFile, String label) {
    return ElevatedButton(
      onPressed: !_isSoundEnabled || _isPlaying ? null : () => _playAudio(audioFile),
      child: Text(label, style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final soundButtons = [
      _buildSoundButton('note1.wav', 'Sound 1'),
      _buildSoundButton('note2.wav', 'Sound 2'),
      _buildSoundButton('note3.wav', 'Sound 3'),
      _buildSoundButton('note4.wav', 'Sound 4'),
      _buildSoundButton('note5.wav', 'Sound 5'),
      _buildSoundButton('note6.wav', 'Sound 6'),
      _buildSoundButton('note7.wav', 'Sound 7'),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Musical Keyboard"),
          backgroundColor: Colors.deepPurple,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Switch(
                value: _isSoundEnabled,
                onChanged: (value) {
                  setState(() {
                    _isSoundEnabled = value;
                    // Optional: Pause the audio if sound is disabled
                    if (!_isSoundEnabled && _isPlaying) {
                      _pauseAudio();
                    }
                  });
                },
                activeColor: Colors.white,
              ),
            ),
          ],
        ),
        body: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: _handleKey,
          autofocus: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey[300],
                              ),
                              child: Center(
                                child: Image.asset("Music_logo.png",height: 20,width: 50,),
                              ),
                            ),
                            if (_currentAudio != null)
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Container(
                                  color: Colors.white70,
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    'Playing: ${_currentAudio!.replaceFirst('.wav', '')}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slider(
                          value: _currentPosition.inSeconds.toDouble(),
                          max: _totalDuration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _player.seek(Duration(seconds: value.toInt()));
                          },
                          activeColor: Colors.deepPurple,
                          inactiveColor: Colors.deepPurple.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_currentPosition),
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            Text(
                              _formatDuration(_totalDuration),
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.skip_previous,
                                  color: Colors.deepPurple),
                              onPressed: () {
                                // Implement previous track logic
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.deepPurple),
                              onPressed: _isPlaying
                                  ? _pauseAudio
                                  : () => _playAudio(
                                      'note1.wav'), // Change to your logic
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next,
                                  color: Colors.deepPurple),
                              onPressed: () {
                                // Implement next track logic
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: soundButtons.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: soundButtons[index],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

void main() {
  runApp(MyAudioPlayer());
}
