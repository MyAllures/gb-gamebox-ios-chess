//
//  SH_ColorConfigView.m
//  GameBox
//
//  Created by shin on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ColorConfigView.h"
#import "SH_ColorsJsonManager.h"
#import "UIColor+HexString.h"

@implementation SH_ColorConfigView

- (void)setColorCategory:(NSString *)colorCategory
{
    _colorCategory = colorCategory;
    NSString *hexString = [[[SH_ColorsJsonManager sharedManager] obj] objectForKey:colorCategory];
    self.backgroundColor = [UIColor colorWithHexStr:hexString];
}


@end
