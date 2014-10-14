//
//  TreeViewController.m
//  CIDRtree
//
//  Created by Jan-Willem Smaal on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeViewController.h"

@interface TreeViewController ()
@end

@implementation TreeViewController

@synthesize ipAddress;
@synthesize ipPlan;
@synthesize childsTable;
@synthesize growParentMaskSwitch;
@synthesize numberOfChildsStepper;
@synthesize childsLabel;

#pragma mark UITableSource protocol 
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return ipPlan.parentBlock.Text;
}


-(NSInteger)tableView:(UITableView *)tableView 
	numberOfRowsInSection:(NSInteger)section
{
	// Anders wordt het lijstje te groot.... 
	// Iets op verzinnen zoals een "load more"  optie oid. 
	if (ipPlan.NumberOfNetworks > 65535){	
		return 65535; 
	}
	return ipPlan.NumberOfNetworks;
	//return numberOfChildsStepper.value;
}


// Cell inhoud. 
-(UITableViewCell *)tableView:childsTable 
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier1 = @"Cell1";
	//static NSString *CellIdentifier2 = @"Cell2";
	UITableViewCell *cell;
	IPAddress *ipa;
	
	cell = [self.childsTable dequeueReusableCellWithIdentifier:CellIdentifier1];
	if (cell == nil){
		cell = [[UITableViewCell alloc] 
				initWithStyle:UITableViewCellStyleDefault
				reuseIdentifier:CellIdentifier1 ];
		
	}
	ipa = [ipPlan.childFirstBlock makenetworkIndex:(uint32_t)indexPath.row];
	cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@/%d", ipa.networkText, ipa.bitmask];
	ipa = nil;	

	return cell;
}


#pragma mark UITableView Delegate protocol
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		
}




#pragma mark Actions

- (IBAction)numberOfChildsValueChanged:(id)sender {
	// ipPlan.NumberOfNetworks = pow (2, numberOfChildsStepper.value);
	networks = pow (2, numberOfChildsStepper.value);
	ipPlan.NumberOfNetworks = networks;
	childsLabel.text = [[NSString alloc] initWithFormat:@"%0.f",networks];
	[childsTable reloadData];
}



#pragma mark View Lifecyle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	//[self.view setBackgroundColor:[UIColor yellowColor] ];
	
	// Get reference to the singleton.
	ipAddress = [IPAddress sharedIPAddress];

}

- (void)viewWillAppear:(BOOL)animated
{

	// Eerst maar de normale masks. 
	if(ipAddress.bitmask < 32){
		// TODO doe eerst een check of the number of childs wel in de parent passen! 
		networks = pow (2, numberOfChildsStepper.value);
		ipPlan.NumberOfNetworks = networks;
		
		ipPlan = [[IPplan alloc] initWithParentBlock:ipAddress childs:networks bitmask:ipAddress.bitmask + 1];
	}
	else {	// Special case for splitting /31 masks to /32's 
		ipPlan = [[IPplan alloc] initWithParentBlock:ipAddress childs:1 bitmask:32];
	}
	childsLabel.text = [[NSString alloc] initWithFormat:@"%0.f",networks];
	
	// Lijkt nodig anders laten cellen oude data zien. 
	[childsTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
}


- (void)viewDidUnload
{
	childsTable = nil;
	[self setChildsTable:nil];
    growParentMaskSwitch = nil;
    numberOfChildsStepper = nil;
    [self setGrowParentMaskSwitch:nil];
    [self setNumberOfChildsStepper:nil];
	childsLabel = nil;
	[self setChildsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
 
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
}

@end
