import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongDataController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  var hasPermission = false.obs;
  var allSongs = <SongModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkAndRequestPermissions();
  }

  Future<void> checkAndRequestPermissions() async {
    hasPermission.value = await _audioQuery.permissionsStatus();
    if (!hasPermission.value) {
      hasPermission.value = await _audioQuery.permissionsRequest();
    }

    if (hasPermission.value) {
      fetchSongs();
    } else {
      Get.snackbar(
        "Permission Denied",
        "Cannot fetch songs without storage permission.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchSongs() async {
    if (!hasPermission.value) return;

    try {
      final List<SongModel> songs = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      allSongs.value = songs.where((song) => song.isMusic ?? false).toList();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch songs: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  SongModel? getSongById(int id) {
    return allSongs.firstWhereOrNull((song) => song.id == id);
  }
}
