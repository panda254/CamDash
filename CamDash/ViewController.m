//
//  ViewController.m
//  CamDash
//
//  Created by Arpit Panda on 18/01/19.
//  Copyright © 2019 Arpit Panda. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureFileOutput.h>


@interface ViewController ()  <AVCaptureFileOutputRecordingDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)shootVideoClicked:(id)sender {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    captureSession.sessionPreset = AVCaptureSessionPresetMedium;

    AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                                                                                        mediaType:AVMediaTypeVideo
                                                                                                                position:AVCaptureDevicePositionBack];
    NSArray *captureDevices = [captureDeviceDiscoverySession devices];

    AVCaptureDevice *currentDevice = captureDevices[0];

    if ([currentDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error;
        if ([currentDevice lockForConfiguration:&error]) {
            CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
            [currentDevice setFocusPointOfInterest:autofocusPoint];
            [currentDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [currentDevice unlockForConfiguration];
        }
//        [currentDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }

    if ([currentDevice
         isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        NSError *error;
        if ([currentDevice lockForConfiguration:&error]) {
            CGPoint exposurePoint = CGPointMake(0.5f, 0.5f);
            [currentDevice setExposurePointOfInterest:exposurePoint];
            [currentDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            [currentDevice unlockForConfiguration];
        }
    }

    NSError *error;

    [captureSession beginConfiguration];
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput
                                   deviceInputWithDevice:currentDevice
                                   error:&error];

    if ([captureSession canAddInput:captureDeviceInput]) {
        [captureSession addInput:captureDeviceInput];
    }

    AVCaptureMovieFileOutput *aMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    CMTime maxDuration = CMTimeMake(20, 1);
    aMovieFileOutput.maxRecordedDuration = maxDuration;
    aMovieFileOutput.minFreeDiskSpaceLimit = 1000;

    if ([captureSession canAddOutput:aMovieFileOutput]) {
        [captureSession addOutput:aMovieFileOutput];
    }
    else {
        // Handle the failure.
    }

    [captureSession commitConfiguration];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *appSupport = [paths objectAtIndex:0];
    NSString *videoLocation = [appSupport stringByAppendingPathComponent:@"vide.mov"];

    NSURL *fileURL = [NSURL fileURLWithPath:videoLocation];

    [captureSession startRunning];

    AVCaptureConnection *c = [aMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if (c.active) {
        //connection is active
    } else {
        captureSession.sessionPreset = AVCaptureSessionPresetLow;
        //connection is not active
        //try to change self.captureSession.sessionPreset,
        //or change videoDevice.activeFormat
    }

    [aMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
    sleep(15);
    [aMovieFileOutput stopRecording];


}

- (void)captureOutput:(nonnull AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(nonnull NSURL *)outputFileURL fromConnections:(nonnull NSArray<AVCaptureConnection *> *)connections error:(nullable NSError *)error {
    // do nothing
    BOOL recordedSuccessfully = YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    // do nothing
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    // do nothing
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    // do nothing
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    // do nothing
    return CGSizeMake(floorf(parentSize.width / 3.0),
                      parentSize.height);
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    // do nothing
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    // do nothing
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    // do nothing
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    // do nothing
}

- (void)setNeedsFocusUpdate {
    // do nothing
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}

- (void)updateFocusIfNeeded {
    // do nothing
}

@end
