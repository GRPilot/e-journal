#include "ProfileData.h"

using profile_t = ProfileData::Profile_type;

ProfileData::ProfileData(const QString& username)
    : m_queryUsersBuilder{ Tables::Users }
{
    m_currentProfile = getProfile(username);
}

QVariantList ProfileData::getValuesFromDB(const QString& query) const
{
    QString dbName{ m_queryUsersBuilder.path() };
    QSqlDatabase dbase = QSqlDatabase::addDatabase("QSQLITE");
    dbase.setDatabaseName(dbName);

    if(!dbase.open()) {
        qDebug() << "[QtSql][ProfileData]: Cannot open the database with name"
                 << dbName.data();
        return {};
    }

    QSqlQuery sqlQuery(query);
    QVariantList values{};

    while (sqlQuery.next()) {
        values.push_back(sqlQuery.value(0));
    }

    if (values.isEmpty())
        values.push_back("<no items>");

    dbase.close();
    return values;
}

profile_t ProfileData::currentProfile() const
{
    return m_currentProfile;
}

profile_t ProfileData::getProfile(const QString& username) const
{
    auto getNameQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select("teachers.full_name")
                   .inner_join_on("teachers",
                                  "users.id = teachers.id_user")
                   .where(QString{"users.username='%1'"}.arg(username));

            return builder.query();
        }
    };
    auto getSubjectsQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select("subjects.subject")
                   .inner_join_on(
                        "user_subjects, subjects",
                        "users.id = user_subjects.id_user AND subjects.id = user_subjects.id_subject"
                   )
                   .where(QString{"users.username='%1'"}.arg(username));

            return builder.query();
        }
    };
    auto getGroupsQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select("groups.name")
                   .inner_join_on(
                        "user_groups, groups",
                        "users.id = user_groups.id_user AND groups.id = user_groups.id_group"
                   )
                   .where(QString{"users.username='%1'"}.arg(username));

            return builder.query();
        }
    };
    auto getImageQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select("teachers.image")
                   .inner_join_on("teachers",
                                  "users.id = teachers.id_user")
                   .where(QString{"users.username='%1'"}.arg(username));

            return builder.query();
        }
    };

    QString     nameQuery{ getNameQueryString     (m_queryUsersBuilder) };
    QString subjectsQuery{ getSubjectsQueryString (m_queryUsersBuilder) };
    QString   groupsQuery{ getGroupsQueryString   (m_queryUsersBuilder) };
    QString    imageQuery{ getImageQueryString    (m_queryUsersBuilder) };
    QString  databaseName{ m_queryUsersBuilder.path() };

    QString name{
        getValuesFromDB(nameQuery).back().toString()
    };

    Strings subjects;
    for (const auto iter : getValuesFromDB(subjectsQuery))
        subjects.push_back(iter.toString());

    Strings groups;
    for (const auto iter : getValuesFromDB(groupsQuery))
        groups.push_back(iter.toString());


    QImage image;
    QVariantList imgs{ getValuesFromDB(imageQuery) };
    QVariant img{ imgs.back() };
    if (!img.isNull()){
        QByteArray byteArr {
            img.value<QByteArray>()
        };

        image.loadFromData(byteArr);
    }
    return Profile_type{
        name,
        subjects,
        groups,
        image
    };
}

