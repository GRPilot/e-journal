#pragma once

#include "DBHelper.h"
#include <QtSql>
#include <QBitmap>
#include <vector>
#include <exception>

class ProfileData {
    using Strings = std::vector<QString>;

 public:
    struct Profile_type {
        QString mName;
        Strings mSubjects;
        Strings mGroups;
        QBitmap mProfileImg;
    };


    ProfileData(const QString& username);

    Profile_type currentProfile() const;

 private:
    DBHelper     m_db_users_helper;
    Profile_type m_currentProfile;

    Profile_type getProfileFromDB(const QString& username);
};

