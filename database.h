#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QDebug>
#include <QDir>
#include <QSqlError>
#include <QSqlField>
#include <QSqlRecord>

class Database :public QObject
{
    Q_OBJECT

public:
    explicit Database(QString tableName);
    explicit Database(QString tableName, QString strquery);
    Database(const Database& other);
    //Database operator=(const Database& other);

    Q_INVOKABLE static QVariant query_returnValue(QString strquery);
    Q_INVOKABLE static QSqlQuery query_return(QString strquery);
    Q_INVOKABLE static bool query_exec(QString strquery);
    Q_INVOKABLE static void transaction(QString open_commit_rollback);
    static bool db_createConnection(QString path);

public slots:

    QVariant getData(QString columnNameForSearch,  QVariant columnValueForSearch,
                      QString columnNameForReturn) const;
    QString getTable() const;
    QString getQuery() const;

    bool setData(QString columnNameForSearch, QVariant columnValueForSearch,
                 QString columnNameForInsert, QVariant insertData);
    void setTable(QString table);
    void setQuery(QString tableName, QString strquery);

    bool addData(const QVariantList& list);
    bool deleteData(QString columnNameForSearch, QVariant columnValueForSearch);


private:
    QString tableName, strQuery;
    mutable QSqlQuery query;
    mutable QSqlRecord record;

protected:
    static QSqlDatabase db;
};

#endif // DATABASE_H
