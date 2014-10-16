//
//  CIDRCalcViewController.h
//  CIDRtree
//
//  Created by Jan-Willem Smaal on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPAddress.h"
#import "MACaddr.h"
#import "NetmaskPickerViewController.h"

@class CIDRCalcViewController;

@interface CIDRCalcViewController : UIViewController 
	<NetmaskPickerViewControllerDelegate, UIPopoverControllerDelegate> {
@protected
		
		// Models
		IPAddress *ipAddr;
		MACaddr *macAddr; 
		float previousSubnetStepperValue;
		// UI elements		
		__weak IBOutlet UITextField *ipAddressText;
		__weak IBOutlet UIButton *maskButton;
		__weak IBOutlet UIStepper *nextMaskStepper;
		
		__weak IBOutlet UIStepper *nextSubnetStepper;
		
		__weak IBOutlet UITableView *ipTableView;
		__weak IBOutlet UILabel *maskLabel;
		__weak IBOutlet UILabel *cidrmaskLabel;
		__weak IBOutlet UILabel *ipLabel;
		__weak IBOutlet UILabel *lowIPLabel;
		__weak IBOutlet UILabel *highIPLabel;
		__weak IBOutlet UILabel *hostsLabel;
		__weak IBOutlet UILabel *broadcastLabel;
		__weak IBOutlet UILabel *hostMaskLabel;
		__weak IBOutlet UIScrollView *ipScrollView;
		__weak NetmaskPickerViewController *netmaskPickerViewController;
		//__weak UIPopoverController *popOverController;
}

@property (weak, nonatomic) IBOutlet UITextField *ipAddressText;
@property (weak, nonatomic) IBOutlet UILabel *maskLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowIPLabel;
@property (weak, nonatomic) IBOutlet UILabel *highIPLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *broadcastLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *ipScrollView;
@property (weak, nonatomic) IBOutlet UILabel *hostMaskLabel;


// Popover met segueways 
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;


@end
