/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiJiraIssueDelegate.h"

@implementation TiJiraIssueDelegate

-(id)initWithParentProxy:(TiProxy *)proxy
{
    if ((self = [super init])) {
        parentProxy = proxy;
    }
    return self;
}

- (void)transportWillSend:(NSString *)entityJSON requestId:(NSString *)requestId issueKey:(NSString *)issueKey
{
    JMCIssue *issue = [JMCIssue issueWith:entityJSON requestId:requestId];
    issue.hasUpdates = NO;
    issue.dateUpdated = [NSDate date];
    issue.requestId = requestId;
    
    JMCIssueStore *issueStore = [JMCIssueStore instance];
    if ([issueStore issueExistsIssueByUUID:requestId]) {
        [issueStore updateIssueByUUID:issue];
        
    } else {
        issue.dateCreated = [NSDate date];
        [issueStore insertOrUpdateIssue:issue];
    }
    
    [parentProxy fireEvent:@"issueStarted"
                withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            requestId, @"requestID",
                            nil]];
}

- (void)transportDidFinish:(NSString *)response requestId:(NSString*)requestId
{
    JMCIssue *issue = [JMCIssue issueWith:response requestId:requestId];
    
    JMCIssueStore *issueStore = [JMCIssueStore instance];
    if ([issueStore issueExistsIssueByUUID:requestId]) {
        [issueStore updateIssueByUUID:issue];
        
    } else {
        [issueStore insertOrUpdateIssue:issue];
    }
    
    [parentProxy fireEvent:@"issueFinished"
                 withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             requestId, @"requestID",
                             nil]];
}

- (void)transportDidFinishWithError:(NSError*)error statusCode:(int)status requestId:(NSString*)requestId
{
    [parentProxy fireEvent:@"issueErrored"
                withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [error localizedDescription], @"error",
                            status, @"status",
                            requestId, @"requestID",
                            nil]];
}

@end
