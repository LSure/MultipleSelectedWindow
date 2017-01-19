# MultipleSelectedWindow
######前言
本文为iOS自定义视图封装《一劳永逸》系列的第三期，旨在提供封装思路，结果固然重要，但理解过程才最好。授人以鱼不如授人以渔。⚠️文章旨在帮助封装程度较低的朋友们，大神可无视，勿喷。
######历史文章链接列表：
- [一劳永逸，iOS引导蒙版封装流程](http://www.jianshu.com/p/dfc3ecdd5810)
- [一劳永逸，iOS网页视图控制器封装流程](http://www.jianshu.com/p/553424763585)

######正文
最近更新项目需求，需要封装一款多选弹窗视图，故将封装流程进行分享，效果图如下：
![多选弹窗.png](http://upload-images.jianshu.io/upload_images/1767950-0309c825d4a55ce5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

对于弹窗视图，大体由两个视图进行搭建，一为蒙版视图（maskView）二为内容视图（contentView）。maskView通常设定一定的透明度允许用户交互点击取消弹窗操作，需要注意的是不要maskView做为contentView的子视图，因改变父视图透明度会影响子视图，因此maskView与contentView均需添加在弹窗视图self上，保证兄弟视图关系，这里不再赘述。对于contentView，因需求变动不大，本文直接采用collectionView作为内容视图，标题与决策按钮以组头组尾视图进行展示。
```
- (void)createUI {
    [self addSubview:self.maskView];
    [self addSubview:self.collectionView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}
```
接下来我们解决首要问题，即collectionView多选操作，既然tableView具有多选功能，那么collectionView为什么不呢？对于collectionView的多选功能的使用场景还是很多的，比如本例多选弹窗、自定义相册功能等。
接下来简单讲述下collectionView实现多选功能的实现，以下为部分核心代码。

⚠️collectionView开启多选功能，需将属性allowsMultipleSelection置为YES
```
_collectionView.allowsMultipleSelection = YES;
```
接下来我们需要准备两个数据源，分别存储全部选项与选中选项，命名为dataArr与selectedArr
```
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *selectedArr;
```
为了防止复用问题的出现，我们需要存储每个item的选中状态，这里选择创建数据模型进行实现。
```
#import <Foundation/Foundation.h>

@interface SureConditionModel : NSObject
@property (nonatomic, assign) BOOL isSelected;//是否选中 默认为NO
@property (nonatomic, copy) NSString *title;//选中item标题
@end
```
接下来对collectionView布局时，我们即可通过数据模型中提供的数据进行布局
```
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SureConditionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CONDITION" forIndexPath:indexPath];
    SureConditionModel *model = _dataArr[indexPath.item];
    [cell loadDataFromModel:model];
    return cell;
}
```
```
@implementation SureConditionCollectionViewCell

- (void)loadDataFromModel:(SureConditionModel *)model {
    _conditionLabel.text = model.title;
    if (model.isSelected) {
        _conditionLabel.backgroundColor = SureQuickSetRed;
        _conditionLabel.textColor = [UIColor whiteColor];
        _conditionLabel.font = [UIFont boldSystemFontOfSize:15.0];
    } else {
        _conditionLabel.backgroundColor = SureQuickSetWhite;
        _conditionLabel.textColor = [UIColor darkGrayColor];
        _conditionLabel.font = [UIFont systemFontOfSize:15.0];
    }
}
```
在这里简单的更改了选中文字的背景颜色、字体颜色和字体，如有其他需求也可进行更改。
接下来我们实现collectionView选中与取消选中的代理方法即可，这里需要取得当前选中或取消选中的item对应的数据模型，并对其选中属性进行置反操作。然后进行添加或删除操作，选中与取消选中的最终结果都存储在selectedArr中。
```
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
```
执行上述操作，我们即可简单实现collectionView的多选功能。

接下来需要解决的问题为随选项个数动态调节collectionView高度的问题。即简单实现自适应内容高度。

因此我们需要获取collectionView的行数，但API中并没有给予。楼主通过数据源除列数获取行数，然后判断是否有余数进行++操作进行解决，如有更好的方式请评论指出，多谢。
```
NSInteger rows = window.dataArr.count / 2;
if (window.dataArr.count % 2 != 0) {
    rows++;
}
```
既然UI上的操作基本考虑完成，接下里即需获取所选中选项并进行回调。因确认与取消按钮布局在collectionView的组尾上，因此我们需要回调传递所选选项，使用Block、代理等均可。
```
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
```
最后即为最重要的外漏方法问题，前几篇文章提过，为了降低代码耦合度，尽量外漏简易的方法，使其他开发人员可快速使用。并且在对象方法与类方法之间通常选择类方法进行实现。

考虑本文需求，既然为自定义View，因此数据获取一定不要放在View中，因此我们需要传入所有可选择数据，对于可选择数据可能具有默认选项，我们也可进行提供，最后最重要的为选中结果，我们需要将用户所选中的信息进行回调传递。

最终的结果如下，部分代码已省略，可前往demo查看。
```
+ (void)showWindowWithTitle:(NSString*)title
         selectedConditions:(NSArray*)conditions
       defaultSelectedConditions:(NSArray*)SelectedConditions
              selectedBlock:(void(^)(NSArray *selectedArr))block;
```
```
+ (void)showWindowWithTitle:(NSString*)title
         selectedConditions:(NSArray*)conditions
  defaultSelectedConditions:(NSArray*)SelectedConditions
              selectedBlock:(void(^)(NSArray *selectedArr))block{
    SureMultipleSelectedWindow *window = [[SureMultipleSelectedWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:window];
    //数据接收处理
    window.selectedBlock = block;
    //显示调节
}
```
调用方式如下
```
[SureMultipleSelectedWindow showWindowWithTitle:@"多选弹窗"
                             selectedConditions:@[@"我",@"是",@"卖报的",@"小画家",@"Sure"] defaultSelectedIndex:3
                                  selectedBlock:^(NSArray *selectedArr) {
        NSLog(@"%@",selectedArr);
}];
```
至此多选弹窗即封装完毕。
