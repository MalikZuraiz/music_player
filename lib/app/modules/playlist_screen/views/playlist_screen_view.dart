import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/Widgets/song_listview.dart';
import '../controllers/playlist_screen_controller.dart';

class PlaylistScreenView extends GetView<PlaylistScreenController> {
  PlaylistScreenView({super.key});

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
      backgroundColor: Colors.black, // Black background
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  // Background Image
                  Container(
                    margin: const EdgeInsets.all(6),
                    height: MediaQuery.of(context).size.height *
                        0.35, // 30% of screen height
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/1.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  // Semi-transparent overlay for text visibility
                  Container(
                    margin: const EdgeInsets.all(6),
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.5), // Semi-transparent overlay
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  // Stack for content (text and icons)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 30),
                    child: Column(
                      children: [
                        // Back Button and Three Dot Icon (Top Right and Left)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Get.back(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white),
                              onPressed: () {
                                // Handle the three-dot icon press
                              },
                            ),
                          ],
                        ),
                        // Playlist Name and Subtitle
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Playlist Name', // Replace with dynamic playlist name
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Subtitle goes here', // Replace with dynamic subtitle
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Heart Icon
                                IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  color: Colors.white,
                                  onPressed: () {
                                    // Handle heart (like/unlike) action
                                  },
                                ),
                                const SizedBox(width: 20),
                                // Play Icon with Gradient Background
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.purple, Colors.pink],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    color: Colors.white,
                                    onPressed: () {
                                      // Handle play action
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Elevated Container Below the Card Section
            SongListView(
              songs: favoriteSongs,
              onSongTap: (songTitle) {
                // controller.onSongTap(songTitle);
              },
            ),
          ],
        ),
      ),
    );
  }
}
