import 'package:get/get.dart';
import 'package:music_player/app/service/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreenController extends GetxController {
  final SongDataController songDataController = Get.put(SongDataController());
  var searchResults = <SongModel>[].obs; // Reactive search results list

  @override
  void onInit() {
    super.onInit();
    searchResults.value = songDataController.allSongs; // Initialize with all songs
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = songDataController.allSongs; // Reset to all songs
    } else {
      searchResults.value = songDataController.allSongs
          .where((song) => song.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void onPlaylistTap(String playlistId) {
    Get.toNamed('/playlist-screen');
    print('Playlist tapped: $playlistId');
  }

  void onSongTap(SongModel song) {
    Get.toNamed('/player-screen', arguments: song);
    print('Song tapped: ${song.title}');
  }

  void onCategoryTap(String categoryId) {
    print('Category tapped: $categoryId');
  }
}
