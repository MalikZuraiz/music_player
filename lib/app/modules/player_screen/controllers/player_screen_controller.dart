import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:music_player/app/service/song_data_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


enum RepeatMode {
  off,
  one,
  all,
}

class PlayerScreenController extends GetxController {
  final SongDataController songDataController = Get.find<SongDataController>();
  static final player = AudioPlayer();
  final allSongs = Get.arguments['allSongs'];
  final isPlaying = false.obs;
  final currentPosition = 0.0.obs;
  final totalDuration = 0.0.obs;
  Rx<int> songIndex = (Get.arguments['id'] as int).obs;
  final isShuffleEnabled = false.obs;
  final Rx<RepeatMode> repeatMode = RepeatMode.off.obs;

  @override
  void onInit() {
    super.onInit();
    player.stop();
    _loadSong();
    _setupPlayerListeners();
  }

  void _setupPlayerListeners() {
    player.positionStream.listen((position) {
      currentPosition.value = position.inSeconds.toDouble();
    });

    player.durationStream.listen((duration) {
      totalDuration.value = duration?.inSeconds.toDouble() ?? 0.0;
    });

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongCompletion();
      }
      isPlaying.value = state.playing;
    });
  }

  void _handleSongCompletion() {
    switch (repeatMode.value) {
      case RepeatMode.off:
        if (songIndex.value < allSongs.length - 1) {
          nextTrack();
        } else {
          player.stop();
          isPlaying.value = false;
        }
        break;
      case RepeatMode.one:
        player.seek(Duration.zero);
        player.play();
        break;
      case RepeatMode.all:
        if (songIndex.value < allSongs.length - 1) {
          nextTrack();
        } else {
          songIndex.value = 0;
          _loadSong();
        }
        break;
    }
  }

  Future<void> _loadSong() async {
    try {
      final currentSong = allSongs[songIndex.value];
      final uri = currentSong.uri!;
      await player.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );
      player.play();
    } catch (e) {
      log('Error loading song: $e');
      Get.snackbar('Error', 'Unable to play this song');
    }
  }

  void togglePlay() {
    if (isPlaying.value) {
      player.pause();
    } else {
      player.play();
    }
  }

  void toggleShuffle() {
    isShuffleEnabled.value = !isShuffleEnabled.value;
    Get.snackbar(
      'Shuffle',
      isShuffleEnabled.value ? 'Shuffle enabled' : 'Shuffle disabled',
      duration: const Duration(seconds: 1),
    );
  }

void toggleRepeat() {
    switch (repeatMode.value) {
      case RepeatMode.off:
        repeatMode.value = RepeatMode.one;
        Get.snackbar('Repeat', 'Repeat one', duration: const Duration(seconds: 1));
        break;
      case RepeatMode.one:
        repeatMode.value = RepeatMode.all;
        Get.snackbar('Repeat', 'Repeat all', duration: const Duration(seconds: 1));
        break;
      case RepeatMode.all:
        repeatMode.value = RepeatMode.off;
        Get.snackbar('Repeat', 'Repeat off', duration: const Duration(seconds: 1));
        break;
    }
  }

  void previousTrack() {
    if (currentPosition.value > 3.0) {
      // If more than 3 seconds into song, restart current song
      player.seek(Duration.zero);
      return;
    }
    
    if (isShuffleEnabled.value) {
      _playRandomTrack();
    } else if (songIndex.value > 0) {
      songIndex.value--;
      _loadSong();
    }
  }

  void nextTrack() {
    if (isShuffleEnabled.value) {
      _playRandomTrack();
    } else if (songIndex.value < allSongs.length - 1) {
      songIndex.value++;
      _loadSong();
    } else if (repeatMode.value == RepeatMode.all) {
      songIndex.value = 0;
      _loadSong();
    }
  }

  void _playRandomTrack() {
    // final currentIndex = songIndex.value;
    // int newIndex;
    // do {
    //   newIndex = DateTime.now().millisecondsSinceEpoch % allSongs.length;
    // } while (newIndex == currentIndex && allSongs.length > 1);
    
    // songIndex.value = newIndex;
    // _loadSong();
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
  }

  Future<void> shareSong() async {
  try {
    // First check and request storage permissions
    if (await _checkAndRequestPermissions()) {
      final currentSong = allSongs[songIndex.value];
      final filePath = currentSong.data;
      
      final file = File(filePath);
      if (await file.exists()) {
        // Create a temporary file in app's cache directory
        final tempDir = await getTemporaryDirectory();
        final tempPath = path.join(tempDir.path, path.basename(filePath));
        
        // Ensure the directory exists
        await Directory(path.dirname(tempPath)).create(recursive: true);
        
        // Copy with error handling
        try {
          await file.copy(tempPath);
        } catch (e) {
          // If direct copy fails, try reading and writing
          final bytes = await file.readAsBytes();
          await File(tempPath).writeAsBytes(bytes);
        }
        
        final tempFile = File(tempPath);
        if (await tempFile.exists()) {
          await Share.shareXFiles(
            [XFile(tempPath)],
            text: 'Check out this song: ${currentSong.title}',
          ).whenComplete(() async {
            // Clean up temp file after sharing
            try {
              if (await tempFile.exists()) {
                await tempFile.delete();
              }
            } catch (e) {
              print('Error cleaning up temp file: $e');
            }
          });
        }
      } else {
        Get.snackbar('Error', 'File not found');
      }
    } else {
      Get.snackbar('Error', 'Storage permission required to share songs');
    }
  } catch (e) {
    print('Error sharing song: $e');
    Get.snackbar('Error', 'Unable to share song: ${e.toString()}');
  }
}

// Helper function to check and request permissions
Future<bool> _checkAndRequestPermissions() async {
  if (Platform.isAndroid) {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      // Request permission
      final result = await Permission.storage.request();
      return result.isGranted;
    }
    return status.isGranted;
  }
  return true; // For iOS or other platforms
}

  Future<void> addToPlaylist(int? playlistId) async {
    final currentSong = allSongs[songIndex.value];
    if (playlistId != null) {
      await songDataController.addSongToPlaylist(playlistId, currentSong.id);
      Get.back();
      Get.snackbar('Success', 'Added to playlist');
    }
  }

  Future<void> createNewPlaylist(String name) async {
    final currentSong = allSongs[songIndex.value];
    final playlistId = await songDataController.createPlaylist(name);
    if (playlistId != null) {
      await addToPlaylist(playlistId);
    }
  }

}