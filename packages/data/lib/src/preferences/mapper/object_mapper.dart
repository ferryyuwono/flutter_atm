abstract class ObjectMapper<T> {
  T mapToObject(dynamic json);
  Map<String, dynamic> mapToJson(T object);
}
