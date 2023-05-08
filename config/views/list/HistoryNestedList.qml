import QtQuick 2.0
import "../../primitives"

NestedList {
  property int currentIndex: 0
  signal changeDjangoFilters(var filters)
  // outerListSelectedIndex: 0 // Temp values to not select anything at the start
  //  innerListSelectedIndex: 0
  Component.onCompleted: {
    emitFilters(0, 0)
  }
  outerList: [{
      "name": "RFQ",
      "tableModel": rfqTableModel,
      "icon": "../../resources/icons/rfq_small.svg" // Icon should be relative to nestedlist component
    }, {
      "name": "Quote",
      "tableModel": quoteTableModel,
      "icon": "../../resources/icons/quote_small.svg" // Icon should be relative to nestedlist component
    }, {
      "name": "PO",
      "tableModel": poTableModel,
      "icon": "../../resources/icons/po_small.svg" // Icon should be relative to nestedlist component
    }, {
      "name": "Invoice",
      "tableModel": invoiceTableModel,
      "icon": "../../resources/icons/invoice_small.svg" // Icon should be relative to nestedlist component
    }]
  innerListDict: {
    "RFQ": [{
              "name": "All",
              "icon": "../../resources/icons/clock.svg"
            }, {
              "name": "Today",
              "icon": "../../resources/icons/clock.svg",
              "user_filter": ["today"]
            }, {
              "name": "Last Week",
              "icon": "../../resources/icons/clock.svg",
              "user_filter": ["this_week"]
            }, {
              "name": "Quoted",
              "icon": "../../resources/icons/done.svg",
              "user_filter": ["quoted"]
            }, {
              "name": "Pending",
              "icon": "../../resources/icons/done.svg",
              "user_filter": ["rfq_pending"]
            }],
    "PO": [{
             "name": "All",
             "icon": "../../resources/icons/clock.svg"
           }, {
             "name": "Today",
             "icon": "../../resources/icons/clock.svg",
             "user_filter": ["today"]
           }, {
             "name": "Last Week",
             "icon": "../../resources/icons/clock.svg",
             "user_filter": ["this_week"]
           }],
    "Quote": [{
                "name": "All",
                "icon": "../../resources/icons/clock.svg"
              }, {
                "name": "Today",
                "icon": "../../resources/icons/clock.svg",
                "user_filter": ["today"]
              }, {
                "name": "Last Week",
                "icon": "../../resources/icons/clock.svg",
                "user_filter": ["this_week"]
              }, {
                "name": "Expired",
                "icon": "../../resources/icons/expired.svg",
                "user_filter": ["expired"]
              }, {
                "name": "Need a follow up",
                "icon": "../../resources/icons/attention.svg",
                "user_filter": ["follow_up_required"]
              }],
    "Invoice": [{
                  "name": "All",
                  "icon": "../../resources/icons/clock.svg"
                }, {
                  "name": "Today",
                  "icon": "../../resources/icons/clock.svg",
                  "user_filter": ["today"]
                }, {
                  "name": "Last Week",
                  "icon": "../../resources/icons/clock.svg",
                  "user_filter": ["this_week"]
                }, {
                  "name": "Paid",
                  "icon": "../../resources/icons/paid.svg",
                  "user_filter": ["paid"]
                }, {
                  "name": "Awaiting payment",
                  "icon": "../../resources/icons/wait_payment.svg",
                  "user_filter": ["not_paid"]
                }]
  }
  function emitFilters(listItemIndex, listItemSubIndex) {
    const trans = outerList[listItemIndex].name
    const filter = innerListDict[trans][listItemSubIndex].user_filter
    currentIndex = listItemIndex
    const tableModel = outerList[listItemIndex].tableModel
    changeDjangoFilters(filter)
  }
  onSelectListItem: (listItemIndex, dirtyListItemSubIndex) => {
                      const listItemSubIndex = Math.max(0,
                                                        dirtyListItemSubIndex)
                      emitFilters(listItemIndex, listItemSubIndex)
                    }
}
