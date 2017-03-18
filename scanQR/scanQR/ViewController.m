//
//  ViewController.m
//  scanQR
//
//  Created by 孙承秀 on 16/11/25.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = ({
        UIButton *scanBtn = [[UIButton alloc]init];
        [scanBtn setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2, 100, 100, 50)];
        [scanBtn setTitle:@"识别二维码" forState:UIControlStateNormal];
        [scanBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
        scanBtn;
    });
    [self.view addSubview:btn];
}
- (void)scanQRCode {

    NSLog(@"点击识别二维码了");
    DPScanQRViewController *scanVC = [DPScanQRViewController new];
    [self.navigationController pushViewController:scanVC animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
