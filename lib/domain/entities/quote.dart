import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final int id;
  final String content;
  final String author;
  final String authorSlug;
  final bool isFavorited;

  Quote({
    required this.id,
    required this.content,
    required this.author,
    required this.authorSlug,
    required this.isFavorited,
  });

  static final empty = () => Quote(
        id: 0,
        content: '',
        author: '',
        authorSlug: '',
        isFavorited: false,
      );

  @override
  String toString() {
    return 'Quote(id: $id, content: $content, author: $author, authorSlug: $authorSlug)';
  }

  @override
  List<Object?> get props => [id, content, author, authorSlug];

  Quote copyWith({
    int? id,
    String? content,
    String? author,
    String? authorSlug,
    bool? isFavorited,
  }) {
    return Quote(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      authorSlug: authorSlug ?? this.authorSlug,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
