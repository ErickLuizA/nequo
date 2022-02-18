import 'package:nequo/domain/services/share_service.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class ShareParams {
  String text;
  String subject;

  ShareParams({
    required this.text,
    required this.subject,
  });
}

class ShareQuote extends Usecase<void, ShareParams> {
  ShareService shareService;

  ShareQuote({required this.shareService});

  @override
  Future<void> call(ShareParams params) => shareService.share(params);
}
