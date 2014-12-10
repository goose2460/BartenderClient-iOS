//
//  BluetoothManager.m
//  bartenderClient
//
//  Created by Davis Gossage on 10/2/14.
//  Copyright (c) 2014 Davis Gossage. All rights reserved.
//

#import "BTBluetoothManager.h"

#define BARTENDER_DEVICE_NAME @"BARTEND"


@interface BTBluetoothManager() {
    LGCharacteristic *writeSerialCharacteristic;
    UARTPeripheral *currentPeripheral;
    CBCentralManager *cm;
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

- (void)initialize{
    if (!cm){
        cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}

- (void)attemptBluetoothConnection{
    //Look for available Bluetooth LE devices
    //skip scanning if UART is already connected
    NSArray *connectedPeripherals = [cm retrieveConnectedPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]];
    if ([connectedPeripherals count] > 0) {
        //connect to first peripheral in array
        [self connectPeripheral:[connectedPeripherals objectAtIndex:0]];
    }
    else{
        [cm scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]
                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
    }
}

- (void)connectPeripheral:(CBPeripheral*)peripheral{
    
    //Connect Bluetooth LE device
    
    //Clear off any pending connections
    [cm cancelPeripheralConnection:peripheral];
    
    //Connect
    currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [cm connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    
}

- (void)writeStringData:(NSString*) stringData{
    [currentPeripheral writeString:stringData];
}

- (void)disconnect{
    [cm cancelPeripheralConnection:currentPeripheral.peripheral];
}

#pragma mark central bluetooth manager
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn){
        //respond to powered on
        [self.delegate BTRadioChanged:true];
    }
    else if (central.state == CBCentralManagerStatePoweredOff){
        //respond to powered off
        [self.delegate BTRadioChanged:false];
    }
}

#pragma mark UART peripheral delegate

- (void)didReceiveData:(NSData *)newData{
    
}

- (void)uartDidEncounterError:(NSString *)error{
    
}

- (void)didReadHardwareRevisionString:(NSString *)string{
    
}

- (void) centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI{
    NSLog(@"Did discover peripheral %@", peripheral.name);
    [cm stopScan];
    [self connectPeripheral:peripheral];
}


- (void) centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral{
    if ([currentPeripheral.peripheral isEqual:peripheral]){
        [self.delegate connectionEstablished];
        if(peripheral.services){
            NSLog(@"Did connect to existing peripheral %@", peripheral.name);
            [currentPeripheral peripheral:peripheral didDiscoverServices:nil]; //already discovered services, DO NOT re-discover. Just pass along the peripheral.
        }
        else{
            NSLog(@"Did connect peripheral %@", peripheral.name);
            [currentPeripheral didConnect];
        }
    }
}


- (void) centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    if ([currentPeripheral.peripheral isEqual:peripheral])
    {
        [currentPeripheral didDisconnect];
    }
}



@end
