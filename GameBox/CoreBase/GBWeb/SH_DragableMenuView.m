//
//  SH_DragableMenuView.m
//  GameBox
//
//  Created by shin on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_DragableMenuView.h"

@interface SH_DragableMenuView ()
{
    CGPoint startLocation;
}
@property (weak, nonatomic) IBOutlet SH_WebPImageView *closeGameBT;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *goBackBT;
@property (nonatomic, copy) SHDragableMenuViewClose closeBlock;
@property (nonatomic, copy) SHDragableMenuViewGoBack gobackBlock;

@end

@implementation SH_DragableMenuView

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *closeGameGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeGame)];
    [self.closeGameBT addGestureRecognizer:closeGameGes];
    
    UITapGestureRecognizer *goBackGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goback)];
    [self.goBackBT addGestureRecognizer:goBackGes];
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    //
    float halfx = CGRectGetMidX(self.bounds);
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    //
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    //
    self.center = newcenter;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.autoAttract) {
        CGPoint point = self.center;
        if (point.x>[self superview].frame.size.width/2.0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake([self superview].frame.size.width-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height) ;
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height) ;
            }];
        }
    }
}

- (void)closeGame
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)goback
{
    if (self.gobackBlock) {
        self.gobackBlock();
    }
}

- (void)closeAction:(SHDragableMenuViewClose)closeBlock
{
    self.closeBlock = closeBlock;
}

- (void)gobackAction:(SHDragableMenuViewClose)gobackBlock
{
    self.gobackBlock = gobackBlock;
}

@end
