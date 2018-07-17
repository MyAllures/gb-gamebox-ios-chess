//
//  UITableViewCell+ShowContent.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/28.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ShowContent)
+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info
                       tableView:(UITableView *)tableView
                         context:(id)context;

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context;
-(id)cellContext ;
@end
