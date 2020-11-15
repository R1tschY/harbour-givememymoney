#ifndef QOBJECTLISTMODEL_H
#define QOBJECTLISTMODEL_H

#include <QAbstractListModel>
#include <QMetaMethod>
#include <QList>

#ifndef Q_MOC_RUN
#define ITEM_CHANGED_TAG
#endif

class QObjectListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        ModelDataRole = Qt::UserRole,
        FirstPropertyRole,
    };


    explicit QObjectListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // basic operations
    Q_INVOKABLE void append(QObject* obj);
    Q_INVOKABLE void extend(QVariantList list);
    Q_INVOKABLE void remove(QObject* obj);
    Q_INVOKABLE void clear();
    Q_INVOKABLE QObject* get(int index) const;

    // extended operations
    Q_INVOKABLE QVariantList roleValues(const QString& roleName) const;

private slots:
    ITEM_CHANGED_TAG void onItemChanged();

signals:
    void listChanged();
//    void itemChanged(QObject*);
//    void itemAdded(QObject*);
//    void itemRemoved(QObject*);
    void countChanged(int);

private:
    QList<QObject*> m_list;
    const QMetaObject* m_meta = nullptr;
    QHash<int, QByteArray> m_roleNames;
    QMetaMethod m_onItemChanged;

    void lazyInit(QObject* obj);
};

#endif // QOBJECTLISTMODEL_H
