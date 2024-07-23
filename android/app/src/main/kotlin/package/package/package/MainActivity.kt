package package name

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.content.BroadcastReceiver
import android.content.Context
import android.widget.Toast
import android.os.Bundle
import android.content.IntentFilter

class MainActivity: FlutterFragmentActivity() {
    private val channel = "flutter.app/awake"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
      call, result ->
      // This method is invoked on the main thread.
      // TODO
      
      if(call.method == "awakeapp"){
          awakeapp()
      }else{
          println("message recieved in activityyyy")
      }
    }
    }
      private fun awakeapp(){
        val bringToForegroundIntent = Intent(this,MainActivity::class.java);
        if(bringToForegroundIntent != null){
startActivity(bringToForegroundIntent);
        }else{
val launchIntent = getPackageManager().getLaunchIntentForPackage("package name");
if (launchIntent != null) { 
    startActivity(launchIntent);//null pointer check in case package name was not found
}   }

    }
}
