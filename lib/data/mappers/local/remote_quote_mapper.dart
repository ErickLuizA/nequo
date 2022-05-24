import 'package:nequo/domain/entities/quote.dart';

class RemoteQuoteOfTheDayMapper {
  static Quote toEntity(Map<String, dynamic> map) {
    return Quote(
      id: map['quote']['id'],
      content: map['quote']['content'],
      author: map['quote']['author'],
      authorSlug: map['quote']['author_slug'],
      isFavorited: false,
    );
  }
}

class RemoteQuoteMapper {
  static Quote toEntity(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      content: map['content'],
      author: map['author'],
      authorSlug: map['author_slug'],
      isFavorited: false,
    );
  }
}
