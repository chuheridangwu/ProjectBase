//
//  HomeViewController.m
//  ProjectBase
//
//  Created by dym on 2017/6/29.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.backgroundColor = XBAPPBaseColor;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickbTN) forControlEvents:UIControlEventTouchDown];
}

- (void)clickbTN{
    UIImage *image = [UIImage imageNamed:@"TabBar_Store_selected_new"];
    if ([TSShareHelper shareWithType:TSShareHelperShareTypeQQ andController:self andItems:@[image]]) {
        NSLog(@"没有微信");
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
