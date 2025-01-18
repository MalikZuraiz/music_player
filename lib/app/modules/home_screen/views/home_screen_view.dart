import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  HomeScreenView({super.key});

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
              const SizedBox(height: 24),
              Obx(() {
                // Display songs from searchResults
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
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white),
                      ),
                      title: Text(
                        song.title ?? "Unknown Title",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song.artist ?? "Unknown Artist",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () => controller.onSongTap(song),
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
