import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:national_calendar_hub_app/color_schemes.g.dart';

abstract class SettingsListItem {
  Widget build(BuildContext context);
}

class SettingHeaderItem extends SettingsListItem {
  final String heading;

  SettingHeaderItem(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16, right: 18, top: 12, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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

class SettingsWebLinkItem extends SettingsListItem {
  final String leadingAssetPath;
  final String title;
  final String url;

  SettingsWebLinkItem(this.leadingAssetPath, this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageIcon(
          color: lightColorScheme.primary, AssetImage(leadingAssetPath)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {},
    );
  }
}
