import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Quote extends Equatable {
  int id;
  String content;
  String author;

  Quote({
    this.id,
    this.content,
    this.author,
  });

  @override
  List<Object> get props => [id, content, author];
}
