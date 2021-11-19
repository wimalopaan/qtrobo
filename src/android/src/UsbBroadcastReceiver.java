import android.content.Context;
import android.content.BroadcastReceiver;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.content.Intent;



public class UsbBroadcastReceiver extends BroadcastReceiver {

    private SerialConnector serialConnector;

    public UsbBroadcastReceiver(SerialConnector serialConnector){
        this.serialConnector= serialConnector;
    }

    @Override
     public void onReceive(Context context, Intent intent) {
         String action = intent.getAction();
         if ("com.android.example.USB_PERMISSION".equals(action)) {
            synchronized (this) {
            UsbDevice device = (UsbDevice)intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);
            if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                if(device != null){
                    serialConnector.connect();
                    serialConnector.getFirstConnected().connect();
                }
            }else{
                //Log.d(TAG, "permission denied for device " + device);
            }
           }
        }
    }
}
