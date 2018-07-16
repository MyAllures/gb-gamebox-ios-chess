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
@property (weak, nonatomic) IBOutlet UISlider *sound_slide;
@property (weak, nonatomic) IBOutlet UIView *sound_view;
@property (weak, nonatomic) IBOutlet UISlider *soundeffec_slide;

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
    [self  configSlide];
}
-(void)configSlide{
    UIImage *imagea=[self OriginImage:[UIImage imageNamed:@"circular_slide"] scaleToSize:CGSizeMake(20, 20)];
    [self.sound_slide  setThumbImage:[UIImage imageNamed:@"circular_slide"] forState:UIControlStateNormal];
    [self.soundeffec_slide  setThumbImage:[UIImage imageNamed:@"circular_slide"] forState:UIControlStateNormal];
    
    //自定义MPVolumeView 高度不能改变其他都可以
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    //把自定义的MPVolumeView贴在view上
    [self.sound_view addSubview: volumeView];
    [volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.sound_view).mas_offset(0);;
    }];
    
    //寻找建立UISlider;
    UISlider* volumeViewSlider = nil;
    //设置音量大小
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat currentVol = audioSession.outputVolume;
    volumeViewSlider.value = currentVol;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            volumeViewSlider.backgroundColor = [UIColor clearColor];
            break;
        }
    }
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
