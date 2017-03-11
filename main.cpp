#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "sqleventmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    qmlRegisterType<SqlEventModel>("org.licomm.calendar", 1, 0, "SqlEventModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
