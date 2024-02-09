package com.essentialsapps.essential_control_pc

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val channelName = "exeCommand"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName);

        channel.setMethodCallHandler { call, result ->
            if(call.method == "commadAdb"){
                var args = call.arguments as Map<String, String>
                var dataArgs = args["argsData"]
                val commandToRun = dataArgs.toString()
                var d = Runtime.getRuntime().exec(commandToRun)
                println(d.inputStream)
                Toast.makeText(context, "--> infoExecute : "+d.inputStream, Toast.LENGTH_LONG).show()
            }
        }
    }
}
