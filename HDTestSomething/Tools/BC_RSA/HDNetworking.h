//
//  HDNetworking.h
//  HDTestSomething
//
//  Created by yscompany on 2017/5/23.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDNetworking : NSObject
@property (nonatomic, strong) NSString *baseUrlStr;
+ (instancetype)shareURLSession;

- (void)sendHttp:(NSString *)httpMsgCode content:(NSDictionary *)contentDict controller:(UIViewController *)vc aimate:(BOOL)animate completion:(void(^)(NSString *isMore,NSDictionary *backCodeDict, NSDictionary *backContentDic,NSArray *backContentListDict, NSDictionary *backObligateDict) )compeletion error:(void(^)(NSError *connectionError))errors;

@end
