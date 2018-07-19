//
//  RH_UserSafetyCodeModel.h
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface RH_UserSafetyCodeModel : JSONModel
@property (nonatomic,assign) BOOL hasRealName ;
@property (nonatomic,assign) BOOL hasPermissionPwd ;
@property (nonatomic,assign) BOOL isOpenCaptcha ;
@property (nonatomic,assign) NSInteger remindTimes ;
@property (nonatomic,copy) NSString *captChaUrl ;

-(void)updateHasRealName:(BOOL)bFlag ;
-(void)updateHasPersimmionPwd:(BOOL)bFlag ;
-(void)updateOpenCaptch:(BOOL)bFlag ;
-(void)updateRemindTime:(NSInteger)remindTime ;
@end
