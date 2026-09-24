import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';

void main() {
  testWidgets('renders the Phase 1 foundation screen', (tester) async {
    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.text('Notaku Sejarah V2'), findsOneWidget);
    expect(find.text('Phase 1 — Foundation & CI/CD'), findsOneWidget);
  });
}
