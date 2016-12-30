//
//  SureFooterCollectionReusableView.m
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureFooterCollectionReusableView.h"

@implementation SureFooterCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)confirmClick:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}
- (IBAction)cancelClick:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
