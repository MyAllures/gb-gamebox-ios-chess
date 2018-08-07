//
//  SH_LineCheckErrManager.m
//  GameBox
//
//  Created by shin on 2018/8/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_LineCheckErrManager.h"
#import <sys/utsname.h>
#import "SH_NetWorkService+LineCheck.h"

@interface SH_LineCheckErrManager ()

@property (nonatomic, strong) NSMutableArray *errArr;

@end

@implementation SH_LineCheckErrManager

+ (instancetype)sharedManager
{
    static SH_LineCheckErrManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[SH_LineCheckErrManager alloc] init];
        }
    });
    return manager;
}

- (NSMutableArray *)errArr
{
    if (_errArr == nil) {
        _errArr = [NSMutableArray array];
    }
    return _errArr;
}

- (void)collectErrInfo:(NSDictionary *)errInfo
{
    [self.errArr addObject:errInfo];
}

- (void)send
{
    NSMutableArray *sendingErrArr = [self.errArr mutableCopy];
    [self.errArr removeAllObjects];
    if (sendingErrArr.count) {
        [self uploadLineCheckErr:sendingErrArr];
    }
}

- (NSString *)randomMark
{
    static int kNumber = 6;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//获取设备IP地址
- (NSString *)localIPAddress
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict[@"cip"] ? dict[@"cip"] : @"";
    }
    return @"";
}

- (void)uploadLineCheckErr:(NSMutableArray *)errInfoArr
{
    NSMutableDictionary *dictError = [[NSMutableDictionary alloc] init] ;
    [dictError setValue:SID forKey:RH_SP_COLLECTAPPERROR_SITEID] ;
    [dictError setValue:[self randomMark] forKey:RH_SP_COLLECTAPPERROR_MARK] ;
    [dictError setValue:[self localIPAddress]?[self localIPAddress]:@"" forKey:RH_SP_COLLECTAPPERROR_IP] ;
    if ([RH_UserInfoManager shareUserManager].loginUserName.length){
        [dictError setValue:[RH_UserInfoManager shareUserManager].loginUserName
                     forKey:RH_SP_COLLECTAPPERROR_USERNAME] ;
        [dictError setValue:[RH_UserInfoManager shareUserManager].loginTime
                     forKey:RH_SP_COLLECTAPPERROR_LASTLOGINTIME] ;
    }
    NSMutableString *domainList = [[NSMutableString alloc] init] ;
    NSMutableString *errorCodeList = [[NSMutableString alloc] init] ;
    NSMutableString *errorMessageList = [[NSMutableString alloc] init] ;
    for (NSDictionary *dictTmp in errInfoArr) {
        if (domainList.length){
            [domainList appendString:@";"] ;
        }
        
        if (errorCodeList.length){
            [errorCodeList appendString:@";"] ;
        }
        
        if (errorMessageList.length){
            [errorMessageList appendString:@";"] ;
        }
        
        [domainList appendString:[dictTmp stringValueForKey:RH_SP_COLLECTAPPERROR_DOMAIN]] ;
        [errorCodeList appendString:[dictTmp stringValueForKey:RH_SP_COLLECTAPPERROR_CODE]] ;
        [errorMessageList appendString:[dictTmp stringValueForKey:RH_SP_COLLECTAPPERROR_ERRORMESSAGE]] ;
    }
    
    [dictError setValue:domainList forKey:RH_SP_COLLECTAPPERROR_DOMAIN] ;
    [dictError setValue:errorCodeList forKey:RH_SP_COLLECTAPPERROR_CODE] ;
    [dictError setValue:errorMessageList forKey:RH_SP_COLLECTAPPERROR_ERRORMESSAGE] ;
    [dictError setValue:@"1" forKey:RH_SP_COLLECTAPPERROR_TYPE];
    NSString *appVersion = [NSString stringWithFormat:@"%@.%@",GB_CURRENT_APPVERSION,GB_CURRENT_APPBUILD];
    [dictError setValue:appVersion forKey:RH_SP_COLLECTAPPERROR_VERSIONNAME];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    [dictError setValue:sysVersion forKey:RH_SP_COLLECTAPPERROR_SYSCODE];
    [dictError setValue:@"iOS" forKey:RH_SP_COLLECTAPPERROR_CHANNEL];
    NSString *deviceBrands = [[UIDevice currentDevice] model];
    [dictError setValue:deviceBrands forKey:RH_SP_COLLECTAPPERROR_BRANDS];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [dictError setValue:deviceModel forKey:RH_SP_COLLECTAPPERROR_MODEL];
    
    NSString *js = [self convertToJsonData:dictError];
    [SH_NetWorkService uploadLineCheckErr:dictError complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        //
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


@end
