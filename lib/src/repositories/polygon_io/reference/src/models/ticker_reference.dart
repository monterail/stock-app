import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticker_reference.g.dart';

@autoequalMixin
@JsonSerializable()
class TickerReference extends Equatable with _$TickerReferenceAutoequalMixin {
  final String ticker;
  final String name;

  const TickerReference({
    required this.ticker,
    required this.name,
  });

  factory TickerReference.fromJson(Map<String, dynamic> json) =>
      _$TickerReferenceFromJson(json);
  Map<String, dynamic> toJson() => _$TickerReferenceToJson(this);
}
