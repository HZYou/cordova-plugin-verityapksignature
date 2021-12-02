
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
    
@end
