//
//  SH_PromoListModel.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoListModel.h"

@implementation SH_PromoListModel

- (void)setPhotoWithNSString:(NSString *)string
{
    self.photo = [[[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:string] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setUrlWithNSString:(NSString *)string
{
    self.url = [NSString stringWithFormat:@"%@://%@%@",[NetWorkLineMangaer sharedManager].currentHttpType,[NetWorkLineMangaer sharedManager].currentHost,string];
}

@end
