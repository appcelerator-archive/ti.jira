/**
 * Ti.Jira Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiJiraIssueProxy.h"
#import "TiUtils.h"

@implementation TiJiraIssueProxy

@synthesize requestId = _requestId, key = _key, status = _status, summary = _summary, description = _description, comments, hasUpdates = _hasUpdates, dateUpdated = _dateUpdated, dateCreated = _dateCreated;

+(TiJiraIssueProxy*)issueWithIssue:(JMCIssue*)issue
{
    return [[[TiJiraIssueProxy alloc] initWithIssue:issue] autorelease];
}

-(id)initWithIssue:(JMCIssue*)issue
{
    if ((self = [super init])) {
        _issue = [issue retain];
        _requestId = [issue.requestId retain];
        _key = [issue.key retain];
        _status = [issue.status retain];
        _summary = [issue.summary retain];
        _description = [issue.description retain];
        _dateCreated = [issue.dateCreated retain];
        _dateUpdated = [issue.dateUpdated retain];
        _hasUpdates = [NUMBOOL(issue.hasUpdates) retain];
    }
    return self;
}

-(void)markAsRead:(id)args
{
    [[JMCIssueStore instance] markAsRead:_issue];
}

-(id)comments {
    NSMutableArray* rawComments = [[JMCIssueStore instance] loadCommentsFor:_issue];
    NSMutableArray* retVal = [NSMutableArray arrayWithCapacity: [rawComments count]];
    for (JMCComment* comment in rawComments) {
        [retVal addObject:[TiJiraCommentProxy commentWithComment:comment]];
    }
    return retVal;
}

- (void) dealloc {
    [_requestId release];
    [_key release];
    [_status release];
    [_summary release];
    [_description release];
    [_dateCreated release];
    [_dateUpdated release];
    [_hasUpdates release];
    [_issue release];
    [super dealloc];
}

@end
