import 'package:nequo/domain/usecases/share_quote.dart';

abstract class ShareService {
  Future<void> share(ShareParams params);
}
