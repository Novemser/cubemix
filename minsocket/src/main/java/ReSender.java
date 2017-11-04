import org.json.JSONArray;

import java.io.*;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class ReSender {
    public static Map<String, String> methodMap = new HashMap<String, String>();

    static {

        methodMap.put("listBucket", "GET");
        methodMap.put("listObject", "GET");
        methodMap.put("createBucket", "POST");
        methodMap.put("createText", "POST");
        methodMap.put("destroyBucket", "DELETE");
        methodMap.put("destroyObject", "DELETE");

    }

    static private String getParameters(JSONArray allParameters) {
        StringBuilder result = new StringBuilder();

        for (Object s : allParameters) {
            result.append("/").append(s);
        }
        return result.toString();
    }

    public static String ResendTo(MessageModel mm) throws IOException {
        MessageModel messageModel = new MessageModel();
        messageModel.setArgsVal(mm.getArgsVal());
        messageModel.setMehodName(mm.getMehodName());
        String query = getParameters(mm.getArgsVal());
        try {
            Socket socket = new Socket("127.0.0.1", 8080);
            String path = "/" + mm.getMehodName() + query;

            // Send headers
            String method = methodMap.get(mm.getMehodName());
//            System.out.println(path);
//            System.out.println(method);

            BufferedWriter wr =
                    new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF8"));
            wr.write(method + " " + path + " HTTP/1.0\r\n");
            wr.write("Content-Type: application/json\r\n");
            wr.write("\r\n");
            // Send parameters
            wr.flush();

            // Get response
            BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            String line;
            ArrayList<String> contentList = new ArrayList<String>();
            while ((line = rd.readLine()) != null) {
                System.out.println(line);
                contentList.add(line);
            }
            wr.close();
            rd.close();
            return contentList.get(contentList.size() - 1);


        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
