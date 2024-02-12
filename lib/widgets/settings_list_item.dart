import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:national_calendar_hub_app/color_schemes.g.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class SettingsListItem {
  Widget build(BuildContext context);
}

class SettingHeaderItem extends SettingsListItem {
  final String heading;

  SettingHeaderItem(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 18, top: 12, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class SettingsThemeItem extends SettingsListItem {
  SettingsThemeItem();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageIcon(
          color: lightColorScheme.primary,
          const AssetImage('assets/icons/settings_theme.png')),
      title: const Text("Theme"),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        context.go('/themeSettings');
      },
    );
  }
}

class SettingsWebItem extends SettingsListItem {
  final String leadingAssetPath;
  final String title;
  final String pageType;

  SettingsWebItem(this.leadingAssetPath, this.title, this.pageType);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageIcon(
          color: lightColorScheme.primary, AssetImage(leadingAssetPath)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        context.go('/web/$pageType');
      },
    );
  }
}

class SettingsSwitchItem extends SettingsListItem {
  final String leadingAssetPath;
  final String title;
  final bool value;

  SettingsSwitchItem(this.leadingAssetPath, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageIcon(
          color: lightColorScheme.primary, AssetImage(leadingAssetPath)),
      title: Text(title),
      trailing: Switch(
        onChanged: (bool newValue) {},
        value: value,
      ),
      onTap: () {},
    );
  }
}

class SettingsEmailLinkItem extends SettingsListItem {
  final String leadingAssetPath;
  final String title;
  final String url;

  SettingsEmailLinkItem(this.leadingAssetPath, this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageIcon(
          color: lightColorScheme.primary, AssetImage(leadingAssetPath)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        _launchURL(context, url);
      },
    );
  }

  _showSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Unexpected error occurred. Please try again'),
      duration: Duration(milliseconds: 1500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        _showSnackBar(context);
      }
      FirebaseCrashlytics.instance.log("Could not launch $uri");
    }
  }
}
