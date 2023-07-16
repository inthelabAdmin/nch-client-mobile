import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelperUtils {
  // Android App id ca-app-pub-8426510967287255~5233208821
  // Apple App id ca-app-pub-8426510967287255~8503270690

  static const _prodAndroidAdUnitId = "ca-app-pub-8426510967287255/6274114059";
  static const _prodAppleAdUnitId = "ca-app-pub-8426510967287255/6089963996";

  static const _debugAndroidAdUnitId = "ca-app-pub-8426510967287255/6274114059";
  static const _debugAppleAdUnitId = "ca-app-pub-8426510967287255/6089963996";

  static const _androidAdUnitId =
      kReleaseMode ? _prodAndroidAdUnitId : _debugAndroidAdUnitId;
  static const _appleAdUnitId =
      kReleaseMode ? _prodAppleAdUnitId : _debugAppleAdUnitId;

  const AdHelperUtils();

  String getDetailsBannerAdUnitId() {
    return Platform.isAndroid ? _androidAdUnitId : _appleAdUnitId;
  }
}
