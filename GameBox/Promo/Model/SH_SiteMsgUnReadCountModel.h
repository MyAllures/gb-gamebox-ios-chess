//
//  SH_SiteMsgUnReadCountModel.h
//  GameBox
//
//  Created by Paul on 2018/8/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SH_SiteMsgUnReadCountModel : JSONModel
@property(nonatomic,strong)NSString *sysMessageUnReadCount;
@property(nonatomic,strong)NSString *advisoryUnReadCount;

//extend
@property(nonatomic,assign)NSInteger siteMsgUnReadCount;
@end
