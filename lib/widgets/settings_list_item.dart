import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          EdgeInsets.only(left: 16.w, right: 18.w, top: 12.h, bottom: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style: TextStyle(fontSize: 30.w, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class SettingsDialogItem extends SettingsListItem {
  final String leadingAssetPath;
  final String title;
  final String value;

  SettingsDialogItem(this.leadingAssetPath, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageIcon(
          color: lightColorScheme.primary, AssetImage(leadingAssetPath)),
      title: Text(title),
      trailing: Text(value),
      onTap: () {},
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
