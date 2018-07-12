//
//  UIView+FrameSize.m
//  CoreLib
//
//  Created by jinguihua on 2017/2/8.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import "UIView+FrameSize.h"

@implementation UIView (FrameSize)

-(CGFloat)frameX
{
    return self.frame.origin.x ;
}

-(CGFloat)frameY
{
    return self.frame.origin.y ;
}

-(CGFloat)frameWidth
{
    return self.frame.size.width ;
}

-(CGFloat)frameHeigh
{
    return self.frame.size.height ;
}

-(CGFloat)boundX
{
    return self.bounds.origin.x  ;
}

-(CGFloat)boundY
{
    return self.bounds.origin.y ;
}


-(CGFloat)boundWidth
{
    return self.bounds.size.width ;
}


-(CGFloat)boundHeigh
{
    return self.bounds.size.height ;
}

@end
