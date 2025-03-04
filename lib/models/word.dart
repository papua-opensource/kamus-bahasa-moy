class Word {
  final String word;
  final String phoneticSpelling;
  final String meaning;
  final String wordClass; // Kelas kata (n, v, a, adv, dll)
  final String exampleMoy;
  final String exampleIndonesia;
  bool isFavorite;

  Word({
    required this.word,
    required this.phoneticSpelling,
    required this.meaning,
    required this.wordClass,
    required this.exampleMoy,
    required this.exampleIndonesia,
    this.isFavorite = false,
  });
}

// Dummy data untuk pengujian dengan kelas kata yang jelas
List<Word> dummyWords = [
  Word(
    word: 'ABA',
    phoneticSpelling: '[aba]',
    meaning: 'bete; talas',
    wordClass: 'n',
    exampleMoy: 'Aba iya kanam koya saru minam.',
    exampleIndonesia: 'Bete itu makanan pokok orang dulu.',
    isFavorite: false,
  ),
  Word(
    word: 'ABLETSING',
    phoneticSpelling: '[abletsiŋ]',
    meaning: 'terbalik',
    wordClass: 'a',
    exampleMoy: 'Kurusi abletsing iyo waet weng.',
    exampleIndonesia: 'Kursi terbalik di atas meja.',
    isFavorite: true,
  ),
  Word(
    word: 'ABRAK',
    phoneticSpelling: '[abrak]',
    meaning: 'langit',
    wordClass: 'n',
    exampleMoy: 'Abrak masere ino dima.',
    exampleIndonesia: 'Langit biru itu indah.',
    isFavorite: false,
  ),
  Word(
    word: 'ADAT',
    phoneticSpelling: '[adat]',
    meaning: 'kebiasaan; adat',
    wordClass: 'n',
    exampleMoy: 'Adat Moy pena kora masere.',
    exampleIndonesia: 'Adat Moy sangat kaya dan indah.',
    isFavorite: true,
  ),
  Word(
    word: 'BELAJAR',
    phoneticSpelling: '[belajar]',
    meaning: 'mempelajari',
    wordClass: 'v',
    exampleMoy: 'Sia belajar bahasa Moy.',
    exampleIndonesia: 'Dia belajar bahasa Moy.',
    isFavorite: false,
  ),
  Word(
    word: 'CEPAT',
    phoneticSpelling: '[cepat]',
    meaning: 'tidak lambat',
    wordClass: 'a',
    exampleMoy: 'Sia bergerak cepat.',
    exampleIndonesia: 'Dia bergerak cepat.',
    isFavorite: true,
  ),
];

// Kata untuk ditampilkan sebagai kata hari ini
Word dailyWord = dummyWords[1]; // ABLETSING

// Fungsi untuk mendapatkan nama penuh dari kelas kata
String getFullWordClass(String wordClass) {
  switch (wordClass) {
    case 'n':
      return 'nomina';
    case 'v':
      return 'verba';
    case 'a':
      return 'adjektiva';
    case 'adv':
      return 'adverbia';
    case 'pron':
      return 'pronomina';
    case 'num':
      return 'numeralia';
    case 'p':
      return 'partikel';
    default:
      return wordClass;
  }
}
