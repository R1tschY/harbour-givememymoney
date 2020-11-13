import QtQuick 2.0
import QtQml.Models 2.2
import "../store"

ListModel {
    id: listModel

    property Balance balance

    Component.onCompleted: {
        var items = store.getItems()
        for (var i = 0; i < items.length; i++) {
            _appendItem(items[i])
        }
        balance.itemAdded.connect(_appendItem)
    }

    Component.onDestruction: {
       balance.itemAdded.disconnect(_appendItem)
    }

    function _appendItem(balance){
        append({"object": balance, "rowId": balance.rowId})
    }

    function _onChanged(balance) {

    }

    function _onRemoved(balances) {

    }

    function _findIndex(rowId) {
        var count = listModel.count
        for (var i = 0; i < count; ++i) {
            if (get(i).rowId === rowId) {
                return i
            }
        }
        return -1
    }
}
