//
//  HeadView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "HeadView.h"
#import "HeadViewCell.h"
#import "HomeMmodel.h"
#import "SimpleSwitch.h"

@interface HeadView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
{
    BOOL _isLoadingMore;//加载更多
    BOOL _isRefreshing;//刷新
}


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSDictionary *timeDataSoure;
@property (nonatomic, strong) NSArray *dataSoure;

@property (nonatomic, strong) UIImage *hightImage;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) IBOutlet SimpleSwitch *mySwitch;


@end


@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil] lastObject];
        self.page = 1;
        [self customUI];
        self.frame = frame;
    }
    return self;
}
- (void)customUI {
    self.timeDataSoure = @{@(1):@"4天前",@(2):@"1周前",@(3):@"2周前",@(4):@"3周前",@(5):@"4周前",@(6):@"1月前",@(7):@"1月前",@(8):@"1月前",@(9):@"1月前",@(10):@"2月前",@(11):@"2月前",@(12):@"2月前",@(13):@"2月前"};
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeadViewCell" bundle:nil] forCellWithReuseIdentifier:@"HeadViewCellId"];
    //自定义slider
    [self customSlider];
    [self customUISwitch];
    [self addtimer];
}
- (void)addtimer {
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}
- (void)timerFired {
    self.nextButton.selected = !self.nextButton.selected;
}

- (void)customUISwitch {
    self.mySwitch.titleOn = @"视频";
    self.mySwitch.titleOff = @"全部";
    self.mySwitch.on = NO;
    self.mySwitch.fillColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    self.mySwitch.knobColor = [UIColor colorWithRed:202/255.0 green:21/255.0 blue:44/255.0 alpha:1];
    [self.mySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
}
//视频与全部之间的切换
-(void)switchValueChanged:(SimpleSwitch *)sender
{
    if (self.delegate != nil) {
        [self.delegate refreshData:self.mySwitch.on];
    }
}

//定义滑块
- (void)customSlider {
    UIImage *sliderImage = [[UIImage imageNamed:@"IMG_Firstpage_SeparatorThumb"] setTitle:@"1"];
    [self.slider setThumbImage:sliderImage forState:UIControlStateHighlighted];
    [self.slider setThumbImage:sliderImage forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderChange:(UISlider *)slider {
    [self sliderChangeValue:slider];
    [self collectionViewScrollToNumber];
}
//改变滑块的数字
- (void)sliderChangeValue:(UISlider *)slider {
    NSString *text = [self decimalwithFormat:0 floatV:slider.value];
    self.number = [text integerValue];
    if (self.number == self.total) {
        [self loadMoreData];
    }
    UIImage *normalImage = [[UIImage imageNamed:@"IMG_Firstpage_SeparatorThumb"] setTitle:text];
    [self.slider setThumbImage:normalImage forState:UIControlStateNormal];
    
    UIImage *hightImage = [[UIImage imageNamed:@"IMG_Firstpage_SeparatorPopBG"] setTitle:text];
    self.hightImage = [hightImage addChildIMage:hightImage];
    [self.slider setThumbImage:self.hightImage forState:UIControlStateHighlighted];

}
//collectionView滚动到相应的位置
- (void)collectionViewScrollToNumber {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.number - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}
//加载更多
- (void)loadMoreData {
    if (_isLoadingMore) {
        return;
    }
    if (self.delegate != nil) {
        self.page++;
        _isLoadingMore = YES;
        [self.delegate loadMoreData:self.mySwitch.on];
    }
}
//刷新
- (IBAction)refreshData:(id)sender {
//    if (_isRefreshing) {
//        return;
//    }
    if (self.delegate != nil) {
        _isRefreshing = YES;
        self.page = 1;
        self.number = 1;
        [self.delegate refreshData:self.mySwitch.on];
    }
}
//箭头点击
- (IBAction)loadNextItem:(id)sender {
    if (_isLoadingMore) {
        [self sliderChangeValue:self.slider];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.number inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    self.slider.value++;
    [self sliderChangeValue:self.slider];
}
//搜索
- (IBAction)searchClick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate searchButtonClick];
    }
}
//我的
- (IBAction)gotoUserMessage:(id)sender {
    if (self.delegate != nil) {
        [self.delegate HeadViewDelegateshowUserView];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.width = self.width;
    self.collectionView.height = self.height - 40;
}

- (void)updateWithArray:(NSArray *)array {
    self.slider.maximumValue = array.count;
    
    self.total = array.count;
    self.slider.value = self.number;
    
    [self sliderChangeValue:self.slider];
    
    _isRefreshing = NO;
    _isLoadingMore = NO;
    
    self.dataSoure = array;
    [self.collectionView reloadData];
    if (self.page > 13) {
        self.timeLabel.text = @"数月前";
    }else {
        self.timeLabel.text = [self.timeDataSoure objectForKey:@(self.page)];
    }
    
    if (self.number == 1) {
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}


#pragma mark 
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSoure.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeadViewCellId" forIndexPath:indexPath];
    [cell updateWithModel:self.dataSoure[indexPath.item]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(KScreenWidth, collectionView.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(HeadViewCellDidSelected:cid:)]) {
        HomeMmodel *model = self.dataSoure[indexPath.item];
        [self.delegate HeadViewCellDidSelected:model.id cid:model.cid];
    }
}


#pragma mark - 
#pragma mark - UIScrollViewDelegate

//结束拖拽，改变滑块
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *arr = self.collectionView.visibleCells;
    UICollectionViewCell *cell = [arr firstObject];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    self.slider.value = indexPath.item + 1;
    [self sliderChange:self.slider];
}








@end
