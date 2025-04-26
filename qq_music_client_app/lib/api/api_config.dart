class ApiConfig {
  static String protocol = "http";
  static String host = "10.0.2.2";
  static int port = 3000;

  static String get target => "$protocol://$host:$port/";

  static String defaultAvatarUrl = "https://y.qq.com/music/photo_new/T001R300x300M000003D85G41BVvic_0.jpg?max_age=2592000";
}