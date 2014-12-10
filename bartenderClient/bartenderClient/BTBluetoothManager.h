//
//  BluetoothManager.h
//  bartenderClient
//
//  Created by Davis Gossage on 10/2/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UARTPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BTBluetoothManagerDelegate

- (void)BTRadioChanged:(BOOL) on;
- (void)connectionEstablished;

@end

@interface BTBluetoothManager : NSObject<UARTPeripheralDelegate,CBCentralManagerDelegate>

@property (nonatomic,weak) id<BTBluetoothManagerDelegate> delegate;

+(BTBluetoothManager*)sharedInstance;

- (void)attemptBluetoothConnection;
- (void)initialize;
- (void)writeStringData:(NSString*) stringData;

@end
