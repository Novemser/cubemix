import org.json.JSONArray;

public class MessageModel {
    private String method;
    private JSONArray args = new JSONArray();
    private String data = "";

    public MessageModel() {
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public JSONArray getArgs() {
        return args;
    }

    public void setArgs(JSONArray args) {
        this.args = args;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }
}
