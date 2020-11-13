import QtQuick 2.0
import QmlXX.Models 0.1
import "../components"

Object {
    property int rowId
    property string description

    QObjectListModel {
        id: items
    }

    onRowIdChanged: {

    }
}
