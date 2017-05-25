//
//  HDNetworking.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/23.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDNetworking.h"

static HDNetworking *netWork;
@interface HDNetworking ()

@property (nonatomic, strong) NSURLSession *hdSession;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;

@end

@implementation HDNetworking

+(instancetype)shareURLSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [HDNetworking new];
    });
    return netWork;
}

- (NSURLSession *)hdSession {
    if (!_hdSession) {
        _hdSession = [NSURLSession sharedSession];
    }
    return _hdSession;
}
- (NSURLSessionConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    }
    return _configuration;
}
- (NSMutableURLRequest *)getRequestWithRequestMethod:(NSString *)typeStr andRequestDict:(NSDictionary *)dict {
    NSString *encodingStr = KencodingCNtoEN(self.baseUrlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:encodingStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    request.HTTPMethod = typeStr;
    NSString *bodyStr = [JSONKit jsonStringWithObject:[self getRequestHttpHead]];
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    return request;
}
- (NSMutableDictionary *)getRequestHttpHead {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    headDic[@"msgCode"] = @"CM003";
    headDic[@"ver"] = @"4.0.6";//版本号
    headDic[@"minVer"] = @"0";
    headDic[@"imei"] = [[UIDevice currentDevice].identifierForVendor UUIDString];//设备唯一表示
    headDic[@"time"] = [self theDate];
    headDic[@"systemCode"] = @"YS_MOBILE_PAYMENT";
    headDic[@"osVer"] = [[UIDevice currentDevice] systemVersion];//操作系统的版本号
    headDic[@"msgSn"] = @"";
    headDic[@"deviceId"] = [[UIDevice currentDevice].identifierForVendor UUIDString];
    headDic[@"outerCode"] = @"a4389afbbc71cc765d6a0ec29842a301f030c1c459601830a66698c34710745f";
    headDic[@"src"] = @"IOS|NOLOGIN";
    return dict;
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
@end
