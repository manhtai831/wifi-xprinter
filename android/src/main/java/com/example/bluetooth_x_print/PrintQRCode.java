package com.example.bluetooth_x_print;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;


import android.util.Log;


import net.posprinter.utils.BitmapToByteData;
import net.posprinter.utils.DataForSendToPrinterTSC;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

public class PrintQRCode {
    private static final String TAG = PrintQRCode.class.getSimpleName();

    public static List<byte[]> mapToLabel(Map<String, Object> config, List<Map<String, Object>> configs) {
        List<byte[]> list = new ArrayList<>();

        int width = (int) (config.get("width") == null ? 50 : config.get("width")); // 单位：mm
            int height = (int) (config.get("height") == null ? 30 : config.get("height")); // 单位：mm
        int gap = (int) (config.get("gap") == null ? 2 : config.get("gap")); // 单位：mm
        int qty = (int) (config.get("qty") == null ? 1 : config.get("qty")); // 单位：mm

        list.add(DataForSendToPrinterTSC.sizeBymm(width, height));
        list.add(DataForSendToPrinterTSC.gapBymm(gap, 0));
        list.add(DataForSendToPrinterTSC.cls());
        list.add(DataForSendToPrinterTSC.direction(0));

        // {type:'text|barcode|qrcode|image', content:'', x:0,y:0}
        for (Map<String, Object> m : configs) {
            String type = (String) m.get("type");
            String content = (String) m.get("content");
            int x = (int) (m.get("x") == null ? 0 : m.get("x")); //dpi: 1mm约为8个点
            int y = (int) (m.get("y") == null ? 0 : m.get("y"));
            String font_type = (String) (m.get("font_type") == null ? "TSS24.BF2" : m.get("font_type"));
            int size = (int) (m.get("size") == null ? 10 : m.get("size"));
            int x_multification = (int) (m.get("x_multification") == null ? 1 : m.get("x_multification"));
            int y_multification = (int) (m.get("y_multification") == null ? 1 : m.get("y_multification"));
            int rotation = (int) (m.get("rotation") == null ? 1 : m.get("rotation"));

            if ("text".equals(type)) {
                list.add(DataForSendToPrinterTSC.text(x, y, font_type, rotation, x_multification, y_multification, content));
            }else  if ("cut".equals(type)) {
                list.add(DataForSendToPrinterTSC.cut());
            }else  if ("sound".equals(type)) {
                list.add(DataForSendToPrinterTSC.sound(2,1000));
            } else  if ("selfTest".equals(type)) {
                list.add(DataForSendToPrinterTSC.selfTest());
            } else if ("barcode".equals(type)) {
                list.add(DataForSendToPrinterTSC.barCode(x, y, "128", 100, 1, rotation, 2, 2, content));
            } else if ("qrcode".equals(type)) {
                list.add(DataForSendToPrinterTSC.qrCode(x, y, "M", size, "A", rotation, "M1", "S3", content));
            } else if ("image".equals(type)) {
                Bitmap bitmap = BitmapFactory.decodeFile(content);
                byte[] bytes = DataForSendToPrinterTSC.bitmap(x, y, 0, bitmap, BitmapToByteData.BmpType.Threshold);
                list.add(bytes);
            }
        }

        list.add(DataForSendToPrinterTSC.print(qty));

        return list;
    }

}
