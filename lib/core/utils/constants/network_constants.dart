abstract class NetworkConstants {
  const NetworkConstants();

  static const baseUrl = 'http://ENTER IP ADDRESS HERE:3000/api/v1'; //Using IP Address so that Android devices work. IOS will work regardless.
  static const authority = 'ENTER IP ADDRESS HERE:3000';
  static const apiUrl = '/api/v1';
  static const headers = {'Content-Type': 'application/json; charset=UTF-8'};
  static const pageSize = 10;
}
