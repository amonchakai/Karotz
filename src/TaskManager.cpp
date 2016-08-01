/*
 * TaskManager.cpp
 *
 *  Created on: 22 juil. 2015
 *      Author: pierre
 */

#include "TaskManager.hpp"
#include <bb/data/JsonDataAccess>
#include <bb/cascades/GroupDataModel>

TaskManager::TaskManager(QObject *parent) : QObject(parent), m_TaskList(NULL) {

}

void TaskManager::deleteTask(int id) {

}

void TaskManager::addTask(const QString& name, const QSting& url, qint64 when, bool reppeat, qint64 spacing) {
    QString directory = QDir::homePath() + QLatin1String("/ApplicationData/");
    if (!QFile::exists(directory)) {
        QDir dir;
        dir.mkpath(directory);
    }

    QFile file(directory + "/task_list.json");

    QByteArray buffer;
    if (file.open(QIODevice::ReadOnly)) {
        buffer = file.readAll();
        file.close();
    }

    using namespace bb::data;
    JsonDataAccess jda;

    QVariant qtData = jda.loadFromBuffer(buffer);

    if(jda.hasError()) {
        qDebug() << jda.error().errorMessage();
    }

    const QList<QVariant> &list = qtData.toMap()["tasks"].toList();

    if (file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);


        stream << "{\"radios\": [";
        for(int i = 0 ; i < list.size(); ++i) {
            stream << "{\"id\":" + QString::number(i)
                   + ", \"name\":\"" + list.at(i).toMap()["name"].toString()
                  + "\", \"url\":\"" + list.at(i).toMap()["url"].toString()
                  + "\", \"when\":" + list.at(i).toMap()["when"].toString()
                  + "\", \"reppeat\":" + list.at(i).toMap()["reppeat"].toString()
                  + "\", \"spacing\":" + list.at(i).toMap()["spacing"].toString()
            + "},";
        }

        stream << "{\"id\":" + QString::number(list.size()) + ", \"name\":\"" + name + "\", \"url\":\"" + url + "\""
                + "\", \"when\":" + QString::number(when)
                + "\", \"reppeat\":" + QString::number(static_cast<int>(reppeat))
                + "\", \"spacing\":" + QString::number(spacing)
                + "}";

        stream << "]}";

        file.close();
    }

}

void TaskManager::loadList() {

    QString directory = QDir::homePath() + QLatin1String("/ApplicationData/");
    if (!QFile::exists(directory)) {
        QDir dir;
        dir.mkpath(directory);
    }

    QFile file(directory + "/task_list.json");

    QByteArray buffer;
    if (file.open(QIODevice::ReadOnly)) {
        buffer = file.readAll();
        file.close();
    } else {
        return;
    }

    using namespace bb::data;
    JsonDataAccess jda;

    QVariant qtData = jda.loadFromBuffer(buffer);

    if(jda.hasError()) {
        qDebug() << jda.error().errorMessage();
    }


    if(m_TaskList == NULL) {
        qWarning() << "did not received the listview. quit.";
        return;
    }

    using namespace bb::cascades;
    GroupDataModel* dataModel = dynamic_cast<GroupDataModel*>(m_TaskList->dataModel());
    dataModel->clear();
    dataModel->insertList(qtData.toMap()["tasks"].toList());
}

