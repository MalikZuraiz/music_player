import 'package:flutter/material.dart';

class FeaturedPlaylistsView extends StatelessWidget {
  final List<Map<String, String>> albums;
  final Function(String) onPlaylistTap;

  const FeaturedPlaylistsView({
    super.key,
    required this.albums,
    required this.onPlaylistTap,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: () => onPlaylistTap(album['title']!),
            ),
          );
        },
      ),
    );
  }

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
              child: SizedBox(
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
}
