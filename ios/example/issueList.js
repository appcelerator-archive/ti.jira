function createIssueList() {

    var win = Ti.UI.createWindow({
        backgroundColor: '#fff'
    });

    var closeWindow = Ti.UI.createButton({
        title: 'Close Issue List',
        right: 0, top: 0, left: 0,
        height: 40,
        color: '#fff', backgroundColor: '#000',
        style: 0
    });
    closeWindow.addEventListener('click', function () {
        win.close();
    });
    win.add(closeWindow);

    var issueTable = Ti.UI.createTableView({
        top: 40, right: 0, bottom: 40, left: 0,
        rowHeight: 60
    });
    win.add(issueTable);

    issueTable.addEventListener('click', function (evt) {
        if (evt.row.raw) {
            createIssueDetails(evt.row.raw).open();
        }
        if (evt.row.updatesCircle) {
            evt.row.remove(evt.row.updatesCircle);
            evt.row.updatesCircle = null;
        }
    });

    function refresh() {
        Ti.API.info('Refreshing issueList!');
        var rows = JIRA.retrieveIssues();
        var data = [];
        for (var i = 0; i < rows.length; i++) {
            var row = Ti.UI.createTableViewRow({
                hasChild: true, raw: rows[i]
            });
            row.add(Ti.UI.createLabel({
                text: rows[i].summary, textAlign: 'left',
                font: { fontSize: 16, fontWeight: 'bold' },
                color: '#000',
                top: 0, left: 30, height: 20
            }));
            row.add(Ti.UI.createLabel({
                text: rows[i].description, textAlign: 'left',
                font: { fontSize: 12 },
                color: '#aaa',
                top: 20, left: 30, height: 40
            }));
            if (rows[i].hasUpdates) {
                row.add(row.updatesCircle = Ti.UI.createView({
                    left: 10, top: 25,
                    borderColor: '#004', borderWidth: 2, borderRadius: 12,
                    backgroundColor: '#004',
                    height: 10, width: 10
                }));
            }
            data.push(row);
        }
        if (rows.length == 0) {
            data.push({
                title: 'Nothing reported yet!'
            });
        }
        issueTable.setData(data);
    }

    var createIssue = Ti.UI.createButton({
        title: 'Submit New Issue',
        right: 0, bottom: 0, left: 0,
        height: 40,
        color: '#fff', backgroundColor: '#000',
        style: 0
    });
    createIssue.addEventListener('click', function () {
        createIssueCreation().open();
    });
    win.add(createIssue);

    refresh();
    win.refresh = refresh;

    JIRA.addEventListener('issueStarted', refresh);
    JIRA.addEventListener('issueFinished', refresh);
    JIRA.addEventListener('issueErrored', handleError);

    win.addEventListener('close', function () {
        JIRA.removeEventListener('issueStarted', refresh);
        JIRA.removeEventListener('issueFinished', refresh);
        JIRA.removeEventListener('issueErrored', handleError);
    });

    return win;
}