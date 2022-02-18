import 'package:nequo/domain/entities/category.dart';

class LocalCategoryMapper {
  static Category? toEntity(Map<String, dynamic> map) {
    if (!map['category_id']) return null;

    return Category(
      id: map['category_id'],
      name: map['category_name'],
    );
  }

  static Map<String, dynamic> toMap({
    int? id,
    required String name,
  }) {
    final Map<String, dynamic> map = {'name': name};

    if (id != null) map['id'] = id;

    return map;
  }
}
