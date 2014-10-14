//
//  NetmaskPickerViewController.h
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 22-06-11.
//  Copyright 2011 Communicatie VolZ.in All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetmaskPickerViewController;


@protocol NetmaskPickerViewControllerDelegate <NSObject>
	-(void)NetmaskPickerViewController:(NetmaskPickerViewController *)controller didSelectNetmask:(int) bits;
	- (void)flipsideViewControllerDidFinish:(NetmaskPickerViewController *)controller;
@end


@interface NetmaskPickerViewController : UIViewController 
		<UIPickerViewDataSource, UIPickerViewDelegate> 
{
@protected

	int numberOfBits;
			__weak IBOutlet UIPickerView *Picker;
			__weak IBOutlet UIBarButtonItem *cancelButton;
			__weak IBOutlet UIBarButtonItem *doneButton;
@private	
	// Array of netmasks
	NSMutableArray *NetmaskArray;
}


// UI Elements
@property (weak, nonatomic) UIPickerView *Picker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

// Delegate 
@property (weak,nonatomic) id <NetmaskPickerViewControllerDelegate> delegate;

// Value returned by picker 
@property(nonatomic, readwrite) int numberOfBits;

// 
- (void) setPickerRow:(int) row;

@end
