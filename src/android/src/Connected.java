public class Connected {

    private boolean connected = false;


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

}
