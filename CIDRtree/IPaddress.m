//
//  IPaddress.m
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 10/6/11.
//  Copyright 2012 Communicatie VolZ.in All rights reserved.
//

#import "IPAddress.h"
#import <math.h>

static IPAddress *sharedIPAddress = nil;

@implementation IPAddress

@synthesize ip;
@synthesize mask;


#pragma mark Instance Methods
/*
 * ----------------
 * Instance methods 
 * ----------------
 */
-(instancetype)init {
	self = [super init];
	
	if(self){
		// 
	}
	return self;
}

-(instancetype)initWithData:(uint32_t) ipa
				mask:(uint32_t) bitmaska{
	self.ip = ipa;
	self.bitmask = bitmaska;
	// self.mask = [IPAddress Cidr:bitmaska];  // Not required setter does this.
	return self;
}

// NSCOPYING procotol implemented 
-(id)copyWithZone:(NSZone *)zone{
	IPAddress *ipa = [IPAddress alloc];
	ipa.bitmask = self.bitmask;
	ipa.ip = self.ip;
	ipa.mask = self.mask;
	return ipa;
}

-(void) moveToNextNetwork {
	// Implement
	ip = ip + (self.HostMask + 1);
}

-(void) moveToPreviousNetwork {
	// Implement
	ip = ip - (self.HostMask + 1 );
}

-(uint32_t) networkIndex:(uint32_t)index{
	uint32_t bitshiftindex = index <<(32-self.bitmask);
	return (self.Network + bitshiftindex);
}

// returns a new ip object at index offset 
-(IPAddress *) makenetworkIndex:(uint32_t)index{
	IPAddress *ipa = self.copy; // May not be implemented.
	uint32_t bitshiftindex = index <<(32-ipa.bitmask);
	
	ipa.ip = ipa.Network + bitshiftindex;
	return ipa;
}


#pragma mark Setters
/* 
 * -------
 * Setters
 * -------
 */
-(void)setBitmask:(uint32_t)bitmaska{
	if(bitmaska <=32){
		bitmask = bitmaska;
		mask = [IPAddress Cidr:bitmaska];
	}
}


#pragma mark Getters
/*
 * ------- 
 * Getters
 * -------
 */
-(uint32_t) Network{
	return [IPAddress ipNetwork:self.ip mask: self.mask];
}

-(uint32_t) FirstIp {
	if (self.bitmask == 32) {
		return self.ip;
	}
	if (self.bitmask == 31) {
		return self.Network;
	}
	//	if([IPAddress isMulticastIP:self]){
	//	return self.Network;
	//}
	//else{
		return self.Network + 1;
	//}
}

-(uint32_t) LastIp{
	if (self.bitmask == 32) {
		return self.ip;
	}
	if (self.bitmask == 31){
		return self.Network + 1;	
	}
	
	//	if([IPAddress isMulticastIP:self]){
	//	return self.Broadcast;
	//	}
	//else{
		return self.Broadcast - 1;
	//}
}

-(uint32_t) Host{
	return [IPAddress ipHost:self.ip mask: self.mask];
}

-(uint32_t) HostMask{
	return 0xffffffff^self.mask;
}

-(uint32_t) bitmask{
	return bitmask;
}

-(uint32_t) HostBits {
	return 32 - bitmask;
}


-(uint32_t) Broadcast{
	return self.Network|self.HostMask;
}

// Some special cases (-1 because network and broadcast 
// be used
-(float) numberOfHosts {
	if (bitmask == 32){
		return 1;
	}
	if (bitmask == 31){	// Special case
		return 2;
	}
	//if([IPAddress isMulticastIP:self]){
	//	return self.HostMask;
	//}
	//else{
		return self.HostMask -1;
	//}
}

/*
 * Getters for calculation purposes 
 */
-(uint32_t) nextNetwork {
	return self.Network + (self.HostMask + 1);
}

-(uint32_t) previousNetwork {
	return self.Network - (self.HostMask + 1);
}

#pragma mark Getters that return Text
/**
 * get a NSString of the IP address 
 */
-(NSString *)description {
	return [NSString stringWithFormat:@"%@/%d", 
			[self ipText], self.bitmask];
}

-(NSString *)Text {
	return [NSString stringWithFormat:@"%@/%d\t(%@)", [self ipText], self.bitmask, [self maskText]];
}
-(NSString *) ipText{
	return [IPAddress toDottedDecimal:self.ip];
}

-(NSString *) maskText{
	return [IPAddress toDottedDecimal:self.mask];
}

-(NSString *) networkText{
	return [IPAddress toDottedDecimal:self.Network];
}

-(NSString *) hostText{
	return [IPAddress toDottedDecimal:self.Host];
}

-(NSString *) hostMaskText{
	return [IPAddress toDottedDecimal:self.HostMask];
}

-(NSString *) firstText{
	return [IPAddress toDottedDecimal:self.FirstIp];
}

-(NSString *) lastText{
	return [IPAddress toDottedDecimal:self.LastIp];
}

-(NSString *) broadcastText{
	return [IPAddress toDottedDecimal:self.Broadcast];
}



#pragma mark Class methods - SINGLETON
/*
 * --------------
 * Class methods 
 * --------------
 */

// Singleton pattern 
+(IPAddress *)sharedIPAddress
{
    if (sharedIPAddress== nil) {
        sharedIPAddress = [[super allocWithZone:NULL] init];
    }
    return sharedIPAddress;
}


#pragma mark Class methods - CLASS FACTORY
/**
 * return a IPaddr object (caller owns and must release!)
 */
+(IPAddress *) make:(uint32_t)ipa :(uint32_t)maska {
	IPAddress *ipaddr = [[IPAddress alloc] initWithData:ipa mask:maska];
	return ipaddr;
}

+(IPAddress *) makeCidr:(uint32_t)bits {
	IPAddress *ipaddr = [[IPAddress alloc] 
					  initWithData:0 // IP address is zero
					  mask:[IPAddress Cidr:bits] ];
	return ipaddr;
}


#pragma mark Class methods - UTILLITY
/**
 * make a cidr mask 
 * @param b: number of bits in netmask
 */
+(uint32_t) Cidr:(uint32_t)b{
	if (b == 0  || b > 32){
		return 0;
	}
	else { 
		return 0xffffffff<<(32-b);
	}
}

/**
 * make a inverted cidr mask 
 * @param b: number of bits in netmask
 */
+(uint32_t) InvCidr:(uint32_t)b{
	return 0xffffffff^[IPAddress Cidr:b];
}

/**
 * given a ip address and mask return the network part of the address
 * @param ip ip address
 * @param mask mask
 * @return the network part of the the address
 */
+(uint32_t) ipNetwork:(uint32_t) ip 
				 mask:(uint32_t) mask{
	return ip&mask;
}

/**
 * given a ip address and mask return the host part of the address
 * @param ip ip address
 * @param mask mask
 * @return the network part of the the address
 */
+(uint32_t) ipHost:(uint32_t) ip 
				   mask:(uint32_t) mask{
	//	return ip&(0xffffffff^mask);
	return ip&(~mask);	// Should be the same as above	
}

/** 
 * checks if the ip address fits inside the network argument 
 */
+(BOOL) isSubnet:(IPAddress *)ipa InNetwork:(IPAddress *)network{
	if(ipa.FirstIp >= network.FirstIp && ipa.LastIp <= network.LastIp){
		return YES;
	}
	else {
		return NO;
	}
}


/**
 * convert integer to IP address in dotted decimal notation e.g. 1.2.3.4 
 * @param ip ip address
 */
+(NSString *) toDottedDecimal:(uint32_t) ip{
	uint8_t p1 = (0xff000000&ip)>>24;
	uint8_t p2 = (0x00ff0000&ip)>>16;
	uint8_t p3 = (0x0000ff00&ip)>>8;
	uint8_t p4 = 0x000000ff&ip;
	
	return [NSString stringWithFormat:@"%d.%d.%d.%d", 
			p1, p2, p3, p4];
}

/**
 * Convert a dotted decimal notation to a integer
 */
+(uint32_t) toInt:(id)dottedstring{
	uint32_t ret = 0;
	NSArray *tmparr;
	NSString *stra;
	NSString *strb;
	NSString *strc;
	NSString *strd;
	
	// Split up by "."
	tmparr = [dottedstring componentsSeparatedByString:@"."];

	// If we don't get 4 numbers return 0
	if([tmparr count] < 4){
		return 0;	
	}
	
	stra = tmparr[0];
	strb = tmparr[1];
	strc = tmparr[2];
	strd = tmparr[3];
	
	ret = 0xff000000&([stra intValue]<<24);
	ret = ret | (0x00ff0000&([strb intValue]<<16));
	ret = ret | (0x0000ff00&([strc intValue]<<8));
	ret = ret | (0x000000ff&[strd intValue]);	
	
	return ret; 
}

// Check if the ip is within the 224/4 range 
+(BOOL)isMulticastIP:(IPAddress *) ipa {
	IPAddress *mcastaddr;
	
	mcastaddr = [[IPAddress alloc] 
				 initWithData:[IPAddress toInt:@"224.0.0.0"]
				 mask:4];
	if([IPAddress isSubnet:ipa InNetwork:mcastaddr]){
		return YES;
	}
	else {			
		return NO;	
	}
}

// List number of child networks of size in parent.
+(float)numberOfNetworks:(IPAddress *) ipaddr 
				InParent:(IPAddress *) parentaddr{
	
	if(parentaddr.bitmask > ipaddr.bitmask){
		return 0;	// Parent is smaller than child? 
	}
	return powf(2,(ipaddr.bitmask - parentaddr.bitmask));
}




@end
