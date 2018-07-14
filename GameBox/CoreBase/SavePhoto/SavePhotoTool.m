//
//  SavePhotoTool.m
//  GameBox
//
//  Created by jun on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SavePhotoTool.h"
static SavePhotoTool *_tool;
@implementation SavePhotoTool
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_tool) {
            _tool = [[self alloc]init];
        }
    });
    return _tool;
}
- (void)saveImageToPhoneImage:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message;
    if(error != NULL) {
        message = @"保存失败";
    }else{
        message = @"已存入手机相册";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
    [alert show];
}
@end
