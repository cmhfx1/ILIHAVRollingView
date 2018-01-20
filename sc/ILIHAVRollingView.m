//
//  ILIHAVRollingView.m
//  sc
//
//  Created by fx on 2018/1/19.
//  Copyright © 2018年 fxtest. All rights reserved.
//

#import "ILIHAVRollingView.h"

@interface ILIHAVRollingView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak)UICollectionView *collection;
@property (nonatomic,strong)ILIHAVRollingHeaderView *header;
@property (nonatomic,assign)CGFloat headerHeight;
@property (nonatomic,assign)CGFloat headerMinHeight;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign,getter=isSwitching)BOOL switching;
@property (nonatomic,assign)CGFloat lastHeaderY;
@property (nonatomic,assign)CGFloat currentHeaderY;
@property (nonatomic,strong)NSArray *views;
@property (nonatomic,strong)NSMutableArray *tableviews;
@end

@implementation ILIHAVRollingView

+ (ILIHAVRollingView *)rollingWithViews:(NSArray *)views headerView:(ILIHAVRollingHeaderView *)header headerHeight:(CGFloat)height heightMinHeight:(CGFloat)minH
{
    ILIHAVRollingView *view = [[ILIHAVRollingView alloc] initWithViews:views headerView:header headerHeight:height heightMinHeight:minH];
    return view;
    
}

- (instancetype)initWithViews:(NSArray *)views headerView:(ILIHAVRollingHeaderView *)header headerHeight:(CGFloat)height heightMinHeight:(CGFloat)minH
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.index = 0;
        self.headerMinHeight = minH ? minH : 64;
        self.headerHeight = height ? height : 200;
        self.lastHeaderY = 0.f;
        self.currentHeaderY = 0.f;
        self.views = views;
        self.header = header;
        self.tableviews = [NSMutableArray array];
        [self setupViews];
        [self setupSubviews];
    }
    return self;
}

- (void)setupViews
{
    for (UIView *view in self.views) {
        
        for (UIView *sub in view.subviews) {
            if ([sub isKindOfClass:[UITableView class]]) {
                [self.tableviews addObject:sub];
                UIScrollView *sc = (UIScrollView *)sub;
                [sc addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"nil"];
                [sc.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:@"nil"];
                continue;
            }
        }
        view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
    
}


- (void)setupSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.bounds.size;
    layout.minimumLineSpacing = 0.;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionview.backgroundColor = [UIColor redColor];
    collectionview.pagingEnabled = YES;
    collectionview.delegate = self;
    collectionview.dataSource = self;
    
    NSInteger count = self.views.count;
    for (int i = 0; i < count; i++) {
        NSString *ident = [NSString stringWithFormat:@"base_cell_%d",i];
        [collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ident];
    }
    self.collection = collectionview;
    if (@available(iOS 11.0, *)) {
        collectionview.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    }
    [self addSubview:collectionview];
    self.header.backgroundColor = [UIColor brownColor];
    self.header.frame = CGRectMake(0, 0, self.bounds.size.width, self.headerHeight);
    [self addSubview:self.header];
}



#pragma mark -- scrollview delegate ----

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    self.switching = YES;
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDecelerating");
    [self beforeSwitchSynchronous];
}


- (void)beforeSwitchSynchronous
{
    self.lastHeaderY = self.currentHeaderY;
    self.currentHeaderY = CGRectGetMinY(self.header.frame);
    if (self.lastHeaderY == self.currentHeaderY) return;
    CGFloat value = self.currentHeaderY - self.lastHeaderY;
    
    int i = 0;
    for (UITableView *tb in self.tableviews) {
        if (i == self.index) {
            i++;
            continue;
        }
        CGFloat tbContentOffsetY = tb.contentOffset.y;
        tbContentOffsetY -= value;
        tb.contentOffset = CGPointMake(0, tbContentOffsetY);
        i++;
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    CGFloat index = scrollView.contentOffset.x/self.bounds.size.width;
    self.index = index;
    self.switching = NO;
}



#pragma mark ---  datasource ---

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.views.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idententy = [NSString stringWithFormat:@"base_cell_%lu",indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idententy forIndexPath:indexPath];
    
    UIView *view = self.views[indexPath.row];
    [cell.contentView addSubview:view];
    return cell;
}

#pragma mark -- kvo ---

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([object isKindOfClass:[UIGestureRecognizer class]]){
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)object;
        NSLog(@"%ld",pan.state);
        if(pan.state == UIGestureRecognizerStateFailed){
            [self.header handleClickHeader];
        }
        
    }else{
        
        if (self.switching) return;
        
        UITableView *sc = (UITableView *)object;
        CGFloat oldOffsetY = [change[NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat newOffsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat distance = newOffsetY - oldOffsetY;
        
        
        CGFloat headerY = CGRectGetMinY(self.header.frame);
        CGFloat headerDisplayH = self.headerHeight + headerY;
        
        
        
        if (distance >= 0) {/** 上滑 */
            
            
            CGFloat minOffsetY = -sc.contentInset.top;
            if (sc.contentOffset.y <= minOffsetY) {
                return;
            }
            
            if (headerDisplayH >= self.headerMinHeight) {
                headerY -= distance;
                CGRect frame = self.header.frame;
                frame.origin.y = headerY;
                self.header.frame = frame;
            }
            
            headerY = CGRectGetMinY(self.header.frame);
            CGFloat headerViewMinY = self.headerMinHeight-self.headerHeight;
            if (headerY < headerViewMinY) {
                CGRect frame = self.header.frame;
                frame.origin.y = headerViewMinY;
                self.header.frame = frame;
            }
            
        }else{
            CGFloat maxOffsetY = sc.contentSize.height - self.bounds.size.height;
            if (sc.contentOffset.y >= maxOffsetY) {
                return;
            }
            
            
            
#pragma mark
            /** 下滑的第一种形式 */
            CGFloat minOffsetY = - self.headerMinHeight;
            CGFloat lenth =  minOffsetY - newOffsetY;
            if (newOffsetY > minOffsetY) {
            }else{
                
                CGRect frame = self.header.frame;
                CGFloat headerY = (self.headerMinHeight - self.headerHeight)+lenth;
                if (headerY > 0) {
                    headerY = 0;
                }
                frame.origin.y = headerY;
                self.header.frame = frame;
            }
            return;
        
#pragma mark
           
            if (headerDisplayH <= self.headerHeight) {
                headerY -= distance;
                CGRect frame = self.header.frame;
                frame.origin.y = headerY;
                self.header.frame = frame;
            }
            
            headerY = CGRectGetMinY(self.header.frame);
            if (headerY > 0) {
                CGRect frame = self.header.frame;
                frame.origin.y =0 ;
                self.header.frame = frame;
            }
            
        }
        
        
    }
}


@end
