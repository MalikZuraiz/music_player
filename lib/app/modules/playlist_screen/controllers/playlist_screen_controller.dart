import 'package:get/get.dart';
import 'package:music_player/app/service/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistScreenController extends GetxController {
  final songDataController = Get.find<SongDataController>();
  final playlist = Get.arguments[0];
  final RxList<SongModel> songs = <SongModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize songs
    updateSongs();
    // Listen to changes in the playlist
    ever(songDataController.playlists, (_) => updateSongs());
  }

  void updateSongs() {
    songs.value = songDataController.getPlaylistSongs(playlist.id);
  }

  String formatDuration(int milliseconds) {
    if (milliseconds <= 0) return "00:00";
    final int seconds = (milliseconds / 1000).floor();
    final int minutes = (seconds / 60).floor();
    final int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  Future<void> removeSongFromPlaylist(int songId) async {
    await songDataController.removeSongFromPlaylist(playlist.id, songId);
    updateSongs();
    // Update UI immediately
    songs.refresh();
  }

  Future<void> deletePlaylist() async {
    await songDataController.deletePlaylist(playlist.id);
    Get.back();
  }

  void onSongTap(int index) {
    if (index < 0 || index >= songs.length) return;
    
    Get.toNamed(
      '/player-screen',
      arguments: {
        'allSongs': songs.toList(),
        'id': index,
      },
    );
  }
}