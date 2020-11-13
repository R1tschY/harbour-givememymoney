import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: store.balances

        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Balances")
        }

        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.horizontalPageMargin
                text: description
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: pageStack.push(Qt.resolvedUrl("ItemsPage.qml"), { "balanceId": rowId })
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("New balance")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NewBalance.qml"))
                    dialog.accepted.connect(function() {
                        var balance = store.newBalance({"description": dialog.description})
                        store.addBalance(balance)
                    })
                }
            }
        }


        VerticalScrollDecorator { flickable: listView }
    }
}
