import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/models/tags.dart';
import 'package:national_calendar_hub_app/utils/icons.dart';
import 'package:national_calendar_hub_app/widgets/svg_asset.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HashTagChip extends StatelessWidget {
  const HashTagChip({super.key, required this.tagsItem});

  final TagsItem tagsItem;

  Future<void> onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      tagsItem.label,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showHashTagDialog(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(tagsItem.label),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        _launchURL(tagsItem.instagramLink);
                      },
                      leading: const SvgAsset(
                          assetName: AssetName.instagram,
                          height: 24,
                          width: 24,
                          color: Color(0xFFE1306C)),
                      title: const Text("View on Instagram"),
                    ),
                    ListTile(
                      onTap: () {
                        _launchURL(tagsItem.twitterLink);
                      },
                      leading: const SvgAsset(
                          assetName: AssetName.twitter,
                          height: 24,
                          width: 24,
                          color: Color(0xFF1DA1F2)),
                      title: const Text("View on Twitter"),
                    ),
                    ListTile(
                      onTap: () {
                        _launchURL(tagsItem.facebookLink);
                      },
                      leading: const SvgAsset(
                        assetName: AssetName.facebook,
                        height: 24,
                        width: 24,
                        color: Color(0xFF4267B2),
                      ),
                      title: const Text("View on Facebook"),
                    ),
                    ListTile(
                      onTap: () {
                        onShare(context);
                      },
                      leading: const SvgAsset(
                        assetName: AssetName.share,
                        height: 24,
                        width: 24,
                      ),
                      title: const Text("Share"),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Close'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ActionChip(
            onPressed: () {
              showHashTagDialog(context);
            },
            label:
                Text(tagsItem.label, style: const TextStyle(fontSize: 14.0))));
  }
}
