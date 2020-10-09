// SPDX-License-Identifier: BSD-3-Clause
// Copyright (c) 2020, The Monero Project.

#ifndef FEATHER_HISTORYWIDGET_H
#define FEATHER_HISTORYWIDGET_H

#include "model/TransactionHistoryModel.h"
#include "model/TransactionHistoryProxyModel.h"
#include "libwalletqt/Coins.h"

#include <QWidget>
#include <QMenu>

namespace Ui {
    class HistoryWidget;
}

class HistoryWidget : public QWidget
{
Q_OBJECT

public:
    explicit HistoryWidget(QWidget *parent = nullptr);
    void setModel(Coins * coins, TransactionHistoryProxyModel * model, TransactionHistory * txHistory);
    ~HistoryWidget() override;

public slots:
    void setSearchText(const QString &text);

signals:
    void spendProof(QString txid);
    void viewOnBlockExplorer(QString txid);

private slots:
    void showTxDetails();
    void onViewOnBlockExplorer();
    void getSpendProof();
    void setSearchFilter(const QString &filter);

private:
    enum copyField {
        TxID = 0,
        Date,
        Amount
    };

    void copy(copyField field);

    Ui::HistoryWidget *ui;
    QMenu *m_contextMenu;
    QMenu *m_copyMenu;
    TransactionHistory *m_txHistory;
    TransactionHistoryProxyModel *m_model;
    Coins *m_coins;
};

#endif //FEATHER_HISTORYWIDGET_H