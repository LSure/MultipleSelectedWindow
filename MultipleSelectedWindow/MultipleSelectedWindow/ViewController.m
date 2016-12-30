//
//  ViewController.m
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "ViewController.h"
#import "SureConditionModel.h"
#import "SureMultipleSelectedWindow.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(id)sender {
    [SureMultipleSelectedWindow showWindowWithTitle:@"多选弹窗" selectedConditions:@[@"我",@"是",@"卖报的",@"小画家",@"Sure"] defaultSelectedConditions:@[@"我",@"小画家",@"Sure"] selectedBlock:^(NSArray *selectedArr) {
        NSLog(@"%@",selectedArr);
        for (SureConditionModel *model in selectedArr) {
            NSLog(@"选中[%@]",model.title);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
