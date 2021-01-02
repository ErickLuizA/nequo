import 'package:NeQuo/domain/entities/quote.dart';

// ignore: must_be_immutable
class QuoteModel extends Quote {
  final int listId;

  QuoteModel({
    int id,
    String content,
    String author,
    this.listId,
  }) : super(
          id: id,
          content: content,
          author: author,
        );

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return QuoteModel(
      id: map['id'],
      content: map['content'],
      author: map['author'],
      listId: map['listId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'listId': listId,
    };
  }
}
