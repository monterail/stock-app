enum Timespan {
  minute(value: 'minute'),
  hour(value: 'hour'),
  day(value: 'day'),
  week(value: 'week'),
  month(value: 'month'),
  quarter(value: 'quarter'),
  year(value: 'year');

  const Timespan({required this.value});

  final String value;
}
