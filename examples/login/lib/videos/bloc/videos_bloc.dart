import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'videos_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc(this._authenticationRepository)
      : super(VideoInitial()) {
    on<LoadVideos>(_onLoadVideos);
    on<PlayVideo>(_onPlayVideo);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onLoadVideos(LoadVideos event, Emitter<VideoState> emit) async {
    try {
      final response = await _authenticationRepository.fetchVideoslist();
      //handle response
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final videos = List<String>.from(response.data['videos'] ?? []);
        emit(VideoLoaded(videos: videos, selectedVideoUrl: null));
      } else {
        emit(VideoError("Invalid response format"));
      }
    } catch (e) {
      emit(VideoError("Error fetching videos: ${e.toString()}"));
    }
  }

  void _onPlayVideo(PlayVideo event, Emitter<VideoState> emit) {
    if (state is VideoLoaded) {
      final currentState = state as VideoLoaded;
      emit(currentState.copyWith(selectedVideoUrl: event.videoUrl));
    }
  }
}
