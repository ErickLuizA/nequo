import 'package:equatable/equatable.dart';

class QuoteList extends Equatable {
  final int? id;
  final String? name;

  QuoteList({
    this.id,
    this.name,
  });

  @override
  List<Object> get props => [];
}
