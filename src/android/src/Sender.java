public class Sender{

    Data data;

    public Sender(Data data){
        this.data = data;
    }

    public void addData(byte[] newData){
        data.addData(newData);
    }
}
