import QtQuick 2.0
import QmlXX.Models 0.1
import "../components"

Object {
    id: root

    property int rowId: -1
    property string description
    property alias items: items

    // calculated
    property double amount: 0.0

    QObjectListModel {
        id: items

        onListChanged: {
            var amounts = items.roleValues("amount")
            var amount = 0.0
            for (var i = 0; i < amounts.length; ++i) {
                amount += amounts[i]
            }
            root.amount = amount
        }
    }
}
