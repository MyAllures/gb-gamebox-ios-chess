//
//  RH_WebsocketManagar.h
//  gameBoxEx
//
//  Created by lewis on 2018/5/27.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;
@interface RH_WebsocketManagar : NSObject
// 获取连接状态
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

+ (RH_WebsocketManagar *)instance;

-(void)SRWebSocketOpenWithURLString:(NSString *)urlString;//开启连接
-(void)SRWebSocketClose;//关闭连接
- (void)sendData:(id)data;//发送数据
@end
