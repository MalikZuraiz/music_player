import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreenController extends GetxController {
  final player = AudioPlayer();
  final allSongs = Get.arguments['allSongs']; // List of all songs
  final isPlaying = false.obs;
  final currentPosition = 0.0.obs;
  final totalDuration = 0.0.obs;
  Rx<int> songIndex = (Get.arguments['id'] as int).obs; // Song index as reactive

  // Maintain the list of favorite song IDs
  RxList<int> favoriteSongs = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSong();
    _loadFavoriteSongs(); // Load favorite songs from SharedPreferences
  }

  // Function to load and play the song
  Future<void> _loadSong() async {
    final currentSong = allSongs[songIndex.value];
    await player.setAudioSource(
      AudioSource.uri(Uri.parse(currentSong.uri!)),
      initialIndex: songIndex.value,
    );
    totalDuration.value = player.duration?.inSeconds.toDouble() ?? 0.0;
    player.play();
    isPlaying.value = true;

    // Listen to the player's position to update UI
    player.positionStream.listen((position) {
      currentPosition.value = position.inSeconds.toDouble();
    });

    player.durationStream.listen((duration) {
      totalDuration.value = duration?.inSeconds.toDouble() ?? 0.0;
    });
  }

  // Load the favorite songs from SharedPreferences
  Future<void> _loadFavoriteSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritesList = prefs.getStringList('favorites');
    if (favoritesList != null) {
      favoriteSongs.value = favoritesList
          .map((e) => int.parse(e))
          .toList(); // Convert the string list back to integers
                log("Favorite Songs Loaded: $favoriteSongs");

    }
  }

  // Save the favorite songs list to SharedPreferences
  Future<void> _saveFavoriteSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritesList =
        favoriteSongs.map((e) => e.toString()).toList(); // Convert to strings
    await prefs.setStringList('favorites', favoritesList);
  }

  // Toggle play/pause
  void togglePlay() {
    if (isPlaying.value) {
      player.pause();
      isPlaying.value = false;
    } else {
      player.play();
      isPlaying.value = true;
    }
  }

  // Add/remove song to favorites
  void toggleFavorite() {
    final currentSong = allSongs[songIndex.value];
    if (favoriteSongs.contains(currentSong.id)) {
      favoriteSongs.remove(currentSong.id); // Remove from favorites
    } else {
      favoriteSongs.add(currentSong.id); // Add to favorites
    }
    _saveFavoriteSongs(); // Save the updated list to SharedPreferences
  }

  // Seek to a specific position
  void seekTo(double position) {
    player.seek(Duration(seconds: position.round()));
    currentPosition.value = position;
  }

  // Go to previous song
  void previousTrack() {
    if (songIndex.value > 0) {
      songIndex.value--;
      _loadSong();
    }
  }

  // Go to next song
  void nextTrack() {
    if (songIndex.value < allSongs.length - 1) {
      songIndex.value++;
      _loadSong();
    }
  }

  @override
  void onClose() {
    // player.dispose(); // Dispose of the player when it's no longer needed
    super.onClose();
  }
}
