import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:app_feup/view/Widgets/ScheduleRow.dart';
import '../../../TestableWidget.dart';

void main() {
  group('ScheduleRow', () {
    final subject = 'SOPE';
    final begin = '10:00';
    final end = '12:00';
    testWidgets('When given a single room', (WidgetTester tester) async {
      final rooms = ['B315'];
      final widget = makeTestableWidget(
          child: new ScheduleRow(
              subject: subject, rooms: rooms, begin: begin, end: end));

      await tester.pumpWidget(widget);
      final roomsKey = '$subject-$rooms-$begin-$end';

      expect(
          find.descendant(
              of: find.byKey(new Key(roomsKey)), matching: find.byType(Text)),
          findsOneWidget);
    });

    testWidgets('When given a single room', (WidgetTester tester) async {
      final rooms = ['B315', 'B316', 'B330'];
      final widget = makeTestableWidget(
          child: new ScheduleRow(
              subject: subject, rooms: rooms, begin: begin, end: end));

      await tester.pumpWidget(widget);
      final roomsKey = '$subject-$rooms-$begin-$end';

      expect(
          find.descendant(
              of: find.byKey(new Key(roomsKey)), matching: find.byType(Text)),
          findsNWidgets(3));
    });
  });
}
