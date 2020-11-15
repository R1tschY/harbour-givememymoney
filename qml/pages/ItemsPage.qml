import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Utils.js" as Utils

Page {
    id: page

    property var balance

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: balance.items
        anchors.fill: parent

        header: Column {
            width: page.width

            PageHeader {
                title: balance.description
            }

            SectionHeader {
                text: Utils.formatCurrency(balance.amount)
            }
        }

        delegate: BackgroundItem {
            id: delegate
            width: page.width

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
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("New item")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NewItemDialog.qml"))
                    dialog.accepted.connect(function() {
                        store.addItem(page.balance, store.newBalance(dialog.getProps()))
                    })
                }
            }
        }

        VerticalScrollDecorator { flickable: listView }
    }
}
