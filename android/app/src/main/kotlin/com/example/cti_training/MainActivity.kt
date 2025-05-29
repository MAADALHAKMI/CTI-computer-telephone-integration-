package com.example.cti_training

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.telecom.TelecomManager
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.util.Log
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.cti/call"
    private val PERMISSION_REQUEST_CODE = 1001
    private val DEFAULT_DIALER_REQUEST_CODE = 1234

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (!hasPermissions()) {
            requestPermissions()
        }

        setAsDefaultDialer()

        Log.d("📞 DialerCheck", "Is default dialer? ${isDefaultDialer()}")
    }

    // ======= تعديل مهم: استدعاء listenToIncomingCalls داخل configureFlutterEngine =======
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "endCall" -> {
                    endCall()
                    result.success(null)
                }
                "answerCall" -> {
                    answerCall()
                    result.success(null)
                }
                "listenIncomingNumber" -> {
                    listenToIncomingCalls(flutterEngine)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
    // ================================================================================

    private fun hasPermissions(): Boolean {
        val permissions = arrayOf(
            Manifest.permission.READ_CALL_LOG,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.ANSWER_PHONE_CALLS,
            Manifest.permission.CALL_PHONE
        )
        return permissions.all { ActivityCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED }
    }

    private fun requestPermissions() {
        val permissions = arrayOf(
            Manifest.permission.READ_CALL_LOG,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.ANSWER_PHONE_CALLS,
            Manifest.permission.CALL_PHONE
        )

        val permissionsToRequest = permissions.filter {
            ActivityCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsToRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, permissionsToRequest.toTypedArray(), PERMISSION_REQUEST_CODE)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                Log.d("Permissions", "All permissions granted")
            } else {
                Log.d("Permissions", "Permissions denied")
                // يمكن إضافة إخطار للمستخدم هنا
            }
        }
    }

    private fun setAsDefaultDialer() {
        val telecomManager = getSystemService(Context.TELECOM_SERVICE) as? TelecomManager ?: return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (telecomManager.defaultDialerPackage != packageName) {
                val intent = Intent(TelecomManager.ACTION_CHANGE_DEFAULT_DIALER).apply {
                    putExtra(TelecomManager.EXTRA_CHANGE_DEFAULT_DIALER_PACKAGE_NAME, packageName)
                }
                startActivity(intent)
            }
        }
    }

    private fun listenToIncomingCalls(flutterEngine: FlutterEngine) {
        val telephony = getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager ?: return

        if (!hasPermissions()) {
            requestPermissions()
            return
        }

        telephony.listen(object : PhoneStateListener() {
            override fun onCallStateChanged(state: Int, incomingNumber: String?) {
                if (state == TelephonyManager.CALL_STATE_RINGING && incomingNumber != null) {
                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("onIncomingCall", incomingNumber)
                }
            }
        }, PhoneStateListener.LISTEN_CALL_STATE)
    }

    private fun endCall() {
        val telecomManager = getSystemService(Context.TELECOM_SERVICE) as? TelecomManager ?: return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            telecomManager.endCall()
        }
    }

    private fun answerCall() {
        val telecomManager = getSystemService(Context.TELECOM_SERVICE) as? TelecomManager ?: return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            telecomManager.acceptRingingCall()
        }
    }

    private fun isDefaultDialer(): Boolean {
        val telecomManager = getSystemService(Context.TELECOM_SERVICE) as? TelecomManager ?: return false
        return telecomManager.defaultDialerPackage == packageName
    }
}
