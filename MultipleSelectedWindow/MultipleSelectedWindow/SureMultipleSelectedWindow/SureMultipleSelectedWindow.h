//
//  SureMultipleSelectedWindow.h
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureMultipleSelectedWindow : UIView

@property (nonatomic, copy) void(^selectedBlock)(NSArray*);

+ (void)showWindowWithTitle:(NSString*)title
         selectedConditions:(NSArray*)conditions
       defaultSelectedConditions:(NSArray*)SelectedConditions
              selectedBlock:(void(^)(NSArray *selectedArr))block;

@end
