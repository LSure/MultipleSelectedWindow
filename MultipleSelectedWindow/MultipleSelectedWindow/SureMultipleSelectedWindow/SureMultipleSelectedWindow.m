//
//  SureMultipleSelectedWindow.m
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureMultipleSelectedWindow.h"
#import "SureConditionModel.h"
#import "SureConditionCollectionViewCell.h"
#import "SureHeaderCollectionReusableView.h"
#import "SureFooterCollectionReusableView.h"
#define SPACE 40.0
#define WINDOW_WIDTH ([UIScreen mainScreen].bounds.size.width - (SPACE * 2))
#define WINDOW_HEIGHT ([UIScreen mainScreen].bounds.size.height - (SPACE * 2))
#define ITEM_SIZE ((WINDOW_WIDTH / 2) - 15)
@interface SureMultipleSelectedWindow ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger defaultIndex;
@end

@implementation SureMultipleSelectedWindow

+ (void)showWindowWithTitle:(NSString*)title
         selectedConditions:(NSArray*)conditions
  defaultSelectedConditions:(NSArray*)SelectedConditions
              selectedBlock:(void(^)(NSArray *selectedArr))block{
    SureMultipleSelectedWindow *window = [[SureMultipleSelectedWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.title = title;
    [[UIApplication sharedApplication].keyWindow addSubview:window];
    
    for (NSInteger i = 0; i < conditions.count; i++) {
        SureConditionModel *model = [[SureConditionModel alloc]init];
        if ([SelectedConditions containsObject:conditions[i]]) {
            model.isSelected = YES;
            [window.selectedArr addObject:model];
        } else {
            model.isSelected = NO;
        }
        model.title = conditions[i];
        [window.dataArr addObject:model];
    }
    
    NSInteger rows = window.dataArr.count / 2;
    if (window.dataArr.count % 2 != 0) {
        rows++;
    }
    window.collectionView.frame = CGRectMake(0, 0, WINDOW_WIDTH,  rows * 40 + ((rows - 1) * 5) + 100);
    if (window.collectionView.frame.size.height >= WINDOW_HEIGHT) {
        window.collectionView.frame = CGRectMake(0, 0, WINDOW_WIDTH,  WINDOW_HEIGHT);
    }
    
    window.collectionView.center = window.center;
    window.collectionView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                         CGAffineTransformMakeScale(1.1f, 1.1f));
    [UIView animateWithDuration:.2 animations:^{
        window.collectionView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                                       CGAffineTransformMakeScale(1.0f, 1.0f));
    }];
    
    window.selectedBlock = block;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createUI];
}

- (void)initData {
    _selectedArr = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
}

- (void)createUI {
    [self addSubview:self.maskView];
    [self addSubview:self.collectionView];
}

- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .8;
    }
    return _maskView;
}

- (UICollectionView*)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(ITEM_SIZE, 40);
        layout.headerReferenceSize = CGSizeMake(WINDOW_WIDTH, 50);
        layout.footerReferenceSize = CGSizeMake(WINDOW_WIDTH, 50);
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _collectionView.layer.borderWidth = .5;
        _collectionView.layer.cornerRadius = 10.0;
        [_collectionView registerNib:[UINib nibWithNibName:@"SureConditionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CONDITION"];
        [_collectionView registerNib:[UINib nibWithNibName:@"SureHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];
        [_collectionView registerNib:[UINib nibWithNibName:@"SureFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SureConditionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CONDITION" forIndexPath:indexPath];
    SureConditionModel *model = _dataArr[indexPath.item];
    [cell loadDataFromModel:model];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SureHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
        headerView.titleLabel.text = _title;
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        SureFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FOOTER" forIndexPath:indexPath];
        __weak typeof(self) weakself = self;
        [footerView setConfirmBlock:^{
            __strong typeof(self) stongself = weakself;
            if (stongself.selectedBlock) {
                stongself.selectedBlock(stongself.selectedArr);
            }
            [stongself removeFromSuperview];
        }];
        
        [footerView setCancelBlock:^{
            __strong typeof(self) stongself = weakself;
            [stongself removeFromSuperview];
        }];
        return footerView;
    } else {
        return [[UICollectionReusableView alloc]init];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectedOrDeselectedItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectedOrDeselectedItemAtIndexPath:indexPath];
}

- (void)selectedOrDeselectedItemAtIndexPath:(NSIndexPath*)indexPath {
    SureConditionModel *model = _dataArr[indexPath.item];
    model.isSelected = !model.isSelected;
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    if (model.isSelected) {
        if (![_selectedArr containsObject:model]) {
            [_selectedArr addObject:model];
        }
    } else {
        if ([_selectedArr containsObject:model]) {
            [_selectedArr removeObject:model];
        };
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

- (void)dealloc {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
