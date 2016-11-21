# DYQBannerScrollView
```
/**imagesUrl(本地/网络)***/
@property (strong,nonatomic) NSArray *imageUrls;

/**是否显示底部半透明背景 默认不显示***/
@property (assign,nonatomic) BOOL showBottomBack;

/**PageControl的位置 默认居中***/
@property (assign,nonatomic) PageControlPosition pageControlPosition;

/**轮播时间 默认2秒***/
@property (assign,nonatomic) NSInteger timeInterval;

/**占位图片 默认为cover_cy.png***/
@property (strong,nonatomic) UIImage *placeholderImage;

/**imageUrls 无数据时 遮盖显示的图片***/
@property (strong,nonatomic) UIImage *noDataPlaceholderImage;

/**点击广告block回调***/
@property (nonatomic, copy) void (^bannerItemClick)(NSInteger index);

/**DYQBannerScrollViewDelegate***/
@property(nonatomic, weak) id <DYQBannerScrollViewDelegate> delegate;

/**设置imageUrls 数据 和占位图片 及广告点击回调 更适和展示网络图片***/
-(void)setImageUrls:(NSArray *)imageUrls andPlaceholderImage:(UIImage*)placeholderImage itemClick:(BannerItemClick)bannerItemClick;
```
