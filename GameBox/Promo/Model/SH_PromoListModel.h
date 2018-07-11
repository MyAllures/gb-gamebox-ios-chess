//
//  SH_PromoListModel.h
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_PromoListModel : JSONModel

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *url;

//-(id)initWithDict: (NSDictionary *)dict;
@end
