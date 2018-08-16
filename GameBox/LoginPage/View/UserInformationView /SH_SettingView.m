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
#import "SH_SliderView.h"
#import "SH_RingManager.h"

@interface  SH_SettingView()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *musicLB;
@property (weak, nonatomic) IBOutlet UILabel *soundEffectLB;
@property (nonatomic, strong) SH_SliderView *musicSlider;
@property (nonatomic, strong) SH_SliderView *soundEffectSlider;
@end

@implementation SH_SettingView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

    _musicSlider = [[SH_SliderView alloc] init];
    [self.containerView addSubview:_musicSlider];
    [_musicSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicLB.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(15);
        make.centerY.equalTo(self.musicLB);
    }];
    _musicSlider.progress = [[SH_RingManager sharedManager] bgmPlayerVolume];
    [_musicSlider progressChanging:^(CGFloat progress) {
        [[SH_RingManager sharedManager] configBgmPlayerVolume:progress];
    }];
    
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    _soundEffectSlider = [[SH_SliderView alloc] init];
    _soundEffectSlider.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:_soundEffectSlider];
    [_soundEffectSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.soundEffectLB.mas_right).mas_offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(15);
        make.centerY.equalTo(self.soundEffectLB);
    }];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    _soundEffectSlider.progress = audioSession.outputVolume;
    [_soundEffectSlider progressChanging:^(CGFloat progress) {
        // retrieve system volumefloat systemVolume = volumeViewSlider.value;
        // change system volume, the value is between 0.0f and 1.0f
        [volumeViewSlider setValue:progress animated:NO];
        // send UI control event to make the change effect right now.
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)volumeChanged:(NSNotification *)notification
{
    CGFloat volume = [notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    _soundEffectSlider.progress = volume;
}

@end
