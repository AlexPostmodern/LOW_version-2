#include "database.h"

QSqlDatabase Database::db;

Database::Database(const QString tableName)
{
    this->tableName=tableName;
    strQuery="select * from "+tableName;
    query.exec(strQuery);
    record=query.record();
}

Database::Database(QString tableName, QString strquery)
{
    this->tableName=tableName;
    strQuery=strquery;
    query.exec(strQuery);
    record=query.record();
}

Database::Database(const Database &other)
{
    this->tableName=other.tableName;
    this->strQuery=other.strQuery;
    this->query=other.query;
    this->record=other.record;
}

bool Database::db_createConnection(QString path)
{
    qDebug()<<path;
    db=QSqlDatabase::addDatabase("QSQLITE");    //название драйвера
    db.setDatabaseName(path);                   //указываем имя(в моем случае это адрес для библиотеки)
    db.open();                                  //функция подклюения к бд
    if(!db.open())                              //проверка подключения
    {
        qDebug()<<db.lastError().text();
        return false;
    }
    else
        qDebug()<<"Success!";
    return true;
}

QVariant Database::getData(QString columnNameForSearch,
                           QVariant columnValueForSearch, QString columnNameForReturn) const
{
    query.exec(strQuery);
    record=query.record();
    QVariant data;
    if (record.contains(columnNameForReturn)&&record.contains(columnNameForSearch))
    {
        query.first();
        if(query.value(record.indexOf(columnNameForSearch))==columnValueForSearch)
        {
            data = query.value(record.indexOf(columnNameForReturn));
            return data;
        }
        while (query.next())
        {
            if(query.value(record.indexOf(columnNameForSearch))==columnValueForSearch)
            {
                data = query.value(record.indexOf(columnNameForReturn));
                break;
            }
        }
        return data;
    }
    else
    {
        qDebug()<<"RegUsers::getData(): column '"+columnNameForReturn+"' or '"+columnNameForSearch+"' is not exist!";
        data.isNull();
        return data;
    }
}

QString Database::getTable()const
{
    return tableName;
}

QString Database::getQuery()const
{
    return strQuery;
}

bool Database::setData(QString columnNameForSearch,
                       QVariant columnValueForSearch, QString columnNameForInsert, QVariant insertData)
{
    query.exec(strQuery);
    record=query.record();
    if (record.contains(columnNameForSearch)&&record.contains(columnNameForInsert))
    {
        query.first();
        if(query.value(record.indexOf(columnNameForSearch))==columnValueForSearch)
        {
            query_exec("update "+tableName+" set "+columnNameForInsert+"='"+insertData.toString()+"'"
                       " where "+columnNameForSearch+"='"+columnValueForSearch.toString()+"'");
        }
        while (query.next())
        {
            if(query.value(record.indexOf(columnNameForSearch))==columnValueForSearch)
            {
                query_exec("update "+tableName+" set "+columnNameForInsert+"='"+insertData.toString()+"'"
                           " where "+columnNameForSearch+"='"+columnValueForSearch.toString()+"'");
                break;
            }
        }
        return true;
    }
    else
    {
        qDebug()<<"RegUsers::setData(): column '"+columnNameForSearch+"' or '"+columnNameForInsert+"' is not exist!";
        return false;
    }
}

void Database::setTable(QString table)
{
    this->tableName=table;
    strQuery="select * from "+tableName;
}

void Database::setQuery(QString tableName, QString strquery)
{
    this->tableName=tableName;
    strQuery=strquery;
}

bool Database::addData(const QVariantList &list)
{
    query.exec(strQuery);
    record=query.record();
    QString strquery="insert into ";
    QString strquery2=" values (";
    strquery.append(tableName+" (");

    for(int i=1;i<record.count();i++)
    {
        if (i==record.count()-1)
        {
            strquery.append(record.fieldName(i)+")");
            if ((i)>list.count())
                strquery2.append("null)");
            else
                strquery2.append("'"+list.at(i-1).toString()+"')");
            break;
        }
        else
        {
            strquery.append(record.fieldName(i)+",");
            if ((i)>list.count())
                strquery2.append("null,");
            else
                strquery2.append("'"+list.at(i-1).toString()+"',");
        }
    }
    qDebug()<<strquery+strquery2;
    QSqlQuery qq(db);
    if(qq.exec(strquery+strquery2))
        return true;
    else
        return false;
}

bool Database::deleteData(QString columnNameForSearch, QVariant columnValueForSearch)
{
    QSqlQuery query(db);
    if(query.exec("delete from "+tableName+" where "+columnNameForSearch+"='"+columnValueForSearch.toString()+"'"))
        return true;
    else
        return false;
}

QVariant Database::query_returnValue(QString strquery)
{
    QVariant data;
    QSqlQuery query(db);
    query.exec(strquery);
    while (query.next())
        data=query.value(0);
    return data;
}

QSqlQuery Database::query_return(QString strquery)
{
    QSqlQuery query(db);
    query.exec(strquery);
    return query;
}

bool Database::query_exec(QString strquery)
{
    QSqlQuery query(db);
    if(query.exec(strquery))
        return true;
    else
        return false;
}

void Database::transaction(QString open_commit_rollback)
{
    if (open_commit_rollback=="open")
        db.transaction();
    if(open_commit_rollback=="commit")
        db.commit();
    if(open_commit_rollback=="rollback")
        db.rollback();
}


