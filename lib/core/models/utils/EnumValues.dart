class EnumValues<T, R> {
  Map<R, T> map;
  Map<T, R>? reverseMap;

  EnumValues(this.map);

  Map<T, R>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}