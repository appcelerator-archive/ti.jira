//
//  Created by nick on 20/09/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>
#import "JMCQueueItem.h"
#import "JMCMacros.h"
#import "JMCIssueTransport.h"
#import "JMCReplyTransport.h"
#import "JMCCreateIssueDelegate.h"
#import "JMCReplyDelegate.h"
#import "JMCReachability.h"
#import "JMC.h"

enum {
    JMCSentStatusNew = 0, // request is newly queued
    JMCSentStatusInProgress = 1, // request is being sent at the moment
    JMCSentStatusSuccess = 2,   // request success
    JMCSentStatusRetry = 4,     // request in a temporary error - will be retried
    JMCSentStatusPermError = 8  // request in a permanent error - will not be retried
};
typedef int JMCSentStatus;

/**
* The request queue is used for storing and later forwarding of any feedback
* that can not be sent due to lack of network.
* When an item is added to the queue, it is stored to disk.
* When it is deleted from the queue (after a successful send attempt) it is deleted from disk.
*/
@interface JMCRequestQueue : NSObject {

}

+(JMCRequestQueue*) sharedInstance;

-(void) flushQueue;

-(void) addItem:(JMCQueueItem *)item;
-(void)updateItem:(NSString *)uuid sentStatus:(JMCSentStatus)sentStatus bumpNumAttemptsBy:(int)inc;
-(JMCSentStatus) requestStatusFor:(NSString *)uuid;
-(JMCQueueItem *) getItem:(NSString *)uuid;
-(void) deleteItem:(NSString*)uuid;

// ADDED BY DAWSON -- Expose the transports as properties os we can control them from the outside world
@property(nonatomic, retain) JMCIssueTransport* issueTransport;
@property(nonatomic, retain) JMCReplyTransport* replyTransport;

@end