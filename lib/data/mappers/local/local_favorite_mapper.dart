class LocalFavoriteMapper {
  static Map<String, dynamic> toMap({
    required int quoteId,
  }) {
    final Map<String, dynamic> map = {'quote_id': quoteId};

    return map;
  }
}
