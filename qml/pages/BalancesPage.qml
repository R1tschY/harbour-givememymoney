import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../Utils.js" as Utils

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: store.balances

        Component.onCompleted: {
            console.log("Balances: " + count)
        }

        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Balances")
        }

        delegate: BackgroundItem {
            id: delegate

            Label {
                id: descriptionLabel
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: amountLabel.left
                    rightMargin: Theme.paddingSmall
                }

                text: description
                truncationMode: TruncationMode.Fade
                textFormat: Text.PlainText
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            Label {
                id: amountLabel
                anchors {
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                text: Utils.formatCurrency(amount)
                textFormat: Text.PlainText
                anchors.verticalCenter: parent.verticalCenter
                color: amount >= 0 ? "green" : "red"
            }

            onClicked: pageStack.push(Qt.resolvedUrl("ItemsPage.qml"), { "balance": modelData })
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("New balance")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NewBalanceDialog.qml"))
                    dialog.accepted.connect(function() {
                        store.addBalance(store.newBalance(dialog.getProps()))
                    })
                }
            }
        }


        VerticalScrollDecorator { flickable: listView }
    }
}
