//
//  WZMainViewController.m
//  WZTuPianLunBoDemo
//
//  Created by songbiwen on 2016/11/24.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZMainViewController.h"
#import "WZCarouselView.h" //轮播视图
#import "WZCarouselModel.h" //轮播模型


static NSString *const dataUrlStr = @"http://c.m.163.com/nc/ad/headline/0-3.html";

@interface WZMainViewController ()
@property (nonatomic, strong) WZCarouselView *carouselView;
@end

@implementation WZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}


/**
 加载数据
 */
- (void)loadData {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:dataUrlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //更新UI
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray *headline_adArray = dic[@"headline_ad"];
                NSMutableArray *dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in headline_adArray) {
                    WZCarouselModel *model = [WZCarouselModel modelObjectWithDictionary:dict];
                    [dataSource addObject:model];
                }
                
                WZCarouselView *carouselView = [[WZCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
                carouselView.backgroundColor = [UIColor redColor];
                carouselView.dataSource = dataSource;
                [self.view addSubview:carouselView];
                self.carouselView = carouselView;
                
            }];
            
        }
        
    }] resume];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.carouselView removeFromSuperview];
    self.carouselView = nil;
}
@end
