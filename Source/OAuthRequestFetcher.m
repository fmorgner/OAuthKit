//
//  OAuthRequestFetcher.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 21.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthRequestFetcher.h"
#import "OAuthRequest.h"

@implementation OAuthRequestFetcher

@synthesize request;
@synthesize connection;
@synthesize completionHandler;
@synthesize receivedData;

- (id)init
	{
	if ((self = [super init]))
		{
		receivedData = [[NSMutableData alloc] init];
    }
    
	return self;
	}

- (void)fetchRequest:(NSURLRequest*)aRequest completionHandler:(void (^)(id fetchResult))block
	{
	[receivedData setLength:0];

	if(!block)
		{
		NSException* exception = [NSException exceptionWithName:@"OAuthRequestFetcherCompletionHandlerNULLException" reason:@"The completion handler must not be NULL" userInfo:nil];
		[exception raise];
		return;
		}
	if(!aRequest)
		{
		NSException* exception = [NSException exceptionWithName:@"OAuthRequestFetcherRequestNilException" reason:@"The request must not be nil" userInfo:nil];
		[exception raise];
		return;
		}
	
	if(![(OAuthRequest*)aRequest isPrepared])
		{
		[(OAuthRequest*)aRequest prepare];
		}
	
	[self setCompletionHandler:block];
	[self setRequest:aRequest];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}


#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[receivedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	dispatch_retain(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		completionHandler(receivedData);
		dispatch_release(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
	});
	}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
	{
	dispatch_retain(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		completionHandler(error);
		dispatch_release(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
	});
	}
@end
