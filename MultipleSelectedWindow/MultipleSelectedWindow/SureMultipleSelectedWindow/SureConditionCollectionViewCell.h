//
//  SureConditionCollectionViewCell.h
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SureConditionModel.h"
@interface SureConditionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
- (void)loadDataFromModel:(SureConditionModel*)model;
@end
