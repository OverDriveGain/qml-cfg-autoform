import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.4
import QtQuick.Controls 2.4

Pane {
  signal selectListItem(int index, int subIndex)
  property int outerListSelectedIndex: -1
  property int innerListSelectedIndex: -1
  property var outerList: [{
      "name": "outter-1",
      "name:": "outter-2"
    }]
  property var innerListDict: {
    "outter-1": [{
                   "name": "inside"
                 }]
  }
  property var innerListModelArr: []
  anchors.fill: parent
  Rectangle {
    anchors.fill: parent
    ListModel {
      id: outerListModel
    }
    Component {
      id: someComponent
      ListModel {}
    }

    Component.onCompleted: {
      outerList.forEach(el => {
                          const newModel = someComponent.createObject(parent)
                          if (innerListDict && innerListDict[el.name]) {
                            innerListDict[el.name].forEach(el2 => {
                                                             newModel.append({
                                                                               "name": el2.name,
                                                                               "icon": el2.icon
                                                                             })
                                                           })
                            innerListModelArr.push(newModel)
                          } else {
                            innerListModelArr.push({})
                          }
                          outerListModel.append(el)
                        })
    }

    ListView {
      id: outer
      model: outerListModel
      delegate: listdelegate
      anchors.fill: parent
    }

    Component {
      id: listdelegate

      Item {
        width: parent.width
        height: col.childrenRect.height
        property int colIndex: index

        Column {
          id: col
          anchors.left: parent.left
          anchors.right: parent.right
          Rectangle {
            height: childrenRect.height
            width: parent.width
            color: outerListSelectedIndex === index
                   && innerListSelectedIndex === -1
                   || (outerListSelectedIndex === -1
                       && innerListSelectedIndex === -1
                       && index === 0) ? Material.accent : 'transparent'
            z: 0
            RowLayout {
              id: listRow
              width: parent.width
              Row {
                id: iconRect
                height: 20
                width: parent.width
                spacing: 5
                Layout.leftMargin: 10
                z: 1
                Layout.alignment: Qt.AlignLeft
                Image {
                  id: iconImagePhoto
                  source: icon || '../../resources/icons/next.png'
                  sourceSize: Qt.size(20, 20)
                  smooth: true
                  Layout.topMargin: 5
                  MouseArea {
                    anchors.fill: parent
                    onClicked: {
                      if (insidelist.height === insidelist.collapseHeightFlag) {
                        innerListSelectedIndex = -1
                        insidelist.height = 0
                        selectListItem(index, -1)
                      } else
                        insidelist.height = insidelist.collapseHeightFlag
                      selectListItem(index, -1)
                    }
                  }
                }
                Text {
                  id: t1
                  text: name
                }
              }

              Item {
                id: expandRect
                width: 20
                height: 20
                Layout.rightMargin: 0
                z: 1
                Layout.alignment: Qt.AlignRight
                Image {
                  id: imagePhoto
                  source: '../resources/icons/next.svg'
                  sourceSize: Qt.size(20, 20)
                  smooth: true
                  transform: Rotation {
                    id: rotateImagePhoto
                    angle: insidelist.height === 0 ? 0 : 90
                    origin.x: insidelist.height !== 0 ? imagePhoto.width / 2 : 0
                    origin.y: insidelist.height !== 0 ? imagePhoto.height / 2 : 0
                  }
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: {
                    if (insidelist.height === insidelist.collapseHeightFlag) {
                      innerListSelectedIndex = -1
                      insidelist.height = 0
                    } else
                      insidelist.height = insidelist.collapseHeightFlag
                    selectListItem(index, -1)
                  }
                }
              }
            }

            MouseArea {
              anchors.fill: parent
              z: -1
              onClicked: {
                outerListSelectedIndex = index
                innerListSelectedIndex = -1
                //	if (!innerListModelArr[index])
                selectListItem(index, -1)
              }
              onDoubleClicked: {
                if (insidelist.height === insidelist.collapseHeightFlag) {
                  insidelist.height = 0
                } else
                  insidelist.height = insidelist.collapseHeightFlag
              }
            }
          }

          ListView {
            id: insidelist
            currentIndex: outerListSelectedIndex === index ? innerListSelectedIndex : -1
            model: innerListModelArr[index]
            property int collapseHeightFlag: childrenRect.height
            delegate: Component {
              id: delegate2

              Item {
                width: parent.width
                height: col2.childrenRect.height
                anchors.left: parent.left
                anchors.leftMargin: iconImagePhoto.width + listRow.spacing
                                    + iconRect.Layout.leftMargin
                Row {
                  id: col2
                  anchors.left: parent.left
                  anchors.right: parent.right
                  spacing: 5
                  Image {
                    id: subiconImagePhoto
                    source: icon
                    sourceSize: Qt.size(20, 20)
                    smooth: true
                  }
                  Text {
                    height: 20
                    id: name1
                    text: name
                    Layout.topMargin: 4
                  }
                }
                MouseArea {
                  anchors.fill: parent
                  onClicked: {
                    innerListSelectedIndex = index
                    outerListSelectedIndex = colIndex
                    selectListItem(colIndex, index)
                  }
                }
              }
            }
            contentHeight: contentItem.childrenRect.height
            height: 0
            anchors.left: parent.left
            anchors.right: parent.right
            clip: true
            highlight: Rectangle {
              color: Material.accent
              radius: 2
            }
            focus: true
          }
        }
      }
    }
  }
}
