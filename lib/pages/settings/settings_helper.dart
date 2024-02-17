import 'package:national_calendar_hub_app/utils/web_links.dart';
import 'package:national_calendar_hub_app/widgets/settings_list_item.dart';

class SettingsListCreator {
  List<SettingsListItem> generateList() {
    final List<SettingsListItem> list = [];
    list.add(SettingHeaderItem("Settings"));
    list.add(SettingsThemeItem());
    // list.add(SettingsSwitchItem('assets/icons/settings_notification.png',"Notifications", true));

    list.add(SettingsWebItem('assets/icons/settings_service.png',
        "Terms of Service", WebLinks.terms.name));
    list.add(SettingsWebItem('assets/icons/settings_service.png',
        "Privacy Policy", WebLinks.privacy.name));
    list.add(SettingsWebItem(
        'assets/icons/settings_link.png', "About Us", WebLinks.about.name));

    String email = Uri.encodeComponent("info@nationalcalendarhub.com");
    String subject = Uri.encodeComponent("Contact Us - Mobile User");
    String body = Uri.encodeComponent("[Enter your message here]");
    list.add(SettingsEmailLinkItem('assets/icons/settings_contact.png',
        "Contact Us", "mailto:$email?subject=$subject&body=$body"));

    return list;
  }
}
