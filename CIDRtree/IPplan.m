//
//  IPplan.m
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 04-07-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IPplan.h"
#import <math.h>

static IPplan *sharedIPplan = nil;


@implementation IPplan

@synthesize childFirstBlock;
@synthesize childLastBlock;
@synthesize parentBlock;


#pragma mark Constructors
-(id)init{	
	self = [super init];
	
	if(self){
		
		// Private
		hosts = 1;
		networks = 2;
		
		// 
		parentBlock = [[IPAddress alloc] 
				  initWithData:[IPAddress toInt:@"8.0.0.0"] 
				  mask:8];
		childFirstBlock = [[IPAddress alloc] 
						   initWithData:[IPAddress toInt:@"8.0.0.0"] 
						   mask:16];
		childLastBlock  = [[IPAddress alloc] 
						   initWithData:[IPAddress toInt:@"8.128.0.0"] 
						   mask:16];
		[self CalculateAndAssign];  // Is this BAD? 
	}
	return self;
}


-(id)initWithParentBlock:(IPAddress *)ipa 
				  childs:(uint32_t)childsarg 
				   hosts:(uint32_t)hostsarg{	
	self = [super init];
	
	if(self){
		//hosts = hostsarg;
		hosts = [IPplan maxTwoComplement:hostsarg];
		networks = [IPplan maxTwoComplement:childsarg];
		parentBlock = ipa;
		//[ipa release];
		childFirstBlock = [[IPAddress alloc] init]; 
		childLastBlock  = [[IPAddress alloc] init];
		[self CalculateAndAssign]; // Is this BAD?
	}
	return self;
}


-(id)initWithParentBlock:(IPAddress *)ipa 
				childs:(uint32_t)childsarg 
				bitmask:(uint32_t)bitmask{	
	self = [super init];
	
	if(self){
		//hosts = hostsarg;
		hosts = [IPAddress InvCidr:bitmask];
		networks = [IPplan maxTwoComplement:childsarg];
		parentBlock = ipa;
		//[ipa release];
		childFirstBlock = [[IPAddress alloc] init]; 
		childLastBlock  = [[IPAddress alloc] init];
		[self CalculateAndAssign]; // Is this BAD?
	}
	return self;
}


#pragma mark Destructors


#pragma mark Getters (readonly)
-(float)NumberOfHosts{
	return hosts;
}

-(float)NumberOfNetworks{
	return networks;
}

-(uint32_t)hostsBitWidth{
	if(hosts == 0){
		return 1;
	}
	return [IPplan getBitWidth:hosts-1];
}

-(uint32_t)networksBitWidth{
	if(networks == 0){
		return 1;
	}
	return [IPplan getBitWidth:networks-1];
}


#pragma mark Setters (write)
-(void)setNumberOfHosts:(float)numhosts{
	if(numhosts == 0){
		hosts = 0;
	}
	else {
		hosts = pow(2, [IPplan getBitWidth:numhosts-1]);
	}
	[self CalculateAndAssign];		// ??
}

-(void)setNumberOfNetworks:(float)numnetworks{
	if(numnetworks == 0){
		networks = 0;
	}
	else{
		networks = pow(2, [IPplan getBitWidth:numnetworks-1]);
	}
	[self CalculateAndAssign];	// ??
}

#pragma mark Instance Methods
-(NSString *)description{
		return [NSString 
				stringWithFormat:@"parent IP:\t\t %@ \
				\nchild:\t\t %@ \
				\nlastchild:\t\t %@ \
				\nnumber of nets:\t %0.f \
				\nnumber of hosts:\t %0.f\n", 
				[parentBlock Text], [childFirstBlock Text], [childLastBlock Text],
				self.NumberOfNetworks, self.NumberOfHosts];
}

-(NSString *)Text{
	return [NSString 
			stringWithFormat:@"parent IP:\t\t %@ \
			\nchild:\t\t %@ \
			\nlastchild:\t\t %@ \
			\nnumber of nets:\t %0.f \
			\nnumber of hosts:\t %0.f\n", 
			[parentBlock Text], [childFirstBlock Text], [childLastBlock Text],
			self.NumberOfNetworks, self.NumberOfHosts];
}

-(void)CalculateAndAssign{
	//uint32_t i = 0;
	
	if((self.hostsBitWidth + self.networksBitWidth) > 32){
		return;	// Failure.
	}
	if(self.NumberOfNetworks == 0 && self.NumberOfHosts == 0){
		//parentBlock.ip = 0x0; 
		parentBlock.bitmask = 32;
		childFirstBlock.bitmask = 32;
		childLastBlock.bitmask = 32;
		childFirstBlock.ip = parentBlock.ip;
		childLastBlock.ip =  parentBlock.ip;	
		return;
	}
	
	if(self.NumberOfHosts == 0xFFFFFFFF || self.NumberOfNetworks == 0){
		parentBlock.ip = 0x0; 
		parentBlock.bitmask = 0;
		childFirstBlock.bitmask = 0;
		childLastBlock.bitmask = 0;
		childFirstBlock.ip = 0x0;
		childLastBlock.ip =  0x0;
		return; 
	}
	
	if(self.NumberOfNetworks == 0xFFFFFFFF || self.NumberOfHosts == 0){
		parentBlock.ip = 0x0; 
		parentBlock.bitmask = 0;
		childFirstBlock.bitmask = 32;
		childLastBlock.bitmask = 32;
		childFirstBlock.ip = 0x0;
		childLastBlock.ip =  0xFFFFFFFF;
		return;
	}
	
	
	// Maybe special case for /31 ??? 	
	parentBlock.bitmask = (32 - (self.hostsBitWidth + self.networksBitWidth));
	parentBlock.ip = parentBlock.Network;	// Zero out network and host bits
	childFirstBlock.bitmask = [self  childNetworkBitMask];
	childFirstBlock.ip = [self childFirstNetwork];
	childLastBlock.bitmask = [self childNetworkBitMask];	
	childLastBlock.ip = [self childLastNetwork];
	return;
}

-(uint32_t)childNetworkBitMask{
	if ([IPplan getBitWidth:hosts] == 0) {
		return 32;
	} 
	else {
		return 32 - [IPplan getBitWidth:(hosts-1)];	
	}
}

-(uint32_t)childNetworkNetMask{
	return [IPAddress Cidr:[self childNetworkBitMask]];
}

-(uint32_t)childFirstNetwork{
	return parentBlock.Network;
}


// TODO check for correctness due to off by one error
-(uint32_t)childLastNetwork{
	return [IPplan setBits:self.hostsBitWidth
					   msb:(self.networksBitWidth+self.hostsBitWidth-1) 
				  inNumber:parentBlock.Network];
}

#pragma mark Class Methods
// Singleton pattern
+ (IPplan*)sharedIPplan
{
    if (sharedIPplan == nil) {
        sharedIPplan = [[super allocWithZone:NULL] init];
    }
    return sharedIPplan;
}




+(uint32_t)maxTwoComplement:(uint32_t)number{
	if(number == 0){
		return 0;
	}
	else {
		return pow(2, [IPplan getBitWidth:number -1]);
	}
}

+(uint32_t)getBitWidth:(uint32_t)number {
	uint32_t numbits = 0; 
	
	for(numbits = 0; number > 0; numbits++) {
		number = number>>1;	// Shift one bit till it's zero 
	}
	return numbits;
}


// Set bit (MSB == left LSB == right) 
+(uint32_t)setBit:(uint32_t)position inNumber:(uint32_t)number {
	
	if(position < 32){
		return number | 0x01<<position;
	}
	else {
		return number;
	}
}
 
// clear bit (MSB == left LSB == right) 
+(uint32_t)clearBit:(uint32_t)position inNumber:(uint32_t)number {
	if(position > 32){
		return number;
	}	
	return number & ~(0x01<<position);		
}

+(uint32_t)setBits:(uint32_t)lsb msb:(uint32_t)msb inNumber:(uint32_t)number {
	uint32_t i = 0;
	uint32_t maskoverlay = 0x0;
	
	// Makes no sense just return. 
	if(lsb > 32 || msb > 32){
		return number;
	}

	for(i = lsb; i <= msb ;i ++){
		maskoverlay = maskoverlay | (0x01<<i);	
	}
	return number | maskoverlay;
}

+(uint32_t)clearBits:(uint32_t)lsb msb:(uint32_t)msb inNumber:(uint32_t)number {
	uint32_t i = 0;
	uint32_t maskoverlay = 0x0;
	
	// Makes no sense just return. 
	if(lsb > 32 || msb > 32){
		return number;
	}
	
	for(i = lsb; i <= msb ;i ++){
		maskoverlay = maskoverlay | (0x01<<i);	
	}
	return number & (~maskoverlay);
}


@end
