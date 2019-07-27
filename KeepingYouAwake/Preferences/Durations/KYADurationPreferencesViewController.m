//
//  KYADurationPreferencesViewController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 27.07.19.
//  Copyright © 2019 Marcel Dierkes. All rights reserved.
//

#import "KYADurationPreferencesViewController.h"
#import "KYADefines.h"
#import "KYADurationCell.h"

@interface KYADuration : NSObject
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) NSString *localizedString;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;
- (instancetype)init NS_UNAVAILABLE;
@end

@interface KYADurationPreferencesViewController ()
@property (nonatomic) NSMutableArray<KYADuration *> *durations;
@end

@implementation KYADurationPreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [KYADurationCell registerInTableView:self.tableView];
    
    self.durations = [NSMutableArray new];
    
}

- (BOOL)canAddDurations
{
    return NO;
}

- (IBAction)resetToDefaults:(id)sender
{
    self.durations = [@[
                        [[KYADuration alloc] initWithTimeInterval:3600],
                        [[KYADuration alloc] initWithTimeInterval:14400],
                        [[KYADuration alloc] initWithTimeInterval:28800],
                        [[KYADuration alloc] initWithTimeInterval:9630],
                        ] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (NSInteger)self.durations.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.durations[(NSUInteger)row];
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    KYA_AUTO cell = [KYADurationCell dequeueFromTableView:tableView owner:self];
    
    KYA_AUTO duration = (KYADuration *)[self tableView:tableView objectValueForTableColumn:tableColumn row:row];
    
    cell.textLabel.stringValue = duration.localizedString;
    
    return cell;
}

@end

@implementation KYADuration

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval
{
    self = [super init];
    if(self)
    {
        self.timeInterval = timeInterval;
    }
    return self;
}

- (NSDateComponentsFormatter *)dateComponentsFormatter
{
    static NSDateComponentsFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateComponentsFormatter new];
        dateFormatter.allowedUnits = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
        dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    });
    
    return dateFormatter;
}

- (NSString *)localizedString
{
    return [[self dateComponentsFormatter] stringFromTimeInterval:self.timeInterval];
}

@end
