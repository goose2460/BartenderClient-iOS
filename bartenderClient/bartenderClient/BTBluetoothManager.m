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
    [self scanForPeripheralsByInterval:5 completion:^(NSArray *peripherals) {
        if (peripherals.count){
            [self testPeripheral:[peripherals objectAtIndex:0]];
        }
    }];
}


- (void)testPeripheral:(LGPeripheral *)peripheral
{
    // First of all connecting to peripheral
    [peripheral connectWithCompletion:^(NSError *error) {
        // Discovering services of peripheral
        [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
            for (LGService *service in services) {
                // Finding out our service
                if ([service.UUIDString isEqualToString:@"5ec0"]) {
                    // Discovering characteristics of our service
                    [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                        // We need to count down completed operations for disconnecting
                        __block int i = 0;
                        for (LGCharacteristic *charact in characteristics) {
                            // cef9 is a writabble characteristic, lets test writting
                            if ([charact.UUIDString isEqualToString:@"cef9"]) {
                                [charact writeByte:0xFF completion:^(NSError *error) {
                                    if (++i == 3) {
                                        // finnally disconnecting
                                        [peripheral disconnectWithCompletion:nil];
                                    }
                                }];
                            } else {
                                // Other characteristics are readonly, testing read
                                [charact readValueWithBlock:^(NSData *data, NSError *error) {
                                    if (++i == 3) {
                                        // finnally disconnecting
                                        [peripheral disconnectWithCompletion:nil];
                                    }
                                }];
                            }
                        }
                    }];
                }
            }
        }];
    }];
}


@end
