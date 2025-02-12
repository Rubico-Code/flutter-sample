part of 'videos_bloc.dart';

abstract class VideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoaded extends VideoState {
  final List<String> videos;
  final String? selectedVideoUrl;

  VideoLoaded({required this.videos, this.selectedVideoUrl});

  VideoLoaded copyWith({String? selectedVideoUrl}) {
    return VideoLoaded(
      videos: videos,
      selectedVideoUrl: selectedVideoUrl ?? this.selectedVideoUrl,
    );
  }

  @override
  List<Object?> get props => [videos, selectedVideoUrl];
}

class VideoError extends VideoState {
  final String message;

  VideoError(this.message);

  @override
  List<Object?> get props => [message];
}
