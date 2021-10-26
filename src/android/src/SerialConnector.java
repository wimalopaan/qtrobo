import com.physicaloid.lib.Physicaloid;
import android.content.Context;


public class SerialConnector {

    Physicaloid mPhysicaloid;
    Object context;

    public SerialConnector(){

    }


    public String setBaudrate(){
        mPhysicaloid = new Physicaloid((Context)this.context);
        mPhysicaloid.setBaudrate(960);
        System.out.println("Success");
        return "Success";
    }

}
