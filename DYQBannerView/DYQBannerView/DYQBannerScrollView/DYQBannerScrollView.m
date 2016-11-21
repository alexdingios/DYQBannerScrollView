//
//  DYQBannerScrollView.m
//  DYQBannerView
//
//  Created by Apple on 2016/11/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DYQBannerScrollView.h"
#import "DYQBannerCell.h"
#import "SDAutoLayout.h"
#import "UIImageView+WebCache.h"
NSString *const Identifier = @"DYQBannerCell";
#define radio 100
#define PageControlMargin 30
@implementation DYQBannerScrollView
{
    NSTimer *_scrollTimer;
    NSInteger _currentIndex;
    UICollectionView *_collectionView;
    UIImageView *_coverImageView;
    UIView *_bottomBackView;
    UIPageControl *_pageControl;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

#pragma mark----初始化设置
-(void)setup{
    self.timeInterval = 2;
    self.placeholderImage = [UIImage imageNamed:@"cover_cy.png"];
    self.noDataPlaceholderImage = [UIImage imageNamed:@"cover_cy.png"];
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    _collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    [_collectionView registerClass:[DYQBannerCell class] forCellWithReuseIdentifier:Identifier];
    _coverImageView = [[UIImageView alloc]init];
    _coverImageView.image = self.noDataPlaceholderImage;
    [self addSubview:_coverImageView];
    _coverImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _bottomBackView = [UIView new];
    _bottomBackView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    _bottomBackView.hidden = !self.showBottomBack;
    [self addSubview:_bottomBackView];
    _bottomBackView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,0).heightIs(30);
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    self.pageControlPosition = PageControlPositionCenter;
}
/**设置imageUrls 数据 和占位图片 更适和展示网络图片***/
-(void)setImageUrls:(NSArray *)imageUrls andPlaceholderImage:(UIImage*)placeholderImage itemClick:(BannerItemClick)bannerItemClick
{
    self.bannerItemClick = bannerItemClick;
    self.imageUrls = imageUrls;
    self.placeholderImage = placeholderImage;
}
-(void)setNoDataPlaceholderImage:(UIImage *)noDataPlaceholderImage
{
    _noDataPlaceholderImage = noDataPlaceholderImage;
    _coverImageView.image = noDataPlaceholderImage;
}
-(void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    _pageControl.numberOfPages = imageUrls.count;
    [_collectionView reloadData];
    
    if (!_imageUrls.count) {
        _coverImageView.hidden = NO;
        _bottomBackView.hidden = YES;
        return;
    }
    
    _coverImageView.hidden = YES;
    if (_imageUrls.count <= 1)
    {
        _collectionView.scrollEnabled = NO;
        _bottomBackView.hidden = YES;
        return;
    }
    _bottomBackView.hidden = !self.showBottomBack;
    dispatch_async(dispatch_get_main_queue(), ^{
        _currentIndex = self.imageUrls.count*radio*0.5;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
    [self creatTimer];
}
-(void)setShowBottomBack:(BOOL)showBottomBack
{
    _showBottomBack = showBottomBack;
    if (!self.imageUrls.count) {
        _bottomBackView.hidden = YES;
        return;
    }
    _bottomBackView.hidden = !showBottomBack;
}
-(void)setPageControlPosition:(PageControlPosition)pageControlPosition
{
    _pageControlPosition = pageControlPosition;
    [self layOutPageControlWith:pageControlPosition];
}
-(void)setTimeInterval:(NSInteger)timeInterval
{
    _timeInterval = timeInterval;
    if (_scrollTimer) {
        [self removeTimer];
        [self creatTimer];
    }
    
    
}
#pragma mark----布局PageControl
-(void)layOutPageControlWith:(PageControlPosition)pageControlPosition
{
    switch (pageControlPosition) {
        case PageControlPositionCenter:
        {
            _pageControl.hidden = NO;
            _pageControl.sd_resetLayout.centerXEqualToView(_bottomBackView).centerYEqualToView(_bottomBackView).heightIs(20).widthIs(20);
        }
            break;
        case PageControlPositionLeft:
        {
            _pageControl.hidden = NO;
            _pageControl.sd_resetLayout.leftSpaceToView(self,PageControlMargin).centerYEqualToView(_bottomBackView).heightIs(20).widthIs(20);
        }
            break;
        case PageControlPositionRight:
        {
            _pageControl.hidden = NO;
            _pageControl.sd_resetLayout.rightSpaceToView(self,PageControlMargin).centerYEqualToView(_bottomBackView).heightIs(20).widthIs(20);
        }
            break;
        case PageControlPositionNone:
        {
            _pageControl.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    //[self layoutIfNeeded];
}
#pragma mark----创建定时器
-(void)creatTimer
{
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerRunning) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    
}
-(void)timerRunning{
    NSInteger offSet = _collectionView.contentOffset.x / self.bounds.size.width;
    if (offSet == 0) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageUrls.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if (offSet == [_collectionView numberOfItemsInSection:0]-1) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageUrls.count*radio*0.5-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else{
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:offSet + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}
#pragma mark----移除定时器
-(void)removeTimer
{
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}

#pragma mark----UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageUrls.count * radio;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DYQBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    NSInteger index = indexPath.item % self.imageUrls.count;
    NSString *urlPath = self.imageUrls[index];
    if ([urlPath hasPrefix:@"http://"]||[urlPath hasPrefix:@"https://"])
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlPath] placeholderImage:self.placeholderImage options:SDWebImageRetryFailed];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:urlPath];
    }
    
    return cell;
}


#pragma mark----UICollectionViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    int itemIndex = (scrollView.contentOffset.x + scrollViewWidth * 0.5) / scrollViewWidth;
    if (!self.imageUrls.count) return; // 解决清除timer时偶尔会出现的问题
    int indexOnPageControl = itemIndex % self.imageUrls.count;
    
    _pageControl.currentPage = indexOnPageControl;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self creatTimer];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannerItemClick) {
        self.bannerItemClick(_pageControl.currentPage);
    }
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:didSelectItemAtIndex:)])
    {
        [self.delegate bannerScrollView:self didSelectItemAtIndex:_pageControl.currentPage];
    }
}


#pragma mark----UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


















@end
