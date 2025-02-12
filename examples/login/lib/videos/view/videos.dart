import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/videos/bloc/videos_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  VideoListScreenState createState() => VideoListScreenState();
}

class VideoListScreenState extends State<VideoListScreen> {
  late VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = null;
    context.read<VideoBloc>().add(LoadVideos());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _playVideo(String videoUrl) {
    if (_controller != null) {
      _controller?.dispose();
    }
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video List")),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoaded) {
            return Column(
              children: [
                if (state.selectedVideoUrl != null)
                  _controller != null && _controller!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                      : const Center(child: CircularProgressIndicator()),
                Expanded(
                  child: _buildVideoList(state.videos),
                ),
              ],
            );
          } else if (state is VideoError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildVideoList(
    List<String> videos,
  ) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Video ${index + 1}"),
          leading: const Icon(Icons.play_circle_fill, color: Colors.blue),
          onTap: () {
            context.read<VideoBloc>().add(PlayVideo(videos[index]));
            _playVideo(videos[index]);
          },
        );
      },
    );
  }
}
