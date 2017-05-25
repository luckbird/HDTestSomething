//
//  HDNetworking.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/23.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDNetworking.h"
#import "BC_RSA.h"
#import "Reachability.h"

static HDNetworking *netWork;
@interface HDNetworking ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *hdSession;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) UILabel *showMessageLabel;
@property (nonatomic, strong) UIView *showBackgroundView;
@end

@implementation HDNetworking

+(instancetype)shareURLSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [HDNetworking new];
    });
    return netWork;
}
- (void)sendHttp:(NSString *)httpMsgCode content:(NSDictionary *)contentDict controller:(UIViewController *)vc aimate:(BOOL)animate completion:(void (^)(NSString *, NSDictionary *, NSDictionary *, NSArray *, NSDictionary *))compeletion error:(void (^)(NSError *))errors {
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        //        DLog(@"有wifi");
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        //        DLog(@"使用手机自带网络进行上网");
    } else {
        [self showmessage:@"手机没有网络"];
        return;
    }
    NSString *path;
    NSString *pwd;
    path = [[NSBundle mainBundle] pathForResource:@"u.ysepay.com_new" ofType:@"pfx"];
    pwd = @"yst123";
    if(path){
        [BC_RSA setPrivateKey:path password:pwd];
    }else{
        LOG_INF(@"pfx的路径出现问题");
    }
    NSMutableURLRequest *request = [self getRequestWithRequestMethod:@"POST" andRequestDict:nil];
    request.HTTPBody = [[self getHttpBodyStrWithMsgCode:httpMsgCode andBodyDict:contentDict] dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [self.hdSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            errors(error);
        }else{
            NSString *str_back = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            int headerLenth;
            headerLenth = 401;
            str_back=[str_back substringWithRange:NSMakeRange(headerLenth,str_back.length - headerLenth)];//substring 测试：311  生产：401
            str_back=[GTMBase64 decodeBase64String:str_back];
            NSDictionary *dict = [JSONKit jsonDicWithString:str_back];
            NSDictionary *dict1 = [dict objectForKey:@"body"];
            NSDictionary *backCodeDict = [dict1 objectForKey:@"result"];
            NSArray *backContentlist = [dict1 objectForKey:@"contentList"];
            NSDictionary *backContentDict = [dict1 objectForKey:@"content"];
            NSDictionary *backHeadDict = [dict objectForKey:@"head"];
            NSLog(@"==============%@收到回执数据:\n\n backCodeDict:\n%@\n\n backContentDict:\n%@\n\n backContentlist:\n%@\n\n",[backHeadDict objectForKey:@"msgCode"],backCodeDict,backContentDict,backContentlist);
            compeletion(@"",backCodeDict,backContentDict,backContentlist,nil);
        }
    }];
    [task resume];

}
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSString *method = challenge.protectionSpace.authenticationMethod;
    LOG_INF(@"%@", method);
    if([method isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSString *host = challenge.protectionSpace.host;
        LOG_INF(@"%@", host);
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        return;
    }
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"yst" ofType:@"p12"];
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(PKCS12Data);
    SecIdentityRef identity;
    // 读取p12证书中的内容
    OSStatus result = [self extractP12Data:inPKCS12Data toIdentity:&identity];
    if(result != errSecSuccess){
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        return;
    }
    SecCertificateRef certificate = NULL;
    SecIdentityCopyCertificate (identity, &certificate);
    const void *certs[] = {certificate};
    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(NSArray*)CFBridgingRelease(certArray) persistence:NSURLCredentialPersistencePermanent];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

-(OSStatus) extractP12Data:(CFDataRef)inP12Data toIdentity:(SecIdentityRef*)identity {
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("yst123");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    if (securityError == 0) {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    if (options) {
        CFRelease(options);
    }
    return securityError;
}

- (NSURLSessionConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    }
    return _configuration;
}
- (NSMutableURLRequest *)getRequestWithRequestMethod:(NSString *)typeStr andRequestDict:(NSDictionary *)dict {
    NSString *encodingStr = KencodingCNtoEN(BASE_URL);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:encodingStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    request.HTTPMethod = typeStr;
    [request setValue:@"iPhone 6s Plus" forHTTPHeaderField:@"User-Agent"];
    return request;
}
- (NSMutableDictionary *)getRequestHttpHeadWithMsgCode:(NSString *)msgCode {
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    headDic[@"msgCode"] = [VerifyTools getSafeString:msgCode];
    headDic[@"ver"] = @"4.0.7";//版本号
    headDic[@"minVer"] = @"0";
    headDic[@"imei"] = [[UIDevice currentDevice].identifierForVendor UUIDString];//设备唯一表示
    headDic[@"time"] = [self theDate];
    headDic[@"systemCode"] = @"YS_MOBILE_PAYMENT";
    headDic[@"osVer"] = [[UIDevice currentDevice] systemVersion];//操作系统的版本号
    headDic[@"msgSn"] = @"";
    headDic[@"deviceId"] = [[UIDevice currentDevice].identifierForVendor UUIDString];
    headDic[@"outerCode"] = @"a4389afbbc71cc765d6a0ec29842a301f030c1c459601830a66698c34710745f";
    headDic[@"src"] = @"IOS|NOLOGIN";
    return headDic;
}
- (NSString *)getHttpBodyStrWithMsgCode:(NSString *)msgCode andBodyDict:(NSDictionary *)bodyDict {
    NSString *bodyStr = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *headDict = [self getRequestHttpHeadWithMsgCode:msgCode];
    dict[@"head"] = headDict;
    dict[@"body"] = bodyDict;
    NSString *groupStr = [JSONKit jsonStringWithObject:dict];
    NSString *msgStr = [GTMBase64 encodeBase64String:groupStr];
    NSString *checkStr = [BC_RSA signTheDataSHA1WithRSA:groupStr];
    NSString *key = [self getUniqueStrByUUID];
    bodyStr = [NSString stringWithFormat:@"src=%@&msgCode=%@&msgId=%@&signIn=%@&check=%@&msg=%@&version=%@",[headDict objectForKey:@"src"],[headDict objectForKey:@"msgCode"],[self theDate], [BC_RSA RSAEncrypotoTheData:key],checkStr,msgStr,[headDict objectForKey:@"ver"]];
    return [self UrlEncodedString:bodyStr];
}
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [GTMBase64 encodeBase64String:uuidString];
}
- (NSString *)theDate {
    NSDate * now = [[NSDate alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:now];
}
- (void)showmessage:(NSString *)message {
    NSString *showMessageStr = [VerifyTools getSafeString:message];
    CGSize size = [showMessageStr boundingRectWithSize:CGSizeMake(290, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.showMessageLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.showBackgroundView.frame = CGRectMake((kScreenW - 40 - size.width) / 2, 0, size.width + 20, size.height + 10);
    [UIView animateWithDuration:1 animations:^{
        [window addSubview:self.showBackgroundView];
    } completion:^(BOOL finished) {
        [self.showBackgroundView removeFromSuperview];
    }];
    
}
- (NSURLSession *)hdSession {
    if (!_hdSession) {
        _hdSession = [NSURLSession sessionWithConfiguration:self.configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _hdSession;
}
-(NSString *)UrlEncodedString:(NSString *)sourceText
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceText ,NULL ,CFSTR("+") ,kCFStringEncodingUTF8));
    return result;
}
- (UILabel *)showMessageLabel {
    if (!_showMessageLabel) {
        _showMessageLabel = [UILabel new];
        _showMessageLabel.textAlignment = NSTextAlignmentCenter;
        _showMessageLabel.textColor = [UIColor whiteColor];
        _showMessageLabel.font = [UIFont systemFontOfSize:17.0f];
        _showMessageLabel.backgroundColor = [UIColor clearColor];
        _showBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 1, 1)];
        _showBackgroundView.backgroundColor = [UIColor blackColor];
        [_showBackgroundView addSubview:_showMessageLabel];
    }
    return _showMessageLabel;
}
@end
