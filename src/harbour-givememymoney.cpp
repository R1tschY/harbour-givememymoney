#include <QtQuick>

#include <sailfishapp.h>
#include "models/qobjectlistmodel.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<QObjectListModel>("QmlXX.Models", 0, 1, "QObjectListModel");

    return SailfishApp::main(argc, argv);
}
