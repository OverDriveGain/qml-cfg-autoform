import QtQuick 2.13
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.4
import QtQuick.Dialogs 1.1
import "./views/list"
import "./views/label"
import "./views/dialog"
import "./primitives"
import "./js/text.js" as Text
import "./js/objectOp.js" as OP

ApplicationWindow {
  id: configWindow
  width: 1137
  height: 700
  visible: true
  title: qsTr("Configuration")
  property int currentStackLayoutIndex: 0
  property var stackLayoutMap: {

  }
  property var configPages: []
  property var innerConfigDict: {
    "test": "test"
  }
  MessageDialog {
    property string objectLabel
    property string saveResult: ''
    id: messageDialog
    title: saveResult.length === 0 ? "Configuration Saved successfull" : "Error with configuration"
    text: {
      if (saveResult.length === 0) {
        return "Configuration saved successfully!"
      }
      return saveResult
    }
  }

  Component {
    id: stackLayoutItemComponent
    Pane {
      property alias title: titleText.text
      property alias columnLayout: columnLayout
      ScrollView {
        height: parent.height
        width: parent.width
        ColumnLayout {
          id: columnLayout
          spacing: 10
          SectionLabel {
            id: titleText
            text: text
          }
        }
      }
    }
  }
  Component {
    id: dropDownItemComponent
    DropDown {
      //			property string modelsKey
      //model: OP.get(cfg, modelsKey)
      onActivated: activatedIndex => {
                     OP.set(newConfig, modelsKey, 'new')
                   }
    }
  }
  Component {
    id: checkBoxItemComponent
    CheckBox {
      property string modelsKey
      checked: OP.get(cfg, modelsKey)
      onCheckedChanged: {
        OP.set(cfg, modelsKey, changed)
      }
    }
  }
  Component {
    id: orderedTableItemComponent
    DragDropList {
      property string modelsKey
      itemList: OP.get(cfg, modelsKey)
      onSetChanges: newValues => {
                      OP.set(newConfig, modelsKey, newValues)
                    }
    }
  }
  Component {
    id: directoryItemComponent
    ColumnLayout {
      property string text
      property string modelsKey
      BrowseLogoFileDialog {
        id: browse
        onAccepted: {
          dirTextField.text = backend.uriToPath(browse.fileUrls[0])
        }
      }
      Text {
        text: parent.text
      }
      RowLayout {
        TextField {
          id: dirTextField
          selectByMouse: true
          implicitWidth: 300
          text: OP.get(cfg, modelsKey)
        }
        Button {
          text: "Browse"
          onClicked: {
            browse.open()
          }
        }
      }
    }
  }
  Component {
    id: paragraphItemComponent
    Text {
      text: "Paragraph"
    }
  }
  Component {
    id: sectionItemComponent
    Text {
      text: "section"
    }
  }
  Component {
    id: linkItemComponent
    Text {
      text: "link"
    }
  }
  Component {
    id: idItemComponent
    RowLayout {

      property string text
      property string modelsKey
      ColumnLayout {
        Text {
          text: 'ID Prefix'
        }
        RowLayout {
          TextField {
            text: OP.get(cfg, modelsKey + '.prefix')
          }
        }
      }
      ColumnLayout {
        Text {
          text: 'ID Length'
        }
        RowLayout {
          TextField {
            text: OP.get(cfg, modelsKey + '.length')
          }
        }
      }
    }
  }
  Component {
    id: ipItemComponent
    ColumnLayout {
      property string text
      property string modelsKey
      Text {
        text: parent.text
      }
      TextField {
        text: OP.get(cfg, modelsKey)
      }
    }
  }

  Component.onCompleted: {
    createStackLayoutFromJson(cfgForm, stackLayout)
  }
  function createStackLayoutFromJson(jsonObject, parent) {

    // Parses if object has following: 1 -
    innerConfigDict = {}
    const componentsMap = {
      "dropdown": dropDownItemComponent,
      "checkbox": checkBoxItemComponent,
      "orderedList": orderedTableItemComponent,
      "paragraph": paragraphItemComponent,
      "section": sectionItemComponent,
      "link": linkItemComponent,
      "ip": ipItemComponent,
      "string": ipItemComponent,
      "dir": directoryItemComponent,
      "id": idItemComponent
    }
    let stackLayoutId = 0
    // Create main stack layout
    function recursiveReader(recursiveObject, parentMenu, addressInObject) {
      // Iterates items object
      Object.keys(recursiveObject).forEach(objectKey => {
                                             const el = recursiveObject[objectKey]
                                             if (!el)
                                             return
                                             // If has own layout
                                             if (el.meta.parent) {
                                               recursiveReader(
                                                 el.schema, el.meta.text,
                                                 (addressInObject.length
                                                  > 0 ? addressInObject + '.' : '') + objectKey)
                                             }
                                             if (el.schema) {
                                               if (parentMenu) {
                                                 if (!innerConfigDict[parentMenu]) {
                                                   innerConfigDict[parentMenu] = []
                                                 }
                                                 innerConfigDict[parentMenu].push({
                                                                                    "name": el.meta.text
                                                                                  })
                                               } else {
                                                 configPages.push({
                                                                    "name": el.meta
                                                                            && el.meta.text ? el.meta.text : objectKey,
                                                                    "icon": "../resources/icons/eye.svg"
                                                                  })
                                               }
                                               const keysAddress = (addressInObject.length > 0 ? addressInObject + '.' : '') + objectKey
                                               const stackLayout = stackLayoutItemComponent.createObject(
                                                 parent, {
                                                   "title": Text.capitalizeFirstLetter(
                                                              keysAddress) + ' Configuration'
                                                 })
                                               if (!stackLayoutMap) {
                                                 stackLayoutMap = {}
                                               }
                                               stackLayoutMap[el.meta.text + '-'
                                                              + (parentMenu
                                                                 || '')] = stackLayoutId
                                               stackLayoutId += 1

                                               Object.keys(
                                                 el.schema).forEach(key => {
                                                                      const el2 = el.schema[key]
                                                                      if (el2
                                                                          && el2.meta) {

                                                                        if (el2.meta.parent) {

                                                                        }
                                                                        if (el2.type) {
                                                                          const comp = componentsMap[el2.type]

                                                                          if (comp) {
                                                                            el2.meta.modelsKey = keysAddress + '.' + key
                                                                            const uiForm = comp.createObject(stackLayout.columnLayout, el2.meta)
                                                                            uiForm.Layout.leftMargin
                                                                            = 10
                                                                          }
                                                                          // ToDo connect callbacks
                                                                        }
                                                                      }
                                                                    })
                                             }
                                           })
    }
    recursiveReader(jsonObject, undefined, '')
  }
  property var storageConfig: cfg
  property var newConfig: JSON.parse(JSON.stringify(cfg))
  signal editTrans(string transType)
  signal replyToTrans(string transType)
  GridLayout {
    anchors.fill: parent
    rows: 5
    columns: 7
    columnSpacing: 0
    rowSpacing: 0
    flow: GridLayout.LeftToRight
    Pane {
      Layout.columnSpan: 2
      Layout.rowSpan: 5
      Layout.fillHeight: true
      Layout.preferredWidth: 250
      padding: 0
      ConfigNestedList {
        id: tableSelector
        outerListSelectedIndex: 0
        outerList: configPages
        innerListDict: innerConfigDict
        onSelectListItem: (index, subIndex) => {
                            const parent = configPages[index].name
                            let key = parent + '-'
                            let child = ''
                            if (subIndex !== -1) {
                              child = innerConfigDict[parent][subIndex].name
                              key = child + '-' + parent
                            }
                            currentStackLayoutIndex = stackLayoutMap[key]
                          }
      }
    }
    Pane {
      Layout.columnSpan: 5
      Layout.rowSpan: 4
      Layout.fillWidth: true
      Layout.fillHeight: true
      padding: 10
      StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: currentStackLayoutIndex
      }
    }
    Pane {
      Layout.columnSpan: 5
      Layout.rowSpan: 1
      Layout.fillWidth: true
      RowLayout {
        Button {
          text: "Save"
          onClicked: {

            const res = backend.saveConfig(newConfig)
            messageDialog.saveResult = res
            messageDialog.open()
          }
        }
        Button {
          text: "Cancel"
          onClicked: {
            configWindow.close()
          }
        }
      }
    }
  }
}
