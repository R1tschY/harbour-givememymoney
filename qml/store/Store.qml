import QtQuick 2.0
import QmlXX.Models 0.1

import "../components"

Object {
   id: store

    property Repository repository
    property alias balances: balances
    property alias persons: persons

    QObjectListModel {
       id: persons
    }

    QObjectListModel {
       id: balances
    }

    Component.onCompleted: {
        repository.initDbConnection()
        balances.extend(repository.getBalances())
    }

    function newBalance(balanceProps) {
        var balanceComp = Qt.createComponent(Qt.resolvedUrl("Balance.qml"))
        if (balanceComp.status === Component.Ready) {
            return balanceComp.createObject(store, balanceProps || {})
        } else {
            console.error("Failed to create Balance component: " + balanceComp.errorString())
            return null
        }
    }

    function newItem(itemProps) {
        var itemComp = Qt.createComponent(Qt.resolvedUrl("BalanceItem.qml"))
        if (itemComp.status === Component.Ready) {
            return itemComp.createObject(store, itemProps || {})
        } else {
            console.error("Failed to create Item component: " + itemComp.errorString())
            return null
        }
    }

    function addBalance(balance) {
        balances.append(balance)
        repository.addBalance(balance)
    }

    function addItem(balance, item) {
        balance.items.append(item)
        repository.addItem(balance, item)
    }
}
