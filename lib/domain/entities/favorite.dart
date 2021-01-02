import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  final int id;
  final String content;
  final String author;

  Favorite({
    this.id,
    this.content,
    this.author,
  });

  @override
  List<Object> get props => [id, content, author];
}
