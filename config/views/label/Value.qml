import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0

Label {
  Layout.leftMargin: 10
  font.pixelSize: 15
  font.bold: true
  property bool hideBG
  background: Rectangle {
    radius: 2
    color: "transparent"
    anchors.centerIn: parent
    border.width: hideBG ? 0 : 1
    width: parent.width + 20
    height: parent.height
  }
}
