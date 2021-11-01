import com.physicaloid.lib.Physicaloid;
import android.content.Context;
import android.app.PendingIntent;
import android.content.Intent;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import java.util.ArrayList;
import com.physicaloid.lib.usb.driver.uart.ReadLisener;





public class SerialConnector {

    Physicaloid mPhysicaloid;
    Object context;
    UsbManager usbManager;
    PendingIntent permissionIntent;
    ArrayList<byte[]> dataBuffer;


    int baudrate;
    int stopbits;
    int parity;

    private static final String ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION";
    private final BroadcastReceiver usbReceiver = new BroadcastReceiver() {

            public void onReceive(Context context, Intent intent) {

                for (final UsbDevice usbDevice : usbManager.getDeviceList().values()) {
                    if (usbManager.hasPermission(usbDevice)) {
                        connect();
                    } else {
                        usbManager.requestPermission(usbDevice, permissionIntent);
                    }
               }

              }
        };


    public boolean initializeConnection(){
       mPhysicaloid = new Physicaloid((Context) context);
       usbManager = (UsbManager) (((Context)this.context).getSystemService("usb"));
       permissionIntent = PendingIntent.getBroadcast((Context)this.context, 0, new Intent("com.android.example.USB_PERMISSION"), 0);
       IntentFilter filter = new IntentFilter("com.android.example.USB_PERMISSION");
       ((Context)context).registerReceiver(usbReceiver, filter);
       dataBuffer = new ArrayList<byte[]>();
       return true;
    }


    public String requestPermissionAndConnect(){
        for (final UsbDevice usbDevice : usbManager.getDeviceList().values()) {
            if (usbManager.hasPermission(usbDevice)) {
                connect();
            } else {
                usbManager.requestPermission(usbDevice, permissionIntent);
            }
       }
       return "Success";


    }

    private void connect(){
        mPhysicaloid.open();
        mPhysicaloid.setBaudrate(baudrate);
        mPhysicaloid.setParity(parity);
        mPhysicaloid.setStopBits(stopbits);
        mPhysicaloid.addReadListener(new ReadLisener() {
          @Override
          public void onRead(int size) {
             byte[] buf = new byte[size];
             mPhysicaloid.read(buf, size);
             dataBuffer.add(buf);
          }
       });
    }

    public byte[] read(){
        byte[] result = dataBuffer.get(0);
        dataBuffer.remove(0);
        return result;
    }

    public boolean readyRead(){
        return !dataBuffer.isEmpty();
    }

    public boolean isConnected(){
        return mPhysicaloid.isOpened();

    }

}
