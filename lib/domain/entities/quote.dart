import 'package:equatable/equatable.dart';

import 'author.dart';
import 'tag.dart';

class Quote extends Equatable {
  final int id;
  final bool isFavorited;
  final String content;
  final Author author;
  final List<Tag> tags;
  final String createdAt;
  final String updatedAt;

  Quote({
    required this.id,
    required this.isFavorited,
    required this.content,
    required this.author,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, isFavorited, content, author, tags, createdAt, updatedAt];
}
