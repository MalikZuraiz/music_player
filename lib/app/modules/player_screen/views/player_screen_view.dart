import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        IconButton(
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildArtwork() {
    return Container(
      width: Get.width * 0.85,
      height: Get.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/2.png'), // Add your artwork
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You Right',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Doja Cat, The Weeknd',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
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
          icon: const Icon(Icons.shuffle),
          color: Colors.white,
          onPressed: () {},
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
          icon: const Icon(Icons.repeat),
          color: Colors.white,
          onPressed: () {},
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