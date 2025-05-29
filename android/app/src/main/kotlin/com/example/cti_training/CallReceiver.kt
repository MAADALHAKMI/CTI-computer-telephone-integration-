package com.example.cti_training

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import android.util.Log

class CallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action.equals("android.intent.action.PHONE_STATE")) {
            val state = intent?.getStringExtra(TelephonyManager.EXTRA_STATE)
            val incomingNumber = intent?.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

            if (state == TelephonyManager.EXTRA_STATE_RINGING) {
                Log.d("📞 CallReceiver", "Ringing from: $incomingNumber")

                // ✅ افتح التطبيق
                val launchIntent = context?.packageManager?.getLaunchIntentForPackage(context.packageName)
                launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context?.startActivity(launchIntent)
            }
        }
    }
}
