package com.amicane.amicane_caller

import android.content.Context;
import android.app.Activity
import android.content.Intent;
import android.content.SharedPreferences;
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.widget.Toast;

import android.telecom.TelecomManager;
import android.telephony.TelephonyCallback
import android.telephony.SmsManager

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** AmicaneCallerPlugin */
class AmicaneCallerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private lateinit var telecomManager:TelecomManager
  private lateinit var telephonyManager:TelephonyManager
  private lateinit var smsManager:SmsManager


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "amicane_caller")
    channel.setMethodCallHandler(this)

    context = flutterPluginBinding.applicationContext
    telecomManager = context.getSystemService(Context.TELECOM_SERVICE) as TelecomManager
    telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    smsManager = SmsManager.getDefault();
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if(call.method == "sendSms") {
      var phoneNo:String? = call.argument("phone")
      var message:String? = call.argument("message")

      smsManager.sendTextMessage(phoneNo, null, message, null, null);

    } else if (call.method == "placeCall") {
//      val callIntent = Intent(Intent.ACTION_CALL)
//      callIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//      callIntent.setData(Uri.parse("tel:7350016095"))
//
//      context.startActivity(callIntent)


      var text:String? = call.argument("phone")
      if(text != null) {
        var uri: Uri? = Uri.fromParts("tel", text, null)
        var extras: Bundle? = Bundle()
        extras?.putBoolean(TelecomManager.EXTRA_START_CALL_WITH_SPEAKERPHONE, true)
        telecomManager.placeCall(uri, extras)



        try {
          var teleCb: TelephonyCallback =
            object : TelephonyCallback(), TelephonyCallback.CallStateListener {
              open override fun onCallStateChanged(state: Int) {
                if (state == TelephonyManager.CALL_STATE_RINGING) {
                  print("TELE STATE -------   Ringing   -----------")
                  Toast.makeText(
                    context, "Ringing",
                    Toast.LENGTH_LONG
                  ).show()
                }
                if (state == TelephonyManager.CALL_STATE_OFFHOOK) {
                  print("TELE STATE --------- Call in progress -----------")
                  Toast.makeText(
                    context, "Busy::Currently in another Call",
                    Toast.LENGTH_LONG
                  ).show()
                }
                if (state == TelephonyManager.CALL_STATE_IDLE) {
                  print("TELE STATE ----------- Call idle --------------");
                  Toast.makeText(
                    context, "Not Available:: Neither Ringing nor in a Call",
                    Toast.LENGTH_LONG
                  ).show()
                }

//            Toast.makeText(context, "Call State change -------   $state   -----------",
//              Toast.LENGTH_LONG).show()
              }

            }
          telephonyManager.registerTelephonyCallback(context.getMainExecutor(), teleCb)
        } catch (e: Exception) {

        }

      }
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
