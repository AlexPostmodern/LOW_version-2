#ifndef SPECIALQUERYMODEL_H
#define SPECIALQUERYMODEL_H

#include<QSqlQueryModel>

class SpecialQueryModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit SpecialQueryModel(QObject *parent = nullptr);
    SpecialQueryModel(const SpecialQueryModel &other);
    SpecialQueryModel(QString strQuery);

    void sqm_SetQuery(QString strQuery);
    QVariant data(const QModelIndex &item, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override
    {
        return sqm_roleNames;
    }
private:
    void sqm_GenerateRoleNames();
    QHash<int,QByteArray> sqm_roleNames;
};

#endif // SPECIALQUERYMODEL_H
