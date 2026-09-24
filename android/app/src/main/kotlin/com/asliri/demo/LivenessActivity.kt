package com.asliri.demo

import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.asliri.aslipassiveliveness.sdk.AsliPassiveLivenessContainer
import com.asliri.aslipassiveliveness.sdk.AsliPassiveLivenessListener
import com.asliri.aslipassiveliveness.sdk.AsliPassiveLivenessSDK
import com.asliri.demo.databinding.ActivityDemoBinding

class LivenessActivity : AppCompatActivity(), AsliPassiveLivenessListener {

    private val binding by lazy {
        ActivityDemoBinding.inflate(layoutInflater)
    }
    private val sdk by lazy {
        AsliPassiveLivenessSDK.getInstance(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        sdk.initialize("4cdfb7dd-b690-45db-8f0c-e5a8c0813d1a")
        sdk.passiveLiveness(
            container = AsliPassiveLivenessContainer(
                fragmentManager = supportFragmentManager,
                containerId = binding.frameContainer.id
            ),
            listener = this
        )
    }

    override fun onPassiveLivenessFailure(code: Int, message: String) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show()
//        val intent = Intent().apply {
//            putExtra("livenessResult", "Failed: $code - $message")
//        }
//        setResult(RESULT_OK, intent)
//        finish()
    }

    override fun onPassiveLivenessSuccess(bitmap: Bitmap, result: Boolean) {
        val intent = Intent().apply {
            putExtra("livenessResult", "Success: $result")
        }
        setResult(RESULT_OK, intent)
        finish()
    }
}
