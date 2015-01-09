//
//  ViewController.m
//  STQRCodeScan
//
//  Created by stone on 1/9/15.
//  Copyright (c) 2015 stone. All rights reserved.
//

#import "ViewController.h"
#import "ZBarSDK.h"

@interface ViewController () <ZBarReaderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QRScanViewController";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scanBtn.frame = CGRectMake(100, 240, 240, 120);
    [scanBtn setTitle:@"Click here to scan." forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(initQRCodeScanView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
}

- (void)initQRCodeScanView
{
    [self setQRCodeReader];
}

- (void)setQRCodeReader
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    reader.showsZBarControls = YES;
    
    [self presentViewController:reader animated:YES completion:nil];
}

#pragma mark - ZBarReaderDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id <NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol;
    for (symbol in results) {
        break;
    }
    NSLog(@"Scan Success! Results:%@", symbol.data);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}








@end
