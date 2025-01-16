import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/Widgets/featured_playlists_view.dart';
import 'package:music_player/Widgets/song_listview.dart';
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildWelcomeText(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 24),
            // Featured Playlist Section
            FeaturedPlaylistsView(
              albums: albums,
              onPlaylistTap: (playlistTitle) {
                controller.onPlaylistTap(playlistTitle);
              },
            ),
            const SizedBox(height: 10),
            // Song List Section
            const Text(
              'Your favourites',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            SongListView(
              songs: favoriteSongs,
              onSongTap: (songTitle) {
                controller.onSongTap(songTitle);
              },
            ),
          ]),
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
}
