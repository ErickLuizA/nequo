import 'package:NeQuo/domain/entities/favorite.dart';

// ignore: must_be_immutable
class FavoriteModel extends Favorite {
  FavoriteModel({
    int id,
    String content,
    String author,
  }) : super(
          id: id,
          content: content,
          author: author,
        );

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FavoriteModel(
      id: map['id'],
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
