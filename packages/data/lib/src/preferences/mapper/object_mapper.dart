abstract class ObjectMapper<T> {
  T mapToObject(String? jsonString);
  String mapToJsonString(T object);
}
