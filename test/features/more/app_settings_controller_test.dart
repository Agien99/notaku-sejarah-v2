import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/more/application/app_settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loads the persisted text size', () async {
    SharedPreferences.setMockInitialValues({'app_text_size': 'large'});
    final controller = AppSettingsController();

    await controller.load();

    expect(controller.textSize, AppTextSize.large);
    controller.dispose();
  });

  test('persists a changed text size', () async {
    final controller = AppSettingsController();

    await controller.setTextSize(AppTextSize.small);

    final preferences = await SharedPreferences.getInstance();
    expect(controller.textSize, AppTextSize.small);
    expect(preferences.getString('app_text_size'), 'small');
    controller.dispose();
  });

  test('ignores an unknown persisted text size', () async {
    SharedPreferences.setMockInitialValues({'app_text_size': 'unknown'});
    final controller = AppSettingsController();

    await controller.load();

    expect(controller.textSize, AppTextSize.standard);
    controller.dispose();
  });
}
