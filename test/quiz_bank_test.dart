import 'package:flutter_test/flutter_test.dart';

import 'package:gummy_cloud/quiz/quiz_catalog.dart';

void main() {
  test('quiz bank has four topics with five questions each', () {
    expect(kQuizTopicBank.length, 4);
    for (final topic in kQuizTopicBank) {
      expect(topic.questions.length, 5, reason: topic.id);
    }
  });
}
