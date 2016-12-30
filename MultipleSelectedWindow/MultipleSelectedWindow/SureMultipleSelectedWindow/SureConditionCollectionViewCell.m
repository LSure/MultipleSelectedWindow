//
//  SureConditionCollectionViewCell.m
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureConditionCollectionViewCell.h"
#define SureQuickSetRed [UIColor \
colorWithRed:236.0/255.0 \
green:73.0/255.0 \
blue:73.0/255.0 \
alpha:1.0]
#define SureQuickSetWhite [UIColor \
colorWithRed:245.0/255.0 \
green:245.0/255.0 \
blue:245.0/255.0 \
alpha:1.0]
@implementation SureConditionCollectionViewCell

- (void)loadDataFromModel:(SureConditionModel *)model {
    _conditionLabel.text = model.title;
    if (model.isSelected) {
        _conditionLabel.backgroundColor = SureQuickSetRed;
        _conditionLabel.textColor = [UIColor whiteColor];
        _conditionLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = .0;
    } else {
        _conditionLabel.backgroundColor = SureQuickSetWhite;
        _conditionLabel.textColor = [UIColor darkGrayColor];
        _conditionLabel.font = [UIFont systemFontOfSize:15.0];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = .5;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 20;
    self.layer.borderWidth = .5;
}

@end
