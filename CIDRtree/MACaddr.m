//
//  MACaddr.m
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 6/14/11.
//  Copyright 2011 Communicatie VolZ.in All rights reserved.
//

#import "MACaddr.h"



@implementation MACaddr


/*
 * Constructor
 */
#pragma mark Constructor
-(instancetype)init{
	self = [super init];
	if(self){
		// Do stuff.
	}
	return self;
}


/*
 * ---------------
 * Getters/setters
 * ---------------
 */
#pragma mark Getters/Setters
-(void)setMacaddr:(uint64_t)macaddrarg{
	macaddr = macaddrarg;	
}

-(uint64_t)macaddr{
	return macaddr;
}




/*
 * -------------
 * Class methods
 * -------------
 */
#pragma mark Class methods
+(uint64_t) toMulticastMACintValue:(IPAddress *)ipaddr {
	return IPMCAST_MACADDR_BASE | (ipaddr.ip & IPMCAST_MACADDR_MASK);
}
 

/**
 * Returns the 48 bit mac address as a formatted string. 
 */
+(NSString *) intValueToTextWith:(uint64_t)macaddr Seperator:(int)Seperator{
	
#if 0
	uint64_t p1 = (0x0000ff0000000000&macaddr)>>40;
	uint64_t p2 = (0x000000ff00000000&macaddr)>>32;
	uint64_t p3 = (0x00000000ff000000&macaddr)>>24;
	uint64_t p4 = (0x0000000000ff0000&macaddr)>>16;
	uint64_t p5 = (0x000000000000ff00&macaddr)>>8;
	uint64_t p6 =  0x00000000000000ff&macaddr;
	
#endif
	
	uint_fast8_t p1 = (0x0000ff0000000000&macaddr)>>40;
	uint_fast8_t p2 = (0x000000ff00000000&macaddr)>>32;
	uint_fast8_t p3 = (0x00000000ff000000&macaddr)>>24;
	uint_fast8_t p4 = (0x0000000000ff0000&macaddr)>>16;
	uint_fast8_t p5 = (0x000000000000ff00&macaddr)>>8;
	uint_fast8_t p6 =  0x00000000000000ff&macaddr;
	
	
	
	switch (Seperator) {
		case HYPENS:
			return [NSString stringWithFormat:@"%x-%x-%x-%x-%x-%x",
					p1, p2, p3, p4, p5, p6];
			break;
		case DOTS:
			//return [NSString stringWithFormat:@"%q.2X%q.2X.%q.2X%q.2X.%q.2X%q.2X",
			//		p1, p2, p3, p4, p5, p6];
			return [NSString stringWithFormat:@"%x.%x.%x.%x.%x.%x",
					p1, p2, p3, p4, p5, p6];
			break;
		case COLONS: // This is the default. 
		default:
			return [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x",
					p1, p2, p3, p4, p5, p6];
			break;
	}
}


+(NSString *) intValueToText:(uint64_t)macaddr {
	return [self intValueToTextWith:macaddr Seperator:COLONS];
}


/*
 * ----------------
 * Instance methods
 * ----------------
 */
#pragma mark Instance methods
-(NSString *) Text{
	return [MACaddr intValueToText:macaddr];
}

-(void) assignMulticastMACaddr:(IPAddress *)ipaddr{
	if([IPAddress isMulticastIP:ipaddr]){
		macaddr = [MACaddr toMulticastMACintValue:ipaddr];
	}
	else {
		return;	// Do nothing; does not make sense with other IPs. 
	}
}


@end
