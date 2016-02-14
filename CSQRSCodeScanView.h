//
//  CSQRSCodeScanView.h
//  QRCodeScan
//
//  Created by IMAC on 16/1/25.
//  Copyright © 2016年 ysc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface CSQRSCodeScanView : UIView
@property (nonatomic,strong) AVCaptureSession *session;
@end
