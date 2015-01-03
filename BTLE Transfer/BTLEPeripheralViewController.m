#import "BTLEPeripheralViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "StirService.h"


@interface BTLEPeripheralViewController () <CBPeripheralManagerDelegate>
@property (strong, nonatomic) IBOutlet UISwitch         *advertisingSwitch;
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@end

#define NOTIFY_MTU      20

@implementation BTLEPeripheralViewController


#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Start up the CBPeripheralManager
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    //  [self.peripheralManager stopAdvertising];
  
    [super viewWillDisappear:animated];
}



#pragma mark - Peripheral Methods


/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
}

#pragma mark - Switch Methods



/** Start advertising
 */
- (IBAction)switchChanged:(id)sender
{
    if (self.advertisingSwitch.on) {
        // All we advertise is our service's UUID
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
    }
    
    else {
        [self.peripheralManager stopAdvertising];
    }
}


@end
