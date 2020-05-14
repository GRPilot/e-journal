#include "authorizationvalidator.h"

AuthorizationValidator::AuthorizationValidator(QObject *parent)
    : QObject(parent),
      m_db_helper{ Tables::Users }
{}

AuthorizationValidator::AuthorizationValidator(const AuthorizationValidator &other)
    : AuthorizationValidator{ other.parent() } {}

AuthorizationValidator::~AuthorizationValidator() {
    //delete m_db;
}

bool AuthorizationValidator::checkPassWithUser(const QString& login, const QString& password)
{
    if (login.isEmpty() || login.isNull()) {
        return false;
    }

    if (password.size() < minimumLenghtForPasswords)
        return false;

    HashHelper hHelper(password);

    std::vector columns = {
        QString("username"),
        QString("password")
    };


    m_db_helper.select(columns)
        .where(QString("username='%1' AND password='%2'")
               .arg(login).arg(hHelper.hash()))
        .exist();

    QString query{ m_db_helper.query() };
    bool status { existQuery(query) };

    m_db_helper.clearQuery();

    return status;
}

bool AuthorizationValidator::checkUser(const QString& username)
{
    if (username.isNull() || username.isEmpty()) {
        return false;
    }

    std::vector column = {
        QString(username)
    };

    m_db_helper.select(column)
        .where(QString("username='%1'").arg(username))
        .exist();

    QString query{ m_db_helper.query() };
    bool status { existQuery(query) };

    m_db_helper.clearQuery();

    return status;
}

bool AuthorizationValidator::existQuery(const QString& query) {
    if (query.isEmpty())
        return false;

    QSqlDatabase dbase = QSqlDatabase::addDatabase("QSQLITE");
    dbase.setDatabaseName(m_db_helper.path());

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
