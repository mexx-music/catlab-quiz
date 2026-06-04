import 'dart:math';

/// Provides randomly selected banner images for quiz categories.
///
/// Images are grouped thematically; call [pick] once per session to get a
/// stable image that does not change on widget rebuilds or locale switches.
class CategoryImages {
  CategoryImages._();

  static const _base = 'assets/catpics/';

  static const fallback = '${_base}einzelnes Kitten.png';

  static const breeds = <String>[
    '${_base}Abessinier.png',
    '${_base}Bengal.png',
    '${_base}British Shorthair.png',
    '${_base}Maine Coon.png',
    '${_base}Norwegische Waldkatze.png',
    '${_base}Perser.png',
    '${_base}Ragdoll.png',
    '${_base}Scottish Fold.png',
    '${_base}Siam.png',
    '${_base}Sibirische Katze.png',
  ];

  static const kittens = <String>[
    '${_base}einzelnes Kitten.png',
    '${_base}2 Kitten.png',
    '${_base}3 Kitten.png',
    '${_base}Kitten mit Mutter.png',
    '${_base}rotes Kitten.png',
    '${_base}schwarzes Kitten.png',
    '${_base}getigertes Kitten.png',
    '${_base}langhaariges Kitten.png',
    '${_base}spielende Kitten.png',
    '${_base}schlafende Kitten.png',
  ];

  static const behavior = <String>[
    '${_base}spielend.png',
    '${_base}springend.png',
    '${_base}lauernd.png',
    '${_base}neugierig.png',
    '${_base}schlafend.png',
    '${_base}fenster.png',
    '${_base}jaeger.png',
    '${_base}kneten.png',
    '${_base}kratzbaum.png',
    '${_base}Strecken_Gaehnen.png',
  ];

  static const all = <String>[...breeds, ...kittens, ...behavior];

  static const _groups = <String, List<String>>{
    'cat_breeds': breeds,
    'cat_house_cats': breeds,
    'cat_kittens': kittens,
    'cat_body_language': behavior,
    'cat_behavior': behavior,
    'cat_purring': behavior,
    'cat_cat_communication': behavior,
    'cat_expert_knowledge': behavior,
    'cat_indoor_outdoor': behavior,
    'cat_human_bond': behavior,
    'cat_myths': behavior,
    'cat_mixed_challenge': all,
  };

  /// Returns a random image path for [categoryId], preferring images not yet
  /// present in [used]. Adds the chosen path to [used].
  ///
  /// Falls back to the full category pool (allowing a repeat) only when every
  /// image in the pool has already been used.
  static String pickUnique(
    String categoryId,
    Random rng,
    Set<String> used,
  ) {
    final pool = _groups[categoryId];
    if (pool == null || pool.isEmpty) return fallback;

    final available =
        pool.where((img) => !used.contains(img)).toList(growable: false);
    final chosen = available.isNotEmpty
        ? available[rng.nextInt(available.length)]
        : pool[rng.nextInt(pool.length)];

    used.add(chosen);
    return chosen;
  }
}
