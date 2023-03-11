import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/widgets/settings_list_item.dart';

class SettingsListCreator {
  List<SettingsListItem> generateList() {
    final List<SettingsListItem> list = [];
    //TODO add correct weblinks
    list.add(SettingHeaderItem("Settings"));
    list.add(SettingsDialogItem('assets/icons/settings_theme.png',"Theme", "System"));
    list.add(SettingsSwitchItem('assets/icons/settings_notification.png',"Notifications", true));
    list.add(SettingsWebLinkItem('assets/icons/settings_contact.png',"Contact Us", ""));
    list.add(SettingsWebLinkItem('assets/icons/settings_service.png', "Terms of Service", ""));
    list.add(SettingsWebLinkItem('assets/icons/settings_link.png',"Privacy Policy", ""));

    return list;
  }
}
