//
//  ViewController.m
//  STQRCodeScan
//
//  Created by stone on 1/9/15.
//  Copyright (c) 2015 stone. All rights reserved.
//

#import "ViewController.h"
#import "ZBarSDK.h"

#define SCAN_REGION 240
#define MAIN_BACKGROUND_COLOR [UIColor blackColor]
#define MAIN_BACKGROUND_ALPHA 0.4

@interface ViewController () <ZBarReaderDelegate>
{
    CGFloat SCREEN_WIDTH;
    CGFloat SCREEN_HEIGHT;
    
    UIView *readerView;
    UIImageView *cancleImageView;
    UIView *scanLineView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QRScanViewController";
    [self setCommonParameters];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    scanBtn.frame = CGRectMake(100, 240, 240, 120);
    [scanBtn setTitle:@"Click here to scan." forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(initQRCodeScanView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
}

- (void)setCommonParameters
{
    SCREEN_WIDTH = [UIScreen mainScreen].bounds.size.width;
    SCREEN_HEIGHT = [UIScreen mainScreen].bounds.size.height;
}

#pragma mark - Init Scan View

- (void)initQRCodeScanView
{
    //add custom view
    readerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [readerView setBackgroundColor:[UIColor clearColor]];
    
    UIView *upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-SCAN_REGION)/2)];
    upperView.backgroundColor = MAIN_BACKGROUND_COLOR;
    upperView.alpha = MAIN_BACKGROUND_ALPHA;
    UIView *lowerView = [[UIView alloc] initWithFrame:CGRectMake(0, upperView.frame.size.height+SCAN_REGION, SCREEN_WIDTH, upperView.frame.size.height)];
    lowerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    lowerView.alpha = MAIN_BACKGROUND_ALPHA;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, upperView.frame.size.height, (SCREEN_WIDTH-SCAN_REGION)/2, SCAN_REGION)];
    leftView.backgroundColor = MAIN_BACKGROUND_COLOR;
    leftView.alpha = MAIN_BACKGROUND_ALPHA;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width+SCAN_REGION, leftView.frame.origin.y, leftView.frame.size.width, leftView.frame.size.height)];
    rightView.backgroundColor = MAIN_BACKGROUND_COLOR;
    rightView.alpha = MAIN_BACKGROUND_ALPHA;
    
    [readerView addSubview:upperView];
    [readerView addSubview:leftView];
    [readerView addSubview:rightView];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(SCREEN_WIDTH/2-40, lowerView.frame.origin.y+30, 80, 40);
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor blackColor]];
    [cancelBtn setAlpha:0.5];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(imagePickerControllerDidCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [readerView addSubview:lowerView];
    [readerView addSubview:cancelBtn];
    
    
    
    [self setQRCodeReader];
}

- (void)setQRCodeReader
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
//    reader.showsZBarControls = YES;
    reader.showsZBarControls = NO;
    reader.cameraOverlayView = readerView;
    
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
