package com.asliri.demo

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var methodResult: MethodChannel.Result? = null

    companion object {
        private const val LIVENESS_REQUEST_CODE = 1001
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.dartExecutor.binaryMessenger.let {
            MethodChannel(it, "com.asliri.demo/liveness")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "startLiveness" -> {
                            startActivityForResult(
                                Intent(this, LivenessActivity::class.java),
                                LIVENESS_REQUEST_CODE
                            )
                            result.success(null)
                        }

                        "getResult" -> {
                            methodResult = result
                        }

                        else -> result.notImplemented()
                    }
                }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == LIVENESS_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                val livenessResult = data?.getStringExtra("livenessResult") ?: "No result"
                methodResult?.success(livenessResult)
            } else {
                methodResult?.success("Liveness canceled or failed")
            }
            methodResult = null
        }
    }

}
