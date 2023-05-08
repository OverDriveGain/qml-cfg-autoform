import QtQuick 2.2
import QtQuick.Dialogs 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.0

FileDialog {
	id: fileDialog
	// Used for selecting the contact
	signal success(string fileUrl)
	signal error(string errorString)
	title: "Please choose a file"
	folder: shortcuts.home
	nameFilters: ["All files (*)"]
	onAccepted: {
		success(fileDialog.fileUrls)
	}
}
