import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'persian_context.g.dart';

/// [PersianContext] represents an immutable model for Persian language context.
///
/// This class is designed for persistence with Hive and includes detailed
/// information like translations, usage notes, and collocations to help users
/// understand word usage in a Persian cultural and linguistic context.
@JsonSerializable()
@immutable
@HiveType(typeId: 2)
class PersianContext {
  @HiveField(0)
  final String meaning;

  @HiveField(1)
  final String example;

  @HiveField(2)
  final String? usageNotes;

  @HiveField(3)
  final List<String>? collocations;

  @HiveField(4)
  final String? prepositionUsage;

  const PersianContext({
    required this.meaning,
    required this.example,
    this.usageNotes,
    this.collocations,
    this.prepositionUsage,
  });

  /// Creates a copy of this [PersianContext] instance with optional new values.
  PersianContext copyWith({
    String? meaning,
    String? example,
    String? usageNotes,
    List<String>? collocations,
    String? prepositionUsage,
  }) {
    return PersianContext(
      meaning: meaning ?? this.meaning,
      example: example ?? this.example,
      usageNotes: usageNotes ?? this.usageNotes,
      collocations: collocations ?? this.collocations,
      prepositionUsage: prepositionUsage ?? this.prepositionUsage,
    );
  }

  @override
  String toString() {
    return 'PersianContext(meaning: $meaning, example: $example, usageNotes: $usageNotes, collocations: $collocations, prepositionUsage: $prepositionUsage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersianContext &&
        other.meaning == meaning &&
        other.example == example &&
        other.usageNotes == usageNotes &&
        listEquals(other.collocations, collocations) &&
        other.prepositionUsage == prepositionUsage;
  }

  @override
  int get hashCode {
    return meaning.hashCode ^
        example.hashCode ^
        usageNotes.hashCode ^
        collocations.hashCode ^
        prepositionUsage.hashCode;
  }

  factory PersianContext.fromJson(Map<String, dynamic> json) =>
      _$PersianContextFromJson(json);

  Map<String, dynamic> toJson() => _$PersianContextToJson(this);
}
