#include "ProfileManager.h"

ProfileManager::ProfileManager()
    : m_db_teachers_helper{ Tables::Teachers },
      m_db_users_helper   { Tables::Users }
{}

bool ProfileManager::createNewUser(const QString& username,
                                   const QString& password) {
    if (username.length() <= 4 || password.length() <= 4)
        return false;

    std::vector tables {
        QString{ "username" },
        QString{ "password" }
    };

    HashHelper hHelper{ password };

    std::vector values {
        QString{ "'%1'" }.arg(username.toLower()),
        QString{ "'%1'" }.arg(hHelper.hash())
    };

    m_db_users_helper.insert(tables).values(values);

    QString query{ m_db_users_helper.query() };

    bool status{ exec(query, m_db_users_helper.path()) };
    return status;
}

bool ProfileManager::deleteUser(const QString& username,
                                const QString& password) {
    if (username.length() <= 4 || password.length() <= 4)
        return false;

    bool status{ false };

    return status;
}

bool ProfileManager::checkUser(const QString& username) {
    if (username.isNull() || username.isEmpty()) {
        return false;
    }

    m_db_users_helper.select_all()
                     .where(QString("username='%1'").arg(username.toLower()))
                     .exist();

    QString query{ m_db_users_helper.query() };
    bool status { exsist(query, m_db_users_helper.path()) };

    m_db_users_helper.clearQuery();

    return status;
}

bool ProfileManager::checkPassAndUser(const QString& username,
                                      const QString& password) {
    if (username.isEmpty() || username.isNull()) {
        return false;
    }

    HashHelper hHelper(password);


    m_db_users_helper.select_all()
                     .where(QString("username='%1' AND password='%2'")
                            .arg(username.toLower()).arg(hHelper.hash()))
                     .exist();

    QString query{ m_db_users_helper.query() };
    bool status { exsist(query, m_db_users_helper.path()) };

    m_db_users_helper.clearQuery();

    return status;
}

bool ProfileManager::setUserName(const QString& username,
                                 const QString& newName) {
    if (username.isEmpty() || newName.isEmpty())
        return false;

    if (!checkUser(username))
        return false;

    int user_id{ getUserID(username) };
    QString condition{ QString{"id_user='%1'"}.arg(user_id) };
    QString updateTarget{ QString{ "full_name='%1'" }.arg(newName) };

    m_db_teachers_helper.update(std::vector<QString>{ updateTarget })
                        .values(std::vector<QString>{ newName })
                        .where(condition);

    QString query{ m_db_teachers_helper.query() };
    bool status{ exec(query, m_db_teachers_helper.path()) };

    return status;
}


bool ProfileManager::exec(const QString& query, const QString& pathToDatabase) {
    if (query.isEmpty() || pathToDatabase.isEmpty())
        return false;

    QSqlDatabase dbase = QSqlDatabase::addDatabase("QSQLITE");
    dbase.setDatabaseName(pathToDatabase);

    if (!dbase.open()) {
        qDebug() << "[QtSql] Cannot open the database: " << pathToDatabase;
        return false;
    }

    QSqlQuery sqlQuery;
    bool status{ sqlQuery.exec(query) };
    dbase.close();
    return status;
}

bool ProfileManager::exsist(const QString& query, const QString& pathToDatabase) {
    if (query.isEmpty())
        return false;

    QSqlDatabase dbase = QSqlDatabase::addDatabase("QSQLITE");
    dbase.setDatabaseName(pathToDatabase);

    if (!dbase.open()) {
        return false;
    }

    QSqlQuery sqlQuery;

    bool status{ false };

    sqlQuery.exec(query);
    if (sqlQuery.next()) {
        status = sqlQuery.value(0).toBool();
    }

    dbase.close();
    return status;
}

int ProfileManager::getUserID(const QString& username) {
    if (username.isEmpty())
        return -1;

    QString condition{ QString("username='%1'").arg(username.toLower()) };

    m_db_users_helper.select(
                    std::vector<QString>{"id"}
                ).where(condition);

    QSqlDatabase dbase = QSqlDatabase::addDatabase("QSQLITE");
    dbase.setDatabaseName(m_db_users_helper.path());

    if (!dbase.open()) {
        return false;
    }

    QSqlQuery sqlQuery;

    int user_id{ -1 };

    sqlQuery.exec(m_db_users_helper.query());

    if (sqlQuery.next()) {
        user_id = sqlQuery.value(0).toInt();
    }

    dbase.close();
    return user_id;
}
