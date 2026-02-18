package com.asliri.demo

import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.asliri.aslismileliveness.sdk.AsliSmileLivenessContainer
import com.asliri.aslismileliveness.sdk.AsliSmileLivenessListener
import com.asliri.aslismileliveness.sdk.AsliSmileLivenessSDK
import com.asliri.demo.databinding.ActivityDemoBinding

class LivenessActivity : AppCompatActivity(), AsliSmileLivenessListener {

    private val binding by lazy {
        ActivityDemoBinding.inflate(layoutInflater)
    }
    private val sdk by lazy {
        AsliSmileLivenessSDK.getInstance(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        sdk.initialize("4cdfb7dd-b690-45db-8f0c-e5a8c0813d1a")
        sdk.smileLiveness(
            container = AsliSmileLivenessContainer(
                fragmentManager = supportFragmentManager,
                containerId = binding.frameContainer.id
            ),
            listener = this
        )
    }

    override fun onSmileLivenessFailure(code: Int, message: String) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show()
//        val intent = Intent().apply {
//            putExtra("livenessResult", "Failed: $code - $message")
//        }
//        setResult(RESULT_OK, intent)
//        finish()
    }

    override fun onSmileLivenessSuccess(neutralBitmap: Bitmap, smileBitmap: Bitmap, result: Boolean) {
        val intent = Intent().apply {
            putExtra("livenessResult", "Success: $result")
        }
        setResult(RESULT_OK, intent)
        finish()
    }
}
