class UserData {
  static final UserData _singleton = UserData._internal();

  factory UserData() {
    return _singleton;
  }

  UserData._internal();

  String hostname = "https://long-covid-spa-backend.onrender.com";
  String? token;
  String? username;
  String? firstName;
  String? lastName;

  void setUser(String token, String username, String firstName, String lastName) {
    this.token = token;
    this.username = username;
    this.firstName = firstName;
    this.lastName = lastName;
  }
}