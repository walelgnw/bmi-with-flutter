
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  late int _selectedThemeIndex;
  final secure_storage = const FlutterSecureStorage();
  //late SharedPreferences prefs;
  late Color _active;
  late Color _activeLight;
  ThemeProvider({required int theme}) {
    if (theme == 0) {
      _active = ColorProvider().primaryDeepOrange;
      _activeLight = ColorProvider().primaryOrange;
    } else if (theme == 1) {
      _active = ColorProvider().primaryDeepBlue;
      _activeLight = ColorProvider().primaryBlue;
    }else if (theme == 2) {
      _active = ColorProvider().primaryDeepRed;
      _activeLight = ColorProvider().primaryRed;
    }else if (theme == 3) {
      _active = ColorProvider().primaryDeepTeal;
      _activeLight = ColorProvider().primaryTeal;
    }else if (theme == 4) {
      _active = ColorProvider().primaryDeepBlack;
      _activeLight = ColorProvider().primaryBlack;
    } else if(theme == 5){
      _active = ColorProvider().primaryDeepEbs;
      _activeLight = ColorProvider().primaryOrange;
    } else {
    _active = ColorProvider().primaryDeepOrange;
    _activeLight = ColorProvider().primaryOrange;
    }
    _selectedThemeIndex = theme;
    _setupBars(theme);
    //ready for test
  }

  ThemeData get getTheme => _selectedTheme;
  int getThemeIndex(){
    return _selectedThemeIndex;
  }
  Color get getColor => _active;
  Color get getLightColor => _activeLight;

  Future<void> changeTheme(int theme) async {
    if (theme == 0) {
      _active = ColorProvider().primaryDeepOrange;
      _activeLight = ColorProvider().primaryOrange;
    } else if (theme == 1) {
      _active = ColorProvider().primaryDeepBlue;
      _activeLight = ColorProvider().primaryBlue;
    }else if (theme == 2) {
      _active = ColorProvider().primaryDeepRed;
      _activeLight = ColorProvider().primaryRed;
    }else if (theme == 3) {
      _active = ColorProvider().primaryDeepTeal;
      _activeLight = ColorProvider().primaryTeal;
    }else if (theme == 4) {
      _active = ColorProvider().primaryDeepBlack;
      _activeLight = ColorProvider().primaryBlack;
    } else if (theme == 5) {
      _active = ColorProvider().primaryDeepEbs;
      _activeLight = ColorProvider().primaryEbs;
    } else {
      _active = ColorProvider().primaryDeepOrange;
      _activeLight = ColorProvider().primaryOrange;
    }
    _selectedThemeIndex = theme;
    secure_storage.write(key: "theme", value: theme.toString());
    //await prefs.setInt("theme", theme);
//notifying all the listeners(consumers) about the change.
    notifyListeners();
    _setupBars(theme);
  }


  Color _themeColor(int theme) {
    switch (theme) {
      case 0:
        return ColorProvider().primaryDeepOrange;
      case 1:
        return ColorProvider().primaryDeepBlue;
      case 2:
        return ColorProvider().primaryDeepRed;
      case 3:
        return ColorProvider().primaryDeepTeal;
      case 4:
        return ColorProvider().primaryDeepBlack;
      case 5:
        return ColorProvider().primaryDeepEbs;

    }
    return ColorProvider().primaryDeepGreen;
  }
  _setupBars(int theme){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: _themeColor(theme),
      // navigation bar color
      statusBarColor: _themeColor(theme),
      // status bar color
    ));
  }

}
