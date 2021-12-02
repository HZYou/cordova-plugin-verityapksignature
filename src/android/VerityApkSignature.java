package com.hzy.cordova.verityapksignature;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Objects;

/**
 * This class echoes a string called from JavaScript.
 */
public class VerityApkSignature extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("verityApkSignature")) {
            String packageName = args.getString(0);
            String apkPath = args.getString(1);
            this.verityApkSignature(packageName, apkPath, callbackContext);
            return true;
        }
        return false;
    }

    private void verityApkSignature(String packageName, String apkPath, CallbackContext callbackContext) {
        if (packageName != null && packageName.length() > 0 && apkPath != null && apkPath.length() > 0) {
            try {
                boolean res = this.veritySignature(packageName, apkPath);
                JSONObject r = new JSONObject();
                r.put("valid", res);
                callbackContext.success(r);

            } catch (Exception e) {
                callbackContext.error(e.getMessage());
            }

        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private boolean veritySignature(String packageName, String apkPath) {
        try {
            apkPath = apkPath.replace("file://", "");
            //获取已安装应用签名
            Signature pkgSig = cordova.getActivity().getPackageManager()
                    .getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
                    .signatures[0];

            //获取下载的apk签名
            PackageManager mPm = cordova.getActivity().getPackageManager();
            PackageInfo mInfo = mPm.getPackageArchiveInfo(apkPath, PackageManager.GET_SIGNATURES);
            Signature apkSig = Objects.requireNonNull(mInfo).signatures[0];

            //对比两个签名的md5是否一致
            String pkgSigMd5 = getMd5(pkgSig);
            String apkSigMd5 = getMd5(apkSig);
            if (pkgSigMd5.equals(apkSigMd5)) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private String getMd5(Signature signature) {
        return encryptionMD5(signature.toByteArray());
    }

    public static String encryptionMD5(byte[] byteStr) {
        MessageDigest messageDigest = null;
        StringBuffer md5StrBuff = new StringBuffer();
        try {
            messageDigest = MessageDigest.getInstance("MD5");
            messageDigest.reset();
            messageDigest.update(byteStr);
            byte[] byteArray = messageDigest.digest();
            for (int i = 0; i < byteArray.length; i++) {
                if (Integer.toHexString(0xFF & byteArray[i]).length() == 1) {
                    md5StrBuff.append("0").append(Integer.toHexString(0xFF & byteArray[i]));
                } else {
                    md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));
                }
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return md5StrBuff.toString();
    }
}

