import 'package:nequo/domain/services/share_service.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:share/share.dart';

class ShareServiceImpl implements ShareService {
  @override
  Future<void> share(ShareParams params) {
    return Share.share(params.text, subject: params.subject);
  }
}
