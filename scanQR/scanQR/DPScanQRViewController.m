//
//  DPScanQRViewController.m
//  scanQR
//
//  Created by 孙承秀 on 16/11/25.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "DPScanQRViewController.h"

@interface DPScanQRViewController ()

@end

@implementation DPScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self customQRDevice];
}
#pragma mark - 自定义识别二维码
- (void)customQRDevice {

    // 创建捕捉设备，类型为video类型
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device unlockForConfiguration];
    NSError *error;
    
    // 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error ];
    if (!input) {
        return;
    }
    AVCaptureSession *session =[[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    //预览图层
    AVCaptureVideoPreviewLayer *preview = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    preview.frame = CGRectMake(30, 30+self.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.width-30);
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer addSublayer:preview];
    
    //输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    CGRect rect = [preview rectForMetadataOutputRectOfInterest:preview.frame];
    //设置扫描区域
    output.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);;
    if ([session canAddOutput:output ]) {
        [session addOutput:output];
    }
    if ([[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]||[[output availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeCode128Code]) {
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        [session startRunning];
    }
    else {
    
        [session stopRunning];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉!" message:@"相机权限被拒绝，请前往设置-隐私-相机启用此应用的相机权限。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
}

#pragma mark - output代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    //判断是否扫描到了我二维码
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *type = metadataObjects.firstObject;
        if ([[type type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"%@",type.stringValue);
            [self readQRCode:type.stringValue];
        }
    }

}

#pragma mark - 分析二维码
- (void) readQRCode:(NSString *)code {

    if (code.length <= 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"找不到二维码" message:@"导入的图片里并没有找到二维码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([code hasPrefix:@"http"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:code]];
    }
    else {
    
        NSLog(@"二维码:%@",code);
    }

}
#pragma mark - 通过选择的图片转化为字符串
- (NSString *) revertImageUseImage:(UIImage *)image {
    NSDictionary *dic = @{CIDetectorAccuracy : CIDetectorAccuracyHigh};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:dic];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    CIQRCodeFeature *str = (CIQRCodeFeature *)features.firstObject;
    return str;
}

@end
