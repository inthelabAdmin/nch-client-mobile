import 'package:national_calendar_hub_app/widgets/settings_list_item.dart';

class SettingsListCreator {
  List<SettingsListItem> generateList() {
    final List<SettingsListItem> list = [];
    list.add(SettingHeaderItem("Settings"));
    list.add(SettingsThemeItem());
   // list.add(SettingsSwitchItem('assets/icons/settings_notification.png',"Notifications", true));

    list.add(SettingsWebLinkItem('assets/icons/settings_service.png', "Terms of Service", "https://www.nationalcalendarhub.com/termsOfLegalServices/mobile"));
    list.add(SettingsWebLinkItem('assets/icons/settings_service.png',"Privacy Policy", "https://www.nationalcalendarhub.com/privacyPolicy/mobile"));
    list.add(SettingsWebLinkItem('assets/icons/settings_link.png',"About Us", "https://www.nationalcalendarhub.com/aboutUs/mobile"));

    String email = Uri.encodeComponent("info@nationalcalendarhub.com");
    String subject = Uri.encodeComponent("Contact Us - Mobile User");
    String body = Uri.encodeComponent("[Enter your message here]");
    list.add(SettingsWebLinkItem('assets/icons/settings_contact.png',"Contact Us", "mailto:$email?subject=$subject&body=$body"));

    return list;
  }
}
