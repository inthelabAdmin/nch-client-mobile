package com.nationalcalendarhub.mobile.national_calendar_hub_app

import io.flutter.embedding.android.FlutterActivity
import android.view.Window
import android.os.Bundle
import android.graphics.Color

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setStatusBarColor(Color.TRANSPARENT);
    }
}
