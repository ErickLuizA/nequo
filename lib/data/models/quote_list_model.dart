import 'package:nequo/domain/entities/quote_list.dart';

class QuoteListModel extends QuoteList {
  final int? id;
  final String? name;

  QuoteListModel({
    this.id,
    this.name,
  }) : super(
          id: id,
          name: name,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory QuoteListModel.fromMap(Map<String, dynamic> map) {
    return QuoteListModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
