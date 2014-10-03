//
//  BluetoothManager.m
//  bartenderClient
//
//  Created by Davis Gossage on 10/2/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "BTBluetoothManager.h"


@interface BTBluetoothManager() {
    
}


@end

@implementation BTBluetoothManager

static BTBluetoothManager* gSharedInstance = nil;

+(BTBluetoothManager*)sharedInstance {
    if (!gSharedInstance) {
        gSharedInstance = [[BTBluetoothManager alloc] init];
    }
    return gSharedInstance;
}

- (void)attemptBluetoothConnection{
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:5 completion:^(NSArray *peripherals) {
        //
    }];
}


@end
