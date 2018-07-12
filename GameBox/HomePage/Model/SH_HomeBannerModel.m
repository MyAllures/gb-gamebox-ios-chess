//
//  SH_HomeBannerModel.m
//  GameBox
//
//  Created by shin on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HomeBannerModel.h"
#import "NetWorkLineMangaer.h"

@implementation SH_HomeBannerModel

- (void)setCoverWithNSString:(NSString *)string
{
    self.cover = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:string];
}

@end
