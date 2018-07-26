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

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (void)setCoverWithNSString:(NSString *)string
{
    self.cover = [[[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:string] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setGameLinkWithNSString:(NSString *)string
{
    BOOL isEmpty = IS_EMPTY_STRING(string);
    if (!isEmpty) {
        self.gameLink = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:string];
    }
}

- (void)setNameWithNSString:(NSString *)string
{
    self.name = string;
}

@end
