/*
 * TaskManager.hpp
 *
 *  Created on: 22 juil. 2015
 *      Author: pierre
 */

#ifndef TASKMANAGER_HPP_
#define TASKMANAGER_HPP_

#include <bb/cascades/ListView>

class TaskManager : public QObject {
    Q_OBJECT;

private:

    bb::cascades::ListView       *m_TaskList;

public:
     TaskManager          (QObject *parent = 0);
    virtual ~TaskManager ()                      {};



public Q_SLOTS:

    inline void setTaskList     (QObject *list)                  { m_TaskList= dynamic_cast<bb::cascades::ListView*>(list); };



    void deleteTask             (int id);
    void loadList               ();
    void addTask                (const QString& name, const QSting& url, qint64 when, bool reppeat, qint64 spacing);




Q_SIGNALS:



};



#endif /* TASKMANAGER_HPP_ */
