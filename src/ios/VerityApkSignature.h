
/*
  重签名检测
*/

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVCommandDelegateImpl.h>

@interface VerityApkSignature : CDVPlugin
{
    CDVCommandDelegateImpl *commandDelegate;
}
  
  /*
    判断BundleID 是否被修改
  */
- (void)verityApkSignature:(CDVInvokedUrlCommand*)command;

/*
  判断当前网络是否开启代理
*/
- (void)isProxy:(CDVInvokedUrlCommand*)command;
    
@end
