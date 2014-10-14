//
//  TreeViewController.h
//  CIDRtree
//
//  Created by Jan-Willem Smaal on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h> // For power off 2 calc
#import "IPaddress.h"
#import "IPplan.h"


@interface TreeViewController : UIViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
	@protected
	IPAddress *ipAddress;
	IPplan *ipPlan;
	float	networks;
	
	__weak IBOutlet UITableView *childsTable;
	__weak IBOutlet UISwitch *growParentMaskSwitch;
	__weak IBOutlet UIStepper *numberOfChildsStepper;
	__weak IBOutlet UILabel *childsLabel;
	@private
	@public
}

#pragma mark Model Properties
@property (nonatomic, readwrite) IPAddress *ipAddress;
@property (nonatomic, readwrite) IPplan*ipPlan;

#pragma mark User Interface
@property (weak, nonatomic) IBOutlet UITableView *childsTable;
@property (weak, nonatomic) IBOutlet UISwitch *growParentMaskSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *numberOfChildsStepper;
@property (weak, nonatomic) IBOutlet UILabel *childsLabel;

@end
