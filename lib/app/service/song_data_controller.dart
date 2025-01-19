import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistModel {
  final int id;
  final String name;
  final List<int> songIds;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.songIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'songIds': songIds,
      };

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
        id: json['id'],
        name: json['name'],
        songIds: List<int>.from(json['songIds']),
      );
}

class SongDataController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static const String favoritesKey = 'favorites';
  static const String playlistsKey = 'playlists';

  final RxBool hasPermission = false.obs;
  final RxList<SongModel> allSongs = RxList<SongModel>();
  final RxList<SongModel> favoriteSongs = RxList<SongModel>();
  final RxList<int> favoriteIds = RxList<int>();
  final RxList<PlaylistModel> playlists = RxList<PlaylistModel>();

  @override
  void onInit() {
    super.onInit();
    initializeController();
    ever(favoriteIds, (_) => _updateFavoriteSongsList());
  }

  Future<void> initializeController() async {
    await checkAndRequestPermissions();
    if (hasPermission.value) {
      await Future.wait([
        fetchSongs(),
        loadFavorites(),
        loadPlaylists(),
      ]);
    }
  }

  Future<void> checkAndRequestPermissions() async {
    try {
      hasPermission.value = await _audioQuery.permissionsStatus();
      if (!hasPermission.value) {
        hasPermission.value = await _audioQuery.permissionsRequest();
      }

      if (!hasPermission.value) {
        Get.snackbar(
          "Permission Required",
          "Please grant storage permission to access your music.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      log('Error checking permissions: $e');
    }
  }

  Future<void> fetchSongs() async {
    if (!hasPermission.value) return;

    try {
      final List<SongModel> songs = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      final List<SongModel> validSongs = songs.where((song) {
        if (song.isMusic != true) return false;
        final file = File(song.data);
        return file.existsSync();
      }).toList();

      allSongs.assignAll(validSongs);
      _updateFavoriteSongsList();
    } catch (e) {
      log('Error fetching songs: $e');
      Get.snackbar(
        "Error",
        "Failed to fetch songs. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favoritesList = prefs.getStringList(favoritesKey);

      if (favoritesList != null) {
        favoriteIds.value = favoritesList
            .map((e) => int.tryParse(e))
            .where((id) => id != null)
            .cast<int>()
            .toList();
      }
    } catch (e) {
      log('Error loading favorites: $e');
    }
  }

  Future<void> loadPlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? playlistsJson = prefs.getString(playlistsKey);

      if (playlistsJson != null) {
        final List<dynamic> playlistsList = jsonDecode(playlistsJson);
        playlists.value =
            playlistsList.map((json) => PlaylistModel.fromJson(json)).toList();
      }
    } catch (e) {
      log('Error loading playlists: $e');
    }
  }

  Future<void> _savePlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String playlistsJson = jsonEncode(
        playlists.map((playlist) => playlist.toJson()).toList(),
      );
      await prefs.setString(playlistsKey, playlistsJson);
    } catch (e) {
      log('Error saving playlists: $e');
    }
  }

  void _updateFavoriteSongsList() {
    favoriteSongs.value =
        allSongs.where((song) => favoriteIds.contains(song.id)).toList();
  }

  Future<void> toggleFavorite(int songId) async {
    try {
      if (favoriteIds.contains(songId)) {
        favoriteIds.remove(songId);
      } else {
        favoriteIds.add(songId);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        favoritesKey,
        favoriteIds.map((id) => id.toString()).toList(),
      );
    } catch (e) {
      log('Error toggling favorite: $e');
    }
  }

  Future<int?> createPlaylist(String name) async {
    try {
      final int newId = DateTime.now().millisecondsSinceEpoch;
      final newPlaylist = PlaylistModel(
        id: newId,
        name: name,
        songIds: [],
      );

      playlists.add(newPlaylist);
      await _savePlaylists();
      return newId;
    } catch (e) {
      log('Error creating playlist: $e');
      return null;
    }
  }

  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    try {
      final playlistIndex = playlists.indexWhere((p) => p.id == playlistId);
      if (playlistIndex != -1) {
        final playlist = playlists[playlistIndex];
        if (!playlist.songIds.contains(songId)) {
          final updatedPlaylist = PlaylistModel(
            id: playlist.id,
            name: playlist.name,
            songIds: [...playlist.songIds, songId],
          );
          playlists[playlistIndex] = updatedPlaylist;
          await _savePlaylists();
        }
      }
    } catch (e) {
      log('Error adding song to playlist: $e');
    }
  }

  Future<void> removeSong(int songId) async {
    try {
      // Remove from favorites
      if (favoriteIds.contains(songId)) {
        await toggleFavorite(songId);
      }

      // Remove from playlists
      bool playlistsUpdated = false;
      for (var i = 0; i < playlists.length; i++) {
        final playlist = playlists[i];
        if (playlist.songIds.contains(songId)) {
          playlists[i] = PlaylistModel(
            id: playlist.id,
            name: playlist.name,
            songIds: playlist.songIds.where((id) => id != songId).toList(),
          );
          playlistsUpdated = true;
        }
      }

      if (playlistsUpdated) {
        await _savePlaylists();
      }

      // Remove from allSongs
      allSongs.removeWhere((song) => song.id == songId);
      _updateFavoriteSongsList();
    } catch (e) {
      log('Error removing song: $e');
      rethrow; // Propagate error to caller
    }
  }

  bool isFavorite(int songId) {
    return favoriteIds.contains(songId);
  }

  SongModel? getSongById(int id) {
    try {
      return allSongs.firstWhere((song) => song.id == id);
    } catch (_) {
      return null;
    }
  }

  List<SongModel> getPlaylistSongs(int playlistId) {
    final playlist = playlists.firstWhereOrNull((p) => p.id == playlistId);
    if (playlist != null) {
      return allSongs
          .where((song) => playlist.songIds.contains(song.id))
          .toList();
    }
    return [];
  }
Future<void> deletePlaylist(int playlistId) async {
  try {
    playlists.removeWhere((playlist) => playlist.id == playlistId);
    await _savePlaylists();
    // Force refresh of playlists
    playlists.refresh();
  } catch (e) {
    log('Error deleting playlist: $e');
    Get.snackbar(
      "Error",
      "Failed to delete playlist",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
  try {
    final playlistIndex = playlists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex != -1) {
      final playlist = playlists[playlistIndex];
      if (playlist.songIds.contains(songId)) {
        final updatedPlaylist = PlaylistModel(
          id: playlist.id,
          name: playlist.name,
          songIds: playlist.songIds.where((id) => id != songId).toList(),
        );
        playlists[playlistIndex] = updatedPlaylist;
        await _savePlaylists();
        // Force refresh of playlists
        playlists.refresh();
      }
    }
  } catch (e) {
    log('Error removing song from playlist: $e');
    Get.snackbar(
      "Error",
      "Failed to remove song from playlist",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
}