import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    id: repo

    property var _db: null

    Component.onCompleted: initDbConnection()

    function initDbConnection() {
        if (_db === null) {
            var db = LocalStorage.openDatabaseSync(
                        "EnitiesDB", "", "Database tracking items");
            if (db.version === "") {
                _db = _initDb(db)
            } else if (db.version === "0.1") {
                console.log("Got up-to-date database version")
                _db = db
            } else {
                console.error("unknown database version " + db.version)
            }
        }
    }

    function _initDb(db) {
        console.log("Initialize database")
        db.changeVersion("", "0.1", function(tx) {
            tx.executeSql(
                'CREATE TABLE items ('
                    + 'balance_id INT, amount INT, description TEXT, person_id INT, share INT)')
            tx.executeSql('CREATE TABLE balances (description TEXT)')
            tx.executeSql('CREATE TABLE persons (name TEXT)')
        })
        return db
    }

    function addBalance(balance) {
        var id = null
        _db.transaction(function(tx) {
            var result = tx.executeSql(
                'INSERT INTO balances (description) VALUES (?)', [balance.description])
            id = result.insertId
        })
        balance.rowId = id
    }

    function saveBalance(balance) {
        _db.transaction(function(tx) {
            tx.executeSql(
                'UPDATE balances SET description = ? WHERE rowid = ?',
                [balance.description, balance.rowId])
        })
    }

    function removeBalance(balance) {
        _db.transaction(function(tx) {
            tx.executeSql('DELETE FROM balances WHERE rowid = ?', [balance.rowId])
        })
    }

    function getBalances() {
        var results = null
        _db.readTransaction(function(tx) {
            results = tx.executeSql('SELECT rowid, description FROM balances')
        })

        var balanceComp = Qt.createComponent("Balance.qml");
        var rows = results.rows
        var result = []
        for (var i = 0; i < rows.length; i++) {
            var row = rows.item(i)
            var balance = balanceComp.createObject(repo, {
                rowId: row.rowid,
                description: row.description
            })
            balance.items.extend(getItems(row.rowid))
            result.push(balance)
        }
        return result
    }

    function addItem(balance, item) {
        var result = null
        _db.transaction(function(tx) {
            result = tx.executeSql(
                'INSERT INTO items (balance_id, amount, description, person_id, share)'
                        + ' VALUES (?, ?, ?, ?, ?)',
                [balance.rowId, item.amount, item.description, item.personId, item.share])
        })
        item.rowId = result.insertId
    }

    function saveItem(item) {
        _db.transaction(function(tx) {
            tx.executeSql(
                'UPDATE balances SET amount = ?, description = ?, person_id = ?, share = ?'
                        + ' WHERE rowid = ?',
                [item.amount, item.description, item.personId, item.share, item.rowId])
        })
    }

    function removeItem(item) {
        _db.transaction(function(tx) {
            tx.executeSql('DELETE FROM items WHERE rowid = ?', [item.rowId])
        })
    }

    function getItems(balanceId) {
        var results = null
        _db.readTransaction(function(tx) {
            results = tx.executeSql(
                'SELECT rowid, amount, description, person_id, share FROM items'
                        + ' WHERE balance_id = ?', [balanceId])
        })

        var balanceItemComp = Qt.createComponent("BalanceItem.qml");
        var rows = results.rows
        var result = []
        for (var i = 0; i < rows.length; i++) {
            var row = rows.item(i)
            result.push(balanceItemComp.createObject(repo, {
                rowId: row.rowid,
                balanceId: balanceId,
                amount: row.amount,
                personId: row.person_id,
                share: row.share,
                description: row.description
            }))
        }
        return result
    }
}
