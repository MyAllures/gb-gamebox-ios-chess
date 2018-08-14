//
//  SH_ColorsJsonManager.m
//  GameBox
//
//  Created by shin on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ColorsJsonManager.h"

@interface SH_ColorsJsonManager ()

@property (nonatomic, strong) NSDictionary *jsonDic;

@end

@implementation SH_ColorsJsonManager

+ (instancetype)sharedManager
{
    static SH_ColorsJsonManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[SH_ColorsJsonManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSBundle *bundle;
#if TARGET_INTERFACE_BUILDER
        bundle = [NSBundle bundleForClass:[self class]];
#else
        bundle = [NSBundle mainBundle];
#endif
        NSString *jsonPath = [bundle pathForResource:@"colors" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSError *error = nil;
        self.jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"");
    }
    return self;
}

- (NSDictionary *)obj
{
    return self.jsonDic;
}

@end
