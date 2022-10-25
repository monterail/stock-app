part of 'chart_bloc.dart';

@autoequalMixin
class TimespanSettings extends Equatable with _$TimespanSettingsAutoequalMixin {
  final Timespan timespan;
  final int multiplier;
  final Duration duration;

  const TimespanSettings({
    required this.timespan,
    required this.multiplier,
    required this.duration,
  });
}
