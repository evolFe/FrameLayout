//
//  TestViewController.m
//  TestBlock
//
//  Created by evol on 2018/10/18.
//  Copyright © 2018 evol. All rights reserved.
//

#import "TestViewController.h"
#import "UIButton+ELTool.h"
#import "Tool.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(100, 200, 100, 30);
    b.backgroundColor = [UIColor blueColor];
    ELWeak(self);
    [b addTouchBlock:^(id  _Nonnull sender) {
        ELStrong(self);
        [self t];
    }];
//    [b addTarget:self action:@selector(t) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)t
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    
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
