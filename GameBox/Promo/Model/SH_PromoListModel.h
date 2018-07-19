//
//  SH_PromoListModel.h
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface SH_PromoListModel : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *photo;
@property (nonatomic, strong) NSString <Optional> *url;

@end
