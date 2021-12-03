# cordova-plugin-verityapksignature

安全修复的 Cordova 插件，包含的功能有：1. Android 下载 apk 安装包后验证其签名; 2. iOS 验证 bundleId 是否被篡改; 3. 检测 iOS 网络代理

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

## API Reference

- verityAppIsValid : <code>function</code>
- isProxy : <code>function</code>

### VerityApkSignature.verityApkSignature(packageName,apkPath,successCallback,errorCallback)

Android 校验下载的 apk 包的签名与已知的包是否相同；iOS 校验 bundle ID 是否被篡改

**Supported Platforms**

- Android
- iOS

**参数说明**

1. packageName: Android 已安装应用的包名 / iOS 的 BundleID

2. apkPath: Android: 下载 apk 存放的路径，Android 9 请使用内部存储(getExternalFilesDir); / iOS 此参数忽略

3. successCallback: 成功回调
4. errorCallback: 失败回调
5. successCallback 的结果： `{valid:boolean|1|0}`

**Example**

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
       // android res:{valid:true}
       // ios: {valid: 1}
     }, (e) => {
       reject(e)
     })
   })
 }
```

### VerityApkSignature.isProxy()

检测 iOS 是否代理网络

**Supported Platforms**

- iOS

**Example**

```typescript
declare const VerityApkSignature;

isProxyIos(){
  return new Promise((resolve, reject) => {
    VerityApkSignature.isProxy(res => resolve(res), e =>reject(e))
    // res: {isProxy: 1} or {isProxy: 0}
  })
}
```

**isProxy 暂只支持 iOS。Android 待开发**

**说明：使用 ts 进行开发时，需要在文件上变声明下 <code>declare const VerityApkSignature;</code>**
