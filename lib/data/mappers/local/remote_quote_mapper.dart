import 'package:nequo/domain/entities/quote.dart';

class RemoteQuoteMapper {
  static Quote toEntity(Map<String, dynamic> map) {
    return Quote(
      id: map['quote']['id'],
      content: map['quote']['content'],
      author: map['quote']['author'],
      isFavorited: false,
    );
  }
}
