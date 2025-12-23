import 'package:crypto/crypto.dart';
import 'dart:convert';

class GravatarUtils {
  static String getGravatarUrl(String email, {int size = 200}) {
    final hash = md5.convert(utf8.encode(email.trim().toLowerCase())).toString();
    return 'https://www.gravatar.com/avatar/$hash?s=$size&d=identicon';
  }
}