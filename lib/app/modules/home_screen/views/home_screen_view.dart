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
        child: Obx(() {
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
                _buildAllSongsSection(),
              ],
            ),
          );
        }),
      ),
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
              'Your Favorite Songs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Obx(() => Text(
                  '${controller.songDataController.favoriteSongs.length} songs',
                  style: const TextStyle(color: Colors.grey),
                )),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.songDataController.favoriteSongs.isEmpty) {
            return Container(
              height: 180,
              alignment: Alignment.center,
              child: const Text(
                'No favorites yet. Tap and hold any song to add to favorites.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.songDataController.favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = controller.songDataController.favoriteSongs[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: QueryArtworkWidget(
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Container(
                            height: 120,
                            color: Colors.grey[900],
                            child: const Icon(
                              Icons.music_note,
                              size: 50,
                              color: Colors.white54,
                            ),
                          ),
                          artworkWidth: 160,
                          artworkHeight: 120,
                          artworkFit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        song.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song.artist ?? 'Unknown Artist',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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
        const Text(
          'All Songs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final song = controller.searchResults[index];
              final isFavorite = controller.songDataController.isFavorite(song.id);

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
                onLongPress: () => controller.songDataController.toggleFavorite(song.id),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: controller.onSearchChanged,
    );
  }
}