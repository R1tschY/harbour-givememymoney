import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "store"

ApplicationWindow
{
    Repository {
        id: repo
    }

    Store {
        id: store
        repository: repo
    }

    initialPage: Component { BalancesPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
