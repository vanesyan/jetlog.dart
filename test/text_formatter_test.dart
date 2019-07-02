import 'dart:convert' show utf8;

import 'package:test/test.dart';
import 'package:jetlog/jetlog.dart'
    show Dur, DTM, Str, Obj, Field, Level, Loggable;
import 'package:jetlog/formatters.dart' show TextFormatter;

import 'package:jetlog/src/record_impl.dart';

class Klass extends Loggable {
  Klass(this.dur, this.name);

  final String name;
  final Duration dur;

  @override
  Iterable<Field> toFields() {
    final result = <Field>{};

    result..add(Str('name', name))..add(Dur('dur', dur));

    return result;
  }
}

void main() {
  group('TextFormatter', () {
    test('formats correctly with defaults', () {
      final encoder1 = TextFormatter((
              {name, level, timestamp, message, fields}) =>
          '$name $level $timestamp $message $fields'.trim());
      final encoder2 =
          TextFormatter(({name, level, timestamp, message, fields}) => '');

      final timestamp = DateTime.now();
      const level = Level.info;
      const message = 'Test';
      final record = RecordImpl(
          name: null,
          timestamp: timestamp,
          level: level,
          message: message,
          fields: [const Dur('dur', Duration.zero), DTM('dtm', timestamp)]);
      final result1 = encoder1.call(record);
      final result2 = encoder2.call(record);

      expect(
          utf8.decode(result1),
          '${level.name} ${timestamp.toString()} $message '
          'dur=${Duration.zero} dtm=$timestamp\r\n');
      expect(result2, <int>[]);
    });

    test('TextFormatter.defaultFormatter formats correctly', () {
      final f = TextFormatter.defaultFormatter;

      final timestamp = DateTime.now();
      const level = Level.info;
      const message = 'Test';
      final record1 = RecordImpl(
          name: "str",
          timestamp: timestamp,
          level: level,
          message: message,
          fields: [const Dur('dur', Duration.zero), DTM('dtm', timestamp)]);
      final record2 = RecordImpl(
          name: null,
          timestamp: timestamp,
          level: level,
          message: message,
          fields: [const Dur('dur', Duration.zero), DTM('dtm', timestamp)]);
      final result1 = f.call(record1);
      final result2 = f.call(record2);

      expect(utf8.decode(result1),
          'str $timestamp [${level.name}]: $message dur=${Duration.zero} dtm=$timestamp\r\n');
      expect(utf8.decode(result2),
          '$timestamp [${level.name}]: $message dur=${Duration.zero} dtm=$timestamp\r\n');
    });

    test('supports nested fields with defaults', () {
      final encoder = TextFormatter((
              {name, level, timestamp, message, fields}) =>
          '$name $level $timestamp $message $fields'.trim());

      final timestamp = DateTime.now();
      const level = Level.info;
      const message = 'Test';
      final klass = Klass(Duration.zero, '__name__');
      final record = RecordImpl(
          name: null,
          timestamp: timestamp,
          level: level,
          message: message,
          fields: [
            const Dur('dur', Duration.zero),
            DTM('dtm', timestamp),
            Obj('klass', klass)
          ]);

      final result = encoder.call(record);

      expect(
          utf8.decode(result),
          '${level.name} ${timestamp.toString()} $message '
          'dur=0:00:00.000000 dtm=$timestamp '
          'klass.name=__name__ klass.dur=0:00:00.000000\r\n');
    });

    test('uses custom level encoder', () {
      final encoder = TextFormatter(
          ({name, timestamp, message, level, fields}) => '$level',
          formatLevel: (level) => '$level');

      const level = Level.info;
      final record = RecordImpl(
          name: null, timestamp: DateTime.now(), level: level, message: '');

      final result = encoder.call(record);

      expect(utf8.decode(result), '$level\r\n');
    });

    test('uses custom time encoder', () {
      final encoder = TextFormatter(
          ({name, timestamp, message, level, fields}) => '$timestamp',
          formatTimestamp: (timestamp) =>
              timestamp.millisecondsSinceEpoch.toString());

      final timestamp = DateTime.now();
      final record = RecordImpl(
          name: null, timestamp: timestamp, level: Level.info, message: '');

      final result = encoder.call(record);

      expect(utf8.decode(result), '${timestamp.millisecondsSinceEpoch}\r\n');
    });

    test('uses custom field encoder', () {
      final encoder = TextFormatter(
          ({name, timestamp, message, level, fields}) => '$fields',
          formatFields: (fields) => 'fields');

      final timestamp = DateTime.now();
      final record = RecordImpl(
          name: null,
          timestamp: timestamp,
          level: Level.info,
          message: '',
          fields: [const Dur('dur', Duration.zero)]);

      final result = encoder.call(record);

      expect(utf8.decode(result), 'fields\r\n');
    });
  });
}
