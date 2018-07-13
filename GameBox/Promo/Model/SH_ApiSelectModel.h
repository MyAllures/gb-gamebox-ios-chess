//
//  SH_ApiSelectModel.h
//  GameBox
//
//  Created by sam on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_ApiSelectModel : JSONModel
@property (nonatomic, assign) NSInteger apiId;
@property (nonatomic, strong) NSString *apiName;
@end
