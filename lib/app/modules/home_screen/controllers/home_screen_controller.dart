import 'dart:developer';

import 'package:get/get.dart';
import 'package:music_player/app/service/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenController extends GetxController {
  final SongDataController songDataController = Get.put(SongDataController());
  var searchResults = <SongModel>[].obs; // Reactive search results list
  var favoritesongs = <SongModel>[].obs; // Reactive list of favorite songs
  RxList<int> favoriteIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchResults.value = songDataController.allSongs; // Initialize with all songs
    _loadFavoriteSongs(); // Load favorite songs from SharedPreferences
  }

  // Load the favorite songs from SharedPreferences
  Future<void> _loadFavoriteSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritesList = prefs.getStringList('favorites');
    if (favoritesList != null) {
      favoriteIds.value = favoritesList
          .map((e) => int.parse(e))
          .toList(); // Convert the string list back to integers
      log("Favorite Songs Loaded: $favoriteIds  and all songs ${songDataController.allSongs.length} and search results ${searchResults.value.length}");

      // Now, filter the allSongs list based on the favoriteIds
      favoritesongs.value = songDataController.allSongs
          .where((song) => favoriteIds.contains(song.id))
          .toList(); // Filter songs that are in the favoriteIds list
      log("Favorite Songs List: ${favoritesongs.length}");
    }
  }

  // Function to convert duration in milliseconds to minutes:seconds format
  String formatDuration(int durationInMilliseconds) {
    final durationInSeconds = durationInMilliseconds ~/ 1000; // Convert milliseconds to seconds
    final minutes = durationInSeconds ~/ 60;
    final seconds = durationInSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = songDataController.allSongs; // Reset to all songs
    } else {
      searchResults.value = songDataController.allSongs
          .where((song) => song.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void onSongTap(int index) {
    Get.toNamed('/player-screen', arguments: {
      'allSongs': songDataController.allSongs,
      'id': index,
    });
  }


  void onCategoryTap(String categoryId) {
    print('Category tapped: $categoryId');
  }
}
