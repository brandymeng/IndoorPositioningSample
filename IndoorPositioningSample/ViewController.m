//
//  ViewController.m
//  IndoorPositioningSample
//
//  Created by Ruben Xifré on 15/4/15.
//  Copyright (c) 2015 Ruben Xifré. All rights reserved.
//

#import "ViewController.h"
#import "JCNotificationCenter.h"
#import "IPSStoresManager.h"
#import "IPSStore.h"
#import "IPSStoreDetailViewController.h"
#import <EstimoteSDK/ESTBeaconRegion.h>

@interface ViewController ()

@property (strong, nonatomic) ESTBeaconManager *beaconManager;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *proximityIndicatorLayer;

@property (nonatomic) CLProximity previousProximityStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalNotification:) name:@"kDidReceiveLocalNotification" object:nil];
    
    self.previousProximityStatus = -1;
    self.infoLabel.text = @"Move the phone close to the beacon";
    self.proximityIndicatorLayer.backgroundColor = [UIColor redColor];
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // create sample region object (you can additionally pass major / minor values)
    //NSString *uuidString = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    //CLBeaconMajorValue majValue = 46223;
    //CLBeaconMinorValue minValue = 56112;
    //ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid major:majValue minor:minValue identifier:uuidString];
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"EstimoteSampleRegion"];
    
    // start looking for Estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self startRangingBeacon:region];
    
    [self.beaconManager startMonitoringForRegion:region];
    [self.beaconManager requestStateForRegion:region];
}

-(void)startRangingBeacon:(ESTBeaconRegion *)beaconRegion
{
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self.beaconManager requestAlwaysAuthorization];
        [self.beaconManager startRangingBeaconsInRegion:beaconRegion];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
            [ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.beaconManager startRangingBeaconsInRegion:beaconRegion];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                        message:@"You have denied access to location services. Change this in app settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
                                                        message:@"You have no access to location services."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    if([beacons count] > 0)
    {
        // beacon array is sorted based on distance
        // closest beacon is the first one
        ESTBeacon* closestBeacon = [beacons objectAtIndex:0];
        UIColor *backgroundColor;
        // calculate and set new y position
        switch (closestBeacon.proximity)
        {
            case CLProximityUnknown:
                self.distanceLabel.text = @"Unknown region";
                backgroundColor = [UIColor redColor];
                break;
            case CLProximityImmediate:
                self.distanceLabel.text = @"Immediate region";
                backgroundColor = [UIColor greenColor];
                BOOL didChange = [self didProximityStatusChange:closestBeacon.proximity];
                if (didChange) {
                    //[self presentDiscountView];
                    [self presentStoreDetailInfoView:[closestBeacon.proximityUUID UUIDString]];
                }
                break;
            case CLProximityNear:
                self.distanceLabel.text = @"Near region";
                backgroundColor = [UIColor yellowColor];
                break;
            case CLProximityFar:
                self.distanceLabel.text = @"Far region";
                backgroundColor = [UIColor orangeColor];
                break;
                
            default:
                break;
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.proximityIndicatorLayer.backgroundColor = backgroundColor;
        }];
        [self updatePreviousAndCurrentProximityStatus:closestBeacon.proximity];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
      didEnterRegion:(ESTBeaconRegion *)region
{
    // iPhone/iPad entered the beacon region
    // present local notification
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [JCNotificationCenter
         enqueueNotificationWithTitle:@"Title"
         message:@"You are very close to one of our stores. Come by to check our discounts!"
         tapHandler:^{
             NSLog(@"Received tap on notification banner!");
             [self presentStoreDetailInfoView:[region.proximityUUID UUIDString]];
         }];
    } else {
        [self presentLocalNotificationWithAlertBody:@"You are very close to one of our stores. Come by to check our discounts!" andUUIDString:[region.proximityUUID UUIDString]];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
       didExitRegion:(ESTBeaconRegion *)region
{
    // iPhone/iPad left the beacon region
}

- (BOOL)didProximityStatusChange:(CLProximity)newProximity
{
    return self.previousProximityStatus!=newProximity;
}

- (void)updatePreviousAndCurrentProximityStatus:(CLProximity)newProximity
{
    self.previousProximityStatus = newProximity;
}

- (void)presentLocalNotificationWithAlertBody:(NSString *)alertBody andUUIDString:(NSString *)uuid
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alertBody;
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *userInfo = @{@"uuid":uuid};
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)scheduleLocalNotification
{
    NSDate *futureDate = [NSDate dateWithTimeIntervalSinceNow:15];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = futureDate;
    localNotification.alertBody = @"Test";
    localNotification.alertAction = @"Test";
    localNotification.category = @"Cat";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)presentStoreDetailInfoView:(NSString *)uuidString
{
    if (![self.navigationController presentedViewController]) {
        IPSStore *store = [[IPSStoresManager sharedManagager] storeForProximityUUIDString:uuidString];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IPSStoreDetailViewController *storeDetailViewController = (IPSStoreDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AdViewController"];
        storeDetailViewController.store = store;
        [self.navigationController presentViewController:storeDetailViewController animated:YES completion:nil];
    }
}

- (void)presentDiscountView
{
    if (![self.navigationController presentedViewController]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *adViewController = [storyboard instantiateViewControllerWithIdentifier:@"DiscountViewController"];
        [self.navigationController presentViewController:adViewController animated:YES completion:nil];
    }
}

- (void)didReceiveLocalNotification:(NSNotification *)notification
{
    NSString *proximityUUID = [notification.userInfo objectForKey:@"uuid"];
    if (proximityUUID) {
        [self presentStoreDetailInfoView:proximityUUID];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
