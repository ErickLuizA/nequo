import 'package:NeQuo/domain/usecases/usecase.dart';
import 'package:flutter/material.dart';

abstract class Share {
  Future<void> share(ShareParams params);
}

class ShareParams {
  String text;
  String subject;

  ShareParams({
    @required this.text,
    @required this.subject,
  });
}

class ShareQuote extends Usecase<void, ShareParams> {
  Share share;

  ShareQuote({
    @required this.share,
  });

  @override
  Future<void> call(ShareParams params) => this.share.share(params);
}
