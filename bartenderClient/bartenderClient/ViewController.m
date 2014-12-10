//
//  ViewController.m
//  bartenderClient
//
//  Created by Davis Gossage on 10/2/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){

    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *bluetoothMessage;
    IBOutlet UIView *statusView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BTBluetoothManager sharedInstance] initialize];
    [[BTBluetoothManager sharedInstance] setDelegate:self];
//override point for non-bluetooth device (simulator)
#if NOBT
    [self attemptConnection];
#endif
}

- (void)viewWillAppear:(BOOL)animated{
    //begin animation of our three elements

    [UIView animateWithDuration:1.0 delay:0.0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
        statusLabel.alpha = 0.7;
        statusView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:nil];
    
    [UIView animateWithDuration:.3 delay:0.0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
        bluetoothMessage.alpha = 0.5;
    } completion:nil];
}

- (void)attemptConnection{
#if NOBT
    [self animateViewOut];
#else
    [[BTBluetoothManager sharedInstance] attemptBluetoothConnection];
#endif

}

- (void)animateViewOut{
    bluetoothMessage.hidden = true;
    [UIView animateWithDuration:1.0 animations:^{
        statusLabel.alpha = 0.0;
        statusView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height*.7);
    } completion:^(BOOL finished) {
        [self performSegueWithIdentifier:@"toDrinkSelection" sender:self];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark bluetooth manager

- (void)BTRadioChanged:(BOOL)on{
    bluetoothMessage.hidden = on;
    if (on){
        [self attemptConnection];
    }
}

- (void)connectionEstablished{
    [self animateViewOut];
}


#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //we assume this is the try again button... and we try again
        [self attemptConnection];
    }
}

@end
