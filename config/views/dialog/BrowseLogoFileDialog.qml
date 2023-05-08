import QtQuick 2.2
import QtQuick.Dialogs 1.0

FileDialog {
	id: fileDialog
	// Used for selecting the contact
	signal success(string fileUrl)
	signal error(string errorString)
	title: "Please choose an image for your logo"
	nameFilters: ["Image files (*.png *.jpg)", "All files (*)"]
	folder: shortcuts.home
}
