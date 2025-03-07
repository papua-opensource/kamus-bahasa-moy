class Word {
  final int id;
  final String word;
  final String phoneticSpelling;
  final String meaning;
  final String wordClass; // Kelas kata (n, v, a, adv, dll)
  final String exampleMoy;
  final String exampleIndonesia;
  bool isFavorite;

  Word({
    required this.id,
    required this.word,
    required this.phoneticSpelling,
    required this.meaning,
    required this.wordClass,
    required this.exampleMoy,
    required this.exampleIndonesia,
    this.isFavorite = false,
  });
}
