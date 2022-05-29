import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class RemoteQuoteOfTheDayMapper {
  static Quote toEntity(Map<String, dynamic> map) {
    return Quote(
      id: map['quote']['id'],
      content: map['quote']['content'],
      author: map['quote']['author'],
      authorSlug: map['quote']['author_slug'],
      isFavorited: false,
    );
  }
}

class RemoteQuoteMapper {
  static Quote toEntity(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      content: map['content'],
      author: map['author'],
      authorSlug: map['author_slug'],
      isFavorited: false,
    );
  }

  static PaginatedResponse<List<Quote>> toPaginatedQuoteList(
      Map<String, dynamic> map) {
    return PaginatedResponse(
      data: (map['data'] as List<dynamic>)
          .map((e) => RemoteQuoteMapper.toEntity(e))
          .toList(),
      currentPage: map['meta']['current_page'],
      firstPage: map['meta']['first_page'],
      lastPage: map['meta']['last_page'],
      perPage: map['meta']['per_page'],
      total: map['meta']['total'],
    );
  }
}
