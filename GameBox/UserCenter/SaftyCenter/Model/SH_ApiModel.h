//
//  SH_ApiModel.h
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SH_ApiModel;

@interface SH_ApiModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*apiID      ;
@property (nonatomic,copy) NSString <Optional>*apiName    ;
@property (nonatomic,copy) NSString <Optional>*balance    ;
@property (nonatomic,copy) NSString <Optional>*status     ;
@end
