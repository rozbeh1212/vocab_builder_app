class Word {
  final String word;
  final String? meaning;
  final String? example;

  Word({
    required this.word,
    this.meaning,
    this.example,
  });

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
      'example': example,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] as String,
      meaning: map['meaning'] as String?,
      example: map['example'] as String?,
    );
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] as String,
      meaning: json['meaning'],
      example: json['example'],
    );
  }
}
