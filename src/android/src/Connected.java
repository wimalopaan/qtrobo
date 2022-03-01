public class Connected {

    private boolean connected = false;


    public synchronized boolean hasDisconnected(){
        while(connected){
            try{
                wait();
            }catch (InterruptedException e){
                Thread.currentThread().interrupt();
            }
        }
        notifyAll();
        return true;
    }


    public synchronized boolean hasConnected(){
        while(!connected){
            try{
                wait();
            }catch (InterruptedException e){
                Thread.currentThread().interrupt();
            }
        }
        notifyAll();
        return true;
    }

    public synchronized void connect(){
        this.connected = true;
        notifyAll();
    }

    public synchronized void disconnect(){
        this.connected=false;
        notifyAll();
    }

}
