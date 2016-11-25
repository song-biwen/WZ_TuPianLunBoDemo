//
//  WZCarouselView.m
//  WZTuPianLunBoDemo
//
//  Created by songbiwen on 2016/11/25.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZCarouselView.h"
#import "WZCarouselModel.h" //轮播视图
#import "UIImageView+WebCache.h"
#import "WZTimerObject.h" //定时器

static NSString *const cellIdentifier = @"collectionViewCell";
static NSInteger const labelTag = 100;
static NSInteger const imageTag = 101;
static CGFloat const bottomViewH = 40;

@interface WZCarouselView ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 定时器
 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WZCarouselView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加collectionView
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate

/// 滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

/**
 当滑动减速是调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    NSInteger currentIndex = offsetX/scrollViewW;
    self.pageControl.currentPage = currentIndex % 3;
    if (currentIndex == 0) {
        //滚动到第一个
        [scrollView setContentOffset:CGPointMake(scrollViewW * self.dataSource.count, 0)];
    }
    else if (currentIndex == [self.collectionView numberOfItemsInSection:0] - 1) {
        //滚动到最后一个
        [scrollView setContentOffset:CGPointMake(scrollViewW * (self.dataSource.count * 2 - 1), 0)];
    }
    [self addTimer];
}

///手指开始拖动时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //移除定时器
    [self cancelTimer];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count * 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取模型数据
    WZCarouselModel *carouselModel = self.dataSource[indexPath.row % 3];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    UIImageView *imageView = [cell.contentView viewWithTag:imageTag];
    UILabel *label = [cell.contentView viewWithTag:labelTag];
    if (cell.contentView.subviews.count == 0) {
        //构建视图
        CGRect contentViewF= cell.contentView.frame;
        CGFloat contentViewW = contentViewF.size.width;
        CGFloat contentViewH = contentViewF.size.height;
        
        //设置图片
        imageView = [[UIImageView alloc] initWithFrame:contentViewF];
        imageView.tag = imageTag;
        [cell.contentView addSubview:imageView];
        
        //设置底部视图
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewH - bottomViewH, contentViewW, bottomViewH)];
        bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [cell.contentView addSubview:bottomView];
        
        //设置label
        CGFloat labelH = bottomViewH;
        label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, contentViewW, labelH)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.tag = labelTag;
        [bottomView addSubview:label];
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:carouselModel.imgsrc]];
    label.text = carouselModel.title;
    return cell;
}


/**
 设置即将显示的数据源
 */

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
    self.pageControl.currentPage = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //在主线程空闲时执行block代码
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self addTimer];
    });
}


/**
 添加定时器
 */
- (void)addTimer {
    if (self.timer) {
        return;
    }
    
    self.timer = [WZTimerObject scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}


/**
 下一张图片
 */
- (void)nextImage {
    CGFloat offsetX = self.collectionView.contentOffset.x;
    CGFloat width = self.collectionView.bounds.size.width;
    NSInteger index = offsetX/width;
    [self.collectionView setContentOffset:CGPointMake((index + 1) * width , 0) animated:YES];
}


/**
 取消定时器
 */
- (void)cancelTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/**
 初始化collectionView
 */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        //初始化流动布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置单元的大小
        layout.itemSize = self.frame.size;
        //设置单元间的最小距离
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        //设置滑动的方向为水平f方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //初始化collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        //设置滑动形式,
        _collectionView.pagingEnabled = YES;
        //隐藏水平指示器
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        //注册_collectionView 的cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        CGSize carouselViewSize = self.frame.size;
        CGFloat pageControlW = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(carouselViewSize.width - pageControlW - 10,carouselViewSize.height - bottomViewH, pageControlW, bottomViewH)];
        _pageControl.numberOfPages = self.dataSource.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
