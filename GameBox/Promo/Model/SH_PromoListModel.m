//
//  SH_PromoListModel.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoListModel.h"

@implementation SH_PromoListModel

-(instancetype)initWithDict: (NSDictionary *)dict {
    self = dict ? [self init] :nil;
    if (self) {
        _mId = [dict integerValueForKey:@"id"];
        _mName = [dict stringValueForKey:@"name"];
        _mPhoto = [dict stringValueForKey:@"photo"];
        _mUrl = [dict stringValueForKey:@"url"];
    }
    return self;
}
@end
