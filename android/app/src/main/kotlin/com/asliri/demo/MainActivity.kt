package com.asliri.demo

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var methodResult: MethodChannel.Result? = null

    companion object {
        private const val OCR_REQUEST_CODE = 1001
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.dartExecutor.binaryMessenger.let {
            MethodChannel(it, "com.asliri.demo/ocr")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "startOcr" -> {
                            startActivityForResult(
                                Intent(this, OcrActivity::class.java),
                                OCR_REQUEST_CODE
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
        if (requestCode == OCR_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                val ocrResult = data?.getStringExtra("ocrResult") 
                    ?: data?.getStringExtra("ocrResult") 
                    ?: "No result"
                methodResult?.success(ocrResult)
            } else {
                methodResult?.success("Ocr canceled or failed")
            }
            methodResult = null
        }
    }

}
