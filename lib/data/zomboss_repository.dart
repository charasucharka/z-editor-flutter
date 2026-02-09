import 'package:collection/collection.dart';

enum ZombossTag {
  all,
  main,
  challenge,
  pvz1;
}

class ZombossInfo {
  const ZombossInfo({
    required this.id,
    required this.icon,
    required this.tag,
    required this.defaultPhaseCount,
  });

  final String id;
  final String icon;
  final ZombossTag tag;
  final int defaultPhaseCount;

  /// Localization key for ZombossTag labels. Use ResourceNames.lookup(context, key).
  static String tagLabelKey(ZombossTag tag) {
    return switch (tag) {
      ZombossTag.all => 'zomboss_tag_all',
      ZombossTag.main => 'zomboss_tag_main',
      ZombossTag.challenge => 'zomboss_tag_challenge',
      ZombossTag.pvz1 => 'zomboss_tag_pvz1',
    };
  }
}

class ZombossRepository {
  static const List<ZombossInfo> allZombosses = [
    ZombossInfo(id: "zombossmech_egypt", icon: "zombossmech_egypt.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_pirate", icon: "zombossmech_pirate.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_cowboy", icon: "zombossmech_cowboy.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_future", icon: "zombossmech_future.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_dark", icon: "zombossmech_dark.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_beach", icon: "zombossmech_beach.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_iceage", icon: "zombossmech_iceage.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_skycity", icon: "zombossmech_skycity.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_lostcity", icon: "zombossmech_lostcity.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_eighties", icon: "zombossmech_eighties.webp", tag: ZombossTag.main, defaultPhaseCount: 5),
    ZombossInfo(id: "zombossmech_dino", icon: "zombossmech_dino.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_steam", icon: "zombossmech_steam.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_renai", icon: "zombossmech_renai.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_hydra", icon: "zombossmech_hydra.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_egypt", icon: "zombossmech_egypt.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_pirate", icon: "zombossmech_pirate.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_cowboy", icon: "zombossmech_cowboy.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_future", icon: "zombossmech_future.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_dark", icon: "zombossmech_dark.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_beach", icon: "zombossmech_beach.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_iceage", icon: "zombossmech_iceage.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_lostcity", icon: "zombossmech_lostcity.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_modern_eighties", icon: "zombossmech_eighties.webp", tag: ZombossTag.main, defaultPhaseCount: 5),
    ZombossInfo(id: "zombossmech_modern_dino", icon: "zombossmech_dino.webp", tag: ZombossTag.main, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_egypt_vacation", icon: "zombossmech_egypt.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_pirate_vacation", icon: "zombossmech_pirate.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_cowboy_vacation", icon: "zombossmech_cowboy.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_future_vacation", icon: "zombossmech_future.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_dark_vacation", icon: "zombossmech_dark.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_beach_vacation", icon: "zombossmech_beach.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_iceage_vacation", icon: "zombossmech_iceage.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_skycity_vacation", icon: "zombossmech_skycity.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_lostcity_vacation", icon: "zombossmech_lostcity.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_eighties_vacation", icon: "zombossmech_eighties.webp", tag: ZombossTag.challenge, defaultPhaseCount: 5),
    ZombossInfo(id: "zombossmech_dino_vacation", icon: "zombossmech_dino.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_egypt_12th", icon: "zombossmech_egypt.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_pirate_12th", icon: "zombossmech_pirate.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_cowboy_12th", icon: "zombossmech_cowboy.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_future_12th", icon: "zombossmech_future.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_dark_12th", icon: "zombossmech_dark.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_beach_12th", icon: "zombossmech_beach.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_iceage_12th", icon: "zombossmech_iceage.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_skycity_12th", icon: "zombossmech_skycity.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_lostcity_12th", icon: "zombossmech_lostcity.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_eighties_12th", icon: "zombossmech_eighties.webp", tag: ZombossTag.challenge, defaultPhaseCount: 5),
    ZombossInfo(id: "zombossmech_dino_12th", icon: "zombossmech_dino.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_steam_12th", icon: "zombossmech_steam.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_renai_12th", icon: "zombossmech_renai.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_hydra_12th", icon: "zombossmech_hydra.webp", tag: ZombossTag.challenge, defaultPhaseCount: 3),
    ZombossInfo(id: "zombossmech_pvz1_robot_normal", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_hard", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_1", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_2", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_3", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_4", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_5", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_6", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_7", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_8", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
    ZombossInfo(id: "zombossmech_pvz1_robot_9", icon: "zombossmech_pvz1_robot.webp", tag: ZombossTag.pvz1, defaultPhaseCount: 4),
  ];

  static ZombossInfo? get(String id) {
    return allZombosses.where((e) => e.id == id).firstOrNull;
  }

  static List<ZombossInfo> search(String query, ZombossTag selectedTag) {
    var tagFiltered = allZombosses;
    if (selectedTag != ZombossTag.all) {
      tagFiltered = allZombosses.where((e) => e.tag == selectedTag).toList();
    }

    if (query.trim().isEmpty) return tagFiltered;

    final lowerQ = query.toLowerCase();
    return tagFiltered.where((e) => e.id.toLowerCase().contains(lowerQ)).toList();
  }
}
