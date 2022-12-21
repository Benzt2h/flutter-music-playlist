import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _player = AudioPlayer();
  final List _musicList = [
    {"name": "ยังคงคอย", "art": "NONT TANONT", "file": "hers"},
    {"name": "ร8 (W8)", "art": "Oil Kunjira", "file": "w8"},
    {"name": "คำถาม [My Question]", "art": "UrboyTJ", "file": "question"},
    {"name": "จันทร์เจ้า", "art": "TORWAI", "file": "slot"},
  ];
  int _indexSong = -1;
  bool _isPlay = false;

  _setSong(int index) async {
    if (index != _indexSong) {
      if (_player.playing) {
        _player.pause();
        setState(() {
          _isPlay = false;
        });
      }
      await _player.setAudioSource(
          AudioSource.uri(
              Uri.parse('asset:///assets/${_musicList[index]['file']}.mp3')),
          initialPosition: Duration.zero,
          preload: true);
      _player.play();
      setState(() {
        _indexSong = index;
        _isPlay = true;
      });
    }
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "My Playlist",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _musicList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _setSong(index);
                    },
                    child: Card(
                      child: SizedBox(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                  "assets/${_musicList[index]['file']}.jpg"),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _musicList[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _musicList[index]['art'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _indexSong == -1
                ? Container()
                : StreamBuilder<Object>(
                    stream: _player.positionStream,
                    builder: (context, snapshot) {
                      return ProgressBar(
                        progress: _player.position,
                        total: _player.duration ?? Duration.zero,
                        progressBarColor: Colors.blue,
                        baseBarColor: Colors.white.withOpacity(0.5),
                        thumbColor: Colors.white,
                        barHeight: 3.0,
                        thumbRadius: 5.0,
                        onSeek: (duration) {
                          _player.seek(duration);
                        },
                      );
                    }),
            _indexSong == -1
                ? Container()
                : Container(
                    height: 100,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                    "assets/${_musicList[_indexSong]['file']}.jpg"),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _musicList[_indexSong]['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      _musicList[_indexSong]['art'],
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: !_isPlay
                              ? IconButton(
                                  onPressed: () {
                                    _player.play();
                                    setState(() {
                                      _isPlay = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 50,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    _player.pause();

                                    setState(() {
                                      _isPlay = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.pause,
                                    size: 50,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
