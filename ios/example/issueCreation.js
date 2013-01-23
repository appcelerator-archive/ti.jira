function createIssueCreation() {

    var win = Ti.UI.createWindow({
        backgroundColor: '#fff'
    });

    var description = Ti.UI.createTextField({
        borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
        height: 50,
        top: 10, right: 10, left: 10,
        hintText: 'Description'
    });
    win.add(description);

    var saveAndClose = Ti.UI.createButton({
        title: 'Save And Close',
        top: 70, right: 0, left: 0,
        height: 40,
        color: '#fff', backgroundColor: '#000',
        style: 0
    });
    saveAndClose.addEventListener('click', function () {
        JIRA.submitIssue({
            description: description.value,
            // You can attach files three different ways...
            attachments: [
                // 1. as a string URL to a local file:
                'cats-in-sink.jpg',
                // 2. as a file reference:
                Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'cats-in-sink.jpg'),
                // 3. and as a blob!
                Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'cats-in-sink.jpg').read()
            ]
        });
        win.close();
    });
    win.add(saveAndClose);

    return win;
}