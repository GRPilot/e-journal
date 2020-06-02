#include "ProfileData.h"

ProfileData::ProfileData(const QString& username)
    : m_db_users_helper{ Tables::Users }
{
    m_currentProfile = getProfileFromDB(username);
}

ProfileData::Profile_type ProfileData::currentProfile() const
{
    return m_currentProfile;
}

ProfileData::Profile_type ProfileData::getProfileFromDB(const QString& username)
{
    auto getNameQueryString{
        [username](DBHelper builder) -> QString {
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
        [username](DBHelper builder) -> QString {
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
        [username](DBHelper builder) -> QString {
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
        [username](DBHelper builder) -> QString {
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

    QString     nameQuery{ getNameQueryString(m_db_users_helper)     };
    QString subjectsQuery{ getSubjectsQueryString(m_db_users_helper) };
    QString   groupsQuery{ getGroupsQueryString(m_db_users_helper)   };
    QString    imageQuery{ getImageQueryString(m_db_users_helper)    };
    QString  databaseName{ m_db_users_helper.path() };

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

