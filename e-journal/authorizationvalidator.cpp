#include "authorizationvalidator.h"

AuthorizationValidator::AuthorizationValidator(QObject *parent)
    : QObject(parent),
      db{ new DBProvider( Tables::USERS ) }
{}

AuthorizationValidator::~AuthorizationValidator()
{
    delete db;
}

bool AuthorizationValidator::checkPassWithUser(QString login, QString password) const
{
    if (login.isEmpty() || login.isNull()) {
        return false;
    }

    if (password.size() < minimumLenghtForPasswords)
        return false;

    if (
        db->select(QString("username, password"))
          ->where(QString("username='%1' AND password='%2'")
                    .arg(login)
                    .arg(getHash(password))
                 )
          ->exist()
       ) {
        return true;
    }
    return false;
}

bool AuthorizationValidator::checkUser(QString username) const
{
    if (username.isNull() || username.isEmpty()) {
        return false;
    }

    if (db->select("username")
          ->where(QString("username='%1'").arg(username))
          ->exist()) {
        return true;
    }
    return false;
}

QString AuthorizationValidator::getHash(const QString password) const {
    QString hashOfPass = QString(QCryptographicHash::hash((password.toLocal8Bit()),QCryptographicHash::Md5).toHex());
    return hashOfPass;//blah;
}
