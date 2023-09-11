class Urls {
  Urls._();

  static const String _baseUrl = 'http://20.239.87.34:8080';
  static String registration = '$_baseUrl/signup';
  static String login = '$_baseUrl/login';
  static String addBooks = '$_baseUrl/books';
  static String displayBooksList = '$_baseUrl/books?limit=10&page=1';
  static String addPublishers = '$_baseUrl/publishers';
  static String addCategories= '$_baseUrl/category';
  static String addAuthors= '$_baseUrl/authors';
}
