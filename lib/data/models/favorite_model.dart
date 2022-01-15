import 'package:nequo/domain/entities/favorite.dart';

class FavoriteModel extends Favorite {
  FavoriteModel({
    int? id,
    required String content,
    required String author,
  }) : super(
          id: id ?? 0,
          content: content,
          author: author,
        );

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] ?? 0,
      content: map['content'],
      author: map['author'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
    };
  }
}
