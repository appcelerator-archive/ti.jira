function createIssueDetails(issue) {

    // Mark the issue as read -- we've seen it, after all!
    issue.markAsRead();

    var win = Ti.UI.createWindow({
        backgroundColor: '#fff'
    });

    var table = Ti.UI.createTableView();
    table.addEventListener('click', function (evt) {
        if (evt.source.isCloseButton) {
            win.close();
        }
    });
    win.add(table);

    // Add a close button to the rows so the user can return to the issue list.
    var closeRow = Ti.UI.createTableViewRow();
    closeRow.add(Ti.UI.createButton({
        isCloseButton: true,
        title: 'Back to Issues',
        right: 0, bottom: 10, left: 0,
        height: 40,
        color: '#fff', backgroundColor: '#000',
        style: 0
    }));

    // Add the original issue description.
    var descriptionRow = Ti.UI.createTableViewRow();
    descriptionRow.add(Ti.UI.createLabel({
        text: issue.description,
        height: Ti.UI.SIZE || 'auto'
    }));

    // Add a row to let users type in a new comment.
    var addNewCommentRow = Ti.UI.createTableViewRow();
    var addNewComment = Ti.UI.createTextField({
        height: 50,
        right: 0, bottom: 10, left: 0,
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
        hintText: 'Add New Comment',
        returnKeyType: Ti.UI.RETURNKEY_SEND
    });
    addNewComment.addEventListener('return', function () {
        // Create the issue...
        JIRA.commentOnIssue({
            description: addNewComment.value,
            key: issue.key
        });
        // The "replyStarted" event will fire when it is saved locally in the database.
        // We'll refresh the comments when that happens.
        addNewComment.value = '';
    });
    addNewCommentRow.add(addNewComment);

    // Then create a function that pushes all the existing comments in to the table.
    function refresh() {
        Ti.API.info('Reloading issueDetails!');
        // Start off with the base contents.
        var rows = [
            closeRow,
            descriptionRow,
            addNewCommentRow
        ];

        // And add a row for each comment...
        var comments = issue.comments;
        for (var c in comments) {
            var commentRow = Ti.UI.createTableViewRow();
            commentRow.add(Ti.UI.createLabel({
                text: 'From: ' + comments[c].author + '\n'
                    + 'Date: ' + comments[c].date + '\n'
                    + comments[c].body,
                height: Ti.UI.SIZE || 'auto', bottom: 10
            }));
            rows.push(commentRow);
        }

        table.setData(rows);
    }

    refresh();

    // Whenever a comment is sent to the server, let's refresh the table.
    JIRA.addEventListener('replyStarted', refresh);
    JIRA.addEventListener('replyFinished', refresh);
    JIRA.addEventListener('replyErrored', handleError);

    // When the window closes, stop listening for changes.
    win.addEventListener('close', function () {
        JIRA.removeEventListener('replyStarted', refresh);
        JIRA.removeEventListener('replyFinished', refresh);
        JIRA.removeEventListener('replyErrored', handleError);
    });

    return win;
}