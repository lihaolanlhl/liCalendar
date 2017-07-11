/****************************************************************************
**liCalendar
****************************************************************************/

#include "sqleventmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>
#include <string>
using namespace std;

SqlEventModel::SqlEventModel()
{
    createConnection();
}

void SqlEventModel::addEvents(const QString &event,const QString &startdate,const QString &startime,const QString &stopdate,const QString &stoptime)
{
    QSqlQuery query;
    // We store the time as seconds because it's easier to query.
    const QString addstr = QString::fromLatin1("insert into Event values('%1', '%2', %3, '%4', %5)").arg(event).arg(startdate).arg(startime).arg(stopdate).arg(stoptime);
    query.exec(addstr);
}

void SqlEventModel::dropEvents(const QString &event,const QString &startdate,const QString &startime,const QString &stopdate,const QString &stoptime)
{
    QSqlQuery query;
    // We store the time as seconds because it's easier to query.
    const QString addstr = QString::fromLatin1("insert into Event values('%1', '%2', %3, '%4', %5)").arg(event).arg(startdate).arg(startime).arg(stopdate).arg(stoptime);
    query.exec(addstr);
}

QList<QObject*> SqlEventModel::eventsForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Event WHERE '%1' >= startDate AND '%1' <= endDate").arg(date.toString("yyyy-MM-dd"));
    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    QList<QObject*> events;
    while (query.next()) {
        Event *event = new Event(this);
        event->setName(query.value("name").toString());

        QDateTime startDate;
        startDate.setDate(query.value("startDate").toDate());
        startDate.setTime(QTime(0, 0).addSecs(query.value("startTime").toInt()));
        event->setStartDate(startDate);

        QDateTime endDate;
        endDate.setDate(query.value("endDate").toDate());
        endDate.setTime(QTime(0, 0).addSecs(query.value("endTime").toInt()));
        event->setEndDate(endDate);

        events.append(event);
    }

    return events;
}

void SqlEventModel::createConnection()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("licalendar.db");
    if (!db.open()) {
        qFatal("Cannot open database");
    }
    QSqlQuery query;
    query.exec("create table Event (name TEXT, startDate DATE, startTime INT, endDate DATE, endTime INT)");
    return;
}
