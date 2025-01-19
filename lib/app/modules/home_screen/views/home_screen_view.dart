import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/app/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg1.png', // Replace with your image path
              fit: BoxFit.cover, // Adjust the image to cover the entire screen
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          // Content
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeText(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildFavoritesSection(),
                  const SizedBox(height: 20),
                  _buildplaylistSection(),
                  const SizedBox(height: 20),
                  _buildAllSongsSection(),
                ],
              ),
            );
          }),
        ]),
      ),
    );
  }

  Widget _buildplaylistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Playlists',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Obx(() => Text(
                  '${controller.songDataController.playlists.length} Playlists',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                )),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final playlists = controller.songDataController.playlists;
          if (playlists.isEmpty) {
            return const Text(
              'No playlists available',
              style: TextStyle(color: Colors.white),
            );
          }
          return SizedBox(
            height: 140, // Define a fixed height for the horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                final songs =
                    controller.songDataController.getPlaylistSongs(playlist.id);
                return GestureDetector(
                  child: Container(
                    // padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 100, // Set a fixed width for each playlist item
                    child: Stack(
                      children: [
                        // Artwork Widget
                        Positioned.fill(
                          child: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(5),
                            id: songs.isNotEmpty ? songs.first.id : 0,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Container(
                              color: Colors.grey, // Fallback background color
                              child: const Icon(
                                Icons.playlist_play,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                        // Black Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ),
                        // Centered Text
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                playlist.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${songs.length} songs',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => controller.onPlaylistTap(playlist, songs),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Favorites Songs',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Obx(() => Text(
                  '${controller.songDataController.favoriteSongs.length} songs',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                )),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.songDataController.favoriteSongs.isEmpty) {
            return Container(
              height: 120,
              alignment: Alignment.center,
              child: const Text(
                'No favorites yet. Tap and hold any song to add to favorites.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return SizedBox(
            height: 96,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.songDataController.favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = controller.songDataController.favoriteSongs[index];
                return GestureDetector(
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: QueryArtworkWidget(
                            id: song.id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Container(
                              height: 60,
                              color: Colors.grey[900],
                              child: const Icon(
                                Icons.music_note,
                                size: 50,
                                color: Colors.white54,
                              ),
                            ),
                            artworkWidth: 60,
                            artworkHeight: 60,
                            artworkFit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          song.artist ?? 'Unknown Artist',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  onTap: () => controller.onFavSongTap(index),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAllSongsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All Songs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Obx(() => Text(
                  '${controller.searchResults.length} songs',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                )),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.searchResults.isEmpty) {
            return const Center(
              child: Text(
                'No songs found',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final song = controller.searchResults[index];
              return ListTile(
                leading: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white54),
                  ),
                  artworkWidth: 50,
                  artworkHeight: 50,
                  artworkFit: BoxFit.cover,
                  artworkBorder: BorderRadius.circular(4),
                ),
                title: Text(
                  song.title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist ?? 'Unknown Artist',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.formatDuration(song.duration ?? 0),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                onTap: () => controller.onSongTap(index),
                onLongPress: () =>
                    controller.songDataController.toggleFavorite(song.id),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'What do you feel like today?',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search songs...',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900]?.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: controller.onSearchChanged,
    );
  }
}
