//
//  OAuthRequest.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthRequest.h"
#import "OAuthToken.h"
#import "OAuthSignerHMAC.h"
#import "OAuthSignerProtocol.h"
#import "OAuthParameter.h"
#import "NSString+OAuthAdditions.h"
#import "NSMutableURLRequest+OAuthAdditions.h"
#import "NSURL+OAuthAdditions.h"

@interface OAuthRequest (Private)

- (NSString*)generateNonce;
- (NSString*)generateTimestamp;
- (NSString*)signatureBaseString;

@end

@implementation OAuthRequest

#pragma mark - Object Lifecycle

- (id)init
	{
	if ((self = [super init]))
		{
		
    }
    
	return self;
	}

- (id)initWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass
	{
	if ((self = [super initWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0]))
		{
		[self setConsumer:theConsumer];

		(theToken == nil) ? [self setToken:[OAuthToken token]] : [self setToken:theToken];
		(theRealm == nil) ? [self setRealm:@""] : [self setRealm:theRealm];

		if([theSignerClass conformsToProtocol:@protocol(OAuthSigner)])
			{
			[self setSignerClass:theSignerClass];
			}
		else
			{
			[self setSignerClass:[OAuthSignerHMAC class]];
			}

		[self setNonce:[self generateNonce]];
		[self setTimestamp:[self generateTimestamp]];
		
		self.oauthParameters = [NSMutableArray array];
    }

	return self;
	}



#pragma mark - Convenience Allocators

+ (OAuthRequest*)request
	{
	return [[OAuthRequest alloc] init];
	}

+ (OAuthRequest*)requestWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass
	{
	return [[OAuthRequest alloc] initWithURL:theURL consumer:theConsumer token:theToken realm:theRealm signerClass:theSignerClass];
	}


#pragma mark - Utility Methods

- (void)addParameter:(OAuthParameter*)aParameter
	{
	if(aParameter)
		{
		[_oauthParameters addObject:aParameter];
		}
	}

- (void)prepare
	{
	NSString* sigKey = [NSString stringWithFormat:@"%@&%@", _consumer.secret, _token.secret];
	NSString* sigBase = [self signatureBaseString];
	[self setSignature:[_signerClass signClearText:sigBase withSecret:sigKey]];

	NSMutableString* oauthHeaderString = [NSMutableString stringWithFormat:@"OAuth realm=\"%@\"", [_realm stringUsingOAuthURLEncoding]];
	
	for(OAuthParameter* parameter in _oauthParameters)
		{
		[oauthHeaderString appendFormat:@", %@=\"%@\"", [[parameter key] stringUsingOAuthURLEncoding], [[parameter value] stringUsingOAuthURLEncoding]];
		}

	[oauthHeaderString appendFormat:@", oauth_signature=\"%@\"", [_signature stringUsingOAuthURLEncoding]];

	[self setValue:oauthHeaderString forHTTPHeaderField:@"Authorization"];
	[self setPrepared:YES];
	}

@end

@implementation OAuthRequest (Private)

- (NSString*)generateNonce
	{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
	NSString* nonceString = (NSString*)CFBridgingRelease(uuidString);
	CFRelease(uuid);
	
	return nonceString;
	}
	
- (NSString*)generateTimestamp
	{
	return [NSString stringWithFormat:@"%ld", time(NULL)];
	}

- (NSString*)signatureBaseString
	{
	[_oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_callback" andValue:@"oob"]];
	[_oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_consumer_key" andValue:_consumer.key]];
	[_oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_signature_method" andValue:[_signerClass signatureType]]];
	[_oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_timestamp" andValue:_timestamp]];
	[_oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_nonce" andValue:_nonce]];
	[_oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_version" andValue:@"1.0"]];
	
	if(![_token.key isEqualToString:@""])
		{
		[_oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_token" andValue:_token.key]];
		}
	
	NSSortDescriptor* desc = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
	
	[_oauthParameters sortUsingDescriptors:@[desc]];
	NSMutableArray* keyValuePairStrings = [NSMutableArray arrayWithCapacity:[_oauthParameters count]];
	
	for(OAuthParameter* parameter in [self parameters])
		{
		[keyValuePairStrings addObject:[parameter concatenatedKeyValuePair]];
		}

	for(OAuthParameter* parameter in _oauthParameters)
		{
		[keyValuePairStrings addObject:[parameter concatenatedKeyValuePair]];
		}

	NSString* baseString = [keyValuePairStrings componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@&%@&%@", [self HTTPMethod], [[[self URL] URLStringWithoutQuery] stringUsingOAuthURLEncoding], [baseString stringUsingOAuthURLEncoding]];
	}

@end

