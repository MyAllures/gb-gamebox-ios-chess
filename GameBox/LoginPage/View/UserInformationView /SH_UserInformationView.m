//
//  SH_UserInformationView.m
//  GameBox
//
//  Created by Paul on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_UserInformationView.h"

@implementation SH_UserInformationView
+(instancetype)instanceInformationView{
    return [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
