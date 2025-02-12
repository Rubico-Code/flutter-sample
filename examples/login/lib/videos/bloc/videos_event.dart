part of 'videos_bloc.dart';

abstract class VideoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVideos extends VideoEvent {}

class PlayVideo extends VideoEvent {
  final String videoUrl;

  PlayVideo(this.videoUrl);

  @override
  List<Object> get props => [videoUrl];
}
