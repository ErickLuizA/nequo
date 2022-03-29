import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final int id;
  final String content;
  final String author;
  final bool isFavorited;

  Quote({
    required this.id,
    required this.content,
    required this.author,
    required this.isFavorited,
  });

  static final empty = () => Quote(
        id: 0,
        content: '',
        author: '',
        isFavorited: false,
      );

  @override
  String toString() {
    return 'Quote(id: $id, content: $content, author: $author)';
  }

  @override
  List<Object?> get props => [id, content, author];

  Quote copyWith({
    int? id,
    String? content,
    String? author,
    bool? isFavorited,
  }) {
    return Quote(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
