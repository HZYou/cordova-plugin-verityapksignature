/*
  重签名检测
*/

#import "VerityApkSignature.h"

@implementation VerityApkSignature


- (void)verityApkSignature:(CDVInvokedUrlCommand*)command
{
    NSString *bundleId =[command.arguments objectAtIndex:0];
    BOOL notChange = [self checkCodeSignWithProvisionID:bundleId];
    NSDictionary* checkResult = @{
      @"valid":@(notChange?true:false)
    };
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:checkResult];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)isProxy:(CDVInvokedUrlCommand*)command
{
    
    BOOL proxyRes = [self getProxyStatus];
    NSDictionary* checkResult = @{
      @"isProxy":@(proxyRes?true:false)
    };
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:proxyRes];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (BOOL)checkCodeSignWithProvisionID:(NSString *)provisionID
{
    // 描述文件路径
    NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
 
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:embeddedPath]) {
        
        // 读取application-identifier
        NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
        NSArray *embeddedProvisioningLines = [embeddedProvisioning componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        for (int i = 0; i < [embeddedProvisioningLines count]; i++) {
            if ([[embeddedProvisioningLines objectAtIndex:i] rangeOfString:@"application-identifier"].location != NSNotFound) {
                
                NSInteger fromPosition = [[embeddedProvisioningLines objectAtIndex:i+1] rangeOfString:@"<string>"].location+8;
                
                NSInteger toPosition = [[embeddedProvisioningLines objectAtIndex:i+1] rangeOfString:@"</string>"].location;
                
                NSRange range;
                range.location = fromPosition;
                range.length = toPosition - fromPosition;
                
                NSString *fullIdentifier = [[embeddedProvisioningLines objectAtIndex:i+1] substringWithRange:range];
                
                
                NSArray *identifierComponents = [fullIdentifier componentsSeparatedByString:@"."];
                
                int count = identifierComponents.count;
                NSString *appIdentifier = @"";
                
                for( int i=0; i<count; i++){
                    if(i != 0){
                        NSString *temp = [identifierComponents objectAtIndex:i];
                        if(i < count-1){
                            temp = [temp stringByAppendingString:@"."];
                        }
                        appIdentifier = [appIdentifier stringByAppendingString:temp];
                    }
                }
                
                // 对比BundleID
                if (![appIdentifier isEqual:provisionID])
                {
                    return NO;
                }
                else
                {
                    return YES;
                }
            }
        }
    }
    return YES;
    
}



-(BOOL)getProxyStatus {
    NSDictionary *proxySettings = (__bridge NSDictionary
                                   *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray
                        *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef
                                                       _Nonnull)([NSURL
                                                                  URLWithString:@"https://www.baidu.com"]), (__bridge
                                                                                                             CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings =proxies.count?[proxies
                                           objectAtIndex:0]:nil;
    if ([@"kCFProxyTypeNone" isEqualToString:[settings
                                              objectForKey:(NSString *)kCFProxyTypeKey]]){
        //没有设置代理
        return NO;
    }
    //设置了代理
    return YES;
}

@end
