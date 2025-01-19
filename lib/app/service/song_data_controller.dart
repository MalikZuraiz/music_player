import 'dart:developer';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongDataController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static const String favoritesKey = 'favorites';

  // Observable states
  final RxBool hasPermission = false.obs;
  final RxList<SongModel> allSongs = RxList<SongModel>();
  final RxList<SongModel> favoriteSongs = RxList<SongModel>();
  final RxList<int> favoriteIds = RxList<int>();

  @override
  void onInit() {
    super.onInit();
    initializeController();
    
    // Listen to changes in favoriteIds to update favoriteSongs
    ever(favoriteIds, (_) {
      _updateFavoriteSongsList();
    });
  }

  Future<void> initializeController() async {
    await checkAndRequestPermissions();
    if (hasPermission.value) {
      await Future.wait([
        fetchSongs(),
        loadFavorites(),
      ]);
    }
  }

  Future<void> checkAndRequestPermissions() async {
    hasPermission.value = await _audioQuery.permissionsStatus();
    if (!hasPermission.value) {
      hasPermission.value = await _audioQuery.permissionsRequest();
    }

    if (!hasPermission.value) {
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
      
      final List<SongModel> musicSongs = songs.where((song) => song.isMusic ?? false).toList();
      allSongs.assignAll(musicSongs);
      
      // Update favorites list after fetching songs
      _updateFavoriteSongsList();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch songs: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadFavorites() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? favoritesList = prefs.getStringList(favoritesKey);

      if (favoritesList != null && favoritesList.isNotEmpty) {
        favoriteIds.value = favoritesList
            .map((e) => int.tryParse(e))
            .where((id) => id != null)
            .cast<int>()
            .toList();

        log('Loaded favorite IDs: ${favoriteIds.length}');
      }
    } catch (e) {
      log('Error loading favorites: $e');
    }
  }

  void _updateFavoriteSongsList() {
    if (allSongs.isNotEmpty) {
      favoriteSongs.value = allSongs
          .where((song) => favoriteIds.contains(song.id))
          .toList();
      log('Updated favorite songs: ${favoriteSongs.length}');
    }
  }

  Future<void> toggleFavorite(int songId) async {
    try {
      if (favoriteIds.contains(songId)) {
        favoriteIds.remove(songId);
      } else {
        favoriteIds.add(songId);
      }

      // Save to SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        favoritesKey,
        favoriteIds.map((id) => id.toString()).toList(),
      );

      log('Toggled favorite for song ID: $songId. Total favorites: ${favoriteIds.length}');
    } catch (e) {
      log('Error toggling favorite: $e');
    }
  }

  bool isFavorite(int songId) {
    return favoriteIds.contains(songId);
  }

  SongModel? getSongById(int id) {
    return allSongs.firstWhereOrNull((song) => song.id == id);
  }
}