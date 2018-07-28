//
//  SH_SettingView.m
//  GameBox
//
//  Created by Paul on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SettingView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface  SH_SettingView()

@end
@implementation SH_SettingView
+(instancetype)instanceSettingView{
    return  [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super  awakeFromNib];
//    [self  configSlide];
}
-(void)configSlide{
    //寻找建立UISlider;
    UISlider* volumeViewSlider = nil;
    //设置音量大小
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat currentVol = audioSession.outputVolume;
    volumeViewSlider.value = currentVol;
    [volumeViewSlider setThumbImage:[UIImage imageNamed:@"circular_slide"] forState:UIControlStateNormal];
    volumeViewSlider.minimumTrackTintColor = [UIColor colorWithHexStr:@"0x88CE2E"];
    volumeViewSlider.maximumTrackTintColor = [UIColor colorWithHexStr:@"0x136D6B"];
}
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}
- (IBAction)changeSlideValue:(UISlider *)sender {
    if (sender.tag==100) {
        
    }
}
@end
