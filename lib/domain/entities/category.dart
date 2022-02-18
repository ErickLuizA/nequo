import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  @override
  String toString() => 'Category(id: $id, name: $name)';

  @override
  List<Object> get props => [id, name];
}
