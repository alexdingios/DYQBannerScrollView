//
//  ViewController.m
//  DYQBannerView
//
//  Created by Apple on 2016/11/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "DYQBannerScrollView.h"
#import "SDAutoLayout.h"
@interface ViewController ()<DYQBannerScrollViewDelegate>
/*****/
@property (strong,nonatomic) DYQBannerScrollView *bannerScrollView;
/*****/
@property (strong,nonatomic) NSArray *dataArray;
@end

@implementation ViewController
-(NSArray *)dataArray
{
    //return [NSArray arrayWithObjects:@"1.jpeg",@"2.jpeg",@"3.jpeg",@"4.jpeg", nil];
    return [NSArray arrayWithObjects:@"http://a.cphotos.bdimg.com/timg?image&quality=100&size=b4000_4000&sec=1479712043&di=5c01c9250aaa411825d6802cf8c9c57e&src=http://pic.baike.soso.com/p/20111015/bki-20111015183540-1861675088.jpg",@"http://img4.duitang.com/uploads/item/201511/22/20151122231316_E5A8F.thumb.700_0.jpeg",@"http://img5.duitang.com/uploads/item/201502/24/20150224142121_axcUN.jpeg",@"http://a.cphotos.bdimg.com/timg?image&quality=100&size=b4000_4000&sec=1479712043&di=1ff2077e9749540187c1b1daae8b370b&src=http://img103.mypsd.com.cn/20130502/1/Mypsd_13585_201305020822350023B.jpg", nil];
    //return [NSArray arrayWithObjects:@"1.jpeg", nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.bannerScrollView = [[DYQBannerScrollView alloc]init];
    [self.view addSubview:self.bannerScrollView];
    //self.bannerScrollView.frame = CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width-20, 200);
    
    self.bannerScrollView.sd_layout.leftSpaceToView(self.view,10).topSpaceToView(self.view,40).rightSpaceToView(self.view,10).heightIs(200);
    
    
    self.bannerScrollView.backgroundColor = [UIColor redColor];
    //self.bannerScrollView.showBottomBack = YES;
    self.bannerScrollView.pageControlPosition = PageControlPositionCenter;
    //self.bannerScrollView.noDataPlaceholderImage = [UIImage imageNamed:@"aaaaa.jpg"];
    //self.bannerScrollView.placeholderImage = [UIImage imageNamed:@"aaaaa.jpg"];
    self.bannerScrollView.imageUrls = self.dataArray;
//    self.bannerScrollView.bannerItemClick = ^(NSInteger index){
//#ifdef DEBUG
//        NSLog(@"block - %ld",(long)index);
//#endif
//    };
    self.bannerScrollView.timeInterval = 1;
//    [self.bannerScrollView setImageUrls:self.dataArray andPlaceholderImage:[UIImage imageNamed:@"aaaaa.jpg"] itemClick:^(NSInteger index) {
//#ifdef DEBUG
//        NSLog(@"block - %ld",(long)index);
//#endif
//
//    }];
    self.bannerScrollView.delegate = self;
}

#pragma mark----DYQBannerScrollViewDelegate

-(void)bannerScrollView:(DYQBannerScrollView *)bannerScrollView didSelectItemAtIndex:(NSInteger)index
{
#ifdef DEBUG
        NSLog(@"block - %ld",(long)index);
#endif
}

@end
