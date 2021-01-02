import 'package:NeQuo/domain/entities/quote.dart';
import 'package:flutter/material.dart';

abstract class QuoteOfTheDayState {}

class InitialState extends QuoteOfTheDayState {}

class LoadingState extends QuoteOfTheDayState {}

class SuccessState extends QuoteOfTheDayState {
  final Quote quote;

  SuccessState({
    @required this.quote,
  });
}

class ErrorState extends QuoteOfTheDayState {}
