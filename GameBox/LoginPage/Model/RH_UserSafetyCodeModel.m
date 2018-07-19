//
//  RH_UserSafetyCodeModel.m
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "RH_UserSafetyCodeModel.h"

@implementation RH_UserSafetyCodeModel

-(void)updateHasRealName:(BOOL)bFlag
{
    _hasRealName = bFlag ;
}
-(void)updateHasPersimmionPwd:(BOOL)bFlag
{
    _hasPermissionPwd = bFlag ;
}

-(void)updateOpenCaptch:(BOOL)bFlag
{
    _isOpenCaptcha = bFlag ;
}
-(void)updateRemindTime:(NSInteger)remindTime
{
    _remindTimes = remindTime ;
}

@end
