import QtQuick 2.13
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import "../views/label"

//![0]
ColumnLayout {
	id: root
	property var itemList
	property string text: "Undefined"
	width: 300
	height: 150
	onItemListChanged: {
		listModel.clear()
		itemList.forEach(el => {
							 listModel.append({
												  "textValue": el
											  })
						 })
	}
	ListModel {
		id: listModel
	}
	SubSectionLabel {
		text: root.text
	}
	property int selectedIndex
	signal setChanges(var newOrder)
	function applyChanges() {
		const newValues = []
		for (var i = 0; i < visualModel.items.count; ++i)
			newValues.push(visualModel.items.get(i).model.textValue)
		setChanges(newValues)
	}
	Rectangle {
		height: parent.height - addButton.height
		width: parent.width
		id: rectangleRoot
		Component {
			id: dragDelegate

			MouseArea {
				id: dragArea

				property bool held: false

				anchors {
					left: parent ? parent.left : undefined
					right: parent ? parent.right : undefined
				}
				height: content.height

				drag.target: held ? content : undefined
				drag.axis: Drag.YAxis

				onPressed: {
					held = true
					selectedIndex = index
				}
				onReleased: {
					held = false
					applyChanges()
				}

				Rectangle {
					id: content
					//![0]
					anchors {
						horizontalCenter: parent.horizontalCenter
						verticalCenter: parent.verticalCenter
					}
					width: dragArea.width
					height: column.implicitHeight + 4

					border.width: 1
					border.color: "lightsteelblue"

					color: dragArea.held
						   || selectedIndex === index ? "lightsteelblue" : "white"
					Behavior on color {
						ColorAnimation {
							duration: 100
						}
					}

					radius: 2
					//![1]
					Drag.active: dragArea.held
					Drag.source: dragArea
					Drag.hotSpot.x: width / 2
					Drag.hotSpot.y: height / 2
					//![1]
					states: State {
						when: dragArea.held

						ParentChange {
							target: content
							parent: rectangleRoot
						}
						AnchorChanges {
							target: content
							anchors {
								horizontalCenter: undefined
								verticalCenter: undefined
							}
						}
					}

					Column {
						id: column
						anchors {
							fill: parent
							margins: 2
						}

						Text {
							text: textValue
						}
					}
					//![2]
				}
				//![3]
				DropArea {
					anchors {
						fill: parent
						margins: 10
					}

					onEntered: {
						visualModel.items.move(
									drag.source.DelegateModel.itemsIndex,
									dragArea.DelegateModel.itemsIndex)
					}
				}

				//![3]
			}
		}
		//![2]
		//![4]
		DelegateModel {
			id: visualModel
			model: listModel
			delegate: dragDelegate
		}
		Popup {
			id: popup
			x: 100
			y: 100
			property var valueModel
			property string valueName: "condition"
			width: 200
			height: 100
			modal: true
			focus: true
			onOpened: {
				textField.text = ''
			}
			contentItem: ColumnLayout {
				Text {
					text: "Insert new value for " + popup.valueName
				}
				TextField {
					id: textField
					width: 190
				}
				RowLayout {
					Button {
						text: "Save"
						onClicked: {
							popup.close()
							popup.valueModel.items.insert({
															  "textValue": textField.text
														  })
							applyChanges()
						}
					}
					Button {
						text: "Close"
						onClicked: popup.close()
					}
				}
			}
			closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
		}

		ListView {
			id: view

			anchors {
				fill: parent
				margins: 2
			}
			clip: true
			model: visualModel
			spacing: 4
			cacheBuffer: 50
		}
	}

	Row {
		anchors.top: view.bottom
		Button {
			id: addButton
			text: "Add"
			onClicked: {
				popup.open()
				popup.valueModel = visualModel
				popup.valueName = "Condition"
			}
		}
		Button {
			text: "Remove"
		}
	}

	//![4]
	//![5]
} //![5]
