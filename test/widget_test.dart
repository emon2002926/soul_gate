import 'package:flutter_test/flutter_test.dart';
import 'package:soul_gate/core/constants/app_strings.dart';

void main() {
  test('App basic configuration smoke test', () {
    expect(AppStrings.instance.appName, 'SOULGATE');
  });
}
