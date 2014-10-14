//
//  MACaddr.h
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 6/14/11.
//  Copyright 2011 Communicatie VolZ.in All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPAddress.h"


/*
 * ---------------
 * Constants
 * ---------------
 */
#pragma mark Constants
#define IPMCAST_MACADDR_BASE	0x01005e000000	// 01:00:5E:00:00:00  
#define IPMCAST_MACADDR_MAX		0x01005e7fffff	// 01:00:5E:7F:FF:FF 
#define IPMCAST_MACADDR_MASK	0x0000007fffff	

#define COLONS 0
#define DOTS 1
#define HYPENS 2

@interface MACaddr : NSObject {
	uint64_t	macaddr;
}


/*
 * ---------------
 * Getters/setters
 * ---------------
 */
#pragma mark Getters/Setters
@property(nonatomic, assign, readwrite)uint64_t macaddr;


/*
 * -------------
 * Class methods
 * -------------
 */
#pragma mark Class methods
+(uint64_t) toMulticastMACintValue:(IPAddress *) ipaddr; 
+(NSString *) intValueToText:(uint64_t) macaddr;
+(NSString *) intValueToTextWith:(uint64_t)macaddr Seperator:(int)Seperator;

/*
 * ----------------
 * Instance methods
 * ----------------
 */
#pragma mark Instance methods
-(void) assignMulticastMACaddr:(IPAddress *) ipaddr;
-(NSString *) Text;

@end
