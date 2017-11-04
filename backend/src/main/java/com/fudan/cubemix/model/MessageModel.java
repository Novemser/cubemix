package com.fudan.cubemix.model;

import org.json.JSONObject;

import java.util.ArrayList;

public class MessageModel {
    private String mehodName;
    private ArrayList<String> argsVal = new ArrayList<String>();
    private JSONObject data = new JSONObject();

    public MessageModel() {
    }

    public String getMehodName() {
        return mehodName;
    }

    public void setMehodName(String mehodName) {
        this.mehodName = mehodName;
    }

    public ArrayList<String> getArgsVal() {
        return argsVal;
    }

    public void setArgsVal(ArrayList<String> argsVal) {
        this.argsVal = argsVal;
    }

    public JSONObject getData() {
        return data;
    }

    public void setData(JSONObject data) {
        this.data = data;
    }
}
