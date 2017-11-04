import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class TalkServer {
    public static void main(String args[]) {
        try {
            ServerSocket server = null;
            try {
                server = new ServerSocket(4700);
                //创建一个ServerSocket在端口4700监听客户请求
            } catch (Exception e) {
                e.printStackTrace();
            }
            Socket socket = null;
            try {
                socket = server.accept();
                //使用accept()阻塞等待客户请求，有客户
                //请求到来则产生一个Socket对象，并继续执行

            } catch (Exception e) {
                e.printStackTrace();
            }
            String line;
            BufferedReader is = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            //由Socket对象得到输入流，并构造相应的BufferedReader对象
            PrintWriter os = new PrintWriter(socket.getOutputStream());
            //由Socket对象得到输出流，并构造PrintWriter对象
            BufferedReader sin = new BufferedReader(new InputStreamReader(System.in));
            //由系统标准输入设备构造BufferedReader对象
            //在标准输出上打印从客户端读入的字符串
            //从标准输入读入一字符串
            while (true) {
                MessageModel messageModel = new MessageModel();
                line = is.readLine();
                System.out.println("Client:" + line);

                //如果该字符串为 "bye"，则停止循环
                JSONObject inputJson = new JSONObject(line);
                messageModel.setMethod((String) inputJson.get("method"));
                if (inputJson.has("args")) {
                    messageModel.setArgs((JSONArray) inputJson.get("args"));
                }

                messageModel.setData(ReSender.ResendTo(messageModel));
                ObjectMapper mapper = new ObjectMapper();
                String jsonInString = mapper.writeValueAsString(messageModel);
                os.print(jsonInString);
                //向客户端输出该字符串
                os.flush();
                //刷新输出流，使Client马上收到该字符串
                //在系统标准输出上打印读入的字符串

                //从Client读入一字符串，并打印到标准输出上
                //从系统标准输入读入一字符串
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
