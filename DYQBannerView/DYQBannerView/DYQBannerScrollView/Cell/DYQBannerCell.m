//
//  DYQBannerCell.m
//  DYQBannerView
//
//  Created by Apple on 2016/11/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DYQBannerCell.h"

@implementation DYQBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    self.imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageView];
    self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}
@end
