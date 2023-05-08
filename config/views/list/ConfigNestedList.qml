import QtQuick 2.0
import "../../primitives"

NestedList {
  property int currentIndex: 0
  // outerListSelectedIndex: 0 // Temp values to not select anything at the start
  //  innerListSelectedIndex: 0
  Component.onCompleted: {
    emitFilters(0, 0)
  }
  outerList: []
  innerListDict: {  }
}
