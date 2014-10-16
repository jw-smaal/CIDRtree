//
//  NetmaskPickerViewController.m
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 22-06-11.
//  Copyright 2011 Communicatie VolZ.in All rights reserved.
//

#import "NetmaskPickerViewController.h"
#import "IPaddress.h"

// Set this to 0 later!
#define NETMASKPICKERVIEWCONTROLLER_DEBUG 0

// Used by UIPicker 
#define CIDR 0
#define NETMASK 1

@implementation NetmaskPickerViewController

@synthesize Picker;
@synthesize doneButton;
@synthesize cancelButton;
@synthesize numberOfBits;
@synthesize delegate;


- (IBAction)doneButtonPressed:(id)sender {
	// Set value in the delegate
	[self.delegate NetmaskPickerViewController:self 
							  didSelectNetmask:numberOfBits];

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    	// iPhone
		[self dismissModalViewControllerAnimated:YES];
    } else {
		// Ipad 
		[self.delegate flipsideViewControllerDidFinish:self];
	}
	
#if NETMASKPICKERVIEWCONTROLLER_DEBUG
	NSLog(@"Done Pressed");
#endif
}

- (IBAction)cancelButtonPressed:(id)sender {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    	// iPhone
		[self dismissModalViewControllerAnimated:YES];
    } else {
		// Ipad 
		[self.delegate flipsideViewControllerDidFinish:self];
	}
#if NETMASKPICKERVIEWCONTROLLER_DEBUG
	NSLog(@"cancel Pressed");
#endif
}



/*
 * UIPickerView - implementatie zie onder: 
 */
- (void) setPickerRow:(int) row{
	[Picker selectRow:row inComponent:NETMASK animated:NO];
	[Picker selectRow:row inComponent:CIDR animated:NO];
	[Picker setNeedsDisplay];
}


// Kolommen 
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 2;
}

// Breedte van de Kolommen
- (CGFloat) pickerView:(UIPickerView *)pickerView 
     widthForComponent:(NSInteger)component {
	switch (component) {
		case CIDR:
			return 60;			
			break;
		case NETMASK:
			return 200 ;
			break;
		default:
			return 200;
			break;
	}
}

// Rijen. 
- (NSInteger) pickerView:(UIPickerView *)pickerView 
 numberOfRowsInComponent:(NSInteger)component{
	return [NetmaskArray count];
}

// Wat er in de rijen moet komen
- (NSString *) pickerView:(UIPickerView *)pickerView 
			  titleForRow:(NSInteger)row 
			 forComponent:(NSInteger)component{
	
	IPAddress *ipa;
	
	switch (component) {
		case CIDR:
			return [NSString stringWithFormat:@"/%ld", (long)row];
			break; // never reached but who cares 			
		case NETMASK:	
			ipa = NetmaskArray[row];
			return ipa.maskText;
			break; // Never reached.
		default:
			return @"invalid row";
			break;
	}
}

// Wordt aangeroepen als de gebruiker iets kiest uit de picker. 
- (void) pickerView:(UIPickerView *)pickerView 
       didSelectRow:(NSInteger)row 
		inComponent:(NSInteger)component{
	
	IPAddress *ipa;
	
	// Vraag om een pointer uit de array.
	ipa = NetmaskArray[row];

	// De gebruiker heeft deze waarde gekozen, 
	numberOfBits = ipa.bitmask;
	ipa = nil;
	
	// Set value in the delegate
	[self.delegate NetmaskPickerViewController:self 
							  didSelectNetmask:numberOfBits];
	
	switch (component) {
		case CIDR:
			[self.Picker selectRow:row inComponent:NETMASK animated:YES];
			break;
		case NETMASK: 
			[self.Picker selectRow:row inComponent:CIDR animated:YES];
			break;
		default:
			break;
	}
	// Never get here.
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewDidLoad{
	[super viewDidLoad];
	// Custom initialization
	IPAddress *tmpIPaddr;
	
	// Do any additional setup after loading the view from its nib.
	//// self.contentSizeForViewInPopover=CGSizeMake(300.0,200.0);
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	
	// Fill the netmask array for the chooser.
	NetmaskArray = [[NSMutableArray alloc] init ];
	for(int i = 0; i <= 32; i++){
		// Array takes ownership so we can release
		tmpIPaddr = [[IPAddress alloc] initWithData:0 mask:i]; 
		[NetmaskArray addObject:tmpIPaddr];
		// We may release as Array takes ownership
		//[tmpIPaddr release];
		tmpIPaddr = nil; 
	}
	
	// Set the default from where to start
	[self.Picker selectRow:numberOfBits inComponent:NETMASK animated:NO];
	[self.Picker selectRow:numberOfBits inComponent:CIDR animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
	//
	[self.Picker selectRow:numberOfBits inComponent:NETMASK animated:NO];
	[self.Picker selectRow:numberOfBits inComponent:CIDR animated:NO];
}




- (void)viewDidUnload
{
    //[Picker release];
    Picker = nil;

    cancelButton = nil;
    doneButton = nil;
    [self setDoneButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
