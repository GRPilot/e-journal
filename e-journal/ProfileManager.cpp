#include "ProfileManager.h"

ProfileManager::ProfileManager()
    : m_queryTeachersBuilder{ Tables::Teachers },
      m_queryUsersBuilder   { Tables::Users    }
{}

bool ProfileManager::createNewUser(const QString& username,
                                   const QString& password) {
    if (username.length() <= c_minLenght ||
        password.length() <= c_minLenght) {
        return false;
    }

    std::vector tables {
        QString{ "username" },
        QString{ "password" }
    };

    HashHelper hHelper{ password };

    std::vector values {
        QString{ "'%1'" }.arg(username.toLower()),
        QString{ "'%1'" }.arg(hHelper.hash())
    };

    // Составляем запрос на вставку нового пользователя
    m_queryUsersBuilder.insert(tables).values(values);

    QString query{ m_queryUsersBuilder.query() };

    // отчищаем запрос для последующего использования
    m_queryUsersBuilder.clearQuery();

    // выполняем запрос и получаем в ответ true,
    // если запрос был обработан и false в противном случае
    return exec(query, m_queryUsersBuilder.path());
}

bool ProfileManager::deleteUser(const QString& username,
                                const QString& password) {
    if (username.length() <= c_minLenght ||
        password.length() <= c_minLenght)
        return false;

    // при инициализации HashHelper сразу генерирует хэш стандартным алгоритмом
    HashHelper hHelper{ password };

    QString condition{
        QString{"username='%1' AND password='%2'"}
        .arg(username).arg(hHelper.hash())
    };

    // составляем запрос на удаление пользователя
    m_queryUsersBuilder.delete_from().where(condition);

    // сохраняем запрос
    QString query{ m_queryUsersBuilder.query() };

    // отчищаем запрос для последующего использования
    m_queryUsersBuilder.clearQuery();

    return exec(query, m_queryUsersBuilder.path());
}

bool ProfileManager::checkUser(const QString& username) {
    if (username.isNull() || username.isEmpty()) {
        return false;
    }

    m_queryUsersBuilder.select_all()
                     .where(QString("username='%1'").arg(username.toLower()))
                     .exist();

    QString query{ m_queryUsersBuilder.query() };
    bool status { exsist(query, m_queryUsersBuilder.path()) };

    m_queryUsersBuilder.clearQuery();

    return status;
}

bool ProfileManager::checkPassAndUser(const QString& username,
                                      const QString& password) {
    if (username.isEmpty() || username.isNull()) {
        return false;
    }

    HashHelper hHelper(password);


    m_queryUsersBuilder.select_all()
                     .where(QString("username='%1' AND password='%2'")
                            .arg(username.toLower()).arg(hHelper.hash()))
                     .exist();

    QString query{ m_queryUsersBuilder.query() };
    bool status { exsist(query, m_queryUsersBuilder.path()) };

    // отчищаем запрос для последующего использования
    m_queryUsersBuilder.clearQuery();

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

    m_queryTeachersBuilder.update(std::vector<QString>{ updateTarget })
                          .values(std::vector<QString>{ newName })
                          .where(condition);

    QString query{ m_queryTeachersBuilder.query() };
    m_queryTeachersBuilder.clearQuery();


    bool status{ exec(query, m_queryTeachersBuilder.path()) };

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

bool ProfileManager::exsist(const QString& query,
                            const QString& pathToDatabase) {
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

// Требуется переписать, разделив на функцию getExecutedResult
int ProfileManager::getUserID(const QString& username) {
    if (username.isEmpty())
        return -1;

    QString condition{ QString("username='%1'").arg(username.toLower()) };

    m_queryUsersBuilder.select(
                    std::vector<QString>{"id"}
                ).where(condition);

    QSqlDatabase dbase = QSqlDatabase::addDatabase("QSQLITE");
    dbase.setDatabaseName(m_queryUsersBuilder.path());

    if (!dbase.open()) {
        return false;
    }

    QSqlQuery sqlQuery;

    int user_id{ -1 };

    sqlQuery.exec(m_queryUsersBuilder.query());

    if (sqlQuery.next()) {
        user_id = sqlQuery.value(0).toInt();
    }

    dbase.close();
    return user_id;
}
