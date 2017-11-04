import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

public class MessageModel {
    private String mehodName;
    private JSONArray argsVal = new JSONArray();
    private JSONObject data = new JSONObject();

    public MessageModel() {
    }

    public String getMehodName() {
        return mehodName;
    }

    public void setMehodName(String mehodName) {
        this.mehodName = mehodName;
    }

    public JSONArray getArgsVal() {
        return argsVal;
    }

    public void setArgsVal(JSONArray argsVal) {
        this.argsVal = argsVal;
    }

    public JSONObject getData() {
        return data;
    }

    public void setData(JSONObject data) {
        this.data = data;
    }
}
