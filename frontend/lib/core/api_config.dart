class ApiConfig {
  static const String baseUrl = 'http://69.62.77.6:9999/api';
  
  static String get loginUrl => '$baseUrl/auth/login';
  static String get signupUrl => '$baseUrl/auth/signup';
  static String get checkInUrl => '$baseUrl/attendance/check-in';
  static String get checkOutUrl => '$baseUrl/attendance/check-out';
  static String get attendanceListUrl => '$baseUrl/attendance';
  static String get leaveApplyUrl => '$baseUrl/leave/apply';
  static String get leaveListUrl => '$baseUrl/leave/list';
}

