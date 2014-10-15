//
//  IPplan.h
//  IPcalculator
//
//  Created by Jan-Willem Smaal on 04-07-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPaddress.h"


@interface IPplan : NSObject {
	__strong IPAddress *parentBlock;
	__strong IPAddress *childFirstBlock;
	__strong IPAddress *childLastBlock;
@private
	float hosts;
	float networks;
}

#pragma mark Getters and Setters
@property(strong, nonatomic, readwrite)IPAddress *parentBlock;
@property(nonatomic, readwrite)float NumberOfHosts;
@property(nonatomic, readwrite)float NumberOfNetworks;

#pragma mark Getters
@property(readonly)IPAddress *childFirstBlock;
@property(readonly)IPAddress *childLastBlock;
@property(readonly)uint32_t hostsBitWidth;
@property(readonly)uint32_t networksBitWidth;
@property(readonly)uint32_t childFirstNetwork;
@property(readonly)uint32_t childLastNetwork;

#pragma mark Class Methods
+(IPplan*)sharedIPplan;   // Singleton
+(uint32_t)maxTwoComplement:(uint32_t)number;
+(uint32_t)getBitWidth:(uint32_t)number;
+(uint32_t)setBit:(uint32_t)position inNumber:(uint32_t)number;
+(uint32_t)clearBit:(uint32_t)position inNumber:(uint32_t)number;
+(uint32_t)setBits:(uint32_t)lsb msb:(uint32_t)msb inNumber:(uint32_t)number; 
+(uint32_t)clearBits:(uint32_t)lsb msb:(uint32_t)msb inNumber:(uint32_t)number;

#pragma mark Instance Methods
-(instancetype)initWithParentBlock:(IPAddress *)ipa 
				  childs:(uint32_t)childsarg 
				   hosts:(uint32_t)hostsarg ;

-(instancetype)initWithParentBlock:(IPAddress *)ipa 
				  childs:(uint32_t)childsarg 
				 bitmask:(uint32_t)bitmask ;

-(void)CalculateAndAssign;
@property (NS_NONATOMIC_IOSONLY, readonly) uint32_t childNetworkBitMask;
@property (NS_NONATOMIC_IOSONLY, readonly) uint32_t childNetworkNetMask;
// -(NSString *)description; // Already in NSOBJECT 
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *Text;


@end
