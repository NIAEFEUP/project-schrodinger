import 'dart:async';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/home_page_model.dart';

/// Manages the app's Shared Preferences.
/// 
/// This database stores the user's student number, password and favorite
/// widgets.
class AppSharedPreferences {
  static final String userNumber = 'user_number';
  static final String userPw = 'user_password';
  static final int keyLength = 32;
  static final int ivLength = 16;
  static final String favoriteCards = 'favorite_cards';
  static final List<FAVORITE_WIDGET_TYPE> defaultFavoriteCards = [
    FAVORITE_WIDGET_TYPE.schedule,
    FAVORITE_WIDGET_TYPE.exams,
    FAVORITE_WIDGET_TYPE.busStops
  ];

  /// Saves the user's student number and password.
  static Future savePersistentUserInfo(user, pass) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userNumber, user);
    prefs.setString(userPw, encode(pass));
  }

  /// Deletes the user's student number and passoword.
  static Future removePersistentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userNumber);
    prefs.remove(userPw);
  }

  /// Returns a tuple containing the user's student number and password.
  /// 
  /// *Note:*
  /// * the first element in the tuple is the user's student number.
  /// * the second element in the tuple is the user's password, in plain text
  /// format.
  static Future<Tuple2<String, String>> getPersistentUserInfo() async {
    final String userNum = await getUserNumber();
    final String userPass = await getUserPassword();
    return  Tuple2(userNum, userPass);
  }

  /// Returns the user's student number.
  static Future<String> getUserNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNumber) ??
        ''; // empty string for the case it does not exist
  }

  /// Returns the user's password, in plain text format.
  static Future<String> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String pass = prefs.getString(userPw) ?? '';

    if (pass != '') {
      pass = decode(pass);
    } else {
      Logger().w('User password does not exist in shared preferences.');
    }

    return pass;
  }

  /// Replaces the user's favorite widgets with [newFavorites].
  static saveFavoriteCards(List<FAVORITE_WIDGET_TYPE> newFavorites) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        favoriteCards, newFavorites.map((a) => a.index.toString()).toList());
  }

  /// Returns a list containing the user's favorite widgets.
  static Future<List<FAVORITE_WIDGET_TYPE>> getFavoriteCards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedFavorites = prefs.getStringList(favoriteCards);
    if (storedFavorites == null) return defaultFavoriteCards;
    return storedFavorites
            .map((i) => FAVORITE_WIDGET_TYPE.values[int.parse(i)])
            .toList() ??
        defaultFavoriteCards;
  }

  /// Encrypts [plainText] and returns its Base64 representation.
  static String encode(String plainText) {
    final encrypter = _createEncrypter();
    return encrypter.encrypt(plainText).base64;
  }

  /// Decrypts [base64Text].
  static String decode(String base64Text) {
    final encrypter = _createEncrypter();
    return encrypter.decrypt64(base64Text);
  }

  /// Creates an [Encrypter] for encrypting and decrypting the user's password.
  static Encrypter _createEncrypter() {
    final key = Key.fromLength(keyLength);
    final iv = IV.fromLength(ivLength);
    return Encrypter(AES(key, iv));
  }
}
