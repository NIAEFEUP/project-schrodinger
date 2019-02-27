import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';

class NetworkRouter {
  static Future<Map<String, dynamic>> login(
      String user, String pass, String faculty, bool persistentSession) async {
    final String url =
        NetworkRouter.getBaseUrl(faculty) + 'mob_val_geral.autentica';
    final Map<String, dynamic> res = Map<String, dynamic>();
    final http.Response response =
        await http.post(url, body: {"pv_login": user, "pv_password": pass});
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['authenticated']) {
        res['authenticated'] = true;
        res['studentNumber'] = responseBody['codigo'];
        res['faculty'] = faculty;
        res['persistentSession'] = persistentSession;
        if (persistentSession) res['password'] = pass;
        res['type'] = responseBody['tipo'];
        res['cookies'] = extractCookies(response.headers);
        print('Login successful');
      }
    } else {
      res['authenticated'] = false;
      print('Login failed');
    }
    return res;
  }

  static String extractCookies(response) {
    final List<String> cookieList = List<String>();
    final String cookies = response['set-cookie'];
    if (cookies != null) {
      final List<String> rawCookies = cookies.split(',');
      for (var c in rawCookies) {
        cookieList.add(Cookie.fromSetCookieValue(c).toString());
      }
    }
    return cookieList.join(';');
  }

  static Future<Map<String, dynamic>> getProfile(
      Map<String, dynamic> session) async {
    Map<String, dynamic> profile = Map<String, dynamic>();
    final url =
        NetworkRouter.getBaseUrlFromSession(session) + 'mob_fest_geral.perfil?';
    final response = await getWithCookies(
        url, {"pv_codigo": session['studentNumber']}, session['cookies']);
    if (response.statusCode == 200) {
      profile = json.decode(response.body);
    }
    return profile;
  }

  static Future<Map<String, dynamic>> getUcs(
      Map<String, dynamic> session) async {
    Map<String, dynamic> ucs = Map<String, dynamic>();
    final url =
        NetworkRouter.getBaseUrlFromSession(session) + 'mob_fest_geral.ucurr_inscricoes_corrente?';
    final response = await getWithCookies(
        url, {"pv_codigo": session['studentNumber']}, session['cookies']);
    if (response.statusCode == 200) {
      ucs = json.decode(response.body)[0];
    }
    return ucs;
  }

  static Future<http.Response> getWithCookies(
      String baseUrl, Map<String, String> query, String cookies) {
    final URLQueryParams params = new URLQueryParams();
    query.forEach((key, value) {
      params.append(key, value);
    });

    final url = baseUrl + params.toString();

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = cookies;

    return http.get(url, headers: headers);
  }

  static String getBaseUrl(String faculty) {
    return 'https://sigarra.up.pt/$faculty/pt/';
  }

  static String getBaseUrlFromSession(Map<String, dynamic> session) {
    return NetworkRouter.getBaseUrl(session['faculty']);
  }
}