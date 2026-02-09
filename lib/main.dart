import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_editor/app.dart';
import 'package:z_editor/l10n/resource_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ResourceNames.ensureLoaded();
  final prefs = await SharedPreferences.getInstance();

  final localeCode = prefs.getString('locale') ?? 'en';
  final locale = Locale(localeCode);

  final themeModeStr = prefs.getString('theme_mode');
  final ThemeMode themeMode;
  if (themeModeStr == 'dark') {
    themeMode = ThemeMode.dark;
  } else if (themeModeStr == 'light') {
    themeMode = ThemeMode.light;
  } else {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    themeMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    prefs.setString('theme_mode', themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
  final uiScale = prefs.getDouble('ui_scale') ?? 1.0;

  runApp(ZEditorRoot(
    initialLocale: locale,
    initialThemeMode: themeMode,
    initialUiScale: uiScale.toDouble(),
    prefs: prefs,
  ));
}

class ZEditorRoot extends StatefulWidget {
  const ZEditorRoot({
    super.key,
    required this.initialLocale,
    required this.initialThemeMode,
    required this.initialUiScale,
    required this.prefs,
  });

  final Locale initialLocale;
  final ThemeMode initialThemeMode;
  final double initialUiScale;
  final SharedPreferences prefs;

  @override
  State<ZEditorRoot> createState() => _ZEditorRootState();
}

class _ZEditorRootState extends State<ZEditorRoot> {
  late Locale _locale;
  late ThemeMode _themeMode;
  late double _uiScale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _themeMode = widget.initialThemeMode;
    _uiScale = widget.initialUiScale;
  }

  void _onLocaleChanged(Locale locale) {
    setState(() => _locale = locale);
    widget.prefs.setString('locale', locale.languageCode);
  }

  void _onCycleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      widget.prefs.setString(
        'theme_mode',
        _themeMode == ThemeMode.dark ? 'dark' : 'light',
      );
    });
  }

  void _onUiScaleChange(double scale) {
    setState(() => _uiScale = scale);
    widget.prefs.setDouble('ui_scale', scale);
  }

  @override
  Widget build(BuildContext context) {
    return ZEditorApp(
      locale: _locale,
      onLocaleChanged: _onLocaleChanged,
      themeMode: _themeMode,
      onCycleTheme: _onCycleTheme,
      uiScale: _uiScale,
      onUiScaleChange: _onUiScaleChange,
    );
  }
}
