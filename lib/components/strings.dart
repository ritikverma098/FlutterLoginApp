RegExp emailRexExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

RegExp passwordRexExp =
RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$');

RegExp specialCharRexExp =
RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])');