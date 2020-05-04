#include "authorizationvalidator.h"

AuthorizationValidator::AuthorizationValidator(QObject *parent)
    : QObject(parent),
      m_db{ new DBProvider( Tables::Users ) }
{

}

AuthorizationValidator::AuthorizationValidator(const AuthorizationValidator &other)
    : AuthorizationValidator{ other.parent() } {}

AuthorizationValidator::~AuthorizationValidator() {
    delete m_db;
}

bool AuthorizationValidator::checkPassWithUser(const QString& login, const QString& password) const
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

    if (
        m_db->select(columns)
            ->where(QString("username='%1' AND password='%2'")
                      .arg(login)
                      .arg(hHelper.hash())
                   )
            ->exist()
       ) {
        return true;
    }
    return false;
}

bool AuthorizationValidator::checkUser(const QString& username) const
{
    if (username.isNull() || username.isEmpty()) {
        return false;
    }

    std::vector column = {
        QString(username)
    };

    if (m_db->select(column)
            ->where(QString("username='%1'").arg(username))
            ->exist()) {
        return true;
    }
    return false;
}
