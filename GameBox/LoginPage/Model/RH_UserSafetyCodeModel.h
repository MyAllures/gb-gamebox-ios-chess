//
//  RH_UserSafetyCodeModel.h
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface RH_UserSafetyCodeModel : JSONModel
@property (nonatomic,assign,readonly) BOOL hasRealName ;
@property (nonatomic,assign,readonly) BOOL hasPersimmionPwd ;
@property (nonatomic,assign,readonly) BOOL isOpenCaptch ;
@property (nonatomic,assign,readonly) NSInteger remindTime ;
@property (nonatomic,strong,readonly) NSString *lockTime ;

-(void)updateHasRealName:(BOOL)bFlag ;
-(void)updateHasPersimmionPwd:(BOOL)bFlag ;
-(void)updateOpenCaptch:(BOOL)bFlag ;
-(void)updateRemindTime:(NSInteger)remindTime ;
-(void)updateLockTime:(NSString*)lockTime ;
@end
