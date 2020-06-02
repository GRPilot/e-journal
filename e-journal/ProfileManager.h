#pragma once

#include "DBHelper.h"
#include "HashHelper.h"
#include <QtSql>

class ProfileManager {
 public:
    ProfileManager();

    bool createNewUser(const QString &username, const QString &password);
    bool deleteUser(const QString &username, const QString &password);

    bool checkUser(const QString &username);
    bool checkPassAndUser(const QString& username, const QString& password);

    bool setUserName(const QString &username, const QString& newName);

 private:
    DBHelper m_db_teachers_helper;
    DBHelper m_db_users_helper;

    bool exec(const QString& query, const QString& pathToDatabase);
    bool exsist(const QString& query, const QString& pathToDatabase);
    int  getUserID(const QString& username);
};
