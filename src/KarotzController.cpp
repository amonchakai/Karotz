/*
 * KarotzController.cpp
 *
 *  Created on: 19 juil. 2015
 *      Author: pierre
 */

#include "KarotzController.hpp"

#include <QSettings>
#include <QRegExp>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>

#include <bb/system/SystemToast>
#include <bb/data/JsonDataAccess>
#include <bb/cascades/GroupDataModel>
#include <bb/system/SystemPrompt>

KarotzController::KarotzController(QObject *parent) : QObject(parent), m_NetImage(NULL) {

    m_Settings = new QSettings("Amonchakai", "Karotz");
    m_NetworkAccessManager = new QNetworkAccessManager(this);


    m_IPKarotz = m_Settings->value("IP_Karotz", "").toString();

}



bool KarotzController::isLogged() {
    return !m_Settings->value("IP_Karotz", "").toString().isEmpty();
}

void KarotzController::logOut() {
    m_Settings->setValue("IP_Karotz", "");
}

void KarotzController::setIP(const QString& ip) {
    if(ip.isEmpty()) {

        bb::system::SystemToast *toast = new bb::system::SystemToast(this);

        toast->setBody(tr("You need to provide an IP!"));
        toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
        toast->show();
        return;
    }

    QRegExp ipCheck("([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})");
    if(ipCheck.indexIn(ip) == -1) {
        bb::system::SystemToast *toast = new bb::system::SystemToast(this);

        toast->setBody(tr("The IP format is not valid! It should be something like \"192.168.2.105\""));
        toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
        toast->show();
        return;
    }

    for(int i = 1 ; i < 5 ; ++i) {
        if(ipCheck.cap(i).toInt() > 255) {
            bb::system::SystemToast *toast = new bb::system::SystemToast(this);

            toast->setBody(tr("The IP address is not valid! Each number should be smaller than 256!"));
            toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
            toast->show();
            return;
        }
    }

    m_Settings->setValue("IP_Karotz", ipCheck.cap(1) + "." + ipCheck.cap(2) + "." + ipCheck.cap(3) + "." + ipCheck.cap(4));

    emit loggedIn();
}



void KarotzController::getStatus() {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/status");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), this, SLOT(checkReplyStatus()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::checkReplyStatus() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply) {
        if (reply->error() == QNetworkReply::NoError) {
            const int available = reply->bytesAvailable();
            if (available > 0) {
                const QByteArray buffer(reply->readAll());

                using namespace bb::data;
                JsonDataAccess jda;

                QVariant qtData = jda.loadFromBuffer(buffer);

                if(jda.hasError()) {
                    qDebug() << jda.error().errorMessage();
                }


                emit sleepStatus(qtData.toMap()["sleep"].toInt());


            }



        } else {
            qDebug() << "denied";
            emit noKarotz();

        }

        reply->deleteLater();
    }
}

void KarotzController::wakeUp(int silent) {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/wakeup" + (silent == 1 ? "?silent=1" : ""));

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);

    emit sleepStatus(0);
}


void KarotzController::sleep() {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/sleep" );

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);

    emit sleepStatus(1);
}


void KarotzController::ledColor(const QString &color) {

    QRegExp validColor("([0-9A-Fa-f]{6})");
    if(validColor.indexIn(color) == -1) {
        bb::system::SystemToast *toast = new bb::system::SystemToast(this);

        toast->setBody(tr("The color is not valid. It should be formatted as \"00FFFF\""));
        toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
        toast->show();
        return;
    }


    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/leds?color=" + validColor.cap(1));

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);

}

void KarotzController::ledOff() {
    ledColor("000000");
}


void KarotzController::ledPulse(const QString &color1, const QString& color2, int freq) {
    QRegExp validColor1("([0-9A-Fa-f]{6})");
    if(validColor1.indexIn(color1) == -1) {
        bb::system::SystemToast *toast = new bb::system::SystemToast(this);

        toast->setBody(tr("The main color is not valid. It should be formatted as \"00FFFF\""));
        toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
        toast->show();
        return;
    }

    QRegExp validColor2("([0-9A-Fa-f]{6})");
    if(validColor2.indexIn(color2) == -1) {
        bb::system::SystemToast *toast = new bb::system::SystemToast(this);

        toast->setBody(tr("The secondary color is not valid. It should be formatted as \"00FFFF\""));
        toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
        toast->show();
        return;
    }


    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/leds?pulse=1&color=" + validColor1.cap(1) + "&speed=" + QString::number(freq) + "&color2=" + validColor2.cap(1));

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}


void KarotzController::moveEars(int left, int right) {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/ears?" +
             "left=" + QString::number(left) +
            "&right=" + QString::number(right) +
            "&noreset=1"
    );

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::resetEars() {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/ears_reset");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);

}

void KarotzController::randomEars() {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/ears_random");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::recordNewRFID(bool record) {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/rfid_" + (record ? "start" : "stop") + "_record");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::getRFIDList() {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/rfid_list_ext");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), this, SLOT(rfidListReceived()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::rfidListReceived() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply) {
        if (reply->error() == QNetworkReply::NoError) {
            const int available = reply->bytesAvailable();
            if (available > 0) {
                const QByteArray buffer(reply->readAll());

                using namespace bb::data;
                JsonDataAccess jda;

                QVariant qtData = jda.loadFromBuffer(buffer);

                if(jda.hasError()) {
                    qDebug() << jda.error().errorMessage();
                }


                if(m_RFIDList == NULL) {
                    qWarning() << "did not received the RFIDList. quit.";
                    reply->deleteLater();
                    return;
                }

                using namespace bb::cascades;
                GroupDataModel* dataModel = dynamic_cast<GroupDataModel*>(m_RFIDList->dataModel());
                dataModel->clear();
                dataModel->insertList(qtData.toMap()["tags"].toList());
            }

        } else {
            qDebug() << "denied";
            emit noKarotz();

        }

        reply->deleteLater();
    }
}


void KarotzController::deleteRFID(const QString& id) {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/rfid_delete?tag=" + id);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::editTag(const QString& id, const QString& name, int color) {
    bb::system::SystemToast *toast = new bb::system::SystemToast(this);

    toast->setBody(tr("Done!"));
    toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
    toast->show();

    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/rfid_rename?tag=" + id + "&name=" + name + "&color=" + QString::number(color));

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::programRFID(const QString& id, const QString& name, const QString& url_str, const QString& params) {
    bb::system::SystemToast *toast = new bb::system::SystemToast(this);

    toast->setBody(tr("Done!"));
    toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
    toast->show();

    QString action_url = url_str;
    if(action_url.mid(0,4) != "http") {
        action_url = "http://" + m_Settings->value("IP_Karotz").toString() + url_str;
    }

    qDebug() << "http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/rfid_assign_url?tag=" + id + "&name=" + name + "&url=" + action_url + (params.isEmpty() ? "" : ("?" + params));
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/rfid_assign_url?tag=" + id + "&name=" + name + "&url=" + action_url + (params.isEmpty() ? "" : ("?" + params)));

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}


void KarotzController::getTTSList () {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/display_cache");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), this, SLOT(ttsListReceived()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}


void KarotzController::ttsListReceived () {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply) {
        if (reply->error() == QNetworkReply::NoError) {
            const int available = reply->bytesAvailable();
            if (available > 0) {
                const QByteArray buffer(reply->readAll());

                using namespace bb::data;
                JsonDataAccess jda;

                QVariant qtData = jda.loadFromBuffer(buffer);

                if(jda.hasError()) {
                    qDebug() << jda.error().errorMessage();
                }


                if(m_TTSList == NULL) {
                    qWarning() << "did not received the RFIDList. quit.";
                    reply->deleteLater();
                    return;
                }

                using namespace bb::cascades;
                GroupDataModel* dataModel = dynamic_cast<GroupDataModel*>(m_TTSList->dataModel());
                dataModel->clear();
                dataModel->insertList(qtData.toMap()["cache"].toList());
            }

        } else {
            qDebug() << "denied";
            emit noKarotz();

        }

        reply->deleteLater();
    }
}

void KarotzController::speak(const QString& text, const QString& voice, bool cache) {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/tts?voice=" + voice + "&text=" + text +"&nocache=" + (cache ? "0" : "1") );

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::clearTTSCache() {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/clear_cache");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}


void KarotzController::takePicture() {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/snapshot?silent=1");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), this, SLOT(pictureTaken()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

void KarotzController::pictureTaken() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply) {
        if (reply->error() == QNetworkReply::NoError) {
            const int available = reply->bytesAvailable();
            if (available > 0) {
                const QByteArray buffer(reply->readAll());

                using namespace bb::data;
                JsonDataAccess jda;

                QVariant qtData = jda.loadFromBuffer(buffer);

                if(jda.hasError()) {
                    qDebug() << jda.error().errorMessage();
                }

                if(m_NetImage)
                    m_NetImage->setSource("http://" + m_Settings->value("IP_Karotz").toString()  + "/snapshots/" + qtData.toMap()["filename"].toString());
            }

        } else {
            qDebug() << "denied: " << reply->errorString();
            emit noKarotz();

        }

        reply->deleteLater();
    }
}

void KarotzController::takeUploadPicture(const QString& ip, const QString& user, const QString& password, const QString& dir) {
    if(ip.isEmpty()) {

        bb::system::SystemToast *toast = new bb::system::SystemToast(this);

        toast->setBody(tr("You need to provide an IP!"));
        toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
        toast->show();
        return;
    }

    QRegExp ipCheck("([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})");
    if(ipCheck.indexIn(ip) == -1) {
        bb::system::SystemToast *toast = new bb::system::SystemToast(this);

        toast->setBody(tr("The IP format is not valid! It should be something like \"192.168.2.105\""));
        toast->setPosition(bb::system::SystemUiPosition::MiddleCenter);
        toast->show();
        return;
    }


    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/snapshot_ftp?server=" + ip + "&user=" + user + "&password=" + password +"&remote_dir=" + dir + "&silent=1");

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}


void KarotzController::getRadioList() {

    QString directory = QDir::homePath() + QLatin1String("/ApplicationData/Radio");
    if (!QFile::exists(directory)) {
        QDir dir;
        dir.mkpath(directory);
    }

    QFile file(directory + "/radio_list.json");

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


    if(m_RadioList == NULL) {
        qWarning() << "did not received the RFIDList. quit.";
        return;
    }

    using namespace bb::cascades;
    GroupDataModel* dataModel = dynamic_cast<GroupDataModel*>(m_RadioList->dataModel());
    dataModel->clear();
    dataModel->insertList(qtData.toMap()["radios"].toList());
}

void KarotzController::saveNewRadio(const QString& name, const QString& url) {
    QString directory = QDir::homePath() + QLatin1String("/ApplicationData/Radio");
    if (!QFile::exists(directory)) {
        QDir dir;
        dir.mkpath(directory);
    }

    QFile file(directory + "/radio_list.json");

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

    const QList<QVariant> &list = qtData.toMap()["radios"].toList();

    if (file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);


        stream << "{\"radios\": [";
        for(int i = 0 ; i < list.size(); ++i) {
            stream << "{\"id\":" + QString::number(i) + ", \"name\":\"" + list.at(i).toMap()["name"].toString() + "\", \"url\":\"" + list.at(i).toMap()["url"].toString() + "\"},";
        }

        stream << "{\"id\":" + QString::number(list.size()) + ", \"name\":\"" + name + "\", \"url\":\"" + url + "\"}";

        stream << "]}";

        file.close();
    }
}

void KarotzController::updateRadio(int id, const QString& name, const QString& url) {
    QString directory = QDir::homePath() + QLatin1String("/ApplicationData/Radio");
    if (!QFile::exists(directory)) {
        QDir dir;
        dir.mkpath(directory);
    }

    QFile file(directory + "/radio_list.json");

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

    const QList<QVariant> &list = qtData.toMap()["radios"].toList();

    if (file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);

        bool added = false;
        stream << "{\"radios\": [";
        for(int i = 0 ; i < list.size(); ++i) {
            if(added)
                stream << ",";
            if(i == id)
                stream << "{\"id\":" + QString::number(i) + ", \"name\":\"" + name + "\", \"url\":\"" + url + "\"}";
            else
                stream << "{\"id\":" + QString::number(i) + ", \"name\":\"" + list.at(i).toMap()["name"].toString() + "\", \"url\":\"" + list.at(i).toMap()["url"].toString() + "\"}";
            added = true;
        }

        stream << "]}";

        file.close();
    }
}

void KarotzController::deleteRadio(int id) {
    QString directory = QDir::homePath() + QLatin1String("/ApplicationData/Radio");
    if (!QFile::exists(directory)) {
        QDir dir;
        dir.mkpath(directory);
    }

    QFile file(directory + "/radio_list.json");

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

    const QList<QVariant> &list = qtData.toMap()["radios"].toList();

    if (file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);


        bool added = false;
        stream << "{\"radios\": [";
        for(int i = 0 ; i < list.size(); ++i) {
            if(added)
                stream << ",";
            if(list.at(i).toMap()["id"].toInt() != id) {
                stream << "{\"id\":" + QString::number(i) + ", \"name\":\"" + list.at(i).toMap()["name"].toString() + "\", \"url\":\"" + list.at(i).toMap()["url"].toString() + "\"}";
                added = true;
            }
        }

        stream << "]}";

        file.close();
    }

    getRadioList();
}

void KarotzController::playUrl (const QString& url_str) {
    const QUrl url("http://" + m_Settings->value("IP_Karotz").toString()  + "/cgi-bin/sound?url=?" + url_str);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");


    QNetworkReply* reply = m_NetworkAccessManager->get(request);
    bool ok = connect(reply, SIGNAL(finished()), reply, SLOT(deleteLater()));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}






