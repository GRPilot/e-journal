#ifndef AUTHORIZATIONVALIDATOR_H
#define AUTHORIZATIONVALIDATOR_H

#include <QObject>
#include "dbprovider.h"
#include "HashHelper.h"

class AuthorizationValidator : public QObject
{
    Q_OBJECT
 public:
    const int minimumLenghtForPasswords = 4;
    explicit AuthorizationValidator(QObject *parent = nullptr);
    ~AuthorizationValidator();

 public slots:
    bool checkPassWithUser(QString username, QString password) const;
    bool checkUser(QString username) const;

 private:
    DBProvider *m_db;
};

#endif // AUTHORIZATIONVALIDATOR_H
