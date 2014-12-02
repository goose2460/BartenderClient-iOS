//
//  BluetoothManager.h
//  bartenderClient
//
//  Created by Davis Gossage on 10/2/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGBluetooth.h"

@interface BTBluetoothManager : LGCentralManager

+(BTBluetoothManager*)sharedInstance;

- (void)attemptBluetoothConnectionWithCompletion:(void(^)(NSError* error))completion;

@end
