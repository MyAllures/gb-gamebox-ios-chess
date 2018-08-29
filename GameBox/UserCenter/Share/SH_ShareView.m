//
//  SH_ShareView.m
//  GameBox
//
//  Created by Paul on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ShareView.h"
#import "SH_NetWorkService+UserCenter.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_ShareView()
@property (weak, nonatomic) IBOutlet UIImageView *QRCode_imageView;
@property (weak, nonatomic) IBOutlet UILabel *shareTitle_label;

@end
@implementation SH_ShareView
+(instancetype)instanceShareView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self fetchShareQRCode];
}
#pragma mark --- 保存二维码到相册
- (IBAction)saveQRImageViewButton:(UIButton *)sender {
    
    UIAlertController  * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否需要保存图片到相册" preferredStyle:UIAlertControllerStyleAlert] ;
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert  dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction  actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImageToPhotosAlbum];
    }] ];
     UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
    [svc  presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark --- 保存图片到相册
- (void)saveImageToPhotosAlbum
{
        
        UIImage * displayingImage = self.QRCode_imageView.image;
        if (displayingImage != nil) {
            
            //开始保存到相册
            MBProgressHUD * activityIndicatorView = showHUDWithMyActivityIndicatorView(self.window, nil, @"保存中...");
            UIImageWriteToSavedPhotosAlbum(displayingImage, self, @selector(image:didFinishSavingWithError:contextInfo:), ((__bridge void *)activityIndicatorView));
            
        }else{
            showMessage(self, nil, @"没有需要保存的图片");
        }
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD * activityIndicatorView = (__bridge id)contextInfo;
    activityIndicatorView.completionBlock = ^{
        if (error) {
            showErrorMessage(self, nil, @"保存失败");
        }else{
            showSuccessMessage(self, @"保存成功", nil);
        }
    };
    [activityIndicatorView hideAnimated:YES];
}
#pragma mark --- 获取分享二维码图片
-(void)fetchShareQRCode{
    __weak  typeof(self) weakSelf = self;
    [SH_NetWorkService  fetchShareQRCodeComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary  * dic = ConvertToClassPointer(NSDictionary, response);
        if ([dic[@"code"] isEqualToString:@"0"]) {
             NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:[dic[@"data"] objectForKey:@"qrCodeUrl"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.QRCode_imageView sd_setImageWithURL:[NSURL  URLWithString:url] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
            });
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
