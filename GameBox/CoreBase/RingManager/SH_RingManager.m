
//
//  SH_RingManager.m
//  GameBox
//
//  Created by shin on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RingManager.h"
#import <AVFoundation/AVFoundation.h>

@interface SH_RingManager ()

@property (nonatomic, strong) AVAudioPlayer *bgmPlayer;

@end

@implementation SH_RingManager

+ (instancetype)sharedManager
{
    static SH_RingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[SH_RingManager alloc] init];
        }
    });
    return manager;
}

- (CGFloat)bgmPlayerVolume
{
    return self.bgmPlayer.volume;
}

- (void)configBgmPlayerVolume:(CGFloat)volume
{
    self.bgmPlayer.volume = volume;
    [[NSUserDefaults standardUserDefaults] setObject:@(volume) forKey:@"GB_CHESS_BGM_VOLUME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (AVAudioPlayer *)bgmPlayer
{
    if (_bgmPlayer == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"bgm.mp3" withExtension:nil];
        _bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _bgmPlayer.numberOfLoops = -1;
        NSDictionary *allUserDefaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        NSArray *allKeys = [allUserDefaults allKeys];
        BOOL hasDefaultVolume = NO;
        for (NSString *key in allKeys) {
            if ([key isEqualToString:@"GB_CHESS_BGM_VOLUME"]) {
                hasDefaultVolume = YES;
                break;
            }
        }
        if (hasDefaultVolume) {
            CGFloat volume = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GB_CHESS_BGM_VOLUME"] floatValue];
            _bgmPlayer.volume = volume;
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@(0.8) forKey:@"GB_CHESS_BGM_VOLUME"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _bgmPlayer.volume = 0.8;
        }
        [_bgmPlayer prepareToPlay];
    }
    return _bgmPlayer;
}

- (void)playBGM
{
    [self.bgmPlayer play];
}

- (void)pauseBGM
{
    [self.bgmPlayer pause];
}

- (void)playMoneyRing
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"moneyRing" ofType:@"mp3"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack,NULL);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playAlertRing
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"showAlertRing" ofType:@"mp3"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack,NULL);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playErrRing
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"errRing" ofType:@"mp3"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack,NULL);
    AudioServicesPlaySystemSound(soundID);
}

void soundCompleteCallBack(SystemSoundID soundID, void *clientData)
{
}

@end
