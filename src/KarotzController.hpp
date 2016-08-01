/*
 * KarotzController.hpp
 *
 *  Created on: 19 juil. 2015
 *      Author: pierre
 */

#ifndef KAROTZCONTROLLER_HPP_
#define KAROTZCONTROLLER_HPP_

class QSettings;
class QNetworkAccessManager;

#include <bb/cascades/ListView>
#include <bb/system/SystemUiResult>
#include "Images/NetImageTracker.h"

class NetImageTracker;

class KarotzController : public QObject {
    Q_OBJECT;

    private:

        QSettings                    *m_Settings;
        QNetworkAccessManager        *m_NetworkAccessManager;
        bb::cascades::ListView       *m_RFIDList;
        bb::cascades::ListView       *m_TTSList;
        bb::cascades::ListView       *m_RadioList;
        NetImageTracker              *m_NetImage;

        QString                       m_IPKarotz;




    public:
        KarotzController              (QObject *parent = 0);
        virtual ~KarotzController     ()                               {};



    public Q_SLOTS:
        bool isLogged                 ();
        void logOut                   ();


        void setIP                    (const QString& ip);
        inline void setRFIDListView   (QObject *list)                  { m_RFIDList = dynamic_cast<bb::cascades::ListView*>(list); };
        inline void setTTSListView    (QObject *list)                  { m_TTSList  = dynamic_cast<bb::cascades::ListView*>(list); };
        inline void setRadioListView  (QObject *list)                  { m_RadioList= dynamic_cast<bb::cascades::ListView*>(list); };
        inline void setNetImage       (QObject *obj)                   { m_NetImage  = dynamic_cast<NetImageTracker*>(obj); };

        void getStatus                ();
        void checkReplyStatus         ();

        void wakeUp                   (int silent);
        void sleep                    ();

        void ledColor                 (const QString &color);
        void ledOff                   ();
        void ledPulse                 (const QString &color1, const QString& color2, int freq);

        void moveEars                 (int left, int right);
        void resetEars                ();
        void randomEars               ();

        void recordNewRFID            (bool record);
        void getRFIDList              ();
        void rfidListReceived         ();
        void deleteRFID               (const QString& id);
        void editTag                  (const QString& id, const QString& name, int color);
        void programRFID              (const QString& id, const QString& name, const QString& url, const QString& params);

        void getTTSList               ();
        void ttsListReceived          ();
        void speak                    (const QString& text, const QString& voice, bool cache);
        void clearTTSCache            ();

        void takePicture              ();
        void pictureTaken             ();
        void takeUploadPicture        (const QString& ip, const QString& user, const QString& password, const QString& dir);

        void getRadioList             ();
        void saveNewRadio             (const QString& name, const QString& url);
        void updateRadio              (int id, const QString& name, const QString& url);
        void deleteRadio              (int id);
        void playUrl                  (const QString& url);

    Q_SIGNALS:

        void loggedIn       ();
        void completed      ();
        void sleepStatus    (int status);

        void noKarotz       ();




};


#endif /* KAROTZCONTROLLER_HPP_ */
