import 'package:get/get.dart';

class PlayerScreenController extends GetxController {
  final isPlaying = false.obs;
  final currentPosition = 0.0.obs;
  final totalDuration = 218.0.obs; // 3:58 in seconds

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    // Implement your play/pause logic
  }

  void seekTo(double position) {
    currentPosition.value = position;
    // Implement your seek logic
  }

  void previousTrack() {
    // Implement previous track logic
  }

  void nextTrack() {
    // Implement next track logic
  }
}