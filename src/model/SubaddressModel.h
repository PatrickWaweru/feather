// SPDX-License-Identifier: BSD-3-Clause
// Copyright (c) 2014-2020, The Monero Project.

#ifndef SUBADDRESSMODEL_H
#define SUBADDRESSMODEL_H

#include <wallet/api/wallet2_api.h>

#include <QAbstractTableModel>
#include <QSortFilterProxyModel>
#include <QDebug>

class Subaddress;

class SubaddressModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    enum ModelColumn
    {
         Address = 0,
         Label,
         isUsed,
         COUNT
    };

    explicit SubaddressModel(QObject *parent, Subaddress *subaddress);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    bool isShowFullAddresses() const;
    void setShowFullAddresses(bool show);

    int unusedLookahead() const;

public slots:
    void startReset();
    void endReset();

private:
    Subaddress *m_subaddress;
    QVariant parseSubaddressRow(const Monero::SubaddressRow &subaddress, const QModelIndex &index, int role) const;

    bool m_showFullAddresses;
};

#endif // SUBADDRESSMODEL_H