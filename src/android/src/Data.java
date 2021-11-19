import java.util.ArrayList;

public class Data {
    private ArrayList<byte[]> dataBuffer = new ArrayList<byte[]>();
    private boolean transfer = false;


    public Data(ArrayList<byte[]> dataBuffer){
        this.dataBuffer = dataBuffer;
    }

    public synchronized void addData(byte[] data){
        dataBuffer.add(data);
        while(transfer){
            try{
                wait();
            }catch (InterruptedException e){
                Thread.currentThread().interrupt();
            }
        }
        transfer = true;
        notifyAll();
    }

    public synchronized boolean readyRead(){
        while (!transfer){
            try{
                wait();
            }catch (InterruptedException e){
                Thread.currentThread().interrupt();
            }
        }
        transfer = false;
        notifyAll();
        return true;
    }

    public byte[] readData(){
        byte[] data = dataBuffer.get(0);
        dataBuffer.remove(0);
        return data;
    }
}
