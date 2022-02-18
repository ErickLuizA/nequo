import 'package:equatable/equatable.dart';

import 'package:nequo/domain/entities/category.dart';

class Quote extends Equatable {
  final int id;
  final String content;
  final String author;
  final bool isFavorited;

  final Category? category;

  Quote({
    required this.id,
    required this.content,
    required this.author,
    required this.isFavorited,
    this.category,
  });

  static final empty = () => Quote(
        id: 0,
        content: '',
        author: '',
        isFavorited: false,
      );

  @override
  String toString() {
    return 'Quote(id: $id, content: $content, author: $author, category: $category)';
  }

  @override
  List<Object?> get props => [id, content, author, category];

  Quote copyWith({
    int? id,
    String? content,
    String? author,
    bool? isFavorited,
    Category? category,
  }) {
    return Quote(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      isFavorited: isFavorited ?? this.isFavorited,
      category: category ?? this.category,
    );
  }
}
