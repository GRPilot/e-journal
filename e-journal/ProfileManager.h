#ifndef PROFILEMANAGER_H
#define PROFILEMANAGER_H

#include "dbprovider.h"
#include "HashHelper.h"

class ProfileManager {
public:
    ProfileManager();
    ~ProfileManager();

    bool createNewUser(const QString &login, const QString &password, const QString &name);
    bool deleteUser(const QString &login, const QString &password);
    bool changePassword(const QString &login, const QString &newPassword);
    QString userLogin(const QString &password, const QString &name);

private:
    DBProvider *m_db_teachers;
    DBProvider *m_db_users;
};

#endif // PROFILEMANAGER_H
