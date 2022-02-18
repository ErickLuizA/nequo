import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/load_categories.dart';
import 'package:nequo/presentation/home/bloc/home_list_bloc.dart';
import 'package:nequo/presentation/home/bloc/home_list_event.dart';
import 'package:nequo/presentation/home/bloc/home_list_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoadCategories extends Mock implements LoadCategories {}

void main() {
  HomeBloc homeBloc;
  MockLoadCategories mockLoadCategories;

  setUp(() {
    mockLoadCategories = MockLoadCategories();
    homeBloc = HomeBloc(
      loadCategories: mockLoadCategories,
    );
  });

  group('GetCategories', () {
    test('should get data from LoadCategories usecase', () async {
      when(mockLoadCategories(any))
          .thenAnswer((_) async => Right(List<Category>()));

      homeBloc.add(
        GetCategories(),
      );

      await untilCalled(mockLoadCategories(any));

      verify(mockLoadCategories(any));
    });

    test(
        'should emit Loading and Empty in order when data gotten successfully but is Empty',
        () async {
      when(mockLoadCategories(any))
          .thenAnswer((_) async => Right(List<Category>()));

      expect(
        homeBloc,
        emitsInOrder([
          isA<LoadingListState>(),
          isA<EmptyListState>(),
        ]),
      );

      homeBloc.add(
        GetCategories(),
      );
    });

    test(
        'should emit Loading and Success in order when data gotten successfully',
        () async {
      when(mockLoadCategories(any))
          .thenAnswer((_) async => Right([Category(name: 'name')]));

      expect(
        homeBloc,
        emitsInOrder([
          isA<LoadingListState>(),
          isA<SuccessListState>(),
        ]),
      );

      homeBloc.add(
        GetCategories(),
      );
    });

    test('should emit Loading and Error in order when getting data fails',
        () async {
      when(mockLoadCategories(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      expect(
        homeBloc,
        emitsInOrder([
          isA<LoadingListState>(),
          isA<ErrorListState>(),
        ]),
      );

      homeBloc.add(
        GetCategories(),
      );
    });
  });
}
