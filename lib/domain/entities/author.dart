import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String bio;
  final String createdAt;
  final String updatedAt;

  Author({
    required this.id,
    required this.name,
    required this.slug,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, slug, bio, createdAt, updatedAt];
}
