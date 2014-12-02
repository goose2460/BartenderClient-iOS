//
//  BluetoothManager.m
//  bartenderClient
//
//  Created by Davis Gossage on 10/2/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "BTBluetoothManager.h"

#define BARTENDER_DEVICE_NAME @"UART"


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

- (void)attemptBluetoothConnectionWithCompletion:(void(^)(NSError* error))completion{
    [self scanForPeripheralsByInterval:2 completion:^(NSArray *peripherals) {
        if (peripherals.count){
            for (LGPeripheral *p in peripherals){
                if ([p.name isEqualToString:BARTENDER_DEVICE_NAME]){
                    [p connectWithCompletion:^(NSError *error) {
                        if (completion){
                            completion(error);
                        }
                    }];
                    return;
                }
            }
        }
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Could not connect to the Bartender.  Does not appear to be broadcasting." forKey:NSLocalizedDescriptionKey];
        NSError *nothingFoundError = [NSError errorWithDomain:@"bluetooth" code:200 userInfo:details];
        completion(nothingFoundError);
    }];
}


@end
