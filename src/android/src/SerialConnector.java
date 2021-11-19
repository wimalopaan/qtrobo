import com.physicaloid.lib.Physicaloid;
import android.content.Context;
import android.app.PendingIntent;
import android.content.Intent;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.content.IntentFilter;
import java.util.ArrayList;
import java.io.*;
import java.lang.*;


import com.physicaloid.lib.usb.driver.uart.ReadLisener;



public class SerialConnector {


    public Object context;

    private Physicaloid mPhysicaloid;
    private UsbManager usbManager;
    private PendingIntent permissionIntent;
    private Data data;
    private Sender sender;
    private Receiver receiver;
    private int baudrate;
    private int stopbits;
    private int parity;
    private Connected firstConnected;



    public SerialConnector(){
        this.data = new Data(new ArrayList<byte[]>());
        this.sender = new Sender(data);
        this.receiver = new Receiver(data);
        this.firstConnected = new Connected();
    }




    public void initializeConnection(){
       mPhysicaloid = new Physicaloid((Context) context);
       usbManager = (UsbManager) (((Context)this.context).getSystemService("usb"));
       permissionIntent = PendingIntent.getBroadcast((Context)this.context, 0, new Intent("com.android.example.USB_PERMISSION"), 0);
       UsbBroadcastReceiver br = new UsbBroadcastReceiver(this);
       IntentFilter filter = new IntentFilter("com.android.example.USB_PERMISSION");
       ((Context)context).registerReceiver(br, filter);
    }


    public void requestPermissionAndConnect(){
        for (final UsbDevice usbDevice : usbManager.getDeviceList().values()) {
            if (usbManager.hasPermission(usbDevice)) {
                connect();
            } else {
                usbManager.requestPermission(usbDevice, permissionIntent);
            }
       }
    }

    public void connect(){
        mPhysicaloid.open();
        mPhysicaloid.setBaudrate(baudrate);
        mPhysicaloid.setParity(parity);
        mPhysicaloid.setStopBits(stopbits);
        mPhysicaloid.addReadListener(new ReadLisener() {
          @Override
          public void onRead(int size) {
             byte[] buf = new byte[size];
             mPhysicaloid.read(buf, size);
             sender.addData(buf);
          }
       });
    }

    public void setBaudrate(int baudrate){
        this.baudrate = baudrate;
    }

    public void setParity(int parity){
        this.parity = parity;
    }

    public void setStopbits(int stopbits){
        this.stopbits= stopbits;
    }

    public boolean readyRead(){
        boolean ready = receiver.readyRead();
        return ready;
    }

    public byte[] read(){
        return data.readData();
    }


    public void sendData(byte[] data){
        mPhysicaloid.write(data,data.length);
    }


    public boolean isConnected(){
        return mPhysicaloid.isOpened();
    }

    public boolean hasConnected(){
        return firstConnected.hasConnected();
    }

    public Connected getFirstConnected(){
        return this.firstConnected;
    }

    public void disconnect(){
        mPhysicaloid.close();
    }
}


