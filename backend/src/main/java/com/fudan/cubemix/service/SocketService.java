package com.fudan.cubemix.service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fudan.cubemix.controller.MainController;
import com.fudan.cubemix.model.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @package com.fudan.cubemix.service
 * @Author Novemser
 * @Date 2017/11/4
 * <p>
 * Crafting with devotion.
 */
@Service
public class SocketService {
    private ServerSocket server;
    private Socket socket;
    @Autowired
    private MainController mainController;

    private int bucketSize;

    public void initService() {
        System.out.println("Starting up socket server");
        try {
            try {
                server = new ServerSocket(4700);
                //创建一个ServerSocket在端口4700监听客户请求
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                socket = server.accept();
                //使用accept()阻塞等待客户请求，有客户
                //请求到来则产生一个Socket对象，并继续执行
            } catch (Exception e) {
                e.printStackTrace();
            }

            String requestStr;
            BufferedReader is = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            //由Socket对象得到输入流，并构造相应的BufferedReader对象
            PrintWriter os = new PrintWriter(socket.getOutputStream());

            //从标准输入读入一字符串
            while (true) {
                requestStr = is.readLine();

                JSONObject req = JSON.parseObject(requestStr);
                String method = req.getString("method");
                List<String> args = null;
                if (req.containsKey("args")) {
                    args = new ArrayList<>();
                    for (Object obj : req.getJSONArray("args")) {
                        args.add((String) obj);
                    }
                }

                Object data = null;
                if (method.equals("listBucket")) {
                    JSONArray resArray = new JSONArray();
                    List<Bucket> buckets = mainController.listNamespace();
                    bucketSize = buckets.size();
                    for (Bucket bu : buckets) {
                        JSONObject object = new JSONObject();
                        String nameSpace = bu.getName();
                        List<S3ObjectSummary> summaries = mainController.listObject(nameSpace);
                        object.put("totalObjCount", summaries.size());
                        object.put("name", nameSpace);
                        object.put("creationDate", bu.getCreationDate());
                        resArray.add(object);
                    }

                    data = resArray;
                } else if (method.equals("listObject")) {
                    JSONArray resArray = new JSONArray();
                    List<S3ObjectSummary> summaries = mainController.listObject(args.get(0));
                    for (S3ObjectSummary summary : summaries) {
                        JSONObject object = new JSONObject();
                        object.put("key", summary.getKey());
                        object.put("size", summary.getSize());
                        object.put("lastModified", summary.getLastModified());
                        object.put("storageClass", summary.getStorageClass());
                        resArray.add(object);
                    }

                    data = resArray;
                } else if (method.equals("createBucket")) {

                }

                os.print(packResponse(method, args, data) + "\n");
                os.flush();
            }

        } catch (Exception e) {
            System.out.println("Closing");
        } finally {
            try {
                socket.close();
            } catch (IOException e) {
            }
            try {
                server.close();
            } catch (IOException e) {
            }
            initService();
        }
    }

    private Object packResponse(
            String method,
            List<String> args,
            Object data) {
        JSONObject result = new JSONObject();
        result.put("method", method);
        if (method.equals("listBucket")) {
            result.put("totalBucketCount", bucketSize);
        }

        if (args != null) {
            result.put("args", args);
        }

        if (data != null) {
            result.put("data", data);
        }
        return result;
    }
}
