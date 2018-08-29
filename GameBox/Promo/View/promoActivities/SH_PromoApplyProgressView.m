//
//  SH_PromoApplyProgressView.m
//  GameBox
//
//  Created by jun on 2018/8/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoApplyProgressView.h"

@interface SH_PromoApplyProgressView()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCon;
@property (weak, nonatomic) IBOutlet UIImageView *progressImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
@implementation SH_PromoApplyProgressView
- (void)awakeFromNib{
    [super awakeFromNib];
 
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SH_PromoApplyProgressView" owner:self options:nil];
        self.frame = self.view.frame;
        [self addSubview:self.view];
    }
    return self;
}
-(void)changeProgressValue:(CGFloat)value{
    NSString *imageName;
    NSString *bgImageName;
    if (value >= 1) {
        bgImageName = @"bar_empty";
        imageName = @"bar";
        value=1.0;
    }else{
        imageName = @"bar_red";
        bgImageName = @"bar_empty_red";
    }
    self.bgImageView.image = [UIImage imageNamed:bgImageName];
    self.progressImage.image = [UIImage imageNamed:imageName];
    self.widthCon = [self changeMultiplierOfConstraint:self.widthCon multiplier:value];
}
- (NSLayoutConstraint *)changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
    [NSLayoutConstraint deactivateConstraints:@[constraint]];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    newConstraint.priority = constraint.priority;
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
    return newConstraint;
}
@end
