//
//  SH_BitCoinView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinView.h"
#import "SH_BitCoinSubView.h"
#import "SH_BitCoinTextView.h"
@interface SH_BitCoinView()
@property(nonatomic,strong)UIImageView *QRImageView;
@property(nonatomic,strong)SH_BitCoinTextView *bitCoinView;
@property(nonatomic,strong)UILabel *massegeLab;
@end
@implementation SH_BitCoinView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
- (UIImageView *)QRImageView{
    if (!_QRImageView) {
        _QRImageView = [[UIImageView alloc]init];
        [self addSubview:_QRImageView];
    }
    return _QRImageView;
}
- (SH_BitCoinTextView *)bitCoinView{
    if (!_bitCoinView) {
        _bitCoinView = [[NSBundle mainBundle]loadNibNamed:@"SH_BitCoinTextView" owner:self options:nil].firstObject;
        [self addSubview:_bitCoinView];
    }
    return _bitCoinView;
}
- (UILabel *)massegeLab{
    if (!_massegeLab) {
        _massegeLab = [[UILabel alloc]init];
        _massegeLab.numberOfLines = 0;
        _massegeLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_massegeLab];
    }
    return _massegeLab;
}
-(void)configUI{
      __weak typeof(self) weakSelf = self;
    UIView *colorView = [[UIView alloc]init];
    colorView.backgroundColor = colorWithRGB(0, 122, 255);
    [self addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
        make.height.equalTo(@20);
        make.top.left.equalTo(self).offset(10);
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.text = @"账号信息";
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(colorView);
        make.left.equalTo(colorView.mas_right).offset(10);
    }];
    
    SH_BitCoinSubView *bgView = [[NSBundle mainBundle]loadNibNamed:@"SH_BitCoinSubView" owner:self options:nil].firstObject;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(titleLab.mas_bottom).offset(15);
        make.width.equalTo(@250);
        make.height.equalTo(@140);
    }];
    
    [self.QRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@120);
        make.centerX.equalTo(self);
        make.top.equalTo(bgView.mas_bottom).offset(10);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存手机" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    saveBtn.backgroundColor = colorWithRGB(0, 122, 255);
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.QRImageView);
        make.height.equalTo(@30);
        make.top.equalTo(weakSelf.QRImageView.mas_bottom).offset(5);
    }];
    
    [self.bitCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveBtn.mas_bottom).offset(15);
        make.left.right.equalTo(self);
        make.height.equalTo(@260);
    }];
    
    [self.massegeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bitCoinView.mas_bottom).offset(30);
        make.left.equalTo(self).offset(15);
        make.right.bottom.equalTo(self).offset(-15);

    }];
    self.massegeLab.text = @"近日，湖南农业大学学生发帖称，学校在浏阳实习基地种的玉米、棉花等科研成果被当地村民偷盗。昨天，湖南农业大学浏阳实习基地一位老师告诉北京青年报记者，此次被偷盗最严重的是学校获得审批的一个玉米新品种，一旦被扩散出去，损失或达上千万。昨天湖南省沿溪镇发布通报称，涉事4人已被依法询问，正在组织村民归还所拿农产品。半亩玉米被偷得几乎一个不剩湖南农业大学浏阳实习基地的陈老师告诉北青报记者，浏阳基地是湖南农业大学在浏阳设的一块试验基地，占地面积约800亩，主要种植玉米、水稻、棉花、花生等农作物，用于学校师生科研。";
}
@end
