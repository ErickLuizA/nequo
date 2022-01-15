import 'package:nequo/domain/entities/quote.dart';

class QuoteModel extends Quote {
  final int? listId;

  QuoteModel({
    int? id,
    String? content,
    String? author,
    this.listId,
  }) : super(
          id: id,
          content: content ?? '',
          author: author ?? '',
        );

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
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
