import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/pages/settings/settings_helper.dart';
import 'package:national_calendar_hub_app/widgets/settings_list_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<SettingsListItem> items = SettingsListCreator().generateList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index].build(context);
                })));
  }
}
