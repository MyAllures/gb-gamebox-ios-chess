//
//  CAEmitterSnowCell.m
//  Snowing
//
//  Created by ykh on 15/1/16.
//  Copyright (c) 2015年 YKH. All rights reserved.
//

#import "YFEmitterSnowCell.h"

@implementation YFEmitterSnowCell

+(instancetype)snowCellWithCellImg:(NSString *)cellImg andRadious:(CGFloat)radious andVelocity:(CGFloat)velocity andDirection:(YFEmitterParticleCellDirection)direction
{
    NSString * const snowPic = @"snow.png";//雪花图片样式
    
    YFEmitterSnowCell *cell=[[self alloc] init];
    
    //粒子的名字
    cell.name = @"snow";
    
    //设置雪花图片
    UIImage *img;
    if (cellImg.length==0) {
        
        img=[UIImage imageNamed:snowPic];
    }else{
        
        img=[UIImage imageNamed:cellImg];
    }
    //设置雪花半径大小
    img=[UIImage image:img scaleToSize:CGSizeMake(radious, radious)];
    cell.contents=(id)[img CGImage];
    
    //速率与半径大小正相关
    cell.velocity=radious*3;
    
    //设置雪花飘向的方向
    switch (direction) {
        case YFEmitterParticleCellDirectionToLeft:
            //重力加速方向,y代表竖直,x为横向,数值越大,速度越快
            cell.xAcceleration=-1;
            //向周围发散的角度
            cell.emissionRange = -0.5* M_PI;
            break;
        case YFEmitterParticleCellDirectionToRight:
            cell.xAcceleration=1;
            cell.emissionRange = 0.25* M_PI;
            break;
        case YFEmitterParticleCellDirectionToTop:
            cell.yAcceleration=-1;
            cell.emissionRange = 0.5* M_PI;
            break;
        case YFEmitterParticleCellDirectionToBottom:
            cell.yAcceleration=1;
            cell.emissionRange = 0.5* M_PI;
            break;
    }
    
    return cell;
}
@end
