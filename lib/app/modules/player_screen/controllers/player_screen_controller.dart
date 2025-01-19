import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/app/service/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreenController extends GetxController {
  final SongDataController songDataController = Get.find<SongDataController>();
  final player = AudioPlayer();
  final allSongs = Get.arguments['allSongs'];
  final isPlaying = false.obs;
  final currentPosition = 0.0.obs;
  final totalDuration = 0.0.obs;
  Rx<int> songIndex = (Get.arguments['id'] as int).obs;

  @override
  void onInit() {
    super.onInit();
    _loadSong();
  }

  Future<void> _loadSong() async {
    final currentSong = allSongs[songIndex.value];
    await player.setAudioSource(
      AudioSource.uri(Uri.parse(currentSong.uri!)),
      initialIndex: songIndex.value,
    );
    totalDuration.value = player.duration?.inSeconds.toDouble() ?? 0.0;
    player.play();
    isPlaying.value = true;

    player.positionStream.listen((position) {
      currentPosition.value = position.inSeconds.toDouble();
    });

    player.durationStream.listen((duration) {
      totalDuration.value = duration?.inSeconds.toDouble() ?? 0.0;
    });
  }

  void togglePlay() {
    if (isPlaying.value) {
      player.pause();
      isPlaying.value = false;
    } else {
      player.play();
      isPlaying.value = true;
    }
  }

  void toggleFavorite() {
    final currentSong = allSongs[songIndex.value];
    songDataController.toggleFavorite(currentSong.id);
  }

  bool isFavorite() {
    final currentSong = allSongs[songIndex.value];
    return songDataController.isFavorite(currentSong.id);
  }

  void seekTo(double position) {
    player.seek(Duration(seconds: position.round()));
    currentPosition.value = position;
  }

  void previousTrack() {
    if (songIndex.value > 0) {
      songIndex.value--;
      _loadSong();
    }
  }

  void nextTrack() {
    if (songIndex.value < allSongs.length - 1) {
      songIndex.value++;
      _loadSong();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}