import 'package:flutter_test/flutter_test.dart';
import 'package:canon/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('GptViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
