import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:share/share.dart' as FlutterShare;

class ShareImpl implements Share {
  @override
  Future<void> share(ShareParams params) {
    return FlutterShare.Share.share(params.text, subject: params.subject);
  }
}
