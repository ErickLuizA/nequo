import 'package:nequo/domain/entities/quote.dart';

class Favorite extends Quote {
  final int? id;
  final String content;
  final String author;

  Favorite({
    this.id,
    required this.content,
    required this.author,
  }) : super(id: id ?? 1, author: author, content: content);

  @override
  List<Object> get props => [id ?? 1, content, author];
}
