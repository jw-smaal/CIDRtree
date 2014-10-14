//
//  IPaddress.h
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 10/6/11.
//  Copyright 2011 Communicatie VolZ.in All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPAddress : NSObject <NSCopying> {
	uint32_t ip;		// Ip address 
	uint32_t mask;		// Binary Mask 
	uint32_t bitmask;	// Number of bits in mask 0 --> 32 
}

// Get and setters with synthesize for instance variables
#pragma mark Instance Variables
@property(nonatomic, assign, readwrite)uint32_t ip;
@property(nonatomic, assign, readwrite)uint32_t mask;
@property(nonatomic, readwrite)uint32_t bitmask;


/*
 * ------- 
 * Getters
 * -------
 */
#pragma mark Getters for numbers
// Numeric Getters
@property(readonly)uint32_t Network;	
@property(readonly)uint32_t Host;
@property(readonly)uint32_t HostMask;
@property(readonly)uint32_t HostBits;
@property(readonly)uint32_t FirstIp;
@property(readonly)uint32_t LastIp;
@property(readonly)uint32_t Broadcast;
@property(readonly)float numberOfHosts;
@property(readonly)uint32_t nextNetwork;
@property(readonly)uint32_t previousNetwork;

#pragma mark Getters that return Text
// NSString related getters
@property(readonly)NSString *ipText;
@property(readonly)NSString *maskText;
@property(readonly)NSString *networkText;
@property(readonly)NSString *hostText;
@property(readonly)NSString *hostMaskText;
@property(readonly)NSString *firstText;
@property(readonly)NSString *lastText;
@property(readonly)NSString *broadcastText;
@property(readonly)NSString *Text;



#pragma mark Instance methods
/*
 * ----------------
 * Instance methods 
 * ----------------
 */
-(id)initWithData:(uint32_t) ipa mask:(uint32_t) bitmask;
-(void) moveToNextNetwork;
-(void) moveToPreviousNetwork;
-(uint32_t) networkIndex:(uint32_t) index;
// Class methods that return an object 
-(IPAddress *) makenetworkIndex:(uint32_t)index;


#pragma mark Class methods
/*
 * --------------
 * Class methods 
 * --------------
 */
// Class methods IP related
+(uint32_t) ipNetwork:(uint32_t) ip mask:(uint32_t) mask;
+(uint32_t) ipHost:(uint32_t) ip mask:(uint32_t) mask;
+(NSString *) toDottedDecimal:(uint32_t) ip;
+(uint32_t) Cidr:(uint32_t) b;
+(uint32_t) InvCidr:(uint32_t) b;
+(uint32_t) toInt:(NSString *) dottedstring;
+(BOOL) isSubnet:(IPAddress *)ip InNetwork:(IPAddress *)network;
+(BOOL) isMulticastIP:(IPAddress *) ipa;
+(float) numberOfNetworks:(IPAddress *) ipaddr 
				InParent:(IPAddress *) parentaddr;


#pragma mark Class methods Factory
// Class methods that return an object 
+(IPAddress *)sharedIPAddress;
+(IPAddress *) make:(uint32_t)ipa :(uint32_t)maska;
+(IPAddress *) makeCidr:(uint32_t)bits; 


@end
