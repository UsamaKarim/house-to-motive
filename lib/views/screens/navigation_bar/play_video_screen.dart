import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideoScreen extends StatefulWidget {
  final List<String> videoUrls;

  const PlayVideoScreen({super.key, required this.videoUrls});

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  late PageController _pageController;
  late List<VideoPlayerController> _videoControllers;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _videoControllers =
        widget.videoUrls
            .map((url) => VideoPlayerController.network(url))
            .toList();
    _initializePlayers();
  }

  Future<void> _initializePlayers() async {
    await Future.wait(
      _videoControllers.map((controller) async {
        await controller.initialize();
        controller.setLooping(true); // Optional: Loop the videos
      }),
    );
    setState(() {});
    _videoControllers[_currentPage].play(); // Play the first video
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    _videoControllers[_currentPage].pause(); // Pause the current video
    _currentPage = index;

    // Ensure the next video is initialized before playing
    if (_videoControllers[index].value.isInitialized) {
      _videoControllers[index].play(); // Play the new video
    } else {
      _videoControllers[index].initialize().then((_) {
        setState(() {});
        _videoControllers[index].play(); // Play after initialization
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.videoUrls.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child:
                    _videoControllers[index].value.isInitialized
                        ? AspectRatio(
                          aspectRatio:
                              _videoControllers[index].value.aspectRatio,
                          child: VideoPlayer(_videoControllers[index]),
                        )
                        : const Center(child: CircularProgressIndicator()),
              ),
              VideoControls(controller: _videoControllers[index]),
            ],
          );
        },
      ),
    );
  }
}

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            if (controller.value.isInitialized) {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            }
          },
        ),
      ],
    );
  }
}
