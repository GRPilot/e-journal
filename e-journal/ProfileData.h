/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * ProfileData работает с получением данных из базы данных и предоставлении    *
 * этих данных в классы, которые связаны с qml                                 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#pragma once

#include "QueryBuilder.h"
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

    /// Возвращает данные о пользователе в виде условного "пакета" с данными
    Profile_type currentProfile() const;

 private:
    QueryBuilder m_queryUsersBuilder;
    Profile_type m_currentProfile;

    /// Помогает достать из базы данных данные о пользователе
    Profile_type getProfileFromDB(const QString& username);
};

