// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

library global;

String endpoint = "http://absensi.ppns.eepis.tech";
String endpoint_get_all = endpoint + "/location/get_all.php";
String endpoint_monitor_karyawan_get_all = endpoint + "/monitor_karyawan/get_all.php";

String username = "admin";
String password = "admin";

bool isLoggedIn = false;
bool loadingAutologin = false;