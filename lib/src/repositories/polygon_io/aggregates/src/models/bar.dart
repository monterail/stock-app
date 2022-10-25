import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bar.g.dart';

@autoequalMixin
@JsonSerializable()
class Bar extends Equatable with _$BarAutoequalMixin {
  @JsonKey(name: 't')
  final int timestamp;
  @JsonKey(name: 'c')
  final double closePrice;

  factory Bar.fromJson(Map<String, dynamic> json) => _$BarFromJson(json);

  const Bar(this.timestamp, this.closePrice);
  Map<String, dynamic> toJson() => _$BarToJson(this);
}
