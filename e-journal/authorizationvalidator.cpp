#include "authorizationvalidator.h"

AuthorizationValidator::AuthorizationValidator(QObject *parent)
    : QObject(parent),
      db{ new DBProvider( Tables::USERS ) }
{}

AuthorizationValidator::~AuthorizationValidator()
{
    delete db;
}

bool AuthorizationValidator::checkUser(QString login, QString password) const
{
    if (login.isEmpty() || login.isNull()) {
        return false;
    }

    if (password.size() < minimumLenghtForPasswords)
        return false;

    if (
        db->select(QString("username, password"))
          ->where(QString("login='%1' AND password='%2'")
                    .arg(login)
                    .arg(getHash(password))
                 )
          ->exec()
       ) {
        return true;
    }
    return false;
}

QString AuthorizationValidator::getHash(const QString password) const {
       //QString blah = QString(QCryptographicHash::hash(password, QCryptographicHash::Md5));
       return password;//blah;
}

void AuthorizationValidator::addNewUser() {
    //creating new person only for administrations
}
