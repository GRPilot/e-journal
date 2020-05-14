#pragma once

#include <QObject>
#include <QtSql>
#include "DBHelper.h"
#include "HashHelper.h"

class AuthorizationValidator : public QObject
{
    Q_OBJECT

 public:
    const int minimumLenghtForPasswords = 4;
    AuthorizationValidator(QObject *parent = nullptr);
    AuthorizationValidator(const AuthorizationValidator& other);

    ~AuthorizationValidator();

    Q_INVOKABLE bool checkPassWithUser(const QString& username, const QString& password);
    Q_INVOKABLE bool checkUser(const QString& username);

 private:
    DBHelper m_db_helper;
    bool existQuery(const QString& query);
};

