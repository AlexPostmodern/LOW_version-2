#include "specialquerymodel.h"
#include <QSqlField>
#include <QSqlRecord>

SpecialQueryModel::SpecialQueryModel(QObject *parent) : QSqlQueryModel(parent)
{

}

//конструктор копирования
SpecialQueryModel::SpecialQueryModel(const SpecialQueryModel &other)
{
    this->sqm_roleNames=other.sqm_roleNames;
}


SpecialQueryModel::SpecialQueryModel(QString strQuery)
{
    QSqlQueryModel::setQuery(strQuery);
    sqm_GenerateRoleNames();
}

void SpecialQueryModel::sqm_SetQuery(QString strQuery)
{
    QSqlQueryModel::setQuery(strQuery);
    sqm_GenerateRoleNames();
}


QVariant SpecialQueryModel::data(const QModelIndex &item, int role) const
{
    QVariant value;
    if (role<Qt::UserRole)
    {
        value=QSqlQueryModel::data(item,role);
    }
    else
    {
        int columnIdx = role - Qt::UserRole -1;
        QModelIndex modelIndex = this->index(item.row(),columnIdx);
        value = QSqlQueryModel::data(modelIndex,Qt::DisplayRole);
    }
    return value;
}

void SpecialQueryModel::sqm_GenerateRoleNames()
{
    sqm_roleNames.clear();
    for(int i=0; i<record().count();i++)
    {
        sqm_roleNames.insert(Qt::UserRole+i+1, record().fieldName(i).toUtf8());
    }
}
