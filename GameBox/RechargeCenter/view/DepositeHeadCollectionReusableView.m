//
//  DepositeHeadCollectionReusableView.m
//  testDemo
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 jun. All rights reserved.
//

#import "DepositeHeadCollectionReusableView.h"
@interface DepositeHeadCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end
@implementation DepositeHeadCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateWithTitle:(NSString *)title{
    self.titleLab.text = title;
}
@end
