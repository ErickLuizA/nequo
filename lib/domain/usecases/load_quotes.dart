import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadQuotesParams {
  final int page;
  final int perPage;

  LoadQuotesParams({this.page = 1, this.perPage = 20});
}

class LoadQuotes
    implements UseCase<PaginatedResponse<List<Quote>>, LoadQuotesParams> {
  QuoteRepository quoteRepository;

  LoadQuotes({required this.quoteRepository});

  @override
  Future<Either<Failure, PaginatedResponse<List<Quote>>>> call(
      LoadQuotesParams params) async {
    return await quoteRepository.findAll(params);
  }
}
