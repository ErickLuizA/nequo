import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  int? id;
  String content;
  String author;

  Quote({
    this.id,
    required this.content,
    required this.author,
  });

  @override
  List<Object> get props => [content, author];
}
