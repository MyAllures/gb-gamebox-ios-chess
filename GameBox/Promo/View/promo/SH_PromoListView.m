//
//  SH_PromoListView.m
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoListView.h"
#import "SH_PromoViewCell.h"

#import "View+MASAdditions.h"

#import "SH_NetWorkService.h"
#import "NetWorkLineMangaer.h"
#import "PopTool.h"

#import "SH_PromoListModel.h"
#import "SH_NetWorkService+Promo.h"
#import <SDWebImage/SDWebImageFrame.h>

@interface SH_PromoListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *promoListArr;

@property(nonatomic,assign) CGSize imageSize ;
@property (nonatomic, strong) SH_PromoViewCell *cell;

@end

@implementation SH_PromoListView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ImageSizeChanged:) name:@"ImageSizeChanged" object:nil];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [SH_NetWorkService_Promo getPromoList:1 pageSize:5000 activityClassifyKey:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        self.promoListArr = [NSMutableArray array];
        NSDictionary *dic = (NSDictionary *)response;
        for (NSDictionary *dict in dic[@"data"][@"list"]) {
            SH_PromoListModel *model = [[SH_PromoListModel alloc]initWithDictionary:dict error:nil];
            [self.promoListArr addObject:model];
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

-(void)ImageSizeChanged:(NSNotification *)noti {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.cell] ;
    if (indexPath){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone] ;
    }
}

- (void)reloadData
{
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_PromoViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.promoListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    self.cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (self.cell == nil) {
        self.cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoViewCell" owner:nil options:nil] lastObject];
    }
    SH_PromoListModel *model = self.promoListArr[indexPath.row];
    [self.cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@%@",[NetWorkLineMangaer sharedManager].currentHost,model.photo]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image){
            NSLog(@"height==%f",image.size.height);
            [model updateImageSize:image.size] ;
            if (self.imageSize.height != image.size.height) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageSizeChanged" object:nil];
            }
        }
    }];
    self.cell.backgroundColor = [UIColor redColor];
//    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@%@",[NetWorkLineMangaer sharedManager].currentHost,model.photo]]];
    NSLog(@"model.photo==%@",[NSString stringWithFormat:@"https://%@%@",[NetWorkLineMangaer sharedManager].currentHost,model.photo]);
    return self.cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SH_PromoListModel *discountActivityModel = self.promoListArr[indexPath.row] ;
    if (discountActivityModel){
        self.imageSize = discountActivityModel.showImageSize;
        NSLog(@"==----%f",floor(discountActivityModel.showImageSize.height));
        return floor(discountActivityModel.showImageSize.height) ;
    }
    return 0.0f  ;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
