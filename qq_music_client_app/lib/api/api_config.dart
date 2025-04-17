class ApiConfig {
  static String protocol = "http";
  static String host = "10.0.2.2";
  static int port = 3000;

  static String get target => "$protocol://$host:$port/";
}