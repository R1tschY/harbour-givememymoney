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

public:
    explicit QObjectListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void append(QObject* obj);
    Q_INVOKABLE void extend(QVariantList list);
    Q_INVOKABLE void remove(QObject* obj);

private slots:
    ITEM_CHANGED_TAG void onItemChanged();

private:
    QList<QObject*> m_list;
    const QMetaObject* m_meta = nullptr;
    QHash<int, QByteArray> m_roleNames;
    QMetaMethod m_onItemChanged;

    void lazyInit(QObject* obj);
};

#endif // QOBJECTLISTMODEL_H
