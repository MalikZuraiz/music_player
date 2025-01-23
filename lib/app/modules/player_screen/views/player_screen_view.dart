import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/player_screen_controller.dart';

class PlayerScreenView extends GetView<PlayerScreenController> {
  const PlayerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              _buildArtwork(),
              const SizedBox(height: 40),
              _buildSongInfo(),
              const SizedBox(height: 20),
              _buildProgressBar(),
              const SizedBox(height: 40),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) => _handleMenuSelection(value),
          color: Colors.black,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'add_to_playlist',
              child: Text('Add to Playlist', style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuItem(
              textStyle: TextStyle(color: Colors.white),
              value: 'share',
              child: Text('Share' ,style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'add_to_playlist':
        _showPlaylistBottomSheet();
        break;
      case 'share':
        controller.shareSong();
        break;
    }
  }

  void _showPlaylistBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(color: Color(0xFF9B4DE0), width: 2),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'Add to Playlist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    final playlists = controller.songDataController.playlists;
                    if (playlists.isEmpty) {
                      return const Text(
                        'No playlists available',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        final songs = controller.songDataController
                            .getPlaylistSongs(playlist.id);
                        return ListTile(
                          leading: QueryArtworkWidget(
                            id: songs.isNotEmpty ? songs.first.id : 0,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.playlist_play,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                playlist.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text(
                                '${songs.length} songs',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {
                            controller.addToPlaylist(playlist.id);
                            Get.back();
                          },
                        );
                      },
                    );
                  }),
                ],
              ),
              FloatingActionButton(
                backgroundColor: const Color(0xFF9B4DE0),
                onPressed: () => _showCreatePlaylistDialog(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    final TextEditingController nameController = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Color(0xFF9B4DE0), width: 1),
        ),
        elevation: 10,
        backgroundColor: Colors.black,
        title: const Text('Create New Playlist',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Playlist Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.createNewPlaylist(nameController.text);
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork() {
    return Obx(() {
      final currentSong = controller.allSongs[controller.songIndex.value];
      return QueryArtworkWidget(
        id: currentSong.id,
        artworkBorder: BorderRadius.circular(12),
        type: ArtworkType.AUDIO,
        nullArtworkWidget:
            const Icon(Icons.music_note, size: 320, color: Colors.white),
        artworkWidth: Get.width * 0.8,
        artworkHeight: Get.height * 0.4,
        artworkFit: BoxFit.cover,
      );
    });
  }

  Widget _buildSongInfo() {
    return Obx(() {
      final currentSong = controller.allSongs[controller.songIndex.value];
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentSong.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  currentSong.artist ?? "Unknown Artist",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              controller.isFavorite() ? Icons.favorite : Icons.favorite_border,
              color: controller.isFavorite() ? Colors.red : Colors.white,
            ),
            onPressed: () => controller.toggleFavorite(),
          ),
        ],
      );
    });
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(Get.context!).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.1),
          ),
          child: Obx(() => Slider(
                value: controller.currentPosition.value,
                min: 0,
                max: controller.totalDuration.value,
                onChanged: (value) => controller.seekTo(value),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    _formatDuration(controller.currentPosition.value),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  )),
              Obx(() => Text(
                    _formatDuration(controller.totalDuration.value),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Obx(() => Icon(
                Icons.shuffle,
                color: controller.isShuffleEnabled.value
                    ? const Color(0xFF9B4DE0)
                    : Colors.white,
              )),
          onPressed: () => controller.toggleShuffle(),
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          color: Colors.white,
          iconSize: 35,
          onPressed: () => controller.previousTrack(),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF9B4DE0),
          ),
          child: IconButton(
            icon: Obx(() => Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                )),
            color: Colors.white,
            iconSize: 35,
            onPressed: () => controller.togglePlay(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          color: Colors.white,
          iconSize: 35,
          onPressed: () => controller.nextTrack(),
        ),
        IconButton(
          icon: Obx(() {
            final mode = controller.repeatMode.value;
            switch (mode) {
              case RepeatMode.off:
                return const Icon(Icons.repeat, color: Colors.white);
              case RepeatMode.one:
                return const Icon(Icons.repeat_one, color: Color(0xFF9B4DE0));
              case RepeatMode.all:
                return const Icon(Icons.repeat, color: Color(0xFF9B4DE0));
            }
          }),
          onPressed: () => controller.toggleRepeat(),
        ),
      ],
    );
  }

  String _formatDuration(double value) {
    final duration = Duration(seconds: value.round());
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
