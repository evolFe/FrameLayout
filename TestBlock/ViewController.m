//
//  ViewController.m
//  TestBlock
//
//  Created by evol on 2018/10/16.
//  Copyright © 2018 evol. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "Tool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad { 
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 500)];
    a.backgroundColor = [UIColor greenColor];
    [self.view addSubview:a];
    
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.backgroundColor = [UIColor blackColor];
    [a addSubview:b];
    
//    b.frame = CGRectMake(20, 20, CGRectGetWidth(a.frame) - 50, 200);
    
    UIButton * c = [UIButton buttonWithType:UIButtonTypeCustom];
    c.backgroundColor = [UIColor blueColor];
    [a addSubview:c];
    
//    c.frame = CGRectMake(CGRectGetMinX(b.frame) + 20, CGRectGetMaxY(b.frame) + 20, CGRectGetWidth(a.frame) - 50, 200);

//    a.f_left(0).f_right(0).f_top(0).f_bottom(0);
    b.f_top(20).f_left(20).f_right(-20).f_height(100);
    c.f_top(b.f_bottom_offset(20)).f_left(b.f_left_offset(10)).f_right(b.f_right_offset(-10)).f_bottom(-20);

//    ELWeak(self);
    ELWeak(a);
    [b addTouchBlock:^(id  _Nonnull sender) {
        ELStrong(a);
//        ELStrong(self);
        CGRect frame = a.frame;
        frame.size.width = frame.size.width - 50;
        frame.size.height = frame.size.height -50;
        a.frame = frame;
//        [self presentViewController:[TestViewController new] animated:YES completion:nil];
    }];
    
    [c addTouchBlock:^(id  _Nonnull sender) {
        CGRect frame = a.frame;
        frame.size.width = frame.size.width + 50;
        frame.size.height = frame.size.height + 50;
        a.frame = frame;
    }];
}

@end
