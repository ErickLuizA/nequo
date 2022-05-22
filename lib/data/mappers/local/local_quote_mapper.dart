import 'dart:convert';

import 'package:nequo/domain/entities/quote.dart';

class LocalQuoteMapper {
  static Quote toEntity(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      content: map['content'],
      author: map['author'],
      authorSlug: map['author_slug'],
      isFavorited: map['favorite_id'] != null ? true : false,
    );
  }

  static Map<String, dynamic> toMap({
    int? id,
    int? serverId,
    String? content,
    String? author,
    String? authorSlug,
  }) {
    final Map<String, dynamic> map = {
      'content': content,
      'author': author,
      'author_slug': authorSlug,
    };

    if (id != null) map['id'] = id;
    if (serverId != null) map['server_id'] = serverId;

    return map;
  }

  static toJson(Quote quote) {
    return json.encode({
      'id': quote.id,
      'author': quote.author,
      'authorSlug': quote.authorSlug,
      'content': quote.content,
    });
  }

  static fromJson(String source) {
    return json.decode(source);
  }
}
