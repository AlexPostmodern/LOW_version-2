#include "appcore.h"
QString AppCore::idUser;
QString AppCore::loginUser;
QString AppCore::passUser;
QString AppCore::nameUser;

AppCore::AppCore(QObject *parent) : QObject(parent){}

AppCore::~AppCore(){}

//ВХОД В ПРОГРАММУ
int AppCore::ac_enterInProgram(QString login, QString pass, bool checkState)
{ 
    enum returnArg {SUCCESS,PASS,LOGIN};
    Database RegUsers("RegUsers");
    if (RegUsers.getData("login",login,"id").isValid())
    {
        if (RegUsers.getData("login",login,"id")==RegUsers.getData("password",pass,"id"))
        {
            idUser=RegUsers.getData("login",login,"id").toString();
            loginUser=login;
            passUser=pass;
            nameUser=RegUsers.getData("id",idUser,"name").toString();
            if(checkState)
                RegUsers.setData("id",idUser,"lastEnter",1);
            qDebug()<<"RIGHT! id ="<<idUser<<"login ="<<loginUser<<"pass ="<<passUser<<"name ="<<nameUser<<"checkState ="<<checkState;
            return SUCCESS;
        }
        else
        {
            qDebug()<<"Password is not correct";
            return PASS;
        }
    }
    else
    {
        qDebug()<<"User is NOT exist";
        return LOGIN;
    }
}


//ПРОВЕРКА lastEnter
void AppCore::ac_lastEnter()
{    
    int id = Database::query_returnValue("select id from RegUsers where lastEnter=1").toInt();
    if(id)
    {
        Database db("RegUsers");
        idUser=QString::number(id);
        loginUser=db.getData("id",id,"login").toString();
        passUser=db.getData("id",id,"password").toString();
        nameUser=db.getData("id",id,"name").toString();
        qDebug()<<"lastEnter = 1 id ="<<idUser<<"login ="<<loginUser<<"pass ="<<passUser<<"name ="<<nameUser;
        emit signal_lastEnter();
    }
    else
        qDebug()<<"all lastEnter = 0";
}

//СМЕНИТЬ ПОЛЬЗОВАТЕЛЯ
void AppCore::ac_changeUser()
{
    Database le("RegUsers");
    le.setData("id",idUser,"lastEnter",0);
    //db->db_Query("update RegUsers set lastEnter=0 where id="+idUser);
}

//ГЕТЕРЫ ДЛЯ ПРИВАТ ПОЛЕЙ
QString AppCore::ac_GetID()
{
    return idUser;
}

QString AppCore::ac_GetName()
{
    return nameUser;
}

QString AppCore::ac_GetPass()
{
    return passUser;
}

QString AppCore::ac_GetLogin()
{
    return loginUser;
}

SpecialQueryModel & AppCore::ac_GetModelWG()const
{
    return modelWG;
}

SpecialQueryModel &AppCore::ac_GetModelSearch()const
{
    return modelSearch;
}

SpecialQueryModel & AppCore::ac_GetModelWords()const
{
    return modelWords;
}

SpecialQueryModel & AppCore::ac_GetModelIrregularVerbs()const
{
    return modelIrregularVerbs;
}

//ПРИСВОЕНИЕ ЗАПРОСА МОДЕЛЯМ
void AppCore::ac_createModelWG()
{
    //modelWG=new SpecialQueryModel("select * from WordGroup where userid="+idUser);
    modelWG.sqm_SetQuery("select * from WordGroup where userid="+idUser);
}

void AppCore::ac_createModelWords(QString id)
{
    modelWords.sqm_SetQuery("select * from Words where wordid="+id);
    //проверка
    /*qDebug()<<"modelWords roleNames: "<<modelWords.roleNames();
    QModelIndex index = modelWords.index(1, 1);
    qDebug()<<"checking of modelWords (1,1) "<<index.data(Qt::DisplayRole).toString();*/
}

void AppCore::ac_createModelSearch(QString word)
{
    /*modelSearch.sqm_SetQuery("select w.id as id, wg.id as idWG, wg.name as nameWG, w.russian as russian, w.english as english, w.progress as progress "
                             "from RegUsers as rg left outer join WordGroup as wg on rg.id=wg.userid "
                             "join Words as w on wg.id=w.wordid where (rg.id="+idUser+" and (russian like '"+word+"%' "
                             "or english like '"+word+"%')) order by wg.name;");*/

    modelSearch.sqm_SetQuery("select * from selectWords where (userid="+idUser+" and (russian like '"+word+"%' "
                                "or english like '"+word+"%')) order by nameWG;");
}

void AppCore::ac_createModelIrregularVerbs()
{
    modelIrregularVerbs.sqm_SetQuery("select * from IrregularVerbs");
}

void AppCore::ac_modelQuery(QString model, QString query)
{
    if (model=="modelSearch")
        modelSearch.sqm_SetQuery(query);
    else if (model=="modelWG")
        modelWG.sqm_SetQuery(query);
    else if (model=="modelWords")
        modelWords.sqm_SetQuery(query);
}


//УДАЛЕНИЕ ИЗ МОДЕЛЕЙ ЭЛЕМЕНТОВ
/*void AppCore::ac_removeFromModelWG(QString id)
{
    QModelIndex idx;
    for(int i=0;i<(db->db_QueryRecordOneNumber("select count(*) from WordGroup where userid="+idUser,0,0).toInt());i++)
    {
        idx=modelWG.index(i,0);
        if(idx.data(Qt::DisplayRole).toString()==id)
        {
            qDebug()<<"ID ="<<i;
            modelWG.removeRow(i);
        }
    }
}*/

//ОТОБРАЖЕНИЕ ПОСЛЕДНЕГО ПОВТОРЕНИЯ НАБОРА
QString AppCore::ac_lastRepeat(QString lastRepeat)
{
    QDateTime repeatTime=QDateTime::fromString(lastRepeat,"yyyy.MM.dd HH:mm:ss");
    QDateTime currentTime(QDateTime::currentDateTime());
    QVariant daysGone(repeatTime.daysTo(currentTime));
    switch(daysGone.toInt())
    {
    case 0:
        return "сегодня";
    case 1:
        return "вчера";
    case 2:
        return "позавчера";
    }

    if (daysGone.toInt() >10 &&daysGone.toInt() < 20)
        return daysGone.toString()+" дней назад";

    else if (daysGone.toString().endsWith("1"))
        return daysGone.toString()+" дeнь назад";

    else if (daysGone.toString().endsWith("2")||daysGone.toString().endsWith("3")
             ||daysGone.toString().endsWith("4"))
        return daysGone.toString()+" дня назад";

    else
        return daysGone.toString()+" дней назад";
}

//УДАЛИТЬ НАБОР
void AppCore::ac_deleteWG(QString id)
{
    Database db("Words");
    db.deleteData("wordid",id);
    db.setTable("WordGroup");
    db.deleteData("id",id);

//    db->db_Transaction("open");
//    db->db_Query("delete from Words where wordid="+id);
//    db->db_Query("delete from WordGroup where id="+id);
//    db->db_Transaction("commit");
}


//ПЕЧАТЬ
bool AppCore::ac_print_word_WG(int idWG)
{    
    QAxObject *word = new QAxObject(this);
    word->setControl("Word.Application");
    if (word->isNull())
    {
        qDebug()<<"word is not exist";
        return false;
    }
    QAxObject *docs = word->querySubObject("Documents");
    QAxObject *doc = docs->querySubObject("Add()");
    QAxObject *ActiveDocument = word->querySubObject("ActiveDocument()");
    QAxObject *range = ActiveDocument->querySubObject("Range()");
    QAxObject *font = range->querySubObject("Font");
    int first=0,second=100;
    range->dynamicCall("SetRange(int,int)",first,second);
    first++;
    Database db("WordGroup");
    range->setProperty("Text","Название набора - "+db.getData("id",idWG,"name").toString()+"\n\n");
    font->setProperty("Size",18);
    font->setProperty("Bold",true);
    QAxObject* pswds = range->querySubObject ("ParagraphFormat ()");
    pswds->dynamicCall ("SetAlignment (WdParagraphAlignment)", 1);
    range->setProperty("Alignment",1);
    QSqlQuery query=Database::query_return("select *from Words where wordid="+QString::number(idWG));//db->db_ReturnQuery("select *from Words where wordid="+QString::number(idWG));
    while (query.next())
    {
        second+=100;
        first+=100;
        range->dynamicCall("SetRange(int,int)",first,second);
        range->setProperty("Text", query.value(2).toString()+" - "+query.value(1).toString()+"\n");
        font->setProperty("Size",14);
        font->setProperty("Bold",false);
        pswds->dynamicCall ("SetAlignment (WdParagraphAlignment)", 0);
        range->setProperty("Alignment",0);
    }
    word->setProperty("Visible", true);
    delete pswds; delete font; delete range; delete ActiveDocument; delete doc; delete docs; delete word;
    qDebug()<<"word is exist";
    return true;
}

//работа с ексель или ворд, почти тоже самое что и в делфи с OLE
bool AppCore::ac_print_excel_WG(int idWG)
{
    //путь к exe-файлу
    QString path= QDir::currentPath();

    //создаем указатель на приложение
    QAxObject *excel = new QAxObject(this);

    //выбираем тип приложения
    excel->setControl("Excel.Application");

    //проверка установлен ли ексель на компьютере
    if (excel->isNull())
    {
        qDebug()<<"false, excel is not exist";
        return false;
    }

    //колекция книг
    QAxObject *books = excel->querySubObject("Workbooks");

    //открываем шаблон
    QAxObject *bookTemp = books->querySubObject("Open(QString)",path+"/source/template.xls");

    //колекция листов
    QAxObject *sheets = bookTemp->querySubObject("Sheets");

    //выбираем нужный лист
    QAxObject *sheetTemp = sheets->querySubObject("Item(int)", 1);

    //создаем новую книгу
    QAxObject *bookNew = books->querySubObject("Add()");

    //колекция листов
    sheets = bookNew->querySubObject("Sheets");

    //выбираем нужный лист
    QAxObject *sheetNew = sheets->querySubObject("Item(int)", 1);

    //копируем лист из шаблона в новую книгу
    sheetTemp->dynamicCall("Copy(QVariant)",sheetNew->asVariant());

    //закрываем шаблон
    bookTemp->dynamicCall("Close");

    //удаляем указатели на шаблон
    delete sheetTemp; delete bookTemp;

    //выбираем нужный лист
    sheetNew = sheets->querySubObject("Item(int)", 1);

    //выбираем ячейку
    QAxObject *cell = sheetNew->querySubObject("Cells(int,int)",1,1);

    //присваеваем значения
    Database db("WordGroup");
    cell->setProperty("Value", db.getData("id",idWG,"name").toString());
    cell = sheetNew->querySubObject("Cells(int,int)",2,1);
    cell->setProperty("Value", QVariant("На английском"));
    cell = sheetNew->querySubObject("Cells(int,int)",2,2);
    cell->setProperty("Value", QVariant("На русском"));
    int row=2;
    QSqlQuery query=Database::query_return("select * from Words where wordid="+QString::number(idWG));//db->db_ReturnQuery("select * from Words where wordid="+QString::number(idWG));
    while (query.next())
    {
        row++;
        cell = sheetNew->querySubObject("Cells(int,int)",row,1);
        cell->setProperty("Value", query.value(2).toString());
        cell = sheetNew->querySubObject("Cells(int,int)",row,2);
        cell->setProperty("Value", query.value(1).toString());
    }

    //выбираем интервал ячеек
    cell=sheetNew->querySubObject("Range(QString,QString)", "A4", "B"+QString::number(row));

    //создаем указатель на класс границ
    QAxObject *border = cell->querySubObject("Borders");

    //изменяем свойство этого класса, стиль границ
    border->setProperty("LineStyle",1);

    //делаем видимым приложение ексель после всех изменений
    excel->setProperty("Visible",true);

    //очищаем выделенную память
    delete border; delete cell; delete sheetNew; delete sheets; delete bookNew; delete books; delete excel;
    qDebug()<<"true, excel is exist";
    return true;
}


//заполнение базы данных неправильными глаголами
void AppCore::ap_test_irrVerbs()
{
    QString path= QDir::currentPath()+"/source/irregularVerbs.xlsx";
    QAxObject *excel=new QAxObject(this);
    excel->setControl("Excel.Application");
    QAxObject *books = excel->querySubObject("Workbooks");
    QAxObject *bookTemp = books->querySubObject("Open(QString)",path);
    QAxObject *sheets = bookTemp->querySubObject("Sheets");
    QAxObject *sheetTemp = sheets->querySubObject("Item(int)", 1);
    QAxObject *range = sheetTemp->querySubObject("Cells(int,int)",1,1);
    int second;
    Database db("IrregularVerbs");
    QVariantList list;
    QString firstStr;
    bool list1=false,list2=false;
    QStringList listStr, listStr2;
    Database::transaction(transactions::OPEN);
    for (int i=1;i<295;i++)
    {
        second=4;
        range=sheetTemp->querySubObject("Cells(int,int)",i,second);
        list.append(range->property("Value"));
        second=1;
        for (int j=1; j<4;j++,second++)
        {
            range=sheetTemp->querySubObject("Cells(int,int)",i,second);
            firstStr=range->property("Value").toString();
            if(j!=1 && firstStr.contains(";"))
            {
                switch(j)
                {
                    case 2:
                        listStr=firstStr.split(";");
                        listStr[1]=listStr[1].simplified();
                        list.append(listStr[0]);
                        list1=true;
                        break;
                    case 3:
                        listStr2=firstStr.split(";");
                        listStr2[1]=listStr2[1].simplified();
                        list.append(listStr2[0]);
                        list2=true;
                        break;
                }
            }
            else
                list.append(firstStr);
        }

        list1 ? list.append(listStr[1]): list.append("");
        list2 ? list.append(listStr2[1]): list.append("");
        listStr.clear();
        listStr2.clear();
        list1=list2=false;
        if(!db.addData(list))
        {
            qDebug()<<"FAILED!";
            break;
        }
        list.clear();
    }
    Database::transaction(transactions::COMMIT);
    books->dynamicCall("Close");
    delete range; delete sheetTemp; delete sheets;
    delete bookTemp; delete books; delete excel;
}


