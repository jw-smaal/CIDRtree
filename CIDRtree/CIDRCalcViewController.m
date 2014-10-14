//
//  CIDRCalcViewController.m
//  CIDRtree
//
//  Created by Jan-Willem Smaal on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CIDRCalcViewController.h"


@interface CIDRCalcViewController ()

@end

@implementation CIDRCalcViewController

#pragma mark Implementation
@synthesize ipAddressText;
@synthesize maskLabel;
@synthesize ipLabel;
@synthesize lowIPLabel;
@synthesize highIPLabel;
@synthesize hostsLabel;
@synthesize broadcastLabel;
@synthesize ipScrollView;
@synthesize hostMaskLabel;
@synthesize flipsidePopoverController;


/**
 * Delegate protocols
 */
#pragma mark Delegate protocols
-(void)NetmaskPickerViewController:(NetmaskPickerViewController *)controller didSelectNetmask:(int)bits {
	ipAddr.bitmask = bits;
	[self refreshView];
}


/**
 * Flipside View Controller
 */
#pragma mark - Flipside View Controller
- (void)flipsideViewControllerDidFinish:(NetmaskPickerViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"maskButtonTOmask"]) {
        // Get destination view
        NetmaskPickerViewController *vc = [segue destinationViewController]; 
		
		// configureer de view van mijn model. 
		vc.numberOfBits = ipAddr.bitmask;
		// Wij zijn de delegate 
		vc.delegate = self;
		// free
		vc = nil;
    }
	if ([[segue identifier] isEqualToString:@"maskTOpopover"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
			
			// Get destination view
			NetmaskPickerViewController *vc = [segue destinationViewController]; 
			
			// configureer de view van mijn model. 
			vc.numberOfBits = ipAddr.bitmask;
			// Wij zijn de delegate 
			vc.delegate = self;
			// free
			vc = nil;
			
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"maskTOpopover" sender:sender];
    }
}


/**
 * Actions
 */
#pragma mark Actions
- (IBAction)ipAddressTextEditingDidEnd:(id)sender {
	ipAddr.ip = [IPAddress toInt:ipAddressText.text];
	[ipAddressText resignFirstResponder]; // Hide Keyboard 
	[self refreshView];
}

- (IBAction)maskStepperAction:(id)sender {
	ipAddr.bitmask = nextMaskStepper.value;
	[self refreshView];
}

- (IBAction)subnetStepperAction:(id)sender {
	if( nextSubnetStepper.value > previousSubnetStepperValue ) {
		[ipAddr moveToNextNetwork];	
	}else {
		[ipAddr moveToPreviousNetwork];
	}
	previousSubnetStepperValue = nextSubnetStepper.value;
	[self refreshView];
}


/**
 * Update View
 */
#pragma mark Update View
// JWS: Display the state of the object. 
-(void)refreshView{
	//ipAddressText.text = ipAddr.description;
	ipAddressText.text = ipAddr.ipText;
	ipLabel.text = ipAddr.networkText;
	maskLabel.text = ipAddr.maskText;
	lowIPLabel.text = ipAddr.firstText;
	highIPLabel.text = ipAddr.lastText;
	hostsLabel.text = [NSString stringWithFormat:@"%0.f", ipAddr.numberOfHosts];
	broadcastLabel.text = ipAddr.broadcastText;
	hostMaskLabel.text = ipAddr.hostMaskText;
	
	//maskLabel.text = [NSString stringWithFormat:@"/%d (%@)", ipAddr.bitmask, ipAddr.maskText];
	maskButton.titleLabel.text = [NSString stringWithFormat:@"/%d", ipAddr.bitmask];
}


/**
 * View lifecycle
 */
#pragma mark View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	////////////////////////////////////
	ipAddr = [IPAddress sharedIPAddress];
	ipAddr.ip = [IPAddress toInt:@"192.168.1.1"];
	ipAddr.bitmask = 26;
	nextMaskStepper.value = ipAddr.bitmask;
	
	macAddr = [[MACaddr alloc] init];
	previousSubnetStepperValue = nextSubnetStepper.value;
	[self refreshView];
}

- (void)viewDidUnload
{
	// Added myself
	ipAddr = nil;
	macAddr = nil;
	
	// 
	maskButton = nil;
	nextMaskStepper = nil;
	nextSubnetStepper = nil;
	ipTableView = nil;
	maskLabel = nil;
	[self setMaskLabel:nil];
	ipLabel = nil;
	[self setIpLabel:nil];
	ipAddressText = nil;
	[self setIpAddressText:nil];
	lowIPLabel = nil;
	highIPLabel = nil;
	hostsLabel = nil;
	broadcastLabel = nil;
	[self setLowIPLabel:nil];
	[self setHighIPLabel:nil];
	[self setHostsLabel:nil];
	[self setBroadcastLabel:nil];
	ipScrollView = nil;
	[self setIpScrollView:nil];
	hostMaskLabel = nil;
	[self setHostMaskLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	// ONly rotate on IPAD? 
	//return YES;
}

@end
