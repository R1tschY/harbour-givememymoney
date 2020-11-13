#include "qobjectlistmodel.h"

#include <QMetaObject>
#include <QMetaProperty>
#include <QtDebug>

QObjectListModel::QObjectListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    const QMetaObject* meta = metaObject();
    for (int i = meta->methodOffset(); i < meta->methodCount(); ++i) {
        if (meta->method(i).tag() != nullptr) {
            m_onItemChanged = meta->method(i);
            break;
        }
    }

    if (!m_onItemChanged.isValid()) {
        qDebug() << "Failed to find onItemChanged slot";
    }
}

int QObjectListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_list.size();
}

QVariant QObjectListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    int row = index.row();

    if (row < 0 || row >= m_list.size()) {
        return QVariant();
    }

    if (role == Qt::UserRole) {
        return QVariant::fromValue(m_list[row]);
    }

    int propIndex = role - Qt::UserRole - 1;
    if (propIndex < 0 || propIndex >= m_roleNames.size()) {
        return QVariant();
    }

    return m_meta->property(propIndex).read(m_list[row]);
}


QHash<int, QByteArray> QObjectListModel::roleNames() const
{
    return m_roleNames;
}

void QObjectListModel::append(QObject *obj)
{
    if (m_meta == nullptr) {
        lazyInit(obj);
    }

    beginInsertRows({}, m_list.size(), m_list.size());
    m_list.append(obj);

    for (int i = 0; i < m_meta->propertyCount(); ++i) {
        QMetaProperty property = m_meta->property(i);
        QMetaMethod signal = property.notifySignal();
        if (signal.isValid()) {
            connect(obj, signal, this, m_onItemChanged);
        }
    }

    endInsertRows();
}

void QObjectListModel::extend(QVariantList list)
{
    if (list.isEmpty())
        return;

    if (m_meta == nullptr) {
        lazyInit(qvariant_cast<QObject*>(list[0]));
    }

    beginInsertRows({}, m_list.size(), m_list.size() + list.size() - 1);

    for (const auto& elem : list) {
        QObject* obj = qvariant_cast<QObject*>(elem);
        m_list.append(obj);
        for (int i = 0; i < m_meta->propertyCount(); ++i) {
            QMetaProperty property = m_meta->property(i);
            QMetaMethod signal = property.notifySignal();
            if (signal.isValid()) {
                connect(obj, signal, this, m_onItemChanged);
            }
        }
    }

    endInsertRows();
}

void QObjectListModel::remove(QObject *obj)
{
    int idx = m_list.indexOf(obj);
    if (idx < 0) {
        return;
    }

    beginRemoveRows({}, idx, idx);
    m_list.removeAt(idx);
    obj->disconnect(this);
    endRemoveRows();
}

void QObjectListModel::onItemChanged()
{
    QObject* s = sender();
    if (s == nullptr) {
        return;
    }

    int idx = m_list.indexOf(s);
    if (idx < 0) {
        return;
    }

    QModelIndex i = index(idx);
    dataChanged(i, i);
}

void QObjectListModel::lazyInit(QObject* obj)
{
    QHash<int, QByteArray> roles;

    beginResetModel();

    roles.insert(Qt::UserRole, "modelData");
    const QMetaObject* metaObject = obj->metaObject();
    for (int i = 0; i < metaObject->propertyCount(); ++i) {
        QMetaProperty property = metaObject->property(i);
        roles.insert(Qt::UserRole + 1 + i, property.name());
    }

    m_meta = metaObject;
    m_roleNames = roles;
    endResetModel();
}
