/*
 * AppSettings.cpp
 *
 *  Created on: 16 oct. 2014
 *      Author: pierre
 */


#include "SettingsController.hpp"



SettingsController::SettingsController(QObject *parent) : QObject(parent), m_Settings(NULL) {

     m_Settings = new QSettings("Amonchakai", "Karotz");

    m_Theme = m_Settings->value("theme").value<int>();
    m_User = m_Settings->value("IP_Karotz").toString();

}


void SettingsController::save() {
    m_Settings->setValue("theme", m_Theme);
    m_Settings->setValue("IP_Karotz", m_User);

}





