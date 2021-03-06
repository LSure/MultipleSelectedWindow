//
//  SureFooterCollectionReusableView.h
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureFooterCollectionReusableView : UICollectionReusableView
@property (nonatomic, copy) void(^confirmBlock)(void);
@property (nonatomic, copy) void(^cancelBlock)(void);
@end
