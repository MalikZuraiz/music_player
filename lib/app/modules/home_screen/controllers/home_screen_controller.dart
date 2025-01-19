import 'dart:developer';
import 'package:get/get.dart';
import 'package:music_player/app/service/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreenController extends GetxController {
  // Controllers
  final SongDataController songDataController = Get.find<SongDataController>();

  // Observable lists
  final RxList<SongModel> searchResults = RxList<SongModel>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in songDataController.allSongs
    ever(songDataController.allSongs, (_) {
      _updateSearchResults();
    });

    initializeController();
  }

  Future<void> initializeController() async {
    try {
      // Initialize search results if songs are already loaded
      _updateSearchResults();
      isLoading.value = false;
    } catch (e) {
      log('Error initializing controller: $e');
      isLoading.value = false;
    }
  }

  void _updateSearchResults() {
    if (songDataController.allSongs.isNotEmpty) {
      searchResults.assignAll(songDataController.allSongs);
      log('Search results updated: ${searchResults.length}');
    }
  }

  String formatDuration(int milliseconds) {
    if (milliseconds <= 0) return "00:00";

    final int seconds = (milliseconds / 1000).floor();
    final int minutes = (seconds / 60).floor();
    final int remainingSeconds = seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.assignAll(songDataController.allSongs);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    searchResults.value = songDataController.allSongs
        .where((song) => song.title.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  void onSongTap(int index) {
    if (index < 0 || index >= searchResults.length) return;

    Get.toNamed(
      '/player-screen',
      arguments: {
        'allSongs': searchResults,
        'id': index,
      },
    );
  }
}