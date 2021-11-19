public class Receiver {

    private Data data;

    public Receiver(Data data){
        this.data = data;
    }

    public boolean readyRead(){
        return data.readyRead();
    }

}
