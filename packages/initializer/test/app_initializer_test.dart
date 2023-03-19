import 'package:flutter_test/flutter_test.dart';
import 'package:initializer/initializer.dart';
import 'package:mocktail/mocktail.dart';

class MockAppConfig extends Mock implements ApplicationConfig {}

void main() {
  group('AppInitializer', () {
    final appConfig = MockAppConfig();
    final appInitializer = AppInitializer(appConfig);

    setUp(() {});

    test('when init is called, should call app config init', () async {
      // Given
      when(() => appConfig.init())
        .thenAnswer((_) async => Future.value(true));

      // When
      final result = await appInitializer.init();

      // Expect
      expect(result, true);
      verify(appConfig.init).called(1);
    });

    tearDown(() {});
  });
}
