//
//  SH_GameItemModel.m
//  GameBox
//
//  Created by shin on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GameItemModel.h"
#import "NetWorkLineMangaer.h"

@implementation SH_GameItemModel

- (void)setCoverWithNSString:(NSString *)string
{
    self.cover = [[[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:string] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setGameLinkWithNSString:(NSString *)string
{
    if ([self.name isEqualToString:@"电竞牛"]) {
        NSLog(@"");
    }

    BOOL isEmpty = IS_EMPTY_STRING(string);
    if (!isEmpty) {
        self.gameLink = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:string];
    }
}

- (void)setNameWithNSString:(NSString *)string
{
    if ([string isEqualToString:@"电竞牛"]) {
        NSLog(@"");
    }
    self.name = string;
}

@end
