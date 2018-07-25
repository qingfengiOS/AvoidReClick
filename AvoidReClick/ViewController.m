//
//  ViewController.m
//  AvoidReClick
//
//  Created by qingfeng on 2018/7/20.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+AvoidReClick.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _button.timeInterval = 3;
}

- (IBAction)click:(id)sender {
    
    
    NSLog(@"%@",[NSNumber numberWithDouble:CFAbsoluteTimeGetCurrent()]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
