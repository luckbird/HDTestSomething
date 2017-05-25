//
//  HDNetworkingLearnController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/23.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDNetworkingLearnController.h"
#import "BC_RSA.h"

@interface HDNetworkingLearnController ()<NSURLSessionDelegate>

@end

@implementation HDNetworkingLearnController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSURL *url = [NSURL URLWithString:
    //                  @"http://www.onevcat.com/2011/11/debug/;param?p=307#more-307"];
    //    NSLog(@"Scheme: %@", [url scheme]);
    //    NSLog(@"Host: %@", [url host]);
    //    NSLog(@"Port: %@", [url port]);
    //    NSLog(@"Path: %@", [url path]);
    //    NSLog(@"Relative path: %@", [url relativePath]);
    //    NSLog(@"Path components as array: %@", [url pathComponents]);
    //    NSLog(@"Parameter string: %@", [url parameterString]);
    //    NSLog(@"Query: %@", [url query]);
    //    NSLog(@"Fragment: %@", [url fragment]);
    
    NSString *path;
    NSString *pwd;
    path = [[NSBundle mainBundle] pathForResource:@"u.ysepay.com_new" ofType:@"pfx"];
    pwd = @"yst123";
    if(path){
        [BC_RSA setPrivateKey:path password:pwd];
    }else{
        LOG_INF(@"pfx的路径出现问题");
    }
    
    NSMutableURLRequest *request = [self buildRequestFunction];
    
    NSURLSessionConfiguration *configuration = [self buildSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败");
        }else{
            NSString *str_back = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            int headerLenth;
            headerLenth = 401;
            str_back=[str_back substringWithRange:NSMakeRange(headerLenth,str_back.length - headerLenth)];//substring 测试：311  生产：401
            str_back=[GTMBase64 decodeBase64String:str_back];
            NSLog(@"请求数据%@",str_back);
        }
    }];
    [task resume];   // 开始 Task 任务
    
    //    [task suspend];  // 暂停 Task 任务
    
    // 取消 Task 任务
    //    [task cancel];  // 完全取消，下次下载又从 0.0% 开始
    
    
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    // 可恢复性取消，下次下载可从 保存的 resumeData 处开始
    [downTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
    }];
}

-(NSMutableURLRequest *)buildRequestFunction
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://u.ysepay.com:8288/MobileGate/login.do"]];
    
    // 设置缓存策略
    /*
     // 默认的缓存策略，会在本地缓存
     NSURLRequestUseProtocolCachePolicy = 0,
     
     // 忽略本地缓存数据，永远都是从服务器获取数据，不使用缓存，应用场景：股票，彩票
     NSURLRequestReloadIgnoringLocalCacheData = 1,
     NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData
     
     // 首先使用缓存，如果没有本地缓存，才从原地址下载
     NSURLRequestReturnCacheDataElseLoad = 2,
     
     // 使用本地缓存，从不下载，如果本地没有缓存，则请求失败和 "离线" 数据访问有关，可以和 Reachability 框架结合使用，
     // 如果用户联网，直接使用默认策略。如果没有联网，可以使用返回缓存策略，郑重提示：要把用户拉到网络上来。
     NSURLRequestReturnCacheDataDontLoad = 3,
     
     // 无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载
     NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4,      // Unimplemented
     
     // 如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载
     NSURLRequestReloadRevalidatingCacheData = 5,                // Unimplemented
     
     缓存的数据保存在沙盒路径下 Caches 文件夹中的 SQLite 数据库中。
     */
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    // 设置超时时间
    request.timeoutInterval = 60;
    
    // 设置请求模式
    /*
     默认是 GET
     */
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    request.HTTPBody = [self buildRequestHTTPBody];
    
    // 设置请求头
    /*
     告诉服务器客户端类型，只能写英文，User-Agent 是固定的 key
     */
    [request setValue:@"iPhone 6s Plus" forHTTPHeaderField:@"User-Agent"];
    
    return request;
}

-(NSURLSessionConfiguration *)buildSessionConfiguration
{
    NSURLSessionConfiguration *resultConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    /*
     HTTPAdditionalHeaders           HTTP 请求头，告诉服务器有关客户端的附加信息，这对于跨会话共享信息，
     如内容类型，语言，用户代理，身份认证，是很有用的。
     
     Accept                          告诉服务器客户端可接收的数据类型，如：@"application/json" 。
     Accept-Language                 告诉服务器客户端使用的语言类型，如：@"en" 。
     Authorization                   验证身份信息，如：authString 。
     User-Agent                      告诉服务器客户端类型，如：@"iPhone AppleWebKit" 。
     range                           用于断点续传，如：bytes=10- 。
     
     networkServiceType              网络服务类型，对标准的网络流量，网络电话，语音，视频，以及由一个后台进程使用的流量
     进行了区分。大多数应用程序都不需要设置这个。
     NSURLNetworkServiceTypeDefault          默认
     NSURLNetworkServiceTypeVoIP             VoIP
     NSURLNetworkServiceTypeVideo            视频
     NSURLNetworkServiceTypeBackground       后台
     NSURLNetworkServiceTypeVoice            语音
     
     allowsCellularAccess            允许蜂窝访问，和 discretionary 自行决定，被用于节省通过蜂窝连接的带宽。
     建议在使用后台传输的时候，使用 discretionary 属性，而不是 allowsCellularAccess
     属性，因为它会把 WiFi 和电源可用性考虑在内。
     
     timeoutIntervalForRequest       超时时长，许多开发人员试图使用 timeoutInterval 去限制发送请求的总时间，但这误会了
     timeoutIntervalForRequest 的意思：报文之间的时间。
     timeoutIntervalForResource      整个资源请求时长，实际上提供了整体超时的特性，这应该只用于后台传输，而不是用户实际上
     可能想要等待的任何东西。
     
     HTTPMaximumConnectionsPerHost   对于一个 host 的最大并发连接数，iOS 默认数值是 4，MAC 下的默认数值是 6，从某种程度上，
     替代了 NSOpeartionQueue 的最大并发线程数。是 Foundation 框架中 URL 加载系统的一个新
     的配置选项。它曾经被用于 NSURLConnection 管理私人连接池。现在有了 NSURLSession，开发
     者可以在需要时限制连接到特定主机的数量。日常开发中，几乎不用去管 session 的最大并发数。
     
     HTTPShouldUsePipelining         也出现在 NSMutableURLRequest，它可以被用于开启 HTTP 管道，这可以显着降低请求的加载时
     间，但是由于没有被服务器广泛支持，默认是禁用的。
     
     sessionSendsLaunchEvents        是另一个新的属性，该属性指定该会话是否应该从后台启动。
     
     connectionProxyDictionary       指定了会话连接中的代理服务器。同样地，大多数面向消费者的应用程序都不需要代理，所以基本上不
     需要配置这个属性。关于连接代理的更多信息可以在 CFProxySupport Reference 找到。
     
     Cookie Policies
     HTTPCookieStorage               被会话使用的 cookie 存储。默认情况下，NSHTTPCookieShorage 的sharedHTTPCookieStorage
     会被使用，这与 NSURLConnection 是相同的。
     HTTPCookieAcceptPolicy          决定了该会话应该接受从服务器发出的 cookie 的条件。
     HTTPShouldSetCookies            指定了请求是否应该使用会话 HTTPCookieStorage 的 cookie。
     
     Security Policies
     URLCredentialStorage            会话使用的证书存储。默认情况下，NSURLCredentialStorage 的sharedCredentialStorage
     会被使用，这与 NSURLConnection 是相同的。
     
     TLSMaximumSupportedProtocol     确定是否支持 SSLProtocol 版本的会话。
     TLSMinimumSupportedProtocol     确定是否支持 SSLProtocol 版本的会话。
     
     Caching Policies
     URLCache                        会话使用的缓存。默认情况下，NSURLCache 的sharedURLCache 会被使用，
     这与 NSURLConnection是相同的。
     requestCachePolicy              缓存策略，指定一个请求的缓存响应应该在什么时候返回。这相当于 NSURLRequest 的
     cachePolicy方法。
     
     Custom Protocols
     protocolClasses                 注册 NSURLProtocol 类的特定会话数组。
     */
    return resultConfiguration;
}

-(NSData *)buildRequestHTTPBody
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    dataDic[@"loginId"] = @"15211462082";
    dataDic[@"loginPWD"] = @"ho5w0jbhL+BHD+lO7P9eAA==";
    dataDic[@"loginType"] = @"1";
    
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    headDic[@"msgCode"] = @"CM003";
    headDic[@"ver"] = @"4.0.7";//版本号
    headDic[@"minVer"] = @"0";
    headDic[@"imei"] = [[UIDevice currentDevice].identifierForVendor UUIDString];//设备唯一表示
    headDic[@"time"] = [self thedate];
    headDic[@"systemCode"] = @"YS_MOBILE_PAYMENT";
    headDic[@"osVer"] = [[UIDevice currentDevice] systemVersion];//操作系统的版本号
    headDic[@"msgSn"] = @"";
    headDic[@"deviceId"] = [[UIDevice currentDevice].identifierForVendor UUIDString];
    headDic[@"outerCode"] = @"a4389afbbc71cc765d6a0ec29842a301f030c1c459601830a66698c34710745f";
    headDic[@"src"] = @"IOS|NOLOGIN";
    
    NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
    groupDic[@"head"] = headDic;
    groupDic[@"body"] = dataDic;
    NSString *groupStr = [JSONKit jsonStringWithObject:groupDic];
    NSString *msgStr = [GTMBase64 encodeBase64String:groupStr];
    NSString *checkStr = [BC_RSA signTheDataSHA1WithRSA:groupStr];
    
    NSString *key = [self getUniqueStrByUUID];
    NSString *bodyStr = [NSString stringWithFormat:@"src=%@&msgCode=%@&msgId=%@&signIn=%@&check=%@&msg=%@&version=%@",[headDic objectForKey:@"src"],[headDic objectForKey:@"msgCode"],[self thedate], [BC_RSA RSAEncrypotoTheData:key],checkStr,msgStr,@"4.0.7"];
    
    return [[self UrlEncodedString:bodyStr] dataUsingEncoding:NSUTF8StringEncoding];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获得当前时间
-(NSString *)thedate
{
    NSDate *now = [[NSDate alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *theDate = [dateFormat stringFromDate:now];
    return theDate;
}

//处理要发送URL
-(NSString *)UrlEncodedString:(NSString *)sourceText
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceText ,NULL ,CFSTR("+") ,kCFStringEncodingUTF8));
    return result;
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [GTMBase64 encodeBase64String:uuidString];
}

@end
