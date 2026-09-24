package com.asliri.demo

import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.asliri.ocr.sdk.AsliOcrContainer
import com.asliri.ocr.sdk.AsliOcrListener
import com.asliri.ocr.sdk.AsliOcrSDK
import com.asliri.demo.databinding.ActivityDemoBinding

class OcrActivity : AppCompatActivity(), AsliOcrListener {

    private val binding by lazy {
        ActivityDemoBinding.inflate(layoutInflater)
    }
    private val asliOcr by lazy {
        AsliOcrSDK.getInstance(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        asliOcr.initialize("4cdfb7dd-b690-45db-8f0c-e5a8c0813d1a")
        asliOcr.ocr(
            container = AsliOcrContainer(
                fragmentManager = supportFragmentManager,
                containerId = binding.frameContainer.id
            ),
            listener = this
        )
    }

    override fun onScanFailure(code: Int, message: String) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show()
//        val intent = Intent().apply {
//            putExtra("ocrResult", "Failed: $code - $message")
//        }
//        setResult(RESULT_OK, intent)
//        finish()
    }

    override fun onScanSuccess(bitmap: Bitmap, ocrData: String) {
        val intent = Intent().apply {
            putExtra("ocrResult", "Success: $ocrData")
        }
        setResult(RESULT_OK, intent)
        finish()
    }
}
