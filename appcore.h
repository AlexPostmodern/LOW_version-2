#ifndef APPCORE_H
#define APPCORE_H

#include <QObject>
#include <QDateTime>
#include <QAxObject>
#include "database.h"
#include "specialquerymodel.h"


class AppCore : public QObject
{
    Q_OBJECT
public:
    explicit AppCore(QObject *parent = nullptr);
    ~AppCore();
public slots:
    int ac_enterInProgram(QString login, QString pass, bool checkState);
    void ac_lastEnter();
    void ac_changeUser();

    static QString ac_GetID();
    static QString ac_GetName();
    static QString ac_GetPass();
    static QString ac_GetLogin();

    void ac_createModelWG();
    void ac_createModelWords(QString id);
    void ac_createModelSearch(QString word);
    void ac_createModelIrregularVerbs();
    void ac_modelQuery(QString model, QString query);

    SpecialQueryModel &ac_GetModelWords()const;
    SpecialQueryModel &ac_GetModelWG()const;
    SpecialQueryModel &ac_GetModelSearch()const;
    SpecialQueryModel &ac_GetModelIrregularVerbs()const;

    //void ac_removeFromModelWG(QString id);
    QString ac_lastRepeat(QString lastRepeat);
    void ac_deleteWG(QString id);

    bool ac_print_word_WG(int idWG);
    bool ac_print_excel_WG(int idWG);


    //TESTING
    void ap_test_irrVerbs();

signals:
    void signal_lastEnter();
private:
    //Database RegUsers;
    static QString idUser,loginUser,nameUser,passUser;
    mutable SpecialQueryModel modelWG, modelWords, modelSearch, modelIrregularVerbs;
    //Database RegUsers;
};

#endif // APPCORE_H
