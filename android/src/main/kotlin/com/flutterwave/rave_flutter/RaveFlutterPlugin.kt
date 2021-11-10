package com.flutterwave.rave_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class RaveFlutterPlugin : MethodCallHandler, FlutterPlugin {

    private lateinit var methodChannel: MethodChannel

    companion object {
        fun registerWith(registrar: Registrar) {
            val plugin = RaveFlutterPlugin()
            plugin.setupMethodChannel(registrar.messenger())
        }
    }

    private fun setupMethodChannel(binaryMessenger: BinaryMessenger?) {
        methodChannel = MethodChannel(binaryMessenger, "rave_flutter")
        methodChannel.setMethodCallHandler(RaveFlutterPlugin())
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setupMethodChannel(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        result.notImplemented()
    }
}
