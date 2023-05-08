import QtQuick 2.0
import QtQuick.Controls 2.4
import "../js/dropdown.js" as DropDownList

ComboBox {
  id: dropDown
  property bool isAsync: false
  signal undo
  // Model that is holding the value
  property var modelObject
  // Key of the value inside the model
  property string primaryKey
  // Key inside the value of key inside the model (Nested)
  property string keyInObject
  property bool isConstantModel: false
  signal setNoneExistingText(string text)
  textRole: primaryKey
  function updateIndex(indexValue) {
    if (!modelObject) {
      dropDown.currentIndex = -1
      return
    }
    if (!isConstantModel) {
      //Model from QT
      if (!indexValue && modelObject[keyInObject]) {
        indexValue = keyInObject.length
            > 0 ? modelObject[keyInObject][primaryKey] : modelObject[primaryKey]
      }
      dropDown.currentIndex = DropDownList.mapDropdownModelToIndex(
            dropDown.delegateModel, model, primaryKey, indexValue)
      if (dropDown.currentIndex === -1)
        dropDown.editText = ''
    } else {
      // Model is constant from QML List
      let modelValue = modelObject[primaryKey]
      if (indexValue) {
        modelValue = indexValue
      }
      const tempCurrentIndex = DropDownList.mapDropdownTextToIndex(model,
                                                                   modelValue)
      if (tempCurrentIndex === -1) {
        DropDownList.pushValue(dropDown, modelValue)
        dropDown.currentIndex = DropDownList.mapDropdownTextToIndex(model,
                                                                    modelValue)
      } else {
        dropDown.currentIndex = tempCurrentIndex
      }
    }
  }
  selectTextByMouse: true
  currentIndex: -1
  editable: true
  displayText: currentIndex === -1 ? "Select Value" : currentText
  Component.onCompleted: {
    if (!modelObject)
      return
    updateIndex()
  }
  // This is only useful for asynchronosly readen models if its constant model we don't need it
  onCountChanged: {
    if (isConstantModel)
      return
    if (!modelObject)
      return
    updateIndex()
  }
  onModelObjectChanged: {
    if (!modelObject)
      return
    updateIndex()
  }
  onAccepted: {
    updateIndex(editText)
    activated(currentIndex)
  }
  onActivated: {
    if (modelObject) {
      try {
        dropDownUndoCallBack(dropDown, modelObject,
                             keyInObject ? keyInObject : primaryKey)
      } catch (Exception) {
        console.warn("Un-undoable action, dropDownUndoCallBack not defined")
      }
    }
  }
  onCurrentIndexChanged: {

  }
  onEditTextChanged: {

    // if (!isConstantModel) {
    //   const currentIndex = DropDownList.mapDropdownModelToIndex(
    //                        dropDown.delegateModel, model, primaryKey, editText)
    //  if (currentIndex === -1)
    //     setNoneExistingText(editText)
    //   else
    //     setNoneExistingText('')
    // }
  }
  onActiveFocusChanged: {
    if (activeFocus) {

      // Gained focus
    } else {

      if (!isConstantModel) {
        const currentIndex = DropDownList.mapDropdownModelToIndex(
                             dropDown.delegateModel, model,
                             primaryKey, editText)
        if (currentIndex === -1)
          setNoneExistingText(editText)
      }
    }
  }
}
