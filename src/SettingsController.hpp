/*
 * AppSettings.hpp
 *
 *  Created on: 16 oct. 2014
 *      Author: pierre
 */

#ifndef APPSETTINGS_HPP_
#define APPSETTINGS_HPP_

#include <QtCore/QObject>
#include <QSettings>
#include <bb/system/SystemUiResult>

class SettingsController : public QObject {
    Q_OBJECT;


    Q_PROPERTY( QString userName     READ getUserName        WRITE setUserName       NOTIFY  userNameChanged)
    Q_PROPERTY( int     theme        READ getTheme           WRITE setTheme          NOTIFY  themeChanged)

private:

     QString            m_User;
     int                m_Theme;

     QSettings          *m_Settings;

public:
    SettingsController          (QObject *parent = 0);
    virtual ~SettingsController ()                      {};

    inline const QString &getUserName() const               { return m_User; }
    inline void           setUserName(const QString &c)     { m_User = c; emit userNameChanged(); }

    inline int            getTheme() const                  { return m_Theme; }
    inline void           setTheme(int c)                   { m_Theme = c; emit themeChanged(); }



public Q_SLOTS:
    void save();


Q_SIGNALS:

    void userNameChanged();
    void themeChanged();

};


#endif /* APPSETTINGS_HPP_ */
