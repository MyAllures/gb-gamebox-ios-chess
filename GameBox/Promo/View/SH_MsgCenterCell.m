//
//  SH_MsgCenterCell.m
//  GameBox
//
//  Created by shin on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MsgCenterCell.h"
#import "SH_SystemNotificationModel.h"
#import "UIImage+SH_WebPImage.h"
#import "SH_GameBulletinModel.h"
#import "SH_SysMsgDataListModel.h"
#import "SH_TimeZoneManager.h"

@interface SH_MsgCenterCell ()
@property (weak, nonatomic) IBOutlet UILabel *msgContentLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet SH_WebPButton *selectBt;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *markNewImg;

@end

@implementation SH_MsgCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateSelectedStatus
{
    self.selectBt.selected = !self.selectBt.selected;
    self.markNewImg.hidden = YES;
}

- (void)setModel:(id)model
{
    _model = model;
    if ([_model isMemberOfClass:[SH_SystemNotificationModel class]]) {
        self.markNewImg.hidden = YES;
        self.selectBt.hidden = YES;
        SH_SystemNotificationModel *tModel = (SH_SystemNotificationModel *)_model;
        self.msgContentLB.text = tModel.content;
        self.dateLB.text = [self getTimeFrom:tModel.publishTime/1000.0];
    }
    else if ([_model isMemberOfClass:[SH_GameBulletinModel class]]) {
        self.markNewImg.hidden = YES;
        self.selectBt.hidden = YES;
        SH_GameBulletinModel *tModel = (SH_GameBulletinModel *)_model;
        self.msgContentLB.text = tModel.context;
        self.dateLB.text = [self getTimeFrom:tModel.publishTime/1000.0];
    }
    else if ([_model isMemberOfClass:[SH_SysMsgDataListModel class]]) {
        self.selectBt.hidden = NO;
        SH_SysMsgDataListModel *tModel = (SH_SysMsgDataListModel *)_model;
        self.msgContentLB.text = tModel.title;
        self.dateLB.text = [self getTimeFrom:tModel.publishTime/1000.0];
        self.markNewImg.hidden = tModel.read;
        self.selectBt.selected = tModel.selected;
    }
}

- (IBAction)selectAction:(id)sender {
    self.selectBt.selected = !self.selectBt.selected;
    //model赋值
    SH_SysMsgDataListModel *tModel = (SH_SysMsgDataListModel *)_model;
    tModel.selected = self.selectBt.isSelected;
}

- (NSString*)getTimeFrom:(NSTimeInterval)time
{    
    NSString *currentTimeString = [[SH_TimeZoneManager sharedManager] timeStringFrom:time format:@"yyyy-MM-dd HH:MM:ss"];
    return currentTimeString;
}

@end
