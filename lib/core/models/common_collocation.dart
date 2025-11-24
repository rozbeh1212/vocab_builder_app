import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'common_collocation.g.dart';

@HiveType(typeId: 5) // Unique typeId for CommonCollocation
@JsonSerializable()
class CommonCollocation extends HiveObject {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String collocation;
  @HiveField(2)
  final String example;

  CommonCollocation({
    required this.type,
    required this.collocation,
    required this.example,
  });

  factory CommonCollocation.fromJson(Map<String, dynamic> json) => _$CommonCollocationFromJson(json);
  Map<String, dynamic> toJson() => _$CommonCollocationToJson(this);

  @override
  String toString() {
    return 'CommonCollocation(type: $type, collocation: $collocation, example: $example)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommonCollocation &&
        other.type == type &&
        other.collocation == collocation &&
        other.example == example;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        collocation.hashCode ^
        example.hashCode;
  }
}
