//
//  OAuthRequestResponse.m
//  OAuthKit
//
//  Created by Felix Morgner on 12.03.12.
//  Copyright (c) 2012 Felix Morgner. All rights reserved.
//

#import "OAuthRequestResponse.h"

@interface OAuthRequestResponse(Private)

- (BOOL)parse;

@end

@implementation OAuthRequestResponse

- (id)initWithData:(NSData*)theData requestURL:(NSURL*)theRequestURL
	{
	if((self = [super init]))
		{
		_responseData = (theData) ? theData : nil;
		_requestURL = (theRequestURL) ? theRequestURL : nil;

		if(_responseData)
			{
			[self parse];
			}
		}
	
	
	return self;
	}
	
- (OAuthRequestResponse*)responseWithData:(NSData*)theData requestURL:(NSURL*)theRequestURL
	{
	return [[OAuthRequestResponse alloc] initWithData:theData requestURL:theRequestURL];
	}

@end

@implementation OAuthRequestResponse(Private)

- (BOOL)parse
	{
	NSString* responseDataString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
	
	if([responseDataString rangeOfString:@"<?xml"].location != NSNotFound && [responseDataString rangeOfString:@"?>"].location != NSNotFound)
		{
		_responseType = @"XML";
		}
	else if([responseDataString rangeOfString:@"{"].location == 0)
		{
		_responseType = @"JSON";
		}

	if([_responseType isEqualToString:@"XML"])
		{
		NSError* error;
		NSXMLDocument* xmlResponse = [[NSXMLDocument alloc] initWithData:_responseData options:NSXMLDocumentTidyXML error:&error];
		}
	
	return YES;
	}

@end
