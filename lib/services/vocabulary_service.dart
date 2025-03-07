import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word.dart';

class VocabularyService {
  static const String baseUrl = 'https://api.kastauterjemahan.web.id/v1';

  // Mengambil daftar kata dari API
  static Future<VocabularyResponse> getVocabulary(
      {int page = 1,
      int limit = 15,
      String? startWith,
      int languageId = 2}) async {
    // Buat Uri dengan query parameters
    final uri = Uri.parse('$baseUrl/kosakata/').replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
      'language_id': languageId.toString(),
      if (startWith != null && startWith.isNotEmpty) 'start_with': startWith,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return VocabularyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load vocabulary data: ${response.statusCode}');
    }
  }

  // Fungsi baru untuk mendapatkan detail kata berdasarkan ID
  static Future<ApiWord> getWordDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/kosakata/$id/'));

    if (response.statusCode == 200) {
      return ApiWord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load word detail: ${response.statusCode}');
    }
  }

  // Mengubah hasil respons API menjadi model Word
  static Word mapApiWordToWord(ApiWord apiWord) {
    return Word(
      id: apiWord.id,
      word: apiWord.text.toUpperCase(),
      phoneticSpelling: '[${apiWord.pronunciation}]',
      meaning: apiWord.meanings.join('; '),
      wordClass: apiWord.wordClassId.abbreviation,
      exampleMoy: apiWord.exampleOriginal,
      exampleIndonesia: apiWord.exampleTranslation,
      isFavorite: false,
    );
  }
}

// Model untuk menyimpan respons API
class VocabularyResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ApiWord> results;

  VocabularyResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory VocabularyResponse.fromJson(Map<String, dynamic> json) {
    return VocabularyResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: List<ApiWord>.from(
        json['results'].map((x) => ApiWord.fromJson(x)),
      ),
    );
  }
}

// Model untuk data kata dari API
class ApiWord {
  final int id;
  final String text;
  final String pronunciation;
  final List<String> meanings;
  final String exampleOriginal;
  final String exampleTranslation;
  final WordClassId wordClassId;
  final LanguageId languageId;

  ApiWord({
    required this.id,
    required this.text,
    required this.pronunciation,
    required this.meanings,
    required this.exampleOriginal,
    required this.exampleTranslation,
    required this.wordClassId,
    required this.languageId,
  });

  factory ApiWord.fromJson(Map<String, dynamic> json) {
    return ApiWord(
      id: json['id'],
      text: json['text'],
      pronunciation: json['pronunciation'],
      meanings: List<String>.from(json['meanings']),
      exampleOriginal: json['example_original'] ?? '',
      exampleTranslation: json['example_translation'] ?? '',
      wordClassId: WordClassId.fromJson(json['word_class_id']),
      languageId: LanguageId.fromJson(json['language_id']),
    );
  }
}

class WordClassId {
  final int id;
  final String name;
  final String abbreviation;

  WordClassId({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory WordClassId.fromJson(Map<String, dynamic> json) {
    return WordClassId(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }
}

class LanguageId {
  final int id;
  final String name;

  LanguageId({
    required this.id,
    required this.name,
  });

  factory LanguageId.fromJson(Map<String, dynamic> json) {
    return LanguageId(
      id: json['id'],
      name: json['name'],
    );
  }
}
