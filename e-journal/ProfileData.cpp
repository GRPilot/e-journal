#include "ProfileData.h"

using profile_t = ProfileData::Profile_type;

ProfileData::ProfileData(const QString& username)
    : m_queryUsersBuilder{ Tabels::Users }
{
    m_currentProfile = getProfileFromDB(username);
}

profile_t ProfileData::currentProfile() const
{
    return m_currentProfile;
}

// TODO: Разбить метод, дополнив функционал QueryBuilder и ProfileManager
profile_t ProfileData::getProfileFromDB(const QString& username)
{
    auto getNameQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select(Strings{QString{"teachers.full_name"}});
            QString query{
                builder.query()
                       .append("INNER JOIN teachers ")
                       .append("ON users.id = teachers.id_user ")
                       .append("WHERE users.username='%1';")
                       .arg(username)
            };
            return query;
        }
    };
    auto getSubjectsQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select(Strings{QString{"subjects.subject"}});
            QString query{
                builder.query()
                       .append("INNER JOIN user_subjects, subjects ")
                       .append("ON users.id = user_subjects.id_user AND subjects.id = user_subjects.id_subject ")
                       .append("WHERE users.username = '%1';")
                       .arg(username)
            };
            return query;
        }
    };
    auto getGroupsQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select(Strings{QString{"groups.name"}});
            QString query{
                builder.query()
                       .append("INNER JOIN user_groups, groups ")
                       .append("ON users.id = user_groups.id_user AND groups.id = user_groups.id_group ")
                       .append("WHERE users.username='%1';")
                       .arg(username)
            };
            return query;
        }
    };
    auto getImageQueryString{
        [username](QueryBuilder builder) -> QString {
            builder.select(Strings{QString{"teachers.image"}});
            QString query{
                builder.query()
                       .append("INNER JOIN teachers ")
                       .append("ON users.id = teachers.id_user ")
                       .append("WHERE users.username='%1';")
                       .arg(username)
            };
            return query;
        }
    };
    auto getValues {
        [](const QString& query, const QString& dbName) -> QVariantList {
            QSqlDatabase dbase = QSqlDatabase::addDatabase("QSQLITE");
            dbase.setDatabaseName(dbName);

            if(!dbase.open()) {
                qDebug() << "[QtSql][ProfileData]: Cannot open the database with name" << dbName.data();
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
    };

    QString     nameQuery{ getNameQueryString(m_queryUsersBuilder)     };
    QString subjectsQuery{ getSubjectsQueryString(m_queryUsersBuilder) };
    QString   groupsQuery{ getGroupsQueryString(m_queryUsersBuilder)   };
    QString    imageQuery{ getImageQueryString(m_queryUsersBuilder)    };
    QString  databaseName{ m_queryUsersBuilder.path() };

    QString name{
        getValues(nameQuery, databaseName).back().toString()
    };

    Strings subjects;
    for (const auto iter : getValues(subjectsQuery, databaseName))
        subjects.push_back(iter.toString());

    Strings groups;
    for (const auto iter : getValues(groupsQuery, databaseName))
        groups.push_back(iter.toString());

    QByteArray byteArr {
        getValues(imageQuery, databaseName)
                .back().value<QByteArray>()
    };
    QPixmap image;
    image.loadFromData(byteArr);

    return Profile_type{
        name,
        subjects,
        groups,
        image
    };
}

