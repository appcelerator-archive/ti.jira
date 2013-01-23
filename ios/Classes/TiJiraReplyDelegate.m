/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiJiraReplyDelegate.h"

@implementation TiJiraReplyDelegate

-(id)initWithParentProxy:(TiProxy *)proxy
{
    if ((self = [super init])) {
        parentProxy = proxy;
    }
    return self;
}

- (void)transportWillSend:(NSString *)entityJSON requestId:(NSString *)requestId issueKey:(NSString *)issueKey
{
    NSDictionary *responseDict = [entityJSON JSONValue];
    NSString* description = [responseDict objectForKey:@"description"];
    JMCComment *comment = [[JMCComment alloc] initWithAuthor:@"jiraconnectuser"
                                                  systemUser:YES
                                                        body:description
                                                        date:[NSDate date]
                                                   requestId:requestId];
    
    [[JMCIssueStore instance] insertComment:comment forIssue:issueKey];
    [comment release];
    
    [parentProxy fireEvent:@"replyStarted"
                withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            requestId, @"requestID",
                            nil]];
}

- (void)transportDidFinish:(NSString *)response requestId:(NSString*)requestId
{
    JMCIssueStore *store = [JMCIssueStore instance];
    
    if (![store commentExistsIssueByUUID:requestId])
    {
        NSDictionary *commentDict = [response JSONValue];
        JMCComment *comment = [JMCComment newCommentFromDict:commentDict];
        NSString *issueKey = [commentDict valueForKey:@"issueKey"];
        comment.requestId = requestId;
        [store insertComment:comment forIssue:issueKey];
        [comment release];
    }
    [parentProxy fireEvent:@"replyFinished"
                withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            requestId, @"requestID",
                            nil]];
}

- (void)transportDidFinishWithError:(NSError*)error statusCode:(int)status requestId:(NSString*)requestId
{
    [parentProxy fireEvent:@"replyErrored"
                withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [error localizedDescription], @"error",
                            status, @"status",
                            requestId, @"requestID",
                            nil]];
}

@end
