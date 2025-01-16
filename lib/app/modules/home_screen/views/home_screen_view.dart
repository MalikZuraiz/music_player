import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  HomeScreenView({super.key});

  // Dummy data for playlists
  final List<Map<String, String>> albums = [
    {
      "title": "R&B Playlist",
      "subtitle": "Chill your mind",
      "imagePath": "assets/1.png"
    },
    {
      "title": "Daily Mix 2",
      "subtitle": "Made for you",
      "imagePath": "assets/2.png"
    },
    {
      "title": "R&B Playlist",
      "subtitle": "Chill your mind",
      "imagePath": "assets/1.png"
    },
    {
      "title": "Daily Mix 2",
      "subtitle": "Made for you",
      "imagePath": "assets/2.png"
    },
  ];

  // Dummy data for favorite songs
  final List<Map<String, String>> favoriteSongs = [
    {
      "title": "Bye Bye",
      "artist": "Marshmello, Juice WRLD",
      "duration": "2:09",
      "imagePath": "assets/1.png"
    },
    {
      "title": "I Like You",
      "artist": "Post Malone, Doja Cat",
      "duration": "4:03",
      "imagePath": "assets/1.png"
    },
    {
      "title": "Fountains",
      "artist": "Drake, Tems",
      "duration": "3:18",
      "imagePath": "assets/4.png"
    },
        {
      "title": "I Like You",
      "artist": "Post Malone, Doja Cat",
      "duration": "4:03",
      "imagePath": "assets/2.png"
    },
    {
      "title": "Fountains",
      "artist": "Drake, Tems",
      "duration": "3:18",
      "imagePath": "assets/3.png"
    },
  ];

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
              _buildFeaturedPlaylists(),
              const SizedBox(height: 20),
              _buildFavoritesSection(),
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
        prefixIcon: const Icon(Icons.search),
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

  // Helper Method: Featured Playlists
  Widget _buildFeaturedPlaylists() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildPlaylistCard(
              album['title']!,
              album['subtitle']!,
              album['imagePath']!,
              onTap: () => controller.onPlaylistTap(album['title']!),
            ),
          );
        },
      ),
    );
  }

  // Helper Method: Playlist Card
  Widget _buildPlaylistCard(
    String title,
    String subtitle,
    String imagePath, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Container(
                height: 160,
                width: 180,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method: Favorites Section
  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your favourites',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: favoriteSongs.length,
          itemBuilder: (context, index) {
            final song = favoriteSongs[index];
            return _buildSongListTile(
              song['title']!,
              song['artist']!,
              song['duration']!,
              song['imagePath']!,
              onTap: () => controller.onSongTap(song['title']!),
            );
          },
        ),
      ],
    );
  }

  // Helper Method: Song List Tile
  Widget _buildSongListTile(
    String title,
    String artist,
    String duration,
    String imagePath, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 50,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      subtitle: Text(
        artist,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: Text(
        duration,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
