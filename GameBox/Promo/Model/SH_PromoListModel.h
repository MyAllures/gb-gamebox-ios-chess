//
//  SH_PromoListModel.h
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_PromoListModel : NSObject

@property (nonatomic, assign) NSInteger mId;

@property (nonatomic, strong) NSString *mName;
@property (nonatomic, strong) NSString *mPhoto;
@property (nonatomic, strong) NSString *mUrl;

-(id)initWithDict: (NSDictionary *)dict;
@end
