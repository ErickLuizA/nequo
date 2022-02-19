import 'dart:convert';

import 'package:nequo/data/mappers/local/local_category_mapper.dart';
import 'package:nequo/domain/entities/quote.dart';

class LocalQuoteMapper {
  static Quote toEntity(Map<String, dynamic> map) {
    final category = LocalCategoryMapper.toEntity(map);

    return Quote(
      id: map['id'],
      content: map['content'],
      author: map['author'],
      isFavorited: map['favorite_id'] != null ? true : false,
      category: category,
    );
  }

  static Map<String, dynamic> toMap({
    int? id,
    int? categoryId,
    int? serverId,
    String? content,
    String? author,
  }) {
    final Map<String, dynamic> map = {
      'content': content,
      'author': author,
    };

    if (id != null) map['id'] = id;
    if (categoryId != null) map['category_id'] = categoryId;
    if (serverId != null) map['server_id'] = serverId;

    return map;
  }

  static toJson(Quote quote) {
    return json.encode({
      'id': quote.id,
      'author': quote.author,
      'content': quote.content,
      'category': quote.category,
    });
  }

  static fromJson(String source) {
    return json.decode(source);
  }
}
