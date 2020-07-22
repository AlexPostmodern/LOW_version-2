#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "database.h"
#include "appcore.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    Database::db_createConnection(QDir::currentPath()+"/source/LOW.db");
    Database db;
    QQmlApplicationEngine engine;
    AppCore appcore;
    QQmlContext *contex=engine.rootContext();
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    QObject::connect(&engine, &QQmlApplicationEngine::quit, &QGuiApplication::quit);
    contex->setContextProperty("AppCore",&appcore);
    contex->setContextProperty("db", &db);
    contex->setContextProperty("modelWG",&appcore.ac_GetModelWG());
    contex->setContextProperty("modelWords",&appcore.ac_GetModelWords());
    contex->setContextProperty("modelSearch",&appcore.ac_GetModelSearch());
    contex->setContextProperty("modelIrregularVerbs",&appcore.ac_GetModelIrregularVerbs());
    engine.load(url);
    appcore.ac_lastEnter();
    return app.exec();
}

