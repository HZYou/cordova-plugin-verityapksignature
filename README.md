# cordova-plugin-verityapksignature

下载 apk 安装包后验证其签名的 Cordova 插件

## 支持平台

- Android
- iOS

## 安装插件

```

# 通过 npm 安装插件

cordova plugin cordova-plugin-verityapksignature

# 通过 github 安装

cordova plugin add https://github.com/HZYou/cordova-plugin-verityapksignature.git

# 通过本地文件路径安装

cordova plugin add 文件路径

```

**说明： ionic 项目命令前加上 ionic，即 ionic cordova plugin xxxxx**

参数说明：

1. packagename: Android 已安装应用的包名 / iOS 的 BundleID

2. apkPath: Android: 下载 apk 存放的路径，Android 9 请使用内部存储(getExternalFilesDir); / iOS 此参数忽略

3. successCallback: 成功回调
4. errorCallback: 失败回调

## 使用方法

验证包是否被篡改

**说明：使用 ts 进行开发时，需要在文件上变声明下 declare const VerityApkSignature;**

```typescript
declare const VerityApkSignature;
/**
   * 验证包是否被篡改
   * @param packageName 安卓包名/iOS bundleID
   * @param apkPath 安卓下载包存放的路径
   * @returns
   */
  verityAppIsValid(packageName: string, apkPath?: string) {
    return new Promise((resolve, reject) => {
      VerityApkSignature.verityApkSignature(packageName, apkPath, (res) => {
        resolve(res)
      }, (e) => {
        reject(e)
      })
    })
  }
```

## 常见错误

后续更新
