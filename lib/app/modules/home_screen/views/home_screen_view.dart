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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeText(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 10),
              
              // Display Favorites Horizontal List
              const Text(
                'Your Favorite Songs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.favoritesongs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No favorites yet.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.favoritesongs.length,
                    itemBuilder: (context, index) {
                      final song = controller.favoritesongs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            QueryArtworkWidget(
                              id: song.id,
                              artworkBorder: BorderRadius.circular(8),
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(Icons.music_note,
                                  size: 60, color: Colors.white),
                              artworkWidth: 140,
                              artworkHeight: 80,
                              artworkFit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  song.title ?? "Unknown Title",
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                ),
                                 Text(
                              controller.formatDuration(song.duration ?? 0),
                              style: const TextStyle(color: Colors.grey,  fontSize: 12),
                            ),
                              ],
                            ),
                           
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),

              // Song List Section
              const Text(
                'Your songs',
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
                      'No songs found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final song = controller.searchResults[index];

                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: song.id,
                        artworkBorder: BorderRadius.circular(8),
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(Icons.music_note,
                            size: 60, color: Colors.white),
                        artworkWidth: 60,
                        artworkHeight: 60,
                        artworkFit: BoxFit.cover,
                      ),
                      title: Text(
                        song.title ?? "Unknown Title",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.artist ?? "Unknown Artist",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: Text(
                        controller.formatDuration(song.duration ?? 0),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      onTap: () => controller.onSongTap(index),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Method: Welcome Text
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
        Text(
          'What do you feel like today?',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // Helper Method: Search Bar
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search song, playlist, artist...',
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900]?.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: controller.onSearchChanged,
    );
  }
}
