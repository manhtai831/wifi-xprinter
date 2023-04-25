package com.example.bluetooth_x_print;

import java.util.HashMap;
import java.util.Map;

public class PrintResponse {
    int code;
    String msg;

    public PrintResponse(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    static Map<String, Object> error(int code) {
        String message = "Lỗi không xác định";
        if (code == 1) {
            message = "Lỗi kết nối";
        }

        if (code == 3) {
            message = "Lỗi tham số";
        }
        return new PrintResponse(code, message).toMap();
    }

    static Map<String, Object> error() {
        return new PrintResponse(99, "Lỗi không xác định").toMap();

    }

    static Map<String, Object> success() {
        return new PrintResponse(0, "Thành công").toMap();
    }

    Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("code", code);
        map.put("msg", msg);
        return map;
    }
}
