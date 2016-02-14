//
//  ViewController.m
//  QRCodeScan
//
//  Created by IMAC on 16/1/25.
//  Copyright © 2016年 ysc. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CSQRSCodeScanView.h"
#import <SafariServices/SafariServices.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,weak) CSQRSCodeScanView *qRSCodeScanView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
//    
    CSQRSCodeScanView * qRSCodeScanView = [[CSQRSCodeScanView alloc] initWithFrame:self.view.bounds];
    self.qRSCodeScanView = qRSCodeScanView;
    qRSCodeScanView.session = self.session;
    
//        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
//    self.previewLayer.frame = self.view.bounds;

//    [self.view.layer addSublayer:self.previewLayer];
    
    [self.view addSubview:qRSCodeScanView];
    [self.session startRunning];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection;
{
    [self.session stopRunning];
    [self.qRSCodeScanView removeFromSuperview];
    
    for (AVMetadataMachineReadableCodeObject *codeObject in metadataObjects) {
        NSLog(@"%@",codeObject.stringValue);
        SFSafariViewController *sf =[[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:codeObject.stringValue] entersReaderIfAvailable:YES];
        [self presentViewController:sf animated:YES completion:nil];
    }
}


@end
