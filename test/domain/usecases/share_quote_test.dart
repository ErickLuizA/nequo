import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockShare extends Mock implements Share {}

void main() {
  ShareQuote shareQuote;
  MockShare mockShare;

  setUp(() {
    mockShare = MockShare();
    shareQuote = ShareQuote(share: mockShare);
  });

  final params = ShareParams(text: 'Hello', subject: 'A');

  test('should call share with given params', () async {
    await shareQuote(params);

    verify(mockShare.share(params));
    verifyNoMoreInteractions(mockShare);
  });
}
