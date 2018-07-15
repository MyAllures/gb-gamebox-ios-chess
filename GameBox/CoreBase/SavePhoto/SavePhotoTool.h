//
//  SavePhotoTool.h
//  GameBox
//
//  Created by jun on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavePhotoTool : NSObject
+(instancetype)shared;
-(void)saveImageToPhoneImage:(UIImage *)image;
@end
